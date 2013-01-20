system("ruby pendulum.rb > pendulum.dat")

io = File.open("pendulum.dat")
i = 0
until io.eof?
    i += 1

    t, l, x, v = io.readline.split.map(&:to_f)
    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "pendulum-#{sprintf("%04d", i)}.png"
        set size 0.75
        set yrange [-1.5:0]
        set xrange [-1:1]
        set trange [0:1]
        set zeroaxis
        set parametric
        plot #{l}*sin(#{x}) + 0.05*cos(2*pi*t), -#{l}*cos(#{x}) + 0.05*sin(2*pi*t), t*sin(#{x}), -t*cos(#{x})
    EOS
    p.puts(s)
    p.close
end

system("ffmpeg -y -r 10 -i pendulum-%04d.png pendulum.mp4")
system("rm -rf *.png")
