process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <steps>");
    }
    var steps = parseInt(process.argv[2]) || 100;
    var lights = parseLights(input);
    lights[0][0] = '#';
    lights[0][lights[0].length-1] = '#';
    lights[lights.length-1][0] = '#';
    lights[lights.length-1][lights[0].length-1] = '#';
    for (var i = 0; i < steps; ++i) {
        lights = animate(lights);
        //console.log(lights);
    }
    console.log("Lights on after " + steps + " steps: " + countLightsOn(lights));
}

function animate(lights) {
    var copy = deepCopy(lights);
    for (var i = 0; i < lights.length; ++i) {
        for (var j = 0; j < lights[0].length; ++j) {
            var neighborsOn = countNeighborLightsOn(i, j, lights);
            if (lights[i][j] == '#') {
                if (!(neighborsOn == 2 || neighborsOn == 3)) {
                    copy[i][j] = '.';
                }
            }
            else if (lights[i][j] == '.') {
                if (neighborsOn == 3) {
                    copy[i][j] = '#';
                }
            }
        }
    }
    copy[0][0] = '#';
    copy[0][copy[0].length-1] = '#';
    copy[copy.length-1][0] = '#';
    copy[copy.length-1][copy[0].length-1] = '#';
    return copy;
}

function countNeighborLightsOn(row, col, lights) {
    var count = 0;
    for (var i = row - 1; i <= row + 1; ++i) {
        for (var j = col - 1; j <= col + 1; ++j) {
            if (i == row && j == col) {
                continue;
            }
            if (lights[i] === undefined) {
                continue;
            }
            if (lights[i][j] === '#') {
                count++;
            }
        }
    }
    return count;
}

function countLightsOn(lights) {
    var count = 0;
    for (var i = 0; i < lights.length; ++i) {
        for (var j = 0; j < lights.length; ++j) {
            if (lights[i][j] == '#') {
                count++;
            }
        }
    }
    return count;
}

function parseLights(input) {
    var lights = [];
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        lights.push(lines[i].split(''));
    }
    return lights;
}

function deepCopy(arr) {
    copy = new Array(arr.length);
    for (var i = 0; i < arr.length; ++i) {
        copy[i] = arr[i].slice();
    }
    return copy;
}
