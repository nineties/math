require 'matrix'
include Math

N    = 200
tmax = 2.0
dt   = tmax/N

g = Vector[0.0, -9.8]
x = Vector[0.0, 0.0]
v = Vector[sqrt(5*9.8), sqrt(5*9.8)]

def rk4(f, dt)
    k1 = f
    k2 = f + k1*dt/2
    k3 = f + k2*dt/2
    k4 = f + k3*dt
    (k1 + 2*k2 + 2*k3 + k4)*dt/6
end

puts "#{0.0} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    x2 = x + rk4(v, dt)
    v2 = v + rk4(g, dt)
    x = x2
    v = v2
    puts "#{(i+1)*dt} #{x[0]} #{x[1]}"
end
