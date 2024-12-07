function part1(data)
    function poss(goal, cur, nums) 
        length(nums) == 0 && return cur == goal
        return poss(goal, cur + nums[1], nums[2:end]) || poss(goal, cur * nums[1], nums[2:end])
    end
    parserow(row) = parse.(Int, split(replace(row, ":" => "")))
    sum(poss(row[1], row[2], row[3:end]) * row[1] for row in parserow.(data))
end

function part2(data)
    function poss(goal, cur, nums...) 
        cur > goal && return false
        length(nums) == 0 && return cur == goal
        return any(poss(goal, op(cur, nums[1]), nums[2:end]...) for op in (+, *, (x, y) -> parse(Int, "$x$y")))
    end
    parserow(row) = parse.(Int, split(replace(row, ":" => "")))
    sum(poss(row...) * row[1] for row in parserow.(data))
end

function part1_cleaned(data)
    vals(nums) = length(nums) == 1 ? nums : (op(x, nums[end]) for op in (+, *), x in vals(nums[1:end-1]))
    parserow(row) = parse.(Int, split(row, r"[:\s]+"))
    sum(any(==(row[1]), vals(row[2:end])) * row[1] for row in parserow.(data))
end

function part2_cleaned(data)
    cat(x, y) = parse(Int, "$x$y")
    vals(nums) = length(nums) == 1 ? nums : (op(x, nums[end]) for op in (+, *, cat), x in vals(nums[1:end-1]))
    parserow(row) = parse.(Int, split(row, r"[:\s]+"))
    sum(any(==(row[1]), vals(row[2:end])) * row[1] for row in parserow.(data))
end

data = readlines("input.txt")
@time println(part1(data))
@time println(part1_cleaned(data))
@time println(part2(data))
@time println(part2_cleaned(data))

