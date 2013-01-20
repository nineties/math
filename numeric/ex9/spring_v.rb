require 'matrix'

k = 1.0
m = 1.0
N    = 100
tmin = 0.0
tmax = 4*Math::PI
x = Vector[1.0, 0.0]

$a    = k/m
dt   = (tmax-tmin)/N

def acc(x)
    Vector[x[1], - $a*x[0]]
end

puts "#{tmin} #{x[0]} #{x[1]}"

f0 = acc(x)
x += f0*dt
f1 = acc(x)

puts "#{tmin+dt} #{x[0]} #{x[1]}"

1.upto(N-1) do |i|
    x += (3*f1 - f0)/2*dt
    f0, f1 = f1, acc(x)

    puts "#{tmin+(i+1)*dt} #{x[0]} #{x[1]}"
end
