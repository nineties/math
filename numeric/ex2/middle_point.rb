N = 10
dt = Math::PI/N
x = 0.0

puts "0.0 #{x}"

0.upto(N-1) do |i|
    t1 = i*dt
    t2 = (i+1)*dt
    x += Math.cos((t1+t2)/2) * dt
    puts "#{t2} #{x}"
end
