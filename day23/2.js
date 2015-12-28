process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var instructionSet = parseInstructionSet(input);
    var registers = runInstructionSet(instructionSet);
    var registersToGet;
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <registers>");
        registersToGet = ['b'];
    }
    else {
        registersToGet = process.argv.slice(2, process.argv.length);
    }
    for (var i = 0; i < registersToGet.length; ++i) {
        var r = registersToGet[i];
        if (registers[r] !== undefined) {
            console.log("The value of register " + r + " is: " + registers[r]);
        }
    }
}

// Instructions become a = 31911, a = a*3-1 if odd, a = a/2 if even until a = 1. b is a counter
function runInstructionSet(instructionSet) {
    registers = {"a": 1, "b": 0};
    for (var i = 0; 0 <= i && i < instructionSet.length; ++i) {
        var instr = instructionSet[i];
        switch(instr.instruction) {
            case "hlf":
                registers[instr.register] /= 2;
                break;
            case "tpl":
                registers[instr.register] *= 3;
                break;
            case "inc":
                registers[instr.register]++;
                break;
            case "jmp":
                i += instr.offset - 1; // -1 accounts for the for-loop increment
                break;
            case "jie":
                if (registers[instr.register] % 2 == 0) {
                    i += instr.offset - 1;
                }
                break;
            case "jio":
                if (registers[instr.register] == 1) {
                    i += instr.offset - 1;
                }
                break;
            case "print":
                console.log("Value of register " + instr.register + ": " + registers[instr.register]);
                break;
            default:
                console.log("Unknown instruction: " + instr.instruction);
        }
    }
    return registers;
}

function parseInstructionSet(input) {
    var instructionSet = [];
    var lines = input.split('\n');
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        var tokens = lines[i].split(' ');
        var instruction = tokens[0];
        var register;
        var offset = 0;
        if (isNaN(parseInt(tokens[1]))){
            register = tokens[1];
            if (tokens[2] !== undefined) {
                register = register.substring(0, register.length - 1);
                offset = parseInt(tokens[2]);
            }
        }
        else {
            offset = parseInt(tokens[1]);
        }
        instructionSet.push({
            "instruction": instruction,
            "register": register,
            "offset": offset
        });
    }
    return instructionSet;
}
