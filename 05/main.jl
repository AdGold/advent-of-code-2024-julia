data = readlines("input.txt")

function part1(data)
    sum = 0
    rules = Set()
    for line in data 
        m = match(r"(\d+)\|(\d+)", line)
        if m == nothing
            if strip(line) == ""
                continue
            else
                test = map(x -> parse(Int, x), split(line, ","))
                if all((test[i], test[j]) ∉ rules for i in 2:length(test) for j in 1:i-1)
                    sum += test[(1+length(test)) ÷ 2]
                end
            end
        else
            a, b = map(x -> parse(Int, x), m.captures)
            union!(rules, Set([(a,b)]))
        end
    end
    sum
end

function part2(data)
    sum = 0
    rules = Set()
    for line in data 
        m = match(r"(\d+)\|(\d+)", line)
        if m == nothing
            if strip(line) == ""
                continue
            else
                less(a,b) = (a,b) ∈ rules
                test = map(x -> parse(Int, x), split(line, ","))
                if !all((test[i], test[j]) ∉ rules for i in 2:length(test) for j in 1:i-1)
                    sort!(test, lt=less)
                    sum += test[(1+length(test)) ÷ 2]
                end
            end
        else
            a, b = map(x -> parse(Int, x), m.captures)
            union!(rules, Set([(a,b)]))
        end
    end
    sum
end

function part1_cleaned(data)
    valid(nums) = all("$(nums[i])|$(nums[j])" ∉ data for i in 2:length(nums) for j in 1:i-1)
    contrib(nums) = valid(nums) ? nums[(end + 1) ÷ 2] : 0
    sum(contrib(parse.(Int, split(x, ","))) for x in data if occursin(",", x))
end

function part2_cleaned(data)
    less(a, b) = "$(a)|$(b)" ∈ data
    valid(nums) = any(less(nums[i], nums[j]) for i in 2:length(nums) for j in 1:i-1) 
    contrib(nums) = valid(nums) ? sort(nums, lt=less)[(end + 1) ÷ 2] : 0
    sum(contrib(parse.(Int, split(x, ","))) for x in data if occursin(",", x))
end

println(part1(data))
println(part1_cleaned(data))
println(part2(data))
println(part2_cleaned(data))
