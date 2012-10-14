class Graph
    def dfs_preorder(start)
        visited = Array.new(@nvertices, false)
        Enumerator.new(self, :dfs_sub, start, visited, true)
    end

    def dfs_postorder(start)
        visited = Array.new(@nvertices, false)
        Enumerator.new(self, :dfs_sub, start, visited, false)
    end

    private
    def dfs_sub(i, visited, pre, &blk)
        return if visited[i]
        visited[i] = true

        yield i if pre

        self.successors(i).each do |j|
            dfs_sub(j, visited, pre, &blk)
        end

        yield i if !pre
    end

    public
    def dijkstra(start, goal)
        d = Array.new(@nvertices, 1/0.0)
        d[start] = 0
        prev = Array.new(@nvertices)
        visited = Array.new(@nvertices, false)
        count = 0
        while (count != @nvertices) do
            min = 1/0.0
            u = 0
            @nvertices.times do |i|
                if d[i] < min && !visited[i]
                    min = d[i]
                    u = i
                end
            end

            visited[u] = true
            count += 1

            successors(u).each do |v, w|
                next if visited[v]
                new_d = d[u] + w
                if d[v] > new_d
                    d[v] = new_d
                    prev[v] = u
                end
            end
        end


        # Construct the shortest-path
        path = []
        p = goal
        while p != start
            path.unshift p
            p = prev[p]
        end
        path.unshift start
        path
    end
end
