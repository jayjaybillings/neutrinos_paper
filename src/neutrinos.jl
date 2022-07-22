"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

"""
module neutrinos

# Include plotting support

# Reexport allows us to re-export submodules like electrons and plotting
using Reexport

# Include plotting
include("plots.jl")
@reexport using .plots

# Include auxillary electron functions
include("electrons.jl")
#import .electrons: getElectronNumberDensity
import .electrons
@reexport using .electrons

"""
Fermi's weak coupling constant in MeV cm^2
"""
const fermiConst = 8.955E-44

"""
The difference in neutrino masses of types one and two in MeV^2
"""
const deltaMSquared = 7.6E-17

"""
The energy of the neutrinos in MeV
"""
const energy = 10.0

function julia_main()::Cint
  try
      println("Hello World from Julia app!")
  catch
      Base.invokelatest(Base.display_error, Base.catch_stack())
      return 1
  end

  return 0
end

"""
This function computes the matter mixing angle (theta_m) based on the vacuum mixing angle (theta), the coupling strength (chi), and the radius (x).
"""
function getMatterMixingAngle(theta, chi, x)

    twoTheta = 2.0 * theta
    sinTwoTheta = sin(twoTheta)
    cosTwoTheta = cos(twoTheta)
    innerTerm = ((cosTwoTheta-chi)*(cosTwoTheta-chi)+sinTwoTheta*sinTwoTheta)
    sin2tm = sinTwoTheta / sqrt(innerTerm)
    theta_m = 0.5 * asin(sin2tm)
    # Account for the defintion of the mixing angle within as always being less
    # than pi/4 and its relationship to the critical radius.
    alpha = electrons.defaultDecayConstant
    aa = electrons.maxN_e
    neR = ((cosTwoTheta*neutrinos.deltaMSquared/neutrinos.energy)*(1.0/(2.0*sqrt(2.0)*neutrinos.fermiConst)))
    rCrit = (-1.0/alpha)*log(neR/aa)
    theta_m = (x > rCrit) ? theta_m : ((pi / 2.0) - theta_m)

    return theta_m
end

"""
This function computes the coupling strength (chi) from the neutrino energy (E) and the electron number density (n_e). The energy should be in units of erg.
"""
function getCouplingStrength(energy, e_number_density)

    k = ((2.0 * sqrt(2.0) * energy * fermiConst) / deltaMSquared)
    coupling_strength = k * e_number_density

    return coupling_strength
end

"""
This function computes the probability of a neutrino to be in the electron neutrino flavor as a function of its position in the sun (given by the r/r_sun fraction, radiusFraction), and the vacuum mixing angle, (theta).
"""
function getElectronNeutrinoProbability(radiusFraction, theta)
    # Compute the number density
    electronNumberDensity = electrons.getElectronNumberDensity(radiusFraction)
    # Compute the coupling strength
    couplingStrength = getCouplingStrength(energy, electronNumberDensity)
    # Compute the matter mixing angle
    matterMixingAngle = getMatterMixingAngle(theta, couplingStrength)

    # Compute the probability
    probability =
        0.5 * (1.0 + (cos(2.0 * theta) * cos(2.0 * matterMixingAngle)))

    return probability
end

"""
This function computes the probability of a neutrino to be in the muon neutrino flavor as a function of its position in the sun (given by the r/r_sun fraction, radiusFraction), and the mixing angle, (theta).
"""
function getMuonNeutrinoProbability(radiusFraction, mixingAngle)
    # This is just the opposite of the electron neutrino probability.
    return 1.0 - getElectronNeutrinoProbability(radiusFraction, mixingAngle)
end

"""
This function returns the scaling factor f(theta,chi) for oscillations in matter where theta is the vacuum mixing angle and chi is the coupling strength.
"""
function getScalingFactor(theta, couplingStrength)
    return sqrt(
        1.0 - 2.0 * couplingStrength * cos(2.0 * theta) +
        couplingStrength * couplingStrength,
    )
end

"""
This function plots the coupling strength.
"""
function plotCouplingStrength()
    n = 100
    plotData = plots.make1DPlotData(n)
    plotData.x = collect(range(0.01,0.6,n))
    for i = 1:n
        xi = plotData.x[i]
        n_e = electrons.getElectronNumberDensity(xi)
        plotData.fx[i] = getCouplingStrength(neutrinos.energy,n_e)
        print(xi,",",plotData.fx[i],"\n")
    end
    plotData.title = "Coupling Strength"
    plotData.xLabel = "Radius Fraction"
    plotData.fxLabel = "Chi"
    plotData.lineWidth = 2
    plots.plot(plotData)
end

"""
This function plots the scaling factor f(theta,chi).
"""
function plotScalingFactor(theta)
    n = 100
    plotData = plots.make1DPlotData(n)
    plotData.x = collect(range(0.01,0.6,n))
    for i = 1:n
        xi = plotData.x[i]
        n_e = electrons.getElectronNumberDensity(xi)
        coupStrgth = getCouplingStrength(neutrinos.energy,n_e)
        plotData.fx[i] = getScalingFactor(theta,coupStrgth)
    end
    plotData.title = "Scaling Factor"
    plotData.xLabel = "Radius Fraction"
    plotData.fxLabel = "f(theta)"
    plotData.lineWidth = 2
    plots.plot(plotData)
end

"""
This function plots the matter mixing angle as function of vacuum mixing angle and coupling strength.
"""
function plotMatterMixingAngle(theta)
    n = 20
    plotData = plots.make1DPlotData(n)
    plotData.x = collect(range(0.01,0.6,n))
    for i = 1:n
        n_e = electrons.getElectronNumberDensity(plotData.x[i])
        chi = getCouplingStrength(neutrinos.energy,n_e)
        plotData.fx[i] = getMatterMixingAngle(theta,chi,plotData.x[i])
    end
    plotData.title = "Matter Mixing Angle"
    plotData.xLabel = "Radius Fraction"
    plotData.fxLabel = "theta_m"
    plotData.lineWidth = 2
    plots.plot(plotData)
end

"""
This function plots the electron number density as a function of the the radial fraction, R/R_sun, in a log plot (y-axis only).
"""
function plotElectronNumberDensity()
    n = 100
    plotData = plots.make1DPlotData(n)
    for i = 1:n
        plotData.x[i] = 0.0001*i
        plotData.fx[i] = log10(electrons.getElectronNumberDensity(plotData.x[i]))
    end
    plotData.title = "Electron Number Density"
    plotData.xLabel = "Radius Fraction"
    plotData.fxLabel = "n_e"
    plotData.lineWidth = 2
    plots.plot(plotData)
end

"""
This function plots the matter mixing angle using M. Guidry's original method in plotting/flavorVsR.gnu.
"""
function plotMatterMixingAngleLikeGnuplot()

    # Compute MSW flavor conversion in Sun
    # using realistic density profile parameterized from
    # Standard Solar Model results from Bahcall

    println("Testing plotting like gnuplot")

    # Input data

    radcon = 180.0 / pi  # Radian-degrees conversion

    theta_v = 35.0         # Vacuum mixing angle, degrees
    tv = theta_v / radcon     # Convert to radians
    E = 10.0       # Neutrino energy in MeV
    dm2 = 7.6e-5            # Difference in mass squared in eV^2
    m12 = 5e-5           # mass-squared of nu_1 (assumed)
    m22 = m12 + dm2         # mass-squared of nu_2

    # Function definitions

    # Bahcall standard solar approx. Eq. (14) in Bahcall et al
    # Ap J 555, 990 (2001)

    aa = 1.47539e26
    alph = 10.54

    # Resonance length in meters
    norm = 9.785e30

    # Critical (resonance) density
    neR = 3.95e30 * (dm2 / E) * cos(2.0 * tv)
    #  Radius of resonance density with Bahcall param
    #  in fraction of solar radius
    rcrit = -(1.0 / alph) * log(neR / aa)
    # Vacuum oscillation length in meters
    L = 2.48 * E / dm2
    # Matter mixing angle
    C = cos(2.0 * tv)
    S = sin(2.0 * tv)

    # Make vector, not matrix
    n = 100
    plotData = plots.make1DPlotData(n)
    plotData.x = collect(range(0.01,0.6,n));
    # Main loop
    i = 1;
    for i = 1:n
        xi = plotData.x[i]
        ne = aa * exp(-alph * xi)
        scriptell_m = norm / ne
        chi = L/scriptell_m
        sin2tm = S / sqrt((C - chi)^2 + S^2)

        # Matter mixing angle in radians
        thetam = 0.5 * asin(sin2tm)
        # Evaluate matter angle in correct angle sector for x=R/R0
        thetam = (radcon/100.0)*((xi > rcrit) ? thetam : pi / 2 - thetam)  # Below and above resonance
        plotData.fx[i] = thetam
        print(i,",",xi,",",thetam,"\n")
        i += 1
    end

    plotData.title = "Matter Mixing Angle - Mike's Gnuplot method"
    plotData.xLabel = "r/r_0"
    plotData.fxLabel = "theta_m"
    plotData.lineWidth = 2
    plots.plot(plotData)

end

end # module
