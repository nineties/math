require 'matrix'

k = 1.0
m = 1.0
$g = 9.8
$mu = 0.1
N    = 1000
tmin = 0.0
#tmax = 100*Math::PI
x = Vector[0.0, 0.0]

$a    = k/m
#dt   = (tmax-tmin)/N
dt = 0.1

def acc(t,x)
    Vector[x[1], $g - $mu*x[1] - $a*(x[0] - 5.0*Math.sin(1.5*t))]
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

    k1 = acc(t1, x)
    k2 = acc(t1+dt/2, x+k1*dt/2)
    k3 = acc(t1+dt/2, x+k2*dt/2)
    k4 = acc(t1+dt, x+k3*dt)

    x += (k1+2*k2+2*k3+k4)*dt/6

    puts "#{t2} #{x[0]} #{x[1]}"
end
