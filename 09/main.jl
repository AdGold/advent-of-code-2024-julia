function part1(data)
    data = parse.(Int, data)
    len = sum(data)
    arr = zeros(Int, len)
    at, free = 1, []
    for (id, c) in enumerate(data)
        if id % 2 == 0
            append!(free, at:at+c-1)
        else
            arr[at:at+c-1] .= fld(id, 2)
        end
        at += c
    end
    for i in len:-1:1
        if arr[i] != 0 && !isempty(free) && free[1] < i
            arr[free[1]], arr[i] = arr[i], 0
            popfirst!(free)
        end
    end
    sum(arr[i] * (i-1) for i in 1:len)
end

function part2(data)
    data = parse.(Int, data)
    sums = [0; cumsum(data, dims=1)]
    free = [(sums[i], data[i]) for i in 1:length(data) if i % 2 == 0]
    full = [(sums[i], data[i], fld(i, 2)) for i in 1:length(data) if i % 2 == 1]
    for (i, (a, b, id)) in Iterators.reverse(enumerate(full))
        for (j, (start, len)) in enumerate(free)
            if a > start && b <= len
                free[j] = (start+b, len-b)
                full[i] = (start, b, id)
                break
            end
        end
    end
    sum(sum(a:a+b-1) * id for (a, b, id) in full)
end

function part1_cleaned(data)
    expanded = [isodd(i) ? fld(i, 2) : -1 for (i, c) in enumerate(parse.(Int, data)) for _ in 1:c]
    free, full = findall(expanded .== -1), findall(expanded .!= -1)
    base = sum(expanded[i] * (i - 1) for i in full)
    base + sum(expanded[b] * (a - b) for (a, b) in zip(free, reverse(full)) if a < b)
end

function part2_cleaned(data)
    data = parse.(Int, data)
    base = zip([0; cumsum(data[1:end-1])], data) |> collect
    free, full = base[2:2:end], base[1:2:end]
    for (i, (start, len)) in Iterators.reverse(enumerate(full))
        j = findfirst(x -> x[1] < start && x[2] >= len, free)
        j == nothing && continue
        full[i] = (free[j][1], len)
        free[j] = (free[j][1] + len, free[j][2] - len)
    end
    sum(sum(a:a+b-1) * (i - 1) for (i, (a, b)) in enumerate(full))
end

data = stack(readlines("input.txt"))
@time println(part1(data))
@time println(part1_cleaned(data))
@time println(part2(data))
@time println(part2_cleaned(data))

