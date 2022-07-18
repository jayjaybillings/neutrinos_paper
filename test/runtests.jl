using neutrinos
using Test

include("runtests_electrons.jl")

@testset "neutrinos.jl" begin

    #----- Basic tests for computing the matter mixing angle

    # Test basic vacuum angles. Start with with theta = 0, s.t. tan(2*theta)
    @test 0.0 == neutrinos.getMatterMixingAngle(0.0,0.0);

    ## If the coupling strength is zero, the denominator is 1.0. At 2theta = pi/4.0, the numerator is also 1 such that the result is theta_m = pi/8, which correctly matches the vacuum angle.
    @test isapprox(neutrinos.getMatterMixingAngle(pi/8.0,0.0), pi/8.0; atol=1.0e-5);

    # There is an analytical result nearly as simple as the above, but with coupling strength equal to 1.0. In this case, the denominator is 1 - sqrt(2.0).
    @test isapprox(neutrinos.getMatterMixingAngle(pi/8.0,1.0), 0.5*atan(1.0/(1.0-sqrt(2.0))); atol=1.0e-5);

    ## This version exploits the sqrt(3.0) produced by cos(pi/6.0) (which is just cos(2theta) for theta = pi/12).

    #Really not sure where this one came from...

    @test isapprox(neutrinos.getMatterMixingAngle(pi/12.0,sqrt(3.0)), 0.5*atan(-0.5); atol=1.0e-5);

    ## Problem 12.6 in Guidry's stars book presents an alternative formulation for the mixing angle based on sin that can be used to make the comparsion here.
    twoTheta = 1.0;
    chi = 0.5;
    thetaM_fromSin = 0.5*asin(sin(twoTheta)/(sqrt(1.0-2.0*chi*cos(twoTheta)+chi*chi)));
    @test isapprox(thetaM_fromSin,neutrinos.getMatterMixingAngle(twoTheta/2.0,chi); atol=1.0e-10);

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

    # I made this one up using the defaults and r/R = 0.0 for the number density. It uses chi = L/l_m directly.
    l_m = sqrt(2.0)*pi/(neutrinos.fermiConst*1.475e26);
    L = 4.0*pi*neutrinos.energy/neutrinos.deltaMSquared;
    chi = L/l_m;
    println("test: $L, $l_m, $chi");
    @test isapprox(chi,neutrinos.getCouplingStrength(neutrinos.energy,1.475e26); atol=1.0e-5);

    #----- Tests for the scaling factor f(theta,chi)
    # For chi = theta = 0.0, f = 1.
    @test isapprox(1.0,neutrinos.getScalingFactor(0.0,0.0);atol=1.0e-16)
    # For chi = 1.0, theta = 5.0pi/6.0, f = 1.0
    @test isapprox(1.0,neutrinos.getScalingFactor(5.0*pi/6.0,1.0);atol=1.0e-8)
    # For chi = 1.0, theta = 2.0pi/6.0, f = sqrt(3.0)
    @test isapprox(sqrt(3.0),neutrinos.getScalingFactor(2.0*pi/6.0,1.0);atol=1.0e-8)
    # For chi = 1.0, theta = 4.0pi/6.0, f = sqrt(3.0)
    @test isapprox(sqrt(3.0),neutrinos.getScalingFactor(4.0*pi/6.0,1.0);atol=1.0e-8)

    #----- Basic tests for the electron neutrino probability
    # For r/R = theta = 0.0, P = 1.0.
    @test 1.0 == neutrinos.getElectronNeutrinoProbability(0.0,0.0);
    #@test 0.5 == #neutrinos.getElectronNeutrinoProbability();
    # This is the example from Guidry's stars book (ADD DEETS!)
end #testset
