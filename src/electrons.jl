"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

"""
module electrons

"""
This function computes the electron number density as a function of the radial fraction, R/R_sun.

radiusFraction the radius as a fraction of the maximum radius

aCoeff is the maximum electron number density, 1.475E26 by default

alpha is the exponential decay constant, -10.54 by default
"""
function getElectronNumberDensity(radiusFraction,aCoeff::Float64 = 1.475E26,
    alpha::Float64=-10.54)
    return aCoeff * exp(alpha * radiusFraction)
end

end # module
