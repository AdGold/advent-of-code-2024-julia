using DataStructures

function part1(data)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    blocks = [CartesianIndex(parse.(Int, m.captures)...) for m in eachmatch(r"(\d+),(\d+)", data)]
    blocks = blocks[1:1024] .+ CartesianIndex(1, 1)
    n = 71
    q = Queue{CartesianIndex}()
    dists = fill(typemax(Int), (n, n))
    dists[1, 1] = 0
    enqueue!(q, CartesianIndex(1, 1))
    while !isempty(q)
        p = dequeue!(q)
        p == CartesianIndex(n, n) && return dists[p]
        for d in dirs
            np = p + d
            if np in keys(dists) && !(np in blocks) && dists[np] > dists[p] + 1
                dists[np] = dists[p] + 1
                enqueue!(q, np)
            end
        end
    end
end

function connected(n, blocks)
    dirs = CartesianIndex.([(0, 1), (1, 0), (0, -1), (-1, 0)])
    seen = fill(false, (n, n))
    dfs(p) = p[1] == p[2] == n || any(!(x in blocks) && !get(seen, x, true) && (seen[x] = true; dfs(x)) for x in dirs .+ p)
    dfs(CartesianIndex(1, 1))
end

function part2(data)
    blocks = [CartesianIndex(parse.(Int, m.captures)...) for m in eachmatch(r"(\d+),(\d+)", data)] .+ CartesianIndex(1, 1)
    n = 71
    x = searchsortedlast(1:length(blocks), 1, by=i -> !connected(n, blocks[1:i]))
    "$(blocks[x+1][1]-1),$(blocks[x+1][2]-1)"
end

function part1_cleaned(data)
    dirs(p) = [p .+ d for d in [(0, 1), (1, 0), (0, -1), (-1, 0)]]
    blocks = [Tuple(parse.(Int, m.captures)) .+ (1, 1) for m in eachmatch(r"(\d+),(\d+)", data)]
    dists = Dict([((1, 1), 0); [(b, -1) for b in blocks[:1:1024]]])
    q, n = Queue{Tuple}(), 71
    enqueue!(q, (1, 1))
    while !isempty(q) && (p = dequeue!(q)) != (n, n)
        for np in dirs(p)
            if all(1 .<= np .<= n) && get(dists, np, typemax(Int)) > dists[p] + 1
                dists[np] = dists[p] + 1
                enqueue!(q, np)
            end
        end
    end
    dists[p]
end

function separate(n, seen)
    dirs(p) = [p .+ d for d in [(0, 1), (1, 0), (0, -1), (-1, 0)]]
    dfs(p) = p == (n, n) || any((push!(seen, x); dfs(x)) for x in dirs(p) if !(x in seen) && all(0 .<= x .<= n))
    !dfs((0, 0))
end

function part2_cleaned(data)
    blocks = [Tuple(parse.(Int, m.captures)) for m in eachmatch(r"(\d+),(\d+)", data)]
    x = searchsortedlast(1:length(blocks), 1, by=i -> separate(70, Set(blocks[1:i]))) + 1
    "$(blocks[x][1]),$(blocks[x][2])"
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
