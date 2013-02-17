require 'matrix'
include Math

N    = 200
tmax = 2.0
dt   = tmax/N

g = Vector[0.0, -9.8]
x1 = Vector[0.0, 0.0]
v1 = Vector[9.0, 9.0]

x2 = Vector[10.0, 10.0]
v2 = Vector[0.0, 0.0]

def rk4(f, dt)
    k1 = f
    k2 = f + k1*dt/2
    k3 = f + k2*dt/2
    k4 = f + k3*dt
    (k1 + 2*k2 + 2*k3 + k4)*dt/6
end

puts "#{0.0} #{x1[0]} #{x1[1]}"
puts "#{0.0} #{x2[0]} #{x2[1]}"
0.upto(N-1) do |i|
    x1, v1 = x1 + rk4(v1, dt), v1 + rk4(g, dt)
    x2, v2 = x2 + rk4(v2, dt), v2 + rk4(g, dt)
    puts "#{(i+1)*dt} #{x1[0]} #{x1[1]}"
    puts "#{(i+1)*dt} #{x2[0]} #{x2[1]}"
end
