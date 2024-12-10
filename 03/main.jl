data = read("input.txt", String)

function part1(data)
    regex = r"mul\((\d{1,3}),(\d{1,3})\)"
    sum = 0
    for match in eachmatch(regex, data)
        sum += parse(Int, match[1]) * parse(Int, match[2])
    end
    sum
end

function part2(data)
    regex = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"
    sum = 0
    on = true
    for match in eachmatch(regex, data)
        if match.match == "do()"
            on = true
        elseif match.match == "don't()"
            on = false
        else
            sum += parse(Int, match[1]) * parse(Int, match[2]) * on
        end
    end
    sum
end

function part1_cleaned(data)
    sum(parse(Int, m[1]) * parse(Int, m[2]) for m in eachmatch(r"mul\((\d{1,3}),(\d{1,3})\)", data))
end

function part2_cleaned(data)
    part1_cleaned(replace(data, r"don't\(\)(.*?)(do\(\)|$)"s => ""))
end

println(part1(data))
println(part1_cleaned(data))
println(part2(data))
println(part2_cleaned(data))
