function part1(data)
    function count(n, blinks)
        blinks == 0 && return 1
        nstr = string(n)
        if length(nstr) % 2 == 0 
            return count(parse(Int, nstr[1:end÷2]), blinks-1) + count(parse(Int, nstr[end÷2+1:end]), blinks-1)
        else
            return count(n == 0 ? 1 : n * 2024, blinks-1)
        end
    end
    data = parse.(Int, split(data)) 
    sum(count.(data, 25))
end

function part2(data)
    cache = Dict{Tuple{Int, Int}, Int}()
    function count(n, blinks)
        if !haskey(cache, (n, blinks))
            blinks == 0 && return 1
            nstr = string(n)
            if length(nstr) % 2 == 0 
                cache[(n, blinks)] = count(parse(Int, nstr[1:end÷2]), blinks-1) + count(parse(Int, nstr[end÷2+1:end]), blinks-1)
            else
                cache[(n, blinks)] = count(n == 0 ? 1 : n * 2024, blinks-1)
            end
        end
        return cache[(n, blinks)]
    end
    data = parse.(Int, split(data)) 
    sum(count.(data, 75))
end

function part1_cleaned(data)
    count(n, blinks) = blinks == 0 ? 1 : let (halflen, odd) = divrem(length(string(n)), 2)
        odd == 0 ? sum(count.(divrem(n, 10^halflen), blinks-1)) : count(n == 0 ? 1 : n * 2024, blinks-1)
    end
    sum(count.(parse.(Int, split(data)), 25))
end

function part2_cleaned(data)
    cache = Dict{Tuple{Int, Int}, Int}()
    count(n, blinks) = get!(cache, (n, blinks)) do
        blinks == 0 ? 1 : let (halflen, odd) = divrem(length(string(n)), 2)
            odd == 0 ? sum(count.(divrem(n, 10^halflen), blinks-1)) : count(n == 0 ? 1 : n * 2024, blinks-1)
        end
    end
    sum(count.(parse.(Int, split(data)), 75))
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
