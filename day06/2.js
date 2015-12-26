process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var instructions = input.split("\n");
    var lights = {};
    instructions.forEach(function(instruction) {
        if (instruction == '') {
            return;
        }
        var parsed = parseInstruction(instruction);
        var adjustment;
        if (parsed[0] == 0) {
            adjustment = -1;
        }
        else if (parsed[0] == 1) {
            adjustment = 1;
        }
        else if (parsed[0] == 2) {
            adjustment = 2;
        }
        adjustLights(lights, adjustment, parsed[1], parsed[2], parsed[3], parsed[4]);
    });
    console.log("The total brightness of the lights: " + sumTotalBrightness(lights));
}

function adjustLights(lights, value, startX, startY, endX, endY) {
    for (var i = startX; i <= endX; ++i) {
        for (var j = startY; j <= endY; ++j) {
            key = (i << 16) + j;
            if (lights[key] === undefined) {
                lights[key] = 0;
            }
            lights[key] += value;
            if (lights[key] < 0) {
                lights[key] = 0;
            }
        }
    }
}

function sumTotalBrightness(lights) {
    var lightsKeys = Object.keys(lights);
    var totalBrightness = 0;
    for (var i = 0; i < lightsKeys.length; ++i) {
        totalBrightness += lights[lightsKeys[i]];
    }
    return totalBrightness;
}

function parseInstruction(instruction) {
    var tokens = instruction.split(" ");
    var instr;
    var startX, startY, endX, endY;
    var pos = 0;
    if (tokens[pos] == "turn") {
        pos++;
        if (tokens[pos] == "off") {
            instr = 0;
        }
        else if (tokens[pos] == "on") {
            instr = 1;
        }
        else {
            console.log("Invalid token after turn: " + tokens[pos]);
        }
    }
    else if (tokens[pos] == "toggle") {
        instr = 2;
    }
    else {
        console.log("Invalid start token: " + tokens[pos]);
    }
    pos++;
    var startComma = tokens[pos].indexOf(",");
    if (startComma == -1) {
        console.log("Invalid start coordinate: " + tokens[pos]);
    }
    else {
        startX = parseInt(tokens[pos].substring(0, startComma));
        startY = parseInt(tokens[pos].substring(startComma+1, tokens[pos].length));
    }
    pos++;
    pos++; // handle "through"
    var endComma = tokens[pos].indexOf(",");
    if (endComma == -1) {
        console.log("Invalid end coordinate: " + tokens[pos]);
    }
    else {
        endX = parseInt(tokens[pos].substring(0, endComma));
        endY = parseInt(tokens[pos].substring(endComma+1, tokens[pos].length));
    }
    pos++;
    if (pos != tokens.length) {
        console.log("Likely failure in parsing...");
    }
    return [instr, startX, startY, endX, endY];
}
