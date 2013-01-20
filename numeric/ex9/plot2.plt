#set terminal postscript eps color
#set output "spring_balance2.eps"
set zeroaxis
set samples 10000
plot "spring_balance.dat" w lp, -9.8*cos(x)+9.8
pause -1
