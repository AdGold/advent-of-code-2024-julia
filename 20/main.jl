function part1(data)
    INF = typemax(Int) ÷ 10
    dirs = CartesianIndex.([(1, 0), (0, 1), (-1, 0), (0, -1)])
    pos = findfirst(data .== 'S')
    dists = Dict(pos => 0)
    while data[pos] != 'E'
        new = pos + dirs[findfirst(p -> get(data, p, '#') != '#' && !haskey(dists, p), dirs .+ pos)]
        dists[new], pos = dists[pos] + 1, new
    end
    cost(p, d1, d2) = get(dists, p+d1, INF) + (dists[pos] - get(dists, p+d2, -INF)) + 2
    count(cost(p, d1, d2) <= dists[pos] - 100 for p in findall(data .== '#'), d1 in dirs, d2 in dirs)
end

function part2(data)
    INF = typemax(Int) ÷ 10
    dirs = CartesianIndex.([(1, 0), (0, 1), (-1, 0), (0, -1)])
    pos = findfirst(data .== 'S')
    dists = Dict(pos => 0)
    while data[pos] != 'E'
        new = pos + dirs[findfirst(p -> get(data, p, '#') != '#' && !haskey(dists, p), dirs .+ pos)]
        dists[new], pos = dists[pos] + 1, new
    end
    cost(p, d1, d2) = get(dists, p, INF) + (dists[pos] - get(dists, p + CartesianIndex(d1, d2), -INF)) + abs(d1) + abs(d2)
    count(cost(p, d1, d2) <= dists[pos] - 100 for p in findall(data .!= '#'), d1 in -20:20, d2 in -20:20 if abs(d1) + abs(d2) <= 20)
end


function part1_cleaned(data)
    INF = typemax(Int) ÷ 10
    dirs = CartesianIndex.([(1, 0), (0, 1), (-1, 0), (0, -1)])
    dists = Dict()
    lens(pos, d) = get(data, pos, '#') != '#' && !haskey(dists, pos) && (dists[pos] = d; lens.(dirs .+ pos, d+1))
    lens(findfirst(data .== 'S'), 0)
    count(get(dists, p+d1, INF) + 102 <= get(dists, p+d2, -INF) for p in findall(data .== '#'), d1 in dirs, d2 in dirs)
end

function part2_cleaned(data)
    INF = typemax(Int) ÷ 10
    dirs = CartesianIndex.([(1, 0), (0, 1), (-1, 0), (0, -1)])
    dists = Dict()
    lens(pos, d) = get(data, pos, '#') != '#' && !haskey(dists, pos) && (dists[pos] = d; lens.(dirs .+ pos, d+1))
    lens(findfirst(data .== 'S'), 0)
    valid(p, d1, d2) = get(dists, p, INF) + 100 + abs(d1) + abs(d2) <= get(dists, p + CartesianIndex(d1, d2), -INF)
    count(valid(p, d1, d2) for p in findall(data .!= '#'), d1 in -20:20, d2 in -20:20 if abs(d1) + abs(d2) <= 20)
end

data = stack(readlines("input.txt"))
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
