require 'matrix'
include Math

N     = 1000
$tmax = 100.0
dt    = $tmax/N

def len(t, x)
    1.0 + 0.05*cos(3*sqrt(9.8)*t)
end

def f(t, x)
    Vector[x[1], - 9.8 / len(t, x) * sin(x[0])]
end

x = Vector[0.3, 0.0]

puts "#{0.0} #{len(0.0, x)} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    t = i*dt
    k1 = f(t, x)
    k2 = f(t + dt/2, x + k1*dt/2)
    k3 = f(t + dt/2, x + k2*dt/2)
    k4 = f(t + dt/2, x + k3*dt)
    x += (k1 + 2*k2 + 2*k3 + k4)*dt/6

    puts "#{(i+1)*dt} #{len(t, x)} #{x[0]} #{x[1]}"
end
