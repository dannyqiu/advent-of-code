process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var wires = parseInstructions(input);
    //console.log(wires);
    var wiresToGet;
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(' ') + " [vars ...]");
        wiresToGet = ['a'];
    }
    else {
        wiresToGet = process.argv.slice(2, process.argv.length)
    }
    for (var i = 0; i < wiresToGet.length; ++i) {
        if (wires[wiresToGet[i]] != undefined) {
            var value = getValue(wiresToGet[i], wires);
            console.log("Value of " + wiresToGet[i] + ": " + value);
        }
    }
}

gates = {
    "AND": " & ",
    "OR": " | ",
    "NOT": " 65535 - ",
    "LSHIFT": " << ",
    "RSHIFT": " >> "
}
reversedGates = {
    " & ": true,
    " | ": true,
    " 65535 - ": true,
    " << ": true,
    " >> ": true
}
function getValue(wire, table) {
    var value = table[wire];
    if (value === undefined) {
        console.log("Cannot find '" + wire + "' in table");
    }
    for (var i = 0; i < value.length; ++i) {
        if (typeof value[i] == "string") {
            if (reversedGates[value[i]] === undefined) {
                if (gates[value[i]] === undefined) {
                    value[i] = getValue(value[i], table);
                }
                else {
                    value[i] = gates[value[i]];
                }
            }
        }
    }
    return eval(value.join(''));
}

function parseInstructions(input) {
    var instructions = input.split("\n");
    var wires = {};
    instructions.forEach(function(instruction) {
        if (instruction == '') {
            return;
        }
        parseInstruction(instruction, wires);
    });
    return wires;
} 

function parseInstruction(instruction, table) {
    var tokens = instruction.split(" ");
    var key = tokens[tokens.length-1];
    var value = tokens.slice(0, tokens.length-2); // ignores "-> <wire>"
    value = value.map(function(op) {
        num = parseInt(op) 
        if (isNaN(num)) {
            num = op;
        }
        return num;
    });
    table[key] = value;
}
