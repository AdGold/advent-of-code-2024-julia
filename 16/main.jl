using DataStructures
using Graphs
using SparseArrays

function part1(data)
    INF = typemax(Int)
    rot(d) = CartesianIndex(d[2], -d[1])
    s = findfirst(data .== 'S')
    east = CartesianIndex(1, 0)
    best = Dict((s, east) => 0)
    pq = BinaryMinHeap([(0, s, east)])
    while !isempty(pq)
        score, pos, dir = pop!(pq)
        data[pos] == 'E' && return score
        for (p, d, s) in [(pos + dir, dir, score + 1), (pos, rot(dir), score + 1000), (pos, -rot(dir), score + 1000)]
            (s >= get(best, (p, d), INF) || data[p] == '#') && continue
            best[(p, d)] = s
            push!(pq, (s, p, d))
        end
    end
end

function part2(data)
    INF = typemax(Int)
    rot(d) = CartesianIndex(d[2], -d[1])
    start = findfirst(data .== 'S')
    east = CartesianIndex(1, 0)
    best = Dict((start, east) => 0)
    from = Dict((start, east) => [])
    pq = BinaryMinHeap([(0, start, east)])
    stack = []
    bestend = INF
    while !isempty(pq)
        score, pos, dir = pop!(pq)
        score > bestend && break
        if data[pos] == 'E' 
            push!(stack, (pos, dir))
            bestend = score
        end
        for (p, d, s) in [(pos + dir, dir, score + 1), (pos, rot(dir), score + 1000), (pos, -rot(dir), score + 1000)]
            curbest = get(best, (p, d), INF)
            (s > curbest || data[p] == '#') && continue
            if s == curbest
                push!(from[(p, d)], (pos, dir))
            else
                best[(p, d)] = s
                from[(p, d)] = [(pos, dir)]
                push!(pq, (s, p, d))
            end
        end
    end
    path(x) = vcat([x], path.(from[x])...)
    return length(unique(first.(vcat(path.(stack)...))))
end

function buildgraph(data)
    rows, cols = size(data)
    index(pos, dir) = ((pos[1] - 1) * cols + (pos[2] - 1)) * 4 + dir
    dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]
    g = SimpleDiGraph(rows * cols * 4)
    weights = spzeros(rows * cols * 4, rows * cols * 4)
    for pos in keys(data)
        for d in 1:4
            add_edge!(g, index(pos, d), index(pos, mod1(d+1, 4)))
            weights[index(pos, d), index(pos, mod1(d+1, 4))] = 1000
            add_edge!(g, index(pos, d), index(pos, mod1(d-1, 4)))
            weights[index(pos, d), index(pos, mod1(d-1, 4))] = 1000
            newpos = pos + CartesianIndex(dirs[d])
            if get(data, newpos, '#') != '#' 
                add_edge!(g, index(pos, d), index(newpos, d))
                weights[index(pos, d), index(newpos, d)] = 1
            end
        end
    end
    return g, weights, index
end

function part1_library(data)
    g, weights, index = buildgraph(data)
    s = index(findfirst(data .== 'S'), 1)
    e = findfirst(data .== 'E')
    res = dijkstra_shortest_paths(g, s, weights)
    return Int(minimum(res.dists[index(e, d)] for d in 1:4))
end

function part2_library(data)
    g, weights, index = buildgraph(data)
    s = index(findfirst(data .== 'S'), 1)
    e = findfirst(data .== 'E')
    res = dijkstra_shortest_paths(g, s, weights, allpaths=true)
    best = minimum(res.dists[index(e, d)] for d in 1:4)
    stack = [index(e, d) for d in 1:4 if res.dists[index(e, d)] == best]
    path(pos) = vcat([pos], path.(res.predecessors[pos])...)
    return length(unique(fld.(vcat(path.(stack)...) .- 1, 4)))
end

data = stack(readlines("input.txt"))
@assert part1(data) == part1_library(data)
@time println(part1(data))
@time println(part1_library(data))
@assert part2(data) == part2_library(data)
@time println(part2(data))
@time println(part2_library(data))
