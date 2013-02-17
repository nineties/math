system("ruby kepler.rb > kepler.dat")

io = File.open("kepler.dat")
i = 0
until io.eof?
    i += 1

    t, x, y = io.readline.split.map(&:to_f)
    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "kepler-#{sprintf("%04d", i)}.png"
        set size square
        set yrange [-3:3]
        set xrange [-3:3]
        set trange [0:1]
        set zeroaxis
        set parametric
        plot 0.1*cos(2*pi*t), 0.1*sin(2*pi*t), #{x} + 0.1*cos(2*pi*t), #{y} + 0.1*+sin(2*pi*t)
    EOS
    p.puts(s)
    p.close
end

system("ffmpeg -y -r 10 -i kepler-%04d.png kepler.mp4")
system("rm -rf *.png")
