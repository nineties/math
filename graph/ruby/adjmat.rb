class Graph
    def initialize(nv, edges)
        @nvertices = nv
        @adjmat = nv.times.collect { Array.new(nv, 0) }
        edges.each do |i, j|
            @adjmat[i][j] = 1
        end
    end
    attr_reader :nvertices
    def each_vertices
        @nvertices.times do |i|
            yield i
        end
    end
    def each_edges
        @nvertices.times do |i|
            @nvertices.times do |j|
                yield [i,j] if @adjmat[i][j] == 1
            end
        end
    end
    def each_successors(i)
        @nvertices.times do |j|
            yield [j] if @adjmat[i][j] == 1
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


