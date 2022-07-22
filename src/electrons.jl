"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

This uses the plots.jl routines, which are included in neutrinos.jl and not included here.

"""
module electrons

"""
The maximum electron number density (otherwise denoted 'aa').
"""
const maxN_e = 1.475E26

"""
The default value of the electron number density exponential decay constant (alpha).
"""
const defaultDecayConstant = 10.54


"""
This function computes the electron number density as a function of the radial fraction, R/R_sun.

radiusFraction the radius as a fraction of the maximum radius

aCoeff is the maximum electron number density, 1.475E26 by default

alpha is the exponential decay constant, -10.54 by default
"""
function getElectronNumberDensity(radiusFraction,aCoeff = electrons.maxN_e,
    alpha = electrons.defaultDecayConstant)
    return aCoeff * exp(-1.0*alpha * radiusFraction)
end

end # module
