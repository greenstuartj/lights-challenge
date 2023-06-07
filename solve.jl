
# flips 1 to 0 and vice versa
function flip(n)
    (n * -1) + 1
end

# creates slice indicies
function section(from, to)
    (from+1) : (to+1)
end

# Julia uses vectorisation so you can access a sub matrix,
#  with a vector of indicies and process it elementwise
#  with a function that would accept a scalar value (i.e flip),
#  and reassign the resulting matrix back into the original
#  matrix with .=
function turn_on(lights, y, x)
    lights[section(y...), section(x...)] .= 1
end

function turn_off(lights, y, x)
    lights[section(y...), section(x...)] .= 0
end

function toggle(lights, y, x)
    lights[section(y...), section(x...)] .=
        flip.(lights[section(y...), section(x...)])
end

instruction_map = Dict("turn on"  => turn_on,
                       "turn off" => turn_off,
                       "toggle"   => toggle)

function run_instruction(line, lights)
    re = r"(turn on|turn off|toggle) (\d{1,3}),(\d{1,3}) through (\d{1,3}),(\d{1,3})"
    m = match(re, line)
    instruction = m[1]
    top_y = parse(Int, m[2])
    low_y = parse(Int, m[4])
    left_x = parse(Int, m[3])
    right_x = parse(Int, m[5])
    instruction_map[instruction](lights, [top_y, low_y], [left_x, right_x])
end


# ARGS[1] is input file from command line args
instructions = readlines(ARGS[1])

# initialise light matrix
lights = zeros(Int, 1000, 1000)

for (_, instruction) in enumerate(instructions)
    run_instruction(instruction, lights)
end

println(sum(lights))

