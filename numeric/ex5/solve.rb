N = 10
dt = 1.0/N
x = 1.0

puts "#{0.0} #{x}"
0.upto(N-1) do |i|
    t2 = (i+1)*dt
    x = (1-dt)*x 
    #x = x/(1+dt)
    #x = (2-dt)/(2+dt)*x
    puts "#{t2} #{x}"
end
