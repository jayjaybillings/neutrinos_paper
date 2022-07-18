"""
This is a module for studying neutrino interactions and oscillations in a two flavor model according to the work of Guidry and Billings, 2020.

https://arxiv.org/abs/1812.00035

"""

module electrons

"""
This function computes the electron number density as a function of the radial fraction, R/R_sun.
"""
function getElectronNumberDensity(radiusFraction)
    return 1.475E26 * exp(-10.54 * radiusFraction)
end

end # module
