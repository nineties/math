M = 1000
N = 10**5
a = Array.new(N, 0)

M.times do
    s = 0.0
    N.times do |i|
        if rand(2) == 0
            s += Float::EPSILON
        else
            s -= Float::EPSILON
        end
        a[i] += s.abs
    end
end
a = a.map {|v| v.to_f/M}
N.times do |i|
    if i%100 == 0
        puts "#{i} #{a[i]}"
    end
end
