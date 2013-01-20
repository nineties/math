system("ruby spring_v.rb > runge_kutta.dat")

io = File.open("runge_kutta.dat")
i = 0
until io.eof?
    i += 1
    t,x,v = io.readline.split.map(&:to_f)

    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png
        set nokey
        set output "spring-#{sprintf("%04d", i)}.png"
        set zeroaxis
        set xrange [-2:2]
        set yrange [-20:4]
        set trange [0:1]
        set size ratio 6
        set parametric
        plot 0.5*cos(2*pi*t), 0.5*sin(2*pi*t)-#{x}, 0, -t*#{x}, -2*t+(1-t)*2, 0
    EOS
    p.puts(s)
    p.close
end

system("ffmpeg -i spring-%4d.png spring.mpeg -r 10 -y")
system("rm -rf *.png")
