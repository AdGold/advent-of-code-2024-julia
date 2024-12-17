function run(program, a, b, c)
    program = parse.(Int, split(program, ","))
    combo = [0, 1, 2, 3, a, b, c]
    A, B, C = 5, 6, 7
    out = []
    i = 1
    while i < length(program)
        opcode, operand = program[i:i+1]
        if opcode == 0
            combo[A] = combo[A] >> combo[operand+1]
        elseif opcode == 1
            combo[B] = xor(combo[B], operand)
        elseif opcode == 2
            combo[B] = combo[operand+1] % 8
        elseif opcode == 3
            if combo[A] != 0
                i = operand + 1
                continue
            end
        elseif opcode == 4
            combo[B] = xor(combo[B], combo[C])
        elseif opcode == 5
            push!(out, combo[operand+1] % 8)
        elseif opcode == 6
            combo[B] = combo[A] >> combo[operand+1]
        elseif opcode == 7
            combo[C] = combo[A] >> combo[operand+1]
        else
            println("Unrecognised opcode: ", opcode, " ", operand)
        end
        i += 2
    end
    return join(out, ",")
end

function part1(data)
    reg..., program = match(r".*?(\d+).*?(\d+).*?(\d+).*?([0-9,]+)"s, data)
    a, b, c = parse.(Int, reg)
    run(program, a, b, c)
end

# Program: 2,4,1,2,7,5,4,7,1,3,5,5,0,3,3,0
# 2 4 => B = A % 8
# 1 2 => B = B xor 2
# 7 5 => C = A / (2^B)
# 4 7 => B = B xor C
# 1 3 => B = B xor 3
# 5 5 => output B % 8
# 0 3 => A = A / 8
# 3 0 => jump to start if A != 0
#
# Loop over A in sets of 3 bits, removing the 3 LSB each time
    # B = B xor 2
    # C = A >> B
    # B = B xor C xor 2
    # output LS 3 bits of B
#

function part2(data)
    reg..., program = match(r".*?(\d+).*?(\d+).*?(\d+).*?([0-9,]+)"s, data)
    a, b, c = parse.(Int, reg)
    function find(a)
        run(program, a, b, c) == program && return a
        for new in a << 3:a << 3 + 7
            if endswith(program, run(program, new, b, c))
                if (test = find(new)) != -1
                    return test
                end
            end
        end
        return -1
    end
    find(0)
end

function run_cleaned(program, a, b, c)
    reg, out = [0, 1, 2, 3, a, b, c], []
    A, B, C = 5, 6, 7
    i = 1
    while i < length(program)
        opcode, operand = program[i:i+1]
        opcode == 0 && (reg[A] >>= reg[operand+1])
        opcode == 1 && (reg[B] = xor(reg[B], operand))
        opcode == 2 && (reg[B] = reg[operand+1] & 7)
        opcode == 3 && reg[A] != 0 && (i = operand+1; continue)
        opcode == 4 && (reg[B] = xor(reg[B], reg[C]))
        opcode == 5 && push!(out, reg[operand+1] & 7)
        opcode == 6 && (reg[B] = reg[A] >> reg[operand+1])
        opcode == 7 && (reg[C] = reg[A] >> reg[operand+1])
        i += 2
    end
    join(out, ",")
end

function part1_cleaned(data)
    a, b, c, program... = parse.(Int, getfield.(eachmatch(r"\d+", data), :match))
    run_cleaned(program, a, b, c)
end

function part2_cleaned(data)
    _, b, c, program... = parse.(Int, getfield.(eachmatch(r"\d+", data), :match))
    goal = join(program, ",")
    function find(a)
        for new in a << 3:a << 3 + 7
            res = run_cleaned(program, new, b, c)
            res == goal && return new
            endswith(goal, res) && (t = find(new)) != -1 && return t
        end
        return -1
    end
    find(0)
end

data = read("input.txt", String)
@assert part1(data) == part1_cleaned(data)
@time println(part1(data))
@time println(part1_cleaned(data))
@assert part2(data) == part2_cleaned(data)
@time println(part2(data))
@time println(part2_cleaned(data))
