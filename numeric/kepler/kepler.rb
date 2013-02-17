require 'matrix'
include Math

N    = 1000
tmax = 100.0
dt   = tmax/N

def f(x)
    x * -1 / (x.r)**3 
end

x = Vector[1.0, 0.0]
v = Vector[0.0, 1.0]

puts "#{0.0} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    v += f(x)*dt
    x += v*dt
    puts "#{(i+1)*dt} #{x[0]} #{x[1]}"
end
