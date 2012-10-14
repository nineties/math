class Graph
    def initialize(nv, edges)
        @nvertices = nv
        @adjmat = nv.times.collect { Array.new(nv, 0) }
        edges.each do |i, j, w|
            @adjmat[i][j] = w
        end
    end
    def each_vertices
        @nvertices.times do |i|
            yield i
        end
    end
    def each_edges
        @nvertices.times do |i|
            @nvertices.times do |j|
                w = @adjmat[i][j]
                yield [i,j,w] if w != 0
            end
        end
    end
    def each_successors(i)
        @nvertices.times do |j|
            w = @adjmat[i][j]
            yield [j,w] if w != 0
        end
    end
    def vertices
        Enumerator.new(self, :each_vertices)
    end
    def edges
        Enumerator.new(self, :each_edges)
    end
    def successors(i)
        Enumerator.new(self, :each_successors, i)
    end
end


