data = readlines("input.txt")

function part1(data)
    valid(i, j, di, dj) = 1 <= i + 3di <= length(data) && 1 <= j + 3dj <= length(data[1])
    isxmas(i, j, di, dj) = valid(i, j, di, dj) && [data[i + k*di][j + k*dj] for k in 0:3] == ['X', 'M', 'A', 'S']
    xmases(i, j) = sum(isxmas(i, j, di, dj) for di in -1:1, dj in -1:1 if di != 0 || dj != 0)
    sum(xmases(i, j) for i in 1:length(data), j in 1:length(data[1]))
end

function part2(data)
    ismas(chars) = chars == ['M', 'A', 'S'] || chars == ['S', 'A', 'M']
    ismasx(i, j) = ismas([data[i + d][j + d] for d in -1:1]) && ismas([data[i + d][j - d] for d in -1:1])
    sum(ismasx(i, j) for i in 2:length(data)-1, j in 2:length(data[1])-1)
end

function part1_cleaned(data)
    data = stack(data)
    xmas(ci, cd) = isassigned(data, ci + 3*cd) && all(data[ci + k*cd] == "XMAS"[k + 1] for k in 0:3)
    sum(xmas(ci, CartesianIndex(di, dj)) for ci in CartesianIndices(data), di in -1:1, dj in -1:1)
end

function part2_cleaned(data)
    ismasx(i, j) = all([data[i + d][j + s * d] for d in -1:1] in (['M', 'A', 'S'], ['S', 'A', 'M']) for s in (-1, 1))
    sum(ismasx(i, j) for i in 2:length(data)-1, j in 2:length(data[1])-1)
end

println(part1(data))
println(part1_cleaned(data))
println(part2(data))
println(part2_cleaned(data))
