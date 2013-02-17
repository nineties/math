system("ruby monkey_hunt.rb > monkey_hunt.dat")

io = File.open("monkey_hunt.dat")
i = 0
until io.eof?
    i += 1

    t1, x1, y1 = io.readline.split.map(&:to_f)
    t2, x2, y2 = io.readline.split.map(&:to_f)
    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "monkey_hunt-#{sprintf("%04d", i)}.png"
        set size square
        set yrange [0:10]
        set xrange [0:10]
        set trange [0:1]
        set zeroaxis
        set parametric
        plot #{x1} + 0.1*cos(2*pi*t), #{y1} + 0.1*+sin(2*pi*t), #{x2} + 0.1*cos(2*pi*t), #{y2} + 0.1*+sin(2*pi*t)
    EOS
    p.puts(s)
    p.close
end

system("ffmpeg -y -r 25 -i monkey_hunt-%04d.png monkey_hunt.mp4")
system("rm -rf *.png")
