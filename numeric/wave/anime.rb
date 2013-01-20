system("ruby wave.rb > wave.dat")

io = File.open("wave.dat")
i = 0
until io.eof?
    i += 1

    p = IO.popen("gnuplot", "w")
    s = <<-EOS
        set terminal png size 1280,960
        set nokey
        set output "wave-#{sprintf("%04d", i)}.png"
        set yrange [-2:2]
        set zeroaxis
        plot "-" w l
    EOS
    p.puts(s)

    loop do
        l = io.readline
        break if l == "\n"
        t,x,u = l.split.map(&:to_f)
        p.puts("#{x} #{u}")
    end

    p.puts("end")
    p.close
end

system("ffmpeg -y -r 10 -i wave-%04d.png wave.mp4")
system("rm -rf *.png")
