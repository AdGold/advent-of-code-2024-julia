function part1(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    seen = Set{CartesianIndex}()
    dfs(p, e) = get(data, p, 0) != e ? [0 1] : p in seen ? [0 0] : (push!(seen, p); [1 0] + sum(dfs(p + d, e) for d in dirs))
    sum(prod(dfs(p, data[p])) for p in keys(data))
end

function part2(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    seen = Set{CartesianIndex}()
    add(a, b) = [a[1] + b[1], vcat(a[2], b[2])]
    recurse(p, e) = (push!(seen, p); add([1,[]], reduce(add, dfs.(p .+ dirs, e, dirs), init=[0, []])))
    dfs(p, e, d=0) = get(data, p, 0) != e ? [0,[(p, d)]] : p in seen ? [0, []] : recurse(p, e)
    cost(a, p) = isempty(p) ? 0 : a * (length(p) - sum((f+d, fd) in p for (f, fd) in p for d in dirs[1:2]))
    sum(cost(dfs(p, data[p])...) for p in keys(data))
end

function part1_cleaned(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    seen = Set{CartesianIndex}()
    dfs(p, e) = get(data, p, 0) != e ? [0 1] : p in seen ? [0 0] : (push!(seen, p); [1 0] + sum(dfs.(p .+ dirs, e)))
    sum(prod.(dfs.(keys(data), data)))
end

function part2_cleaned(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    seen = Set{CartesianIndex}()
    corners(p, e) = count(x -> x[1] == x[3] && x[1] ⊼ x[2],
                          [get.(Ref(data), p .+ [d, d + nd, nd], 0) .== e for (d, nd) in zip(dirs, circshift(dirs, 1))])
    dfs(p, e) = get(data, p, 0) != e || p in seen ? [0 0] : (push!(seen, p); sum(dfs.(p .+ dirs, e)) + [1 corners(p, e)])
    sum(prod.(dfs.(keys(data), data)))
end

data = stack(readlines("input.txt"))
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
