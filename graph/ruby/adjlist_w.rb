class Graph
    def initialize(nv, edges)
        @nvertices = nv
        @adjlist = nv.times.collect { [] }
        edges.each do |i, j, w|
            @adjlist[i] << [j, w]
        end
    end
    def each_vertices
        @nvertices.times do |i|
            yield i
        end
    end
    def each_edges
        @nvertices.times do |i|
            @adjlist[i].each do |j, w|
                yield [i, j, w]
            end
        end
    end
    def each_successors(i)
        @adjlist[i].each do |j, w|
            yield [j, w]
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



