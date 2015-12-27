process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <time>");
    }
    var time = parseInt(process.argv[2]) || 2503;
    var reindeers = parseReindeers(input);
    var winningReindeer = getWinningReindeer(reindeers, time);
    var winningPoints = reindeers[winningReindeer]["points"];
    console.log("The winning reindeer after " + time + " seconds has this many points: " + winningPoints + " (" + winningReindeer + ")");
}

function getWinningReindeer(reindeers, time) {
    var reindeerNames = Object.keys(reindeers);
    for (var i = 0; i < reindeerNames.length; ++i) {
        reindeers[reindeerNames[i]]["points"] = 0;
    }
    // time is 1-indexed
    for (var t = 1; t <= time; ++t) {
        // calculate the total distance for each reindeer at every point in time
        for (var i = 0; i < reindeerNames.length; ++i) {
            var stats = reindeers[reindeerNames[i]];
            stats["distance"] = calculateDistance(stats, t);
        }
        // get all reindeers with the highest distance
        var bestReindeer = [reindeerNames[0]]
        var bestReindeerDistance = reindeers[bestReindeer[0]]["distance"];
        for (var i = 1; i < reindeerNames.length; ++i) {
            var tempReindeer = reindeerNames[i];
            var tempReindeerDistance = reindeers[tempReindeer]["distance"];
            if (tempReindeerDistance > bestReindeerDistance) {
                bestReindeer = [tempReindeer];
                bestReindeerDistance = reindeers[bestReindeer[0]]["distance"];
            }
            else if (tempReindeerDistance == bestReindeerDistance) {
                bestReindeer.push(tempReindeer);
            }
        }
        // give one point to all reindeers with the highest distance
        for (var i = 0; i < bestReindeer.length; ++i) {
            reindeers[bestReindeer[i]]["points"]++;
        }
    }
    var winningReindeer = reindeerNames[0];
    for (var i = 1; i < reindeerNames.length; ++i) {
        var tempReindeerName = reindeerNames[i];
        if (reindeers[tempReindeerName]["points"] > reindeers[winningReindeer]["points"]) {
            winningReindeer = tempReindeerName;
        }
    }
    return winningReindeer;
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
