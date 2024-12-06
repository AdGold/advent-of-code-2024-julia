function part1(data)
    pos = [ci for ci in CartesianIndices(data) if data[ci] == '^'][1]
    dir = CartesianIndex(0, -1)
    while isassigned(data, pos)
        if data[pos] == '#'
            pos -= dir
            dir = CartesianIndex(-dir[2], dir[1])
        end
        data[pos] = 'X'
        pos += dir
    end
    sum([data[ci] == 'X' for ci in CartesianIndices(data)])
end

function isloop(data, pos, dir, seen)
    extra_seen = Dict()
    while isassigned(data, pos)
        if data[pos] == '#'
            pos -= dir
            dir = CartesianIndex(-dir[2], dir[1])
        end
        if haskey(seen, (pos, dir)) || haskey(extra_seen, (pos, dir))
            return true
        end
        extra_seen[(pos, dir)] = 1
        pos += dir
    end
    return false
end

function part2(data)
    pos = [ci for ci in CartesianIndices(data) if data[ci] == '^'][1]
    dir = CartesianIndex(0, -1)
    seen = Dict((pos, dir) => 1)
    sum = 0
    while isassigned(data, pos)
        if data[pos] == '#'
            pos -= dir
            dir = CartesianIndex(-dir[2], dir[1])
        elseif data[pos] == '.'
            data[pos] = '#'
            sum += isloop(data, pos, dir, seen)
            data[pos] = '.'
        end
        data[pos] = 'X'
        seen[(pos, dir)] = 1
        pos += dir
    end
    sum
end

function part1_cleaned_old(data)
    pos = findfirst(==('^'), data)
    dir = CartesianIndex(0, -1)
    while pos in keys(data)
        pos, dir = data[pos] == '#' ? (pos - dir, CartesianIndex(-dir[2], dir[1])) : (pos, dir)
        data[pos] = 'X'
        pos += dir
    end
    count(==('X'), data)
end

function path(data, pos, dir; new=nothing)
    order, seen = [], Set()
    while pos in keys(data)
        if data[pos] == '#' || pos == new
            pos -= dir
            dir = CartesianIndex(-dir[2], dir[1])
        else
            push!(seen, (pos, dir))
            push!(order, (pos, dir))
            pos += dir
            (pos, dir) ∈ seen && return -1
        end
    end
    unique(first, order)
end

function part1_cleaned(data)
    length(path(data, findfirst(data .== '^'), CartesianIndex(0, -1)))
end

function part2_cleaned(data)
    sum(x -> path(data, x...; new=x[1]) == -1, path(data, findfirst(data .== '^'), CartesianIndex(0, -1)))
end

data = stack(readlines("input.txt"))
println(part1(data))
data = stack(readlines("input.txt"))
println(part1_cleaned(data))
data = stack(readlines("input.txt"))
println(part2(data))
data = stack(readlines("input.txt"))
println(part2_cleaned(data))

