using StatsBase
using Statistics

function part1(data)
    h, w = 103, 101
    final(x, y, vx, vy) = (mod(x + 100vx, w), mod(y + 100vy, h))
    quad((x,y)) = 2x+1 == w || 2y+1 == h ? nothing : (2x < w, 2y < h)
    pos = [final(parse.(Int, m.captures)...) for m in eachmatch(r"(\d+),(\d+).*?(-?\d+),(-?\d+)", data)]
    c = countmap(quad.(pos))
    fld(prod(values(c)), c[nothing])
end

function part2(data)
    h, w = 103, 101
    pos(i, x, y, vx, vy) = [mod(x + i*vx, w) mod(y + i*vy, h)]
    orig = [parse.(Int, m.captures) for m in eachmatch(r"(\d+),(\d+).*?(-?\d+),(-?\d+)", data)]
    variances(i) = var([pos(i, x, y, vx, vy) for (x, y, vx, vy) in orig])
    goal = variances(0) / 2
    for i in 1:h*w
        if all(variances(i) .< goal)
            chars = fill(' ', h, w)
            for (x, y, vx, vy) in orig
                a, b = pos(i, x, y, vx, vy)
                chars[b+1, a+1] = '#'
            end
            for row in eachrow(chars)
                println(join(row))
            end
            return i
        end
    end
end

function part1_cleaned(data)
    h, w = 103, 101
    final(x, y, vx, vy) = mod.((x, y) .+ 100 .* (vx, vy), (w, h))
    quad((x,y)) = 2x+1 == w || 2y+1 == h ? nothing : (2x < w, 2y < h)
    pos = [final(parse.(Int, m.captures)...) for m in eachmatch(r"(\d+),(\d+).*?(-?\d+),(-?\d+)", data)]
    c = countmap(quad.(pos))
    fld(prod(values(c)), c[nothing])
end

function part2_cleaned(data)
    h, w = 103, 101
    orig = [parse.(Int, m.captures) for m in eachmatch(r"(\d+),(\d+).*?(-?\d+),(-?\d+)", data)]
    # findfirst(i -> allunique([mod.([x y] + i*[vx vy], [w h]) for (x, y, vx, vy) in orig]), 1:h*w)
    variances(i) = var([mod.([x y] + i*[vx vy], [w h]) for (x, y, vx, vy) in orig])
    findfirst(i -> all(variances(i) .< variances(0)/2), 1:h*w)
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
