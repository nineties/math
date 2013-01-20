system("ruby wave.rb > wave.dat")

io = File.open("wave.dat")

i = 0
until io.eof?
    i += 1

    p = IO.popen("gnuplot", "w")

    s = <<-EOS
        set terminal png size 1280,960

        set contour
        unset surface
        set view 0,0
        set cntrparam levels incremental -1, 1, 1

        set size square
        set nokey
        set output "wave-#{sprintf("%04d", i)}.png"
        set zrange [-1:1]
        set hidden3d
        set zeroaxis
        splot '-' w l

    EOS
    #s = <<-EOS
    #    set terminal png
    #    set contour
    #    unset surface
    #    set view 0,0
    #    set nokey
    #    set output "wave-#{sprintf("%04d", i)}.png"
    #    set zrange [-1:1]
    #    set hidden3d
    #    set zeroaxis
    #    splot '-' w l
    #EOS
    p.puts(s)

    loop do
        l = io.readline
        break if l == "end\n"
        p.puts(l)
    end

    p.puts("end")
    p.close
end

system("ffmpeg -y -r 10 -i wave-%04d.png wave.mp4")
system("rm -rf *.png")
