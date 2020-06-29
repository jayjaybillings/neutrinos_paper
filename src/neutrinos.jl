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
const fermiConst = 8.955E-44;

"""
The difference in neutrino masses of types one and two in MeV^2
"""
const deltaMSquared = 7.5E-17;

"""
The energy of the neutrinos in MeV
"""
const energy = 10;

"""
This function computes the matter mixing angle (theta_m) based on the vacuum mixing angle (theta) and the coupling strength (chi).
"""
function getMatterMixingAngle(vacuumMixingAngle, couplingStrength)

    # Note that the vacuum mixing angle is scaled in matter, c.f. section 3 in the paper, by a scaling factor f related to the eigenvalues. FIXME!
    f = 1.0/((cos(2.0*vacuumMixingAngle) - couplingStrength)^2.0 - sin(2.0*vacuumMixingAngle)^2.0);
#    println(f);
#   twoTheta = 2.0*vacuumMixingAngle;
    tanTwoTheta = tan(twoTheta);
#    cosTwoTheta = cos(twoTheta);
#    chiByCosTwoTheta = couplingStrength/cosTwoTheta;
    matterMixingAngle = 0.5*asin(sin(2.0*vacuumMixingAngle)*f);

    return matterMixingAngle;
end

"""
This function computes the coupling strength (chi) from the neutrino energy (E) and the electron number density (n_e). The energy should be in units of erg.
"""
function getCouplingStrength(energy, e_number_density)

    k = ((2.0*sqrt(2.0)*energy*fermiConst)/deltaMSquared);
    println("$k");
    coupling_strength = k*e_number_density;

    return coupling_strength;
end

"""
This function computes the electron number density as a function of the radial fraction, R/R_sun.
"""
function getElectronNumberDensity(radiusFraction)
    return 1.475E26*exp(-10.54*radiusFraction);
end

"""
This function computes the probability of a neutrino to be in the electron neutrino flavor as a function of its position in the sun (given by the r/r_sun fraction, radiusFraction), and the vacuum mixing angle, (theta).
"""
function getElectronNeutrinoProbability(radiusFraction, theta)
    # Compute the number density
    electronNumberDensity = getElectronNumberDensity(radiusFraction);
    # Compute the coupling strength
    couplingStrength = getCouplingStrength(energy, electronNumberDensity);
    # Compute the matter mixing angle
    matterMixingAngle = getMatterMixingAngle(theta, couplingStrength);
    println("$electronNumberDensity, $couplingStrength, $matterMixingAngle");

    # Compute the probability
    probability = 0.5*(1.0 + cos(2.0*theta) * cos(2.0*matterMixingAngle));

    return probability;
end

"""
This function computes the probability of a neutrino to be in the muon neutrino flavor as a function of its position in the sun (given by the r/r_sun fraction, radiusFraction), and the mixing angle, (theta).
"""
function getMuonNeutrinoProbability(radiusFraction, mixingAngle)
    # This is just the opposite of the electron neutrino probability.
    return 1.0 - getElectronNeutrinoProbability(radiusFraction, mixingAngle);
end

"""
This function plots the electron number density as a function of the the radial fraction, R/R_sun.
"""
function plotElectronNumberDensity()
    n = 100;
    xValues = 0.0:0.01:n;
    yValues = Array{Float32}(undef,n);
    for i = 1:n
        yValues[i] = log10(getElectronNumberDensity(xValues[i]));
    end
    layout = Layout(;title="Electron Number Density");
    plot(xValues,yValues,layout);

end

function plotCouplingStrength()

    values[100];
    for i = 1:100
        #values[i] = #getCouplingStrength(i*neutrinos.energy,)
    end

end

end # module
