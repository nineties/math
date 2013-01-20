set terminal postscript eps color
set output "ex5.eps"
plot "forward_euler.dat" w lp, "backward_euler.dat" w lp, "trapezoid.dat" w lp, exp(-x)
