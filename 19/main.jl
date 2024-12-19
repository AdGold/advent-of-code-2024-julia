function part1(data)
    cache = Dict()
    dp(str, n=0) = get!(cache, n) do 
        n == length(str) || any(n + length(word) <= length(str) && str[n+1:n+length(word)] == word && dp(str, n + length(word)) for word in words)
    end
    words, _, designs... = data
    words = split(words, ", ")
    count((cache=Dict(); dp(design, 0)) for design in designs)
end

function part2(data)
    cache = Dict()
    dp(str, n=0) = get!(cache, n) do 
        n == length(str) || sum(n + length(word) <= length(str) && str[n+1:n+length(word)] == word && dp(str, n + length(word)) for word in words)
    end
    words, _, designs... = data
    words = split(words, ", ")
    sum((cache=Dict(); dp(design, 0)) for design in designs)
end

function part1_cleaned(data)
    dp(str, n=0, C=Dict()) = get!(C, n) do 
        n == length(str) || any(w -> startswith(str[n+1:end], w) && dp(str, n+length(w), C), words)
    end
    words, _, designs... = data
    words = split(words, ", ")
    count(dp, designs)
end

function part2_cleaned(data)
    dp(str, n=0, C=Dict()) = get!(C, n) do 
        n == length(str) || sum(w -> startswith(str[n+1:end], w) && dp(str, n+length(w), C), words)
    end
    words, _, designs... = data
    words = split(words, ", ")
    sum(dp, designs)
end

data = readlines("input.txt")
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
