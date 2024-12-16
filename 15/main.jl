function part1(data)
    dirs = Dict('<' => (-1, 0), '>' => (1, 0), '^' => (0, -1), 'v' => (0, 1))
    grid, moves = split(data, "\n\n")
    grid = stack(split(grid, '\n'))
    pos = findfirst(grid .== '@')
    for move in replace(moves, "\n" => "")
        dir = CartesianIndex(dirs[move])
        newpos = pos + dir
        while grid[newpos] == 'O'
            newpos += dir
        end
        if grid[newpos] == '.'
            grid[newpos] = 'O'
            grid[pos] = '.'
            pos += dir
            grid[pos] = '@'
        end
    end
    return sum(100*x[2] + x[1] - 101 for x in findall(grid .== 'O'))
end

function part2(data)
    h = CartesianIndex((1, 0))
    v = CartesianIndex((0, 1))
    dirs = Dict('<' => -h, '>' => h, '^' => -v, 'v' => v)
    grid, moves = split(data, "\n\n")
    grid = replace(grid, "@" => "@.", "#" => "##", "." => "..", "O" => "[]")
    grid = stack(split(grid, '\n'))
    pos = findfirst(grid .== '@')
    grid[pos] = '.'
    pair(pos) = grid[pos] == '[' ? pos + h : pos - h
    nomove(dir) = dir == h || dir == -h
    block(pos) = grid[pos] == '[' || grid[pos] == ']'
    # Can we move into `pos` when moving in direction `dir`?
    canmove(pos, dir) = grid[pos] == '.' || (block(pos) && (nomove(dir) || canmove(pos + dir, dir)) && canmove(pair(pos) + dir, dir))
    function makemove(pos, dir)
        grid[pos] == '.' && return
        nomove(dir) || makemove(pos + dir, dir)
        makemove(pair(pos) + dir, dir)
        grid[pair(pos) + dir] = grid[pair(pos)]
        grid[pair(pos)] = '.'
        grid[pos + dir] = grid[pos]
        grid[pos] = '.'
    end
    for move in replace(moves, "\n" => "")
        dir = dirs[move]
        if canmove(pos + dir, dir)
            makemove(pos + dir, dir)
            pos += dir
        end
    end
    sum(100*x[2] + x[1] - 101 for x in findall(grid .== '['))
end

function part1_cleaned(data)
    dirs = Dict('<' => (-1, 0), '>' => (1, 0), '^' => (0, -1), 'v' => (0, 1))
    grid, moves = split(data, "\n\n")
    grid = stack(split(grid, '\n'))
    pos = findfirst(grid .== '@')
    grid[pos] = '.'
    for move in replace(moves, "\n" => "")
        dir = CartesianIndex(dirs[move])
        last = pos + dir * findfirst(grid[pos + i*dir] != 'O' for i in 1:length(grid))
        if grid[last] == '.'
            grid[[last, pos += dir]] .= 'O', '.'
        end
    end
    return sum(100*x[2] + x[1] - 101 for x in findall(grid .== 'O'))
end

function part2_cleaned(data)
    h, v = CartesianIndex((1, 0)), CartesianIndex((0, 1))
    dirs = Dict('<' => -h, '>' => h, '^' => -v, 'v' => v)
    grid, moves = split(data, "\n\n")
    grid = stack(split(replace(grid, "@" => "@.", "#" => "##", "." => "..", "O" => "[]"), '\n'))
    pos = findfirst(grid .== '@')
    grid[pos] = '.'
    pair(pos) = pos + (grid[pos] == '[' ? h : -h)
    canmove(pos, dir) = grid[pos] == '.' || (grid[pos] in ('[', ']') && (dir in (h, -h) || canmove(pos + dir, dir)) && canmove(pair(pos) + dir, dir))
    function makemove(pos, dir)
        grid[pos] == '.' && return
        dir in (h, -h) || makemove(pos + dir, dir)
        makemove(pair(pos) + dir, dir)
        grid[pair(pos) + dir], grid[pair(pos)] = grid[pair(pos)], '.'
        grid[pos + dir], grid[pos] = grid[pos], '.'
    end
    for move in replace(moves, "\n" => "")
        dir = dirs[move]
        canmove(pos + dir, dir) && makemove(pos += dir, dir)
    end
    sum(100*x[2] + x[1] - 101 for x in findall(grid .== '['))
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
