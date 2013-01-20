include Math

Nx = 300
Nt = 500
$tmin = 0.0
$tmax = 30.0
$dt = ($tmax-$tmin)/Nt

$xmin = 0.0
$xmax = 30.0
$dx = ($xmax-$xmin)/Nx

alpha = ($dt/$dx)**2

def u0(i, j)
    0.0
end

def v0(i,j)
    0.0
end

def print(u, i)
    0.upto(Nx) do |j|
        0.upto(Nx) do |k|
            if j % 5 == 0 && k % 5 == 0
                puts "#{$xmin + j*$dx} #{$xmin + k*$dx} #{u[j][k]}"
            end
        end
        if j % 5 == 0
            puts ""
        end
    end
    puts "end"
end

u1 = Array.new(Nx + 1)
0.upto(Nx) do |i|
    u1[i] = Array.new(Nx + 1)
    0.upto(Nx) {|j| u1[i][j] = u0(i, j) }
end

u2 = Array.new(Nx + 1)
0.upto(Nx) do |i|
    u2[i] = Array.new(Nx + 1)
    if i == 0 || i == Nx
        0.upto(Nx) {|j| u2[i][j] = 0.0}
    else
        u2[i][0] = 0.0
        1.upto(Nx-1) {|j| u2[i][j] = u1[i][j] + v0(i,j)*$dt + alpha*(u1[i+1][j] - 2*u1[i][j] + u1[i-1][j])/2 + alpha*(u1[i][j+1] - 2*u1[i][j] + u1[i][j-1])/2}
        u2[i][Nx] = 0.0
    end
end

print(u1, 0)
0.upto(Nt-1) do |i|
    0.upto(Nx) do |j|
        0.upto(Nx) do |k|
            if j == 0 || j == Nx || k == 0 || k == Nx
                u1[j][k] = 0.0
            elsif j == Nx/2 && ($xmin + k*$dx - ($xmin+$dx*Nx/6+$tmin + 1.2*i*$dt)).abs < 10e-2
                u1[j][k] = sin(2*($tmin + i*$dt))
            else
                u1[j][k] = alpha*(u2[j-1][k]+u2[j+1][k]+u2[j][k-1]+u2[j][k+1]-4*u2[j][k])+2*u2[j][k]-u1[j][k]
            end
        end
    end
    u1, u2 = u2, u1
    print(u1, i+1)
end
