function part1(data)
    data = parse.(Int, data)
    dirs = [CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0)]
    recurse(pos, height) = vcat([dfs(pos + d, height + 1) for d in dirs]...)
    dfs(pos, height) = pos ∉ keys(data) || height != data[pos] ? [] : height == 9 ? [pos] : recurse(pos, height)
    sum(length.(unique.(dfs.(findall(data .== 0), 0))))
end

function part2(data)
    data = parse.(Int, data)
    dirs = [CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0)]
    recurse(pos, height) = sum(dfs.(dirs .+ pos, height + 1))
    dfs(pos, height) = pos ∉ keys(data) || height != data[pos] ? 0 : height == 9 ? 1 : recurse(pos, height)
    sum(dfs.(findall(data .== 0), 0))
end

function part1_cleaned(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    dfs(pos, h='0') = get(data, pos, 0) != h ? [] : h == '9' ? [pos] : vcat(dfs.(pos .+ dirs, h + 1)...)
    sum(length∘Set∘dfs, keys(data))
end

function part2_cleaned(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    dfs(pos, h='0') = get(data, pos, 0) != h ? 0 : h == '9' ? 1 : sum(dfs.(pos .+ dirs, h + 1))
    sum(dfs, keys(data))
end

data = stack(readlines("input.txt"))
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
