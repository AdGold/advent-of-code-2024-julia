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
    dfs(x) = isa(vars[x], Int) ? vars[x] : Dict("AND"=>(&), "OR"=>(|), "XOR"=>xor)[vars[x][2]](dfs(vars[x][1]), dfs(vars[x][3]))
    parse(Int, join(dfs.("z".*lpad.(45:-1:0, 2, '0')), ""), base=2)
end

function part2_cleaned(data)
    # Silly heuristic to find the bad wires based on local connections of adder:
    # - zs should come from a XOR, except z45
    # - the a&b of a XOR should come from a XOR or OR except z01
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

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
