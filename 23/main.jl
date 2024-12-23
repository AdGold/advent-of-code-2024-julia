using DataStructures

function part1(data)
    edges = Dict()
    for line in data
        a, b = split(line, '-')
        push!(get!(edges, a, []), b)
        push!(get!(edges, b, []), a)
    end
    tris(x) = Set([Set(sort([x, a, b])) for a in edges[x], b in edges[x] if a in edges[b]])
    length(reduce(union, [tris(x) for x in keys(edges) if x[1] == 't']))
end

function part2(data)
    edges = merge(vcat, [Dict(a => [b], b => [a]) for (a,b) in split.(data, '-')]...)
    function bf(valid)
        isempty(valid) && return []
        c = first(valid)
        t1 = [bf(valid[2:end] ∩ edges[c])..., c]
        t2 = bf(valid[2:end])
        return length(t1) > length(t2) ? t1 : t2
    end
    best = []
    for x in keys(edges)
        t = [bf(edges[x])..., x]
        best = length(t) > length(best) ? t : best
    end
    join(sort(best), ",")
end

function part1_cleaned(data)
    edges = merge(vcat, [Dict(a => [b], b => [a]) for (a,b) in split.(data, '-')]...)
    tris(x) = Set(sort([x, a, b]) for a in edges[x], b in edges[x] if a in edges[b])
    length(reduce(union, tris.(filter(x->x[1]=='t', keys(edges)))))
end

function part2_cleaned(data)
    maxlength(a, b) = length(a) > length(b) ? a : b
    edges = merge(vcat, [Dict(a => [b], b => [a]) for (a,b) in split.(data, '-')]...)
    bf(valid) = isempty(valid) ? [] : maxlength([bf(valid[2:end] ∩ edges[first(valid)])..., first(valid)], bf(valid[2:end]))
    join(sort(reduce(maxlength, [[bf(edges[x])..., x] for x in keys(edges)])), ",")
end

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
