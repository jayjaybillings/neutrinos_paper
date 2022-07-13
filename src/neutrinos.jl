"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

"""
module neutrinos

# Include plotting support
using PlotlyJS

"""
Fermi's weak coupling constant in MeV cm^2
"""
const fermiConst = 8.955E-44

"""
The difference in neutrino masses of types one and two in MeV^2
"""
const deltaMSquared = 7.5E-17

"""
The energy of the neutrinos in MeV
"""
const energy = 10.0

"""
This function computes the matter mixing angle (theta_m) based on the vacuum mixing angle (theta) and the coupling strength (chi).
"""
function getMatterMixingAngle(vacuumMixingAngle, couplingStrength)

    twoTheta = 2.0 * vacuumMixingAngle
    cosTwoTheta = cos(twoTheta)
    matterMixingAngle =
        0.5 * atan(sin(twoTheta) / (cos(twoTheta) - couplingStrength))
    scalingFactor = getScalingFactor(vacuumMixingAngle, couplingStrength)
    println(
        "2T = $twoTheta, chi = $couplingStrength, cosT2M = $cosTwoTheta, theta_m = $matterMixingAngle, scalingFactor = $scalingFactor",
    )

    matterMixingAngle = 0.5 * asin(sin(twoTheta) / scalingFactor)

    return matterMixingAngle
end

"""
This function computes the coupling strength (chi) from the neutrino energy (E) and the electron number density (n_e). The energy should be in units of erg.
"""
function getCouplingStrength(energy, e_number_density)

    k = ((2.0 * sqrt(2.0) * energy * fermiConst) / deltaMSquared)
    println("$k")
    coupling_strength = k * e_number_density

    return coupling_strength
end

"""
This function computes the electron number density as a function of the radial fraction, R/R_sun.
"""
function getElectronNumberDensity(radiusFraction)
    return 1.475E26 * exp(-10.54 * radiusFraction)
end

"""
This function computes the probability of a neutrino to be in the electron neutrino flavor as a function of its position in the sun (given by the r/r_sun fraction, radiusFraction), and the vacuum mixing angle, (theta).
"""
function getElectronNeutrinoProbability(radiusFraction, theta)
    # Compute the number density
    electronNumberDensity = getElectronNumberDensity(radiusFraction)
    # Compute the coupling strength
    couplingStrength = getCouplingStrength(energy, electronNumberDensity)
    # Compute the matter mixing angle
    matterMixingAngle = getMatterMixingAngle(theta, couplingStrength)
    println("$electronNumberDensity, $couplingStrength, $matterMixingAngle")

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
This function plots the electron number density as a function of the the radial fraction, R/R_sun.
"""
function plotElectronNumberDensity()
    n = 100
    xValues = 0.0:0.01:n
    yValues = Array{Float32}(undef, n)
    for i = 1:n
        yValues[i] = log10(getElectronNumberDensity(xValues[i]))
    end
    layout = Layout(; title = "Electron Number Density")
    plot(xValues, yValues, layout)

end

"""
This function plots the scaling factor f(theta,chi).
"""
function plotScalingFactor(theta)
    n = 400
    xValues = 0.0:0.01:n
    yValues = Array{Float32}(undef, n)
    for i = 1:n
        yValues[i] = getMatterMixingAngle(theta, xValues[i])
    end
    layout = Layout(; title = "Scaling Factor")
    plot(xValues, yValues, layout)
end

"""
This function plots the matter mixing angle as function of vacuum mixing angle and coupling strength.
"""
function plotMatterMixingAngle(theta)
    n = 1000
    xValues = collect(range(0.01,0.6,n))
    yValues = Array{Float32}(undef, n)
    for i = 1:n
        yValues[i] =
            (xValues[i] > 1.0) ? getMatterMixingAngle(theta, xValues[i]) :
            pi / 2.0 - getMatterMixingAngle(theta, xValues[i])
    end
    layout = Layout(; title = "Matter Mixing Angle")
    plot(xValues, yValues, layout)
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
    n = 1000
    x = collect(range(0.01,0.6,n));
    thetam = zeros(n)
    # Main loop
    i = 1;
    for i = 1:n
        xi = x[i]
        ne = aa * exp(-alph * xi)
        scriptell_m = norm / ne
        chi = L/scriptell_m
        sin2tm = S / sqrt((C - chi)^2 + S^2)

        # Matter mixing angle in radians
        thetam[i] = 0.5 * asin(sin2tm)
        # Evaluate matter angle in correct angle sector for x=R/R0
        thetam[i] = (xi > rcrit) ? thetam[i] : pi / 2 - thetam[i]  # Below and above resonance
        print(i,",",xi,",",thetam[i],"\n")
        i += 1
    end

    layout = Layout(; title = "Matter Mixing Angle Like Gnuplot")
    plot(x, thetam, layout)

end

function plotCouplingStrength()

    values[100]
    for i = 1:100
        #values[i] = #getCouplingStrength(i*neutrinos.energy,)
    end

end

end # module
