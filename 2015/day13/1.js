process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var table = parseHappinesses(input);
    var best = getBestHappiness(table);
    console.log("The best seating arrangement has a combined happiness of: " + best);
}

function getBestHappiness(table) {
    var people = Object.keys(table);
    var permutations = getPermutations(people);
    var best = Number.MIN_SAFE_INTEGER;
    for (var i = 0; i < permutations.length; ++i) {
        best = Math.max(best, calculateSeatingHappiness(table, permutations[i]));
    }
    return best;
}

function calculateSeatingHappiness(table, seating) {
    var total = 0;
    for (var i = 0; i < seating.length-1; ++i) {
        total += calculateCombinedHappiness(table, seating[i], seating[i+1]);
    }
    total += calculateCombinedHappiness(table, seating[seating.length-1], seating[0]);
    return total;
}

function calculateCombinedHappiness(table, person, seatmate) {
    var personHappiness = table[person][seatmate];
    var seatmateHappiness = table[seatmate][person];
    return personHappiness + seatmateHappiness;
}

// from http://stackoverflow.com/a/22063440/3026621
function getPermutations( inputArray ) {
    var permutations = inputArray.reduce(function permute(res, item, key, arr) {
        return res.concat(arr.length > 1 && arr.slice(0, key).concat(arr.slice(key + 1)).reduce(permute, []).map(function(perm) { return [item].concat(perm); }) || item);
    }, []);
    return permutations;
}

function parseHappinesses(input) {
    var table = {};
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        parseHappiness(lines[i], table);
    }
    return table;
}

function parseHappiness(line, table) {
    line = line.substring(0, line.length-1); // remove period
    var tokens = line.split(" ");
    var person = tokens[0];
    var change = tokens[3] * ((tokens[2] == "gain") ? 1 : -1);
    var seatmate = tokens[10]
    if (table[person] === undefined) {
        table[person] = {};
    }
    table[person][seatmate] = change;
}
