include Math

Nx = 1000
Nt = 10000
$tmin = 0.0
$tmax = 100.0
$dt = ($tmax-$tmin)/Nt

$xmin = 0.0
$xmax = 10.0
$dx = ($xmax-$xmin)/Nx

k = ($dt/$dx)**2

def u0(i)
    0.0
end

def v0(i)
    0.0
end

def print(u, i)
    return if i%10 != 0
    0.step(Nx, 10) do |j|
        puts "#{$tmin + i*$dt} #{$xmin + j*$dx} #{u[j]}"
    end
    puts ""
end

u1 = Array.new(Nx + 1)
0.upto(Nx) {|i| u1[i] = u0(i) }
u2 = Array.new(Nx + 1)

u2[0] = 0.0
1.upto(Nx-1) {|i| u2[i] = u1[i] + v0(i)*$dt + (u1[i+1] - 2*u1[i] + u1[i-1])/2 }
u2[Nx] = 0.0

print(u1, 0)

0.upto(Nt-1) do |i|
    0.upto(Nx) do |j|
        if j==0
            u1[0] = 0.5*sin(3*($tmin + i*$dt))
        elsif j == Nx
            u1[j] = 0.0
        else
            u1[j] = k*(u2[j-1]-2*u2[j]+u2[j+1])+2*u2[j]-u1[j]
        end
    end
    print(u1, i+1)
    u1, u2 = u2, u1
end
