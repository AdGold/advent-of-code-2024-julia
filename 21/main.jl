using DataStructures

function part1(data)
    keypad = Dict((0, 0) => '7', (1, 0) => '8', (2, 0) => '9', (0, 1) => '4', (1, 1) => '5', (2, 1) => '6', (0, 2) => '1', (1, 2) => '2', (2, 2) => '3', (1, 3) => '0', (2, 3) => 'A')
    dirpad = Dict((1, 0) => (0, -1), (0, 1) => (-1, 0), (1, 1) => (0, 1), (2, 1) => (1, 0), (2, 0) => 'A')
    valid(rs) = all(haskey.(Ref(dirpad), rs[1:end-1])) && haskey(keypad, rs[end])
    apply(rs, x) = x == 'A' ? applyA(rs) : (rs[1] .+ x, rs[2:end]...)
    applyA(rs) = length(rs) == 1 ? rs : dirpad[rs[1]] == 'A' ? (rs[1], applyA(rs[2:end])...) : (rs[1], rs[2] .+ dirpad[rs[1]], rs[3:end]...)
    sum(data) do code
        q = Queue{Any}()
        rs = (Tuple((2, 0) for i in 1:2)..., (2, 3))
        enqueue!(q, (rs, 1))
        cache = Dict((rs, 1) => 0)
        while !isempty(q)
            rs, n = dequeue!(q)
            cost = cache[(rs, n)] + 1
            n == length(code) + 1 && return cache[(rs, n)] * parse(Int, code[1:end-1])
            for d in ((1, 0), (0, 1), (-1, 0), (0, -1), 'A')
                newrs = apply(rs, d)
                nn = newrs == rs && code[n] == keypad[rs[end]] ? n + 1 : n
                if valid(newrs) && cost < get(cache, (newrs, nn), typemax(Int))
                    cache[(newrs, nn)] = cost
                    enqueue!(q, (newrs, nn))
                end
            end
        end
    end
end

function part2(data)
    keypad = Dict('7' => (0, 0), '8' => (1, 0), '9' => (2, 0), '4' => (0, 1), '5' => (1, 1), '6' => (2, 1), '1' => (0, 2), '2' => (1, 2), '3' => (2, 2), '0' => (1, 3), 'A' => (2, 3))
    dirpad = Dict((0, -1) => (1, 0), (-1, 0) => (0, 1), (0, 1) => (1, 1), (1, 0) => (2, 1), 'A' => (2, 0))
    cache = Dict()
    toplevel = 25
    dp(from, to, level) = get!(cache, (from, to, level)) do
        from == to && return 0
        dx, dy = to .- from
        level == 0 && return abs(dx) + abs(dy) + 1
        start = dirpad['A']
        placex = dx == 0 ? dirpad['A'] : dirpad[(sign(dx), 0)]
        placey = dy == 0 ? dirpad['A'] : dirpad[(0, sign(dy))]
        verify = values(level == toplevel ? keypad : dirpad)
        t1 = t2 = typemax(Int)
        if (to[1], from[2]) in verify
            t1 = dp(start, placex, level - 1) + dp(placex, placey, level - 1) + dp(placey, start, level - 1)
        end
        if (from[1], to[2]) in verify
            t2 = dp(start, placey, level - 1) + dp(placey, placex, level - 1) + dp(placex, start, level - 1)
        end
        return min(t1, t2) + max(0, abs(dx) - 1) + max(0, abs(dy) - 1)
    end
    sum(data) do code
        s = 0
        prev = (2, 3)
        for x in code
            s += dp(prev, keypad[x], toplevel)
            prev = keypad[x]
        end
        s * parse(Int, code[1:end-1])
    end
end


function part1_cleaned(data)
    keypad = Dict('7' => (0, 0), '8' => (1, 0), '9' => (2, 0), '4' => (0, 1), '5' => (1, 1), '6' => (2, 1), '1' => (0, 2), '2' => (1, 2), '3' => (2, 2), '0' => (1, 3), 'A' => (2, 3))
    dirpad = Dict((0, -1) => (1, 0), (-1, 0) => (0, 1), (0, 1) => (1, 1), (1, 0) => (2, 1), 'A' => (2, 0))
    cache = Dict()
    dp(from, to, lvl) = get!(cache, (from, to, lvl)) do
        from == to && return 0
        dx, dy = to .- from
        lvl == 0 && return abs(dx) + abs(dy) + 1
        st = dirpad['A']
        extra = max(0, abs(dx) - 1) + max(0, abs(dy) - 1)
        places = (st, dx == 0 ? st : dirpad[(sign(dx), 0)], dy == 0 ? st : dirpad[(0, sign(dy))], st)
        paths = ((places, (to[1], from[2])), (reverse(places), (from[1], to[2])))
        valid(cnr) = cnr in values(lvl == 2 ? keypad : dirpad)
        minimum(sum(dp(path[i], path[i+1], lvl-1) for i in 1:3) for (path, cnr) in paths if valid(cnr)) + extra
    end
    sum(data) do code
        sum(dp(i == 1 ? (2, 3) : keypad[code[i-1]], keypad[code[i]], 2) for i in 1:length(code)) * parse(Int, code[1:end-1])
    end
end

function part2_cleaned(data)
    keypad = Dict('7' => (0, 0), '8' => (1, 0), '9' => (2, 0), '4' => (0, 1), '5' => (1, 1), '6' => (2, 1), '1' => (0, 2), '2' => (1, 2), '3' => (2, 2), '0' => (1, 3), 'A' => (2, 3))
    dirpad = Dict((0, -1) => (1, 0), (-1, 0) => (0, 1), (0, 1) => (1, 1), (1, 0) => (2, 1), 'A' => (2, 0))
    cache = Dict()
    dp(from, to, lvl) = get!(cache, (from, to, lvl)) do
        from == to && return 0
        dx, dy = to .- from
        lvl == 0 && return abs(dx) + abs(dy) + 1
        st = dirpad['A']
        extra = max(0, abs(dx) - 1) + max(0, abs(dy) - 1)
        places = (st, dx == 0 ? st : dirpad[(sign(dx), 0)], dy == 0 ? st : dirpad[(0, sign(dy))], st)
        paths = ((places, (to[1], from[2])), (reverse(places), (from[1], to[2])))
        valid(cnr) = cnr in values(lvl == 25 ? keypad : dirpad)
        minimum(sum(dp(path[i], path[i+1], lvl-1) for i in 1:3) for (path, cnr) in paths if valid(cnr)) + extra
    end
    sum(data) do code
        sum(dp(i == 1 ? (2, 3) : keypad[code[i-1]], keypad[code[i]], 25) for i in 1:length(code)) * parse(Int, code[1:end-1])
    end
end

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
