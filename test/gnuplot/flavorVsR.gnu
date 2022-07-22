# Compute MSW flavor conversion in Sun
# using realistic density profile parameterized from
# Standard Solar Model results from Bahcall

set macro  # Enable macro definition

# Some macro definitions

# Colors: hex #RRGGBB
label_color = "#867961"
tic_color = "#383838"
title_color = "#383838"
myblue = "#2196f3"
myred = "#f44336"
mygreen = "#2e7d32"
mypurple = "#9c27b0"
myviolet = "#673ab7"
mybrown = "#795548"
myorange = "#ff9800"

# Width and height of postscript figure in inches
width = 5.5
height = 8.5

# x-axis resolution
set samples 1000

set pointsize 0.5    # Size of the plotted points

# Line styles.
# For lines: plot x with lines ls 1
# For points: plot x with points ls 1

set style line 1 lc rgb myblue pt 5   # square
set style line 2 lc rgb myred pt 7   # circle
set style line 3 lc rgb 'dark-orange' pt 9   # triangle
set style line 4 lc rgb mygreen pt 7   # circle
set style line 5 lc rgb mypurple pt 7   # circle
set style line 6 lc rgb myviolet  pt 7   # circle
set style line 7 lc rgb mybrown  pt 7   # circle
set style line 8 lc rgb myorange  pt 7   # circle
set style line 9 lc rgb 'black' pt 7   # circle
set style line 10 lc rgb 'gold' pt 7   # circle

#set xtics rotate        # Rotates x tic numbers by 90 degrees
#set ytics rotate        # Rotates y tic numbers by 90 degrees

# Set tic labeling with color
set xtics textcolor rgb tic_color
set ytics textcolor rgb tic_color

set bmargin 4  # Bottom margin

# Set screen display to same aspect ratio as postscript plot
set size ratio height/width

set xlabel 'r/R_0' textcolor rgb tic_color
set ylabel 'Probability' textcolor rgb tic_color

# Uncomment following to set log or log-log plots
#set logscale x
#set logscale y

set key top right font "Arial,9"   # Move legend to top right
#unset key           # Don't show legend
#set timestamp       # Date/time

# Input data

radcon = 180/pi  # Radian-degrees conversion

theta_v = 35          # Vacuum mixing angle, degrees
tv = theta_v/radcon     # Convert to radians
E = 10         # Neutrino energy in MeV
dm2 = 7.6e-5            # Difference in mass squared in eV^2
m12 = 5e-5           # mass-squared of nu_1 (assumed)
m22 = m12+dm2          # mass-squared of nu_2

# Function definitions

# Bahcall standard solar approx. Eq. (14) in Bahcall et al
# Ap J 555, 990 (2001)

aa = 1.47539e26
alph = 10.54

ne(x) = aa*exp(-alph*x)

# Resonance length in meters
norm=9.785e30
scriptell_m(x) = norm/ne(x)

# Critical (resonance) density

neR = 3.95e30*(dm2/E)*cos(2*tv)

#  Radius of resonance density with Bahcall param
#  in fraction of solar radius

rcrit = -(1/alph)*log(neR/aa)

# Vacuum oscillation length in meters

L = 2.48*E/dm2

# Matter mixing angle

C = cos(2*tv)
S = sin(2*tv)

chi(x) = L/scriptell_m(x)

g(x) = (C-chi(x))**2 +S**2

sin2tm(x) = S/sqrt( (C-chi(x))**2 +S**2 )

gxC=gprintf("2tv=%g",2*tv).gprintf(" cos2tv=%g",C).gprintf(" sin2tv=%g",S)\
.gprintf(" innerTerm=%g",sqrt( (C-chi(0.01))**2 +S**2 ))\
.gprintf(" chi(0.01)=%g",chi(0.01))\
.gprintf(" sin2tm(0.01)=%g",sin2tm(0.01))
print gxC

# Matter mixing angle in radians

thetam(x) = 0.5*asin(sin2tm(x))

# Evaluate matter angle in correct angle sector for x=R/R0

