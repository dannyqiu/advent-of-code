process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var reindeers = parseReindeers(input);
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <time>");
    }
    var time = parseInt(process.argv[2]) || 2503;
    var winner = getWinningReindeer(reindeers, time);
    var winningReindeer = winner[0];
    var distance = winner[1];
    console.log("The winning reindeer after " + time + " seconds has traveled a distance of: " + distance + " (" + winningReindeer + ")");
}

function getWinningReindeer(reindeers, time) {
    var reindeerNames = Object.keys(reindeers);
    var bestReindeer;
    var bestDistance = Number.MIN_SAFE_INTEGER;
    for (var i = 0; i < reindeerNames.length; ++i) {
        var stats = reindeers[reindeerNames[i]];
        var dist = calculateDistance(stats, time);
        if (dist > bestDistance) {
            bestReindeer = reindeerNames[i];
            bestDistance = dist;
        }
    }
    return [bestReindeer, bestDistance];
}

function calculateDistance(stats, time) {
    var distance = 0;
    var cycleTime = stats["speedTime"] + stats["restTime"];
    var cycles = Math.floor(time / cycleTime);
    // movement time and resting time cycles
    distance += stats["speed"] * (stats["speedTime"] * cycles);
    // remaining movement in an incomplete cycle
    distance += stats["speed"] * Math.min(stats["speedTime"], (time - (cycles * cycleTime)));
    return distance;
}

function parseReindeers(input) {
    var reindeers = {};
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        parseReindeer(lines[i], reindeers);
    }
    return reindeers;
}

function parseReindeer(line, reindeers) {
    line = line.substring(0, line.length-1); // remove period
    var tokens = line.split(" ");
    var name = tokens[0];
    var speed = parseInt(tokens[3]);
    var speedTime = parseInt(tokens[6]);
    var restTime = parseInt(tokens[13]);
    reindeers[name] = {
        "speed": speed,
        "speedTime": speedTime,
        "restTime": restTime,
    };
}
