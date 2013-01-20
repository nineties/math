require 'matrix'

k = 1.0
m = 1.0
$g = 9.8
N    = 1000
tmin = 0.0
#tmax = 100*Math::PI
x = Vector[0.0, 0.0]

$a    = k/m
#dt   = (tmax-tmin)/N
dt = 0.1

def acc(x)
    Vector[x[1], $g - $a*x[0]]
end

puts "#{tmin} #{x[0]} #{x[1]}"
0.upto(N-1) do |i|
    t1 = tmin + i*dt
    t2 = tmin + (i + 1)*dt

    # forward euler
    #v1 = v
    #v += (g-a*x)*dt
    #x += v1*dt
 
    # backward euler
    #r  = 1+a*dt**2
    #v = (v + (g-a*x)*dt)/(1+a*dt**2)
    #x += v*dt

    # trapezoid
    #v = (4*v + 4*(g-a*x)*dt - a*v*dt**2)/(4+a*dt**2)
    #x += v*dt

    k1 = acc(x)
    k2 = acc(x+k1*dt/2)
    k3 = acc(x+k2*dt/2)
    k4 = acc(x+k3*dt)

    x += (k1+2*k2+2*k3+k4)*dt/6

    puts "#{t2} #{x[0]} #{x[1]}"
end