tm(x) = x > rcrit ? thetam(x) : pi/2-thetam(x)  # Below and above resonance

# thetam at center. Note that this will differ a little from the actual
# value at center because the exponential approximation we are using here
# for electron density in the Sun is not so good exactly at center.

thet1 = tm(0)

# Probability to be electron neutrino at x=R/R0

Pe(x) = 0.5*(1 + cos(2*tm(x)) * cos(2*thet1) )

# Probability to be electron neutrion at x=R/R0

Pmu(x) = 1-Pe(x)

# Matter oscillation length L_m in meters

denom(x) = sqrt(1-(2*L/scriptell_m(x))*cos(2*tv)+(L/scriptell_m(x))**2)
Lm(x) = L/denom(x)

betheA(x) = (L/scriptell_m(x))*dm2

term1(x) = (m12 + m12 +dm2 + betheA(x))/2.0
term2(x) = sqrt( (dm2*cos(2*tv)-betheA(x))**2 + dm2*dm2*(sin(2*tv))**2 )/2.0
lam1(x) = term1(x) + term2(x)
lam2(x) = term1(x) - term2(x)

d1=gprintf("theta_v=%g",theta_v). " deg."
d2=gprintf("L=%g",L/1000)." km"
d3=gprintf("Del m^2=%g",dm2)." eV^2"
d4=gprintf("ne(0.25)=%g",ne(0.25))." g/cm^3"
d6=gprintf("Lm(rcrit)=%g",Lm(rcrit)/1000). " km."
d7=gprintf("neR=%g",neR). " g/cm3."
d8=gprintf("rcrit=%g",rcrit). " solar radii."
d9=gprintf("scriptell_m(rcrit)=%g",scriptell_m(rcrit)/1000). " km."
d10=gprintf("tm(0)=%g",\
tm(0)*radcon).gprintf(" deg tm(1)=%g",tm(1)*radcon)."deg"
d10a=gprintf("sin^2 tm(0)=%g", (sin(tm(0)))**2)
d10a=d10a.gprintf(" cos^2 tm(0)=%g", (cos(tm(0)))**2)
d11=gprintf("Pe(0)=%g",Pe(0)).gprintf(" Pe(1)=%g",Pe(1))

print d1
print d2
print d3
print d4
print d6
print d7
print d8
print d9
print d10
print d10a
print d11

ds=gprintf("tv=%g",theta_v)." deg; "
ds=ds.gprintf("L=%g",L/1000)." km "
ds2=gprintf("dE2=%g",dm2).gprintf(" eV^2 E=%g",E)." MeV"
set title ds.ds2 textcolor rgb title_color font "Arial,10"

set xrange [0.6:0.0]
set yrange[0:1.0]

# Plot and print electron number density
set table "electronNumberDensity.dat"
plot ne(x)
unset table

# Plot and print coupling strength
set table "couplingStrength.dat"
plot chi(x)
unset table

# Plot and print g(x) "inner term"
set table "gx_innerTerm.dat"
plot g(x)
unset table

# Plot and print sin(2*theta_m)
set table "sin2tm.dat"
plot sin2tm(x)
unset table

# Plot and print the matter mixing angle
set table "matterMixingAngle.dat"
plot tm(x)
unset table

# Plots versus x = R/R0

# theta matter versus R/R0

plot tm(x)*radcon/100 ls 2

# Probabilility to be electron neutrino versus R/R0,
# Assuming the neutrino created at center as electron flavor

#plot Pe(x) ls 1

# Probability to be a muon neutrino

#replot Pmu(x) ls 4

#set title ds.ds2 textcolor rgb title_color font "Arial,24"
#set key top right font "Arial,24"

# Plot to postscript file

#set out "flavorVsR.eps"    # Output file
#set terminal postscript eps size width, height enhanced color solid lw 2 "Arial" 32
#replot               # Plot to postscript file

# Plot to PNG file

#set out "flavorVsR.png"
# Assume 72 pixels/inch and make bitmap twice as large for display resolution
#set terminal png transparent size 2*width*72, 2*height*72 lw 2 enhanced font 'Arial,28'
#replot

quit
