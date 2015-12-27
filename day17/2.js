process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <liters>");
    }
    var liters = process.argv[2] || 150;
    var containers = parseContainers(input);
    var totalCombinations = getTotalCombinations(containers, liters);
    console.log("Possible combinations (using minimum containers) for " + liters + " liters of eggnog: " + combinations.length);
}

function getTotalCombinations(containers, liters) {
    var sorted = containers.sort(function(a, b) {
        return a - b;
    });
    var quantity = [];
    return getTotalCombinationsRecursive(containers, quantity, 0, liters);
}

function getTotalCombinationsRecursive(containers, quantity, index, liters) {
    var currentTotal = 0;
    for (var i = 0; i < quantity.length; ++i) {
        currentTotal += quantity[i] * containers[i];
    }
    var remainingTotal = liters - currentTotal;

    if (index == containers.length-1) {
        if (remainingTotal == 0) {
            quantity.push(0);
            trackMinCombinations(quantity);
            quantity.pop();
            return 1;
        }
        else if (remainingTotal - containers[index] == 0) {
            quantity.push(1);
            trackMinCombinations(quantity);
            quantity.pop();
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        var total = 0;
        for (var i = 0; i <= 1; ++i) {
            quantity.push(i);
            total += getTotalCombinationsRecursive(containers, quantity, index + 1, liters);
            quantity.pop();
        }
        return total;
    }
}

combinations = [];
containersUsed = Number.MAX_SAFE_INTEGER;
function trackMinCombinations(quantity) {
    var count = 0;
    for (var i = 0; i < quantity.length; ++i) {
        if (quantity[i] != 0) {
            count++;
        }
    }
    if (count < containersUsed) {
        combinations = [quantity.slice()];
        containersUsed = count;
    }
    else if (count == containersUsed) {
        combinations.push(quantity.slice());
    }
}

function parseContainers(input) {
    var containers = [];
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        containers.push(parseInt(lines[i]));
    }
    return containers;
}
