system("ruby nbody.rb > nbody.dat")

io = File.open("nbody.dat")
M = io.readline.to_i
i = 0
until io.eof?
    i += 1

    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "nbody-#{sprintf("%04d", i)}.png"
        set size square
        set yrange [-10:10]
        set xrange [-10:10]
        set trange [0:1]
        set zeroaxis
        set parametric
    EOS
    p.puts(s)

    p.print "plot "
    M.times do |i|
        t, x, y = io.readline.split.map(&:to_f)
        p.print "#{x} + 0.1*cos(2*pi*t), #{y} + 0.1*+sin(2*pi*t) "
        if i < M-1
            p.print ","
        end
    end
    p.puts ""

    p.close
end

system("ffmpeg -y -r 10 -i nbody-%04d.png nbody.mp4")
system("rm -rf *.png")
