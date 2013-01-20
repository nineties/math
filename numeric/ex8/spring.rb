k = 1.0
m = 1.0
g = 9.8
N    = 1000
tmin = 0.0
tmax = 100*Math::PI
x    = 0.0
v    = 0.0

a    = k/m
dt   = (tmax-tmin)/N

puts "#{tmin} #{x} #{v}"
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

    v_k1 = -a*x
    x_k1 = v
    v_k2 = -a*(x+x_k1*dt/2)
    x_k2 = v+v_k1*dt/2
    v_k3 = -a*(x+x_k2*dt/2)
    x_k3 = v+v_k2*dt/2
    v_k4 = -a*(x+x_k3*dt)
    x_k4 = v+v_k3*dt

    v += (v_k1+2*v_k2+2*v_k3+v_k4)*dt/6
    x += (x_k1+2*x_k2+2*x_k3+x_k4)*dt/6

    puts "#{t2} #{x} #{v}"
end
