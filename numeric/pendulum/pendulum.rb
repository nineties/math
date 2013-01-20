require 'matrix'
include Math

N     = 1000
$tmax = 100.0
dt    = $tmax/N

def f(x)
    Vector[x[1], - 9.8 * sin(x[0])]
end

x = Vector[1.0, 0.0]

puts "#{0.0} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    k1 = f(x)
    k2 = f(x + k1*dt/2)
    k3 = f(x + k2*dt/2)
    k4 = f(x + k3*dt)
    x += (k1 + 2*k2 + 2*k3 + k4)*dt/6

    puts "#{(i+1)*dt} #{x[0]} #{x[1]}"
end
