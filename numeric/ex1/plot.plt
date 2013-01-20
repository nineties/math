set terminal postscript eps color
set output "answer1.eps"
plot "forward_euler.dat" w lp, "backward_euler.dat" w lp, "middle_point.dat" w lp, "trapezoid.dat" w lp, x**2
