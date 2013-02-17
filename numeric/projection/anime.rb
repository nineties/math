system("ruby fall.rb > fall.dat")

io = File.open("fall.dat")
i = 0
until io.eof?
    i += 1

    t, x, y = io.readline.split.map(&:to_f)
    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "fall-#{sprintf("%04d", i)}.png"
        set size square
        set yrange [0:10]
        set xrange [0:10]
        set trange [0:1]
        set zeroaxis
        set parametric
        plot #{x} + 0.1*cos(2*pi*t), #{y} + 0.1*+sin(2*pi*t)
    EOS
    p.puts(s)
    p.close
end

system("ffmpeg -y -r 100 -i fall-%04d.png fall.mp4")
system("rm -rf *.png")
