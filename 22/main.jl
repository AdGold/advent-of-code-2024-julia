using DataStructures

function part1(data)
    function final(n)
        for i in 1:2000
            n = xor(n << 6, n) % 16777216
            n = xor(n >> 5, n) % 16777216
            n = xor(n * 2048, n) % 16777216
        end
        n
    end
    sum(final, parse.(Int, data))
end

function part2(data)
    function find(n)
        cache = Dict()
        prev4 = (100, 100, 100, 100)
        prev = 100
        for i in 1:2000
            n = xor(n << 6, n) % 16777216
            n = xor(n >> 5, n) % 16777216
            n = xor(n * 2048, n) % 16777216
            bn = n % 10
            diff = bn - prev
            prev = bn
            prev4 = (prev4[2], prev4[3], prev4[4], diff)
            if !(100 in prev4)
                get!(cache, prev4, bn)
            end
        end
        return cache
    end
    caches = find.(parse.(Int, data))
    all = Dict()
    best = 0
    for cache in caches
        for (k, v) in cache
            all[k] = get(all, k, 0) + v
            best = max(best, all[k])
        end
    end
    best
end


function part1_cleaned(data)
    final(n) = [(n = xor(n << 6, n) & 0xFFFFFF; n = xor(n >> 5, n); n = xor(n << 11, n) & 0xFFFFFF) for i in 1:2000][end]
    sum(final, parse.(Int, data))
end

function part2_cleaned(data)
    function find(n)
        cache = counter(Tuple{Int, Int, Int, Int})
        bns = [(n = xor(n << 6, n) & 0xFFFFFF; n = xor(n >> 5, n); n = xor(n  << 11, n) & 0xFFFFFF; n % 10) for i in 1:2000]
        [get!(cache, Tuple(bns[i+1:i+4] - bns[i:i+3]), bns[i+4]) for i in 1:length(bns)-5]
        return cache
    end
    maximum(values(reduce(merge, find.(parse.(Int, data)))))
end

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
