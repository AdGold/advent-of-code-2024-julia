using DelimitedFiles
using StatsBase

data = readdlm("input.txt")

function part1(data)
    safe = 0
    for i in 1:size(data, 1)
        line = [x for x in data[i, :] if x != ""]
        if line == sort(line) || line == sort(line, rev=true)
            absdiffs = abs.(diff(line))
            if all(absdiffs .<= 3) && all(absdiffs .>= 1)
                safe += 1
            end
        end
    end
    safe
end

function part2(data)
    safe = 0
    for i in 1:size(data, 1)
        full_line = [x for x in data[i, :] if x != ""]
        test_lines = [[full_line[1:i-1]; full_line[i+1:end]] for i in 1:length(full_line)]
        for line in test_lines
            if line == sort(line) || line == sort(line, rev=true)
                absdiffs = abs.(diff(line))
                if all(absdiffs .<= 3) && all(absdiffs .>= 1)
                    safe += 1
                    break
                end
            end
        end
    end
    safe
end

function part1_partcleaned(data)
    safe = 0
    for i in 1:size(data, 1)
        line = filter(!isempty, data[i, :])
        if issorted(line) || issorted(line, rev=true)
            safe += all(1 .<= abs.(diff(line)) .<= 3)
        end
    end
    return safe
end

function part2_partcleaned(data)
    safe = 0
    for i in 1:size(data, 1)
        full_line = filter(!isempty, data[i, :])
        for j in 1:length(full_line)
            line = vcat(full_line[1:j-1], full_line[j+1:end])
            if (issorted(line) || issorted(line, rev=true)) && all(1 .<= abs.(diff(line)) .<= 3)
                safe += 1
                break
            end
        end
    end
    safe
end

function part1_cleaned(data)
    issafe(line) = (issorted(line) || issorted(line, rev=true)) && all(1 .<= abs.(diff(line)) .<= 3)
    sum(issafe(filter(!isempty, row)) for row in eachrow(data))
end

function part2_cleaned(data)
    issafe(line) = all(1 .<= diff(line) .<= 3) || all(-3 .<= diff(line) .<= -1)
    isalmostsafe(line) = any(issafe(vcat(line[1:i-1], line[i+1:end])) for i in 1:length(line))
    sum(isalmostsafe(filter(!isempty, row)) for row in eachrow(data))
end

println(part1(data))
println(part1_partcleaned(data))
println(part1_cleaned(data))
println(part2(data))
println(part2_partcleaned(data))
println(part2_cleaned(data))
