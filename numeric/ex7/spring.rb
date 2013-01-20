k = 1.0
m = 1.0
g = 9.8
N    = 100
tmin = 0.0
tmax = 4*Math::PI
x    = 1.0
v    = 0.0

a    = k/m
dt   = (tmax-tmin)/N

puts "#{tmin} #{x} #{v}"
0.upto(N-1) do |i|
    t2 = tmin + (i + 1)*dt

    # forward euler
    v1 = v
    v += -a*x*dt
    x += v1*dt
 
    # backward euler
    #r  = 1+a*dt**2
    #v = (v -a*x*dt)/(1+a*dt**2)
    #x += v*dt

    # trapezoid
    #v = (4*v - 4*a*x*dt - a*v*dt**2)/(4+a*dt**2)
    #x += v*dt

    puts "#{t2} #{x} #{v}"
end
