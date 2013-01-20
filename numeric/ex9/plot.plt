set terminal postscript eps color
set output "spring.eps"
set zeroaxis
plot "forward_euler.dat" w lp, "backward_euler.dat" w lp, "trapezoid.dat" w lp, "runge_kutta.dat" w lp, "adams.dat" w lp, cos(x)
