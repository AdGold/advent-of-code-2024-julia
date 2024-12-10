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
    data = parse.(Int, data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    recurse(pos, height) = vcat([dfs(pos + d, height + 1) for d in dirs]...)
    dfs(pos, height) = pos ∉ keys(data) || height != data[pos] ? [] : height == 9 ? [pos] : recurse(pos, height)
    sum(length.(Set.(dfs.(keys(data), 0))))
end

function part2_cleaned(data)
    data = parse.(Int, data)
    recurse(pos, height) = sum(dfs.(CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)]) .+ pos, height + 1))
    dfs(pos, height) = pos ∉ keys(data) || height != data[pos] ? 0 : height == 9 ? 1 : recurse(pos, height)
    sum(dfs.(keys(data), 0))
end

data = stack(readlines("input.txt"))
@time println(part1(data))
@time println(part1_cleaned(data))
@time println(part2(data))
@time println(part2_cleaned(data))
