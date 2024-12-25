function part1(data)
    vars = Dict()
    for line in data
        isempty(line) && continue
        (m = match(r"(.+?): (\d+)", line)) != nothing && (vars[m.captures[1]] = parse(Int, m.captures[2]))
        (m = match(r"(\w+?) (\w+) (\w+) -> (\w+)", line)) != nothing && (vars[m.captures[4]] = Tuple(m.captures[1:3]))
    end
    dfs(pos) = isa(vars[pos], Int) ? vars[pos] : dfs(vars[pos]...)
    dfs(a, op, b) = op == "AND" ? dfs(a) & dfs(b) : op == "OR" ? dfs(a) | dfs(b) : dfs(a) ⊻ dfs(b)
    parse(Int, join((dfs(z) for z in sort(collect(keys(vars)), rev=true) if z[1] == 'z'), ""), base=2)
end

function part2(data)
    # Silly heuristic to find the bad wires based on local connections
    vars = Dict()
    bad = Set()
    for line in data
        (m = match(r"(\w+?) (\w+) (\w+) -> (\w+)", line)) != nothing && (vars[m.captures[4]] = Tuple(m.captures[1:3]))
    end
    for (k, v) in vars
        a, op, b = v
        k[1] != 'z' && continue
        if op != "XOR"
            if k != "z45"
                # println(k, " should come from a XOR")
                push!(bad, k)
            end
            continue
        end
        if k == "z00"
            continue
        end
        for x in (a, b)
            if vars[x][2] != "XOR" && vars[x][2] != "OR"
                if k != "z01"
                    # println(x, " should come from a XOR or OR: k=$k, x=$x")
                    push!(bad, x)
                end
            elseif vars[x][2] == "XOR"
                if (vars[x][1][1] != 'x' && vars[x][1][1] != 'y') || (vars[x][3][1] != 'x' && vars[x][3][1] != 'y')
                    # println(x, " should come from a XOR between x & y: k=$k, x=$x")
                    push!(bad, x)
                end
            elseif vars[x][2] == "OR"
                for z in (vars[x][1], vars[x][3])
                    if vars[z][2] != "AND"
                        # println(z, " should come from an AND: k=$k, x=$x")
                        push!(bad, z)
                    end
                end
            end
        end
    end
    join(sort(collect(bad)), ",")
end

function part1_cleaned(data)
    vars = Dict()
    for line in data
        (m = match(r"(\w+): (\d+)", line)) != nothing && (vars[m.captures[1]] = parse(Int, m.captures[2]))
        (m = match(r"(\w+) (\w+) (\w+) -> (\w+)", line)) != nothing && (vars[m.captures[4]] = Tuple(m.captures[1:3]))
    end
    dfs(x) = isa(vars[x], Int) ? vars[x] : Dict("AND"=>&, "OR"=>|, "XOR"=>⊻)[vars[x][2]](dfs(vars[x][1]), dfs(vars[x][3]))
    parse(Int, join(dfs.("z".*lpad.(45:-1:0, 2, '0')), ""), base=2)
end

function part2_cleaned(data)
    # Silly heuristic to find the bad wires based on local connections of adder:
    # - zs should come from a XOR, except z45
    # - the a&b of the z's XOR should come from a XOR or OR except z01
    # - the one of a/b that came from XOR should be x.. xor y..
    # - the one of a/b that came from OR should have inputs from ANDs
    vars = Dict(m.captures[4] => Tuple(m.captures[1:3]) for m in eachmatch(r"(\w+?) (\w+) (\w+) -> (\w+)", join(data, " ")))
    bad = Set()
    for (k, (a, op, b)) in filter(x -> x[1][1] == 'z', vars)
        op != "XOR" && (k != "z45" && push!(bad, k); continue)
        k == "z00" && continue
        for x in (a, b)
            vars[x][2] ∉ ("XOR", "OR") && k != "z01" && push!(bad, x)
            vars[x][2] == "XOR" && any(vars[x][i][1] ∉ ('x', 'y') for i in (1,3)) && push!(bad, x)
            vars[x][2] == "OR" && vars[vars[x][1]][2] != "AND" && push!(bad, vars[x][1])
            vars[x][2] == "OR" && vars[vars[x][3]][2] != "AND" && push!(bad, vars[x][3])
        end
    end
    join(sort(collect(bad)), ",")
end

function part2_general(data)
    vars = Dict(m.captures[4] => Tuple(m.captures[1:3]) for m in eachmatch(r"(\w+?) (\w+) (\w+) -> (\w+)", join(data, " ")))
    vars = Dict(k => (a, Dict("AND"=>&, "OR"=>|, "XOR"=>⊻)[op], b) for (k, (a, op, b)) in vars)
    base(p, x, y) = p[1] == 'x' ? x & (1 << parse(Int, p[2:end])) > 0 : y & (1 << parse(Int, p[2:end])) > 0
    dfs(p, x, y) = p[1] in ('x', 'y') ? base(p, x, y) : vars[p][2](dfs(vars[p][1], x, y), dfs(vars[p][3], x, y))
    test(i, n=10) = all(dfs("z"*lpad(i, 2, '0'), x, y) == ((x + y) & (1 << i) > 0) for x in rand(0:2^44, n), y in rand(0:2^44, n))
    function hascycles()
        visited, completed = Set(), Set()
        function cycle(p)
            p in visited && return true
            p in completed && return false
            push!(visited, p)
            push!(completed, p)
            any(q -> !(q[1] in ('x', 'y')) && cycle(q), (vars[p][1], vars[p][3])) && return true
            pop!(visited, p)
            return false
        end
        for p in keys(vars)
            p in completed && continue
            visited = Set()
            cycle(p) && return true
        end
        return false
    end
    bad = []
    for i in 0:45
        test(i) && continue
        for a in keys(vars), b in keys(vars)
            a < b || continue
            vars[a], vars[b] = vars[b], vars[a]
            if !hascycles() && test(i)
                push!(bad, a, b)
                println("Swapped ", a, " and ", b)
                break
            end
            vars[a], vars[b] = vars[b], vars[a]
        end
    end
    join(sort(collect(bad)), ",")
end

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data) == part2_general(data)
@time println(part2(data))
@time println(part2_cleaned(data))
@time println(part2_general(data))
