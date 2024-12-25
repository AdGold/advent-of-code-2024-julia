function part1(data)
    options = split.(split(data, "\n\n"))
    keys = [count.(==('#'), collect(zip(o...))) for o in options if o[1][1] != '#']
    locks = [count.(==('#'), collect(zip(o...))) for o in options if o[1][1] == '#']
    sum(all(k .+ l .<= 7) for k in keys, l in locks)
end

function part1_cleaned(data)
    options = stack.(split.(split(data, "\n\n")))
    sum(!any(k .== l .== '#') for k in options, l in options if k[1][1] != '#' && l[1][1] == '#')
end

# No part 2 :(

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
