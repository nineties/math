n = 10
loop do
    dt = (Math::PI)/2/n
    x = 0.0

    0.upto(n-1) do |i|
        t1 = i*dt
        t2 = (i+1)*dt
        x += Math.cos((t1+t2)/2) * dt
    end
    puts sprintf("%.15f", x)
    break if  n == 10e7
    n *= 10
end
