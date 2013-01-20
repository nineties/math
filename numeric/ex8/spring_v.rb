require 'matrix'

N    = 30
tmin = 0.0
tmax = 4*Math::PI
x = Vector[1.0, 0.0]

dt   = (tmax-tmin)/N

def f(x)
    a = 1.0/1.0
    Vector[x[1], - a*x[0]]
end

puts "#{tmin} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    k1 = f(x)
    k2 = f(x+k1*dt/2)
    k3 = f(x+k2*dt/2)
    k4 = f(x+k3*dt)
    x += (k1+2*k2+2*k3+k4)*dt/6

    puts "#{tmin+(i+1)*dt} #{x[0]} #{x[1]}"
end
