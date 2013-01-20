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
        set size ratio 6
        set parametric
        plot 0.5*cos(t), 0.5*sin(t)-#{x}
    EOS
    p.puts(s)
    p.close
end
