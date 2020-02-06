

## This function returns the matter mixing angle for given input x.
function matter_mixing_angle = get_matter_mixing_angle (vacuum_mixing_angle, coupling_strength)
    twoTheta = 2.0*vacuum_mixing_angle;
    tanTwoTheta = tan(twoTheta);
    cosTwoTheta = cos(twoTheta);
    chiByCosTwoTheta = coupling_strength/cosTwoTheta;
    matter_mixing_angle = 0.5*atan(tanTwoTheta/(1.0-chiByCosTwoTheta));
endfunction

## Test basic vacuum angles. Start with with theta = 0, s.t. tan(2*theta)  
%!assert (get_matter_mixing_angle(0.0,0.0),0.0)
## If the coupling strength is zero, the denominator is 1.0.
%!assert (get_matter_mixing_angle(pi/8.0,0.0),0.5*atan(tan(pi/4.0)),1.0e-5)
## This version exploits the sqrt(3.0) produced by cos(pi/6.0).
%!assert (get_matter_mixing_angle(pi/12.0,sqrt(3.0)),0.5*atan(-sqrt(3.0)/3.0),1.0e-5)