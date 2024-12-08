function part1(data)
    antinodes = Set()
    for a in keys(data), b in keys(data), t in (2a-b, 2b-a)
        if a != b && data[a] != '.' && data[a] == data[b] && t in keys(data)
            push!(antinodes, t)
        end
    end
    length(antinodes)
end

function part2(data)
    antinodes = Set()
    for a in keys(data), b in keys(data), i in -size(data, 1):size(data, 1)
        if a != b && data[a] != '.' && data[a] == data[b]
            t = a + i*(b-a)
            t in keys(data) && push!(antinodes, t)
        end
    end
    length(antinodes)
end

function part1_cleaned(data)
    valid(a, b) = a != b && data[a] != '.' && data[a] == data[b]
    count(in(keys(data)), Set(a + t*(b-a) for a in keys(data), b in keys(data), t in (-1, 2) if valid(a, b)))
end

function part2_cleaned(data)
    n, poss = size(data, 1), findall(!=('.'), data)
    count(in(keys(data)), Set(a + t*(b-a) for a in poss, b in poss, t in -n:n if a != b && data[a] == data[b]))
end

data = stack(readlines("input.txt"))
@time println(part1(data))
@time println(part1_cleaned(data))
@time println(part2(data))
@time println(part2_cleaned(data))

