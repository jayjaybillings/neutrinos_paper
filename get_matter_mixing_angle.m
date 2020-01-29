

## This function returns the matter mixing angle for given input x.
function matter_mixing_angle = get_matter_mixing_angle (vacuum_mixing_angle, energy, delta_m2, e_number_density)
    twoTheta = 2.0*vacuum_mixing_angle;
    chi = 1.0;
    matter_mixing_angle = 0.5*atan(tan(twoTheta)/(1.0-(chi/cos(twoTheta))));
endfunction

## Test basic vacuum angles. Start with with theta = 0, s.t. tan(2*theta)  
%!assert (get_matter_mixing_angle(0.0,0.0,0.0,0.0),0.0)
%!assert (get_matter_mixing_angle(0.5,0.0,0.0,0.0),0.5*0.46365,1.0e-5)
%!assert (get_matter_mixing_angle(-0.5,0.0,0.0,0.0),0.5*-0.46365,1.0e-5)
%!assert (get_matter_mixing_angle(1.0,0.0,0.0,0.0),pi/8.0,1.0e-5)
%!assert (get_matter_mixing_angle(-1.0,0.0,0.0,0.0),-pi/8.0,1.0e-5)

## Test 

function coupling_strength = get_coupling_strength(energy, delta_m2, e_number_density)
    print 'Hi'
endfunction
