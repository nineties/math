set terminal postscript eps color
set key left top
set output "answer2.eps"
plot "forward_euler.dat" w lp, "backward_euler.dat" w lp, "middle_point.dat" w lp, "trapezoid.dat" w lp, sin(x)
