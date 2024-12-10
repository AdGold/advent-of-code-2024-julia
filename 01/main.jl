using DelimitedFiles
using StatsBase

data = readdlm("input.txt", Int)

function part1(data)
    list1 = sort(data[:,1])
    list2 = sort(data[:,2])
    n = size(data)[1]
    sum = 0

    for i in 1:n
        sum += abs(list1[i] - list2[i])
    end
    sum
end

function part2(data)
    list1 = data[:,1]
    list2 = data[:,2]
    n = size(data)[1]
    count = Dict()
    for i in 1:n
        count[list2[i]] = get(count, list2[i], 0) + 1
    end

    similarity = 0
    for i in 1:n
        similarity += get(count, list1[i], 0) * list1[i]
    end
    similarity
end

function part1_cleaned(data)
    sum(abs.(sort(data[:,1]) .- sort(data[:,2])))
end

function part2_cleaned(data)
    list1, list2 = data[:, 1], data[:, 2]
    count = countmap(list2)
    sum(get(count, x, 0) * x for x in list1)
end

println(part1(data))
println(part1_cleaned(data))
println(part2(data))
println(part2_cleaned(data))
