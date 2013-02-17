require 'matrix'
include Math

N    = 1000
tmax = 100.0
dt   = tmax/N
M    = 5

def f(x, xs)
    force = Vector[0.0, 0.0]
    xs.each do |y|
        next if x == y
        force += (x-y) * -1 / ((x-y).r + 0.1)**3 
    end
    force
end

xs = []
vs = []

0.upto(M-1) do |i|
    xs[i] = Vector[6*rand-3, 6*rand-3]
    vs[i] = Vector[rand-0.5, rand-0.5]
end

puts M

xs.each do |x|
    puts "#{0.0} #{x[0]} #{x[1]}"
end

0.upto(N-1) do |i|
    0.upto(M-1) do |j|
        vs[j] += f(xs[j], xs)*dt
    end
    0.upto(M-1) do |j|
        xs[j] += vs[j]*dt
    end

    xs.each do |x|
        puts "#{(i+1)*dt} #{x[0]} #{x[1]}"
    end
end
