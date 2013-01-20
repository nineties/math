def solve(a, b, x)
    6.times {
        x = a*Math.sin(x) + b
    }
    x
end

N  = 10
x  = Math::PI/2
dt = 1.0/N

puts "#{0.0} #{x}"
0.upto(N-1) do |i|
    t2 = (i+1)*dt

    x = solve(dt, x, x)

    puts "#{t2} #{x}"
end
