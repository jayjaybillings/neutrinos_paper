using .electrons
using Test

@testset "electrons.jl" begin

    #----- Basic tests for the electron number density
    # This simple test checks behavior when R/R_sun = 0.0, which sets the exponent to zero and the result is the coefficient, 1.475E26.
    @test isapprox(1.475E26, electrons.getElectronNumberDensity(0.0),atol=1.0e-5);
    # Similar to the above, but in the case where the radius is equal to the solar radius and the fraction is 1.0, then the result is 1.475E26*exp(-10.54).
    @test isapprox(1.475E26*exp(-10.54), electrons.getElectronNumberDensity(1.0), atol=1.0e-5);


end #testset
