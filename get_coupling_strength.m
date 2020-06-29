## This function returns the coupling strength for the given energy, mass 
## squared difference, and electron number density
function coupling_strength = get_coupling_strength(energy, e_number_density)
	## Fermi's weak coupling constant
    g_f = 1.0;
	## Difference of squared masses
	delta_m2 = 1.0;
    #coupling_strength = ((2.0*sqrt(2.0)*energy*g_f)/delta_m2)*e_number_density;
endfunction

## Test the simplest case
%!assert (get_coupling_strength(0.0,0.0),0.0,0.0)