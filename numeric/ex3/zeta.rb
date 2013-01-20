N = 100000
s = 0.0
1.upto(N) do |n|
    s += 1.0/n**4
end
puts "upto:\t#{s}"

s = 0.0
N.downto(1) do |n|
    s += 1.0/n**4
end
puts "downto:\t#{s}"

puts "real:\t#{Math::PI**4/90}"
