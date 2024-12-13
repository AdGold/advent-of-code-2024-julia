function part1(data)
    sum = 0
    ax = ay = bx = by = 0
    valid(x, y, i) = (x - i*ax) % bx == 0 && (y - i*ay) % by == 0 && (x - i*ax) ÷ bx == (y - i*ay) ÷ by
    for m in eachmatch(r"Button A: X.(\d+), Y.(\d+).Button B: X.(\d+), Y.(\d+).Prize: X=(\d+), Y=(\d+)"s, data)
        ax, ay, bx, by, x, y = parse.(Int, m.captures)
        options = [3*i+fld(x-i*ax, bx) for i in 0:100 if valid(x, y, i)]
        !isempty(options) && (sum += minimum(options))
    end
    sum
end

function part2(data)
    add = 10000000000000
    sum = 0
    ax = ay = bx = by = 0
    valid(x, y, i) = (x - i*ax) % bx == 0 && (y - i*ay) % by == 0 && (x - i*ax) ÷ bx == (y - i*ay) ÷ by
    for m in eachmatch(r"Button A: X.(\d+), Y.(\d+).Button B: X.(\d+), Y.(\d+).Prize: X=(\d+), Y=(\d+)"s, data)
        ax, ay, bx, by, x, y = parse.(Int, m.captures)
        x, y = x + add, y + add
        f = n -> ((x - n*ax) / bx) * by + n*ay <= y
        rev = ay * bx > by * ax
        n = Base.Sort.searchsortedlast(0:add, 1, by=f, rev=rev)
        options = [3*i+fld(x-i*ax, bx) for i in (n-1, n) if valid(x, y, i)]
        !isempty(options) && (sum += minimum(options))
    end
    sum
end

function part1_cleaned(data)
    sum(eachmatch(r"Button A: X.(\d+), Y.(\d+).Button B: X.(\d+), Y.(\d+).Prize: X=(\d+), Y=(\d+)"s, data)) do m
        ax, ay, bx, by, x, y = parse.(Int, m.captures)
        sum([3i+fld(x-i*ax, bx) for i in 0:100 if divrem(x - i*ax, bx) == divrem(y - i*ay, by) && (x - i*ax) % bx == 0])
    end
end

function part2_cleaned(data)
    add = 10^13
    sum(eachmatch(r"Button A: X.(\d+), Y.(\d+).Button B: X.(\d+), Y.(\d+).Prize: X=(\d+), Y=(\d+)"s, data)) do m
        ax, ay, bx, by, x, y = parse.(Int, m.captures)
        dr(i) = divrem.((x + add - i * ax, y + add - i * ay), (bx, by))
        n = searchsortedlast(0:add, 1, by=i -> <=(dr(i)...), rev=ay * bx > by * ax)
        sum([3i + dr(i)[1][1] for i in n-1:n if ==(dr(i)...) && dr(i)[1][2] == 0])
    end
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
