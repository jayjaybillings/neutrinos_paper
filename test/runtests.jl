using neutrinos
using Test

@testset "neutrinos.jl" begin

    #----- Basic tests for computing the matter mixing angle

    # Test basic vacuum angles. Start with with theta = 0, s.t. tan(2*theta)
    @test 0.0 == neutrinos.getMatterMixingAngle(0.0,0.0);

    ## If the coupling strength is zero, the denominator is 1.0.
    @test isapprox(neutrinos.getMatterMixingAngle(pi/8.0,0.0), 0.5*atan(tan(pi/4.0)); atol=1.0e-5);

    ## This version exploits the sqrt(3.0) produced by cos(pi/6.0).
    @test isapprox(neutrinos.getMatterMixingAngle(pi/12.0,sqrt(3.0)), 0.5*atan(-sqrt(3.0)/3.0); atol=1.0e-5);

    #----- Basic tests for computing the coupling strength

    # Test zero case. Yeah, this means that the neutrinos have no energy and that there are no electrons in the universe! :-P
    @test 0.0 == neutrinos.getCouplingStrength(0.0,0.0);

    # Test the case where either the neutrino energy is zero or the electron number density is zero. Both cases result in no coupling strength.
    @test 0.0 == neutrinos.getCouplingStrength(0.0,5.0);
    @test 0.0 == neutrinos.getCouplingStrength(5.0,0.0);

    # If the energy is equal to deltaMSquared/(2sqrt(2)*fermiConst), then the coupling strength is equal to the electron number density.
    @test isapprox( neutrinos.getCouplingStrength((neutrinos.deltaMSquared/(2.0*sqrt(2.0)*neutrinos.fermiConst)),1.0),1.0; atol=1.0e-5);

    # If the energy and the electron density are both one, the coupling strength is just 2sqrt(2)fermiConst/deltaMSquared.
    @test isapprox( neutrinos.getCouplingStrength(1.0,1.0), (2.0*sqrt(2.0)*neutrinos.fermiConst/neutrinos.deltaMSquared); atol=1.0e-5);

    #----- Basic tests for the electron number density
    # This simple test checks behavior when R/R_sun = 0.0, which sets the exponent to zero and the result is the coefficient, 1.475E26.
    @test isapprox(1.475E26, neutrinos.getElectronNumberDensity(0.0),atol=1.0e-5);
    # Similar to the above, but in the case where the radius is equal to the solar radius and the fraction is 1.0, then the result is 1.475E26*exp(-10.54).
    @test isapprox(1.475E26*exp(-10.54), neutrinos.getElectronNumberDensity(1.0), atol=1.0e-5);
end
