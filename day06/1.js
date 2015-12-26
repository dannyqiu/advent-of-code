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
        if (parsed[0] == 2) {
            toggleLights(lights, parsed[1], parsed[2], parsed[3], parsed[4]);
        }
        else {
            turnLights(lights, !!parsed[0], parsed[1], parsed[2], parsed[3], parsed[4]);
        }
        //console.log(instruction + "\nThere are this many lights lit: " + countLightsOn(lights) + "\n");
    });
    console.log("There are this many lights lit: " + countLightsOn(lights));
}

function turnLights(lights, value, startX, startY, endX, endY) {
    for (var i = startX; i <= endX; ++i) {
        for (var j = startY; j <= endY; ++j) {
            key = (i << 16) + j;
            lights[key] = value;
        }
    }
}

function toggleLights(lights, startX, startY, endX, endY) {
    for (var i = startX; i <= endX; ++i) {
        for (var j = startY; j <= endY; ++j) {
            key = (i << 16) + j;
            if (lights[key] === undefined) {
                lights[key] = true;
            }
            else {
                lights[key] = !lights[key];
            }
        }
    }
}

function countLightsOn(lights) {
    var lightsKeys = Object.keys(lights);
    var lightsOn = lightsKeys.filter(function(lightKey) {
        return lights[lightKey];
    });
    return lightsOn.length;
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
