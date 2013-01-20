puts <<-EOS
set terminal png
set nokey
set xrange [-2:2]
set yrange [-1:1]
set size ratio 0.5
set zeroaxis
set parametric
set trange [0:1]
EOS

step = 0
open("oscillator.dat").each do |line|
    t,x,v = line.split.map(&:to_f)

    puts "set output \"anime-#{sprintf("%04d", step)}.png\""
    puts "plot #{x} + 0.1*cos(2*pi*t), 0.1*sin(2*pi*t), -2*(1-t) + #{x}*t, 0"

    step += 1
end
