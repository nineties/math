require 'matrix'

N    = 200
tmin = 0.0
tmax = 20.0
x = Vector[1.0, 0.0]

$a    = 4*Math::PI**2
dt   = (tmax-tmin)/N

def acc(x)
    Vector[x[1], - $a*x[0]]
end

puts "#{tmin} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    t1 = tmin + i*dt
    t2 = tmin + (i + 1)*dt

    k1 = acc(x)
    k2 = acc(x+k1*dt/2)
    k3 = acc(x+k2*dt/2)
    k4 = acc(x+k3*dt)

    x += (k1+2*k2+2*k3+k4)*dt/6

    puts "#{t2} #{x[0]} #{x[1]}"
end
