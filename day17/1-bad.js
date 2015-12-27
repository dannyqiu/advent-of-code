process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var containers = parseContainers(input);
    var combinations = getTotalCombinations(containers);
    /* NOTE: This allows the usage of multiples of the given containers */
    console.log("Possible combinations for 150 liters of eggnog (if you have multiples of each container): " + combinations);
}

function getTotalCombinations(containers) {
    var sorted = containers.sort(function(a, b) {
        return a - b;
    });
    var quantity = [];
    return getTotalCombinationsRecursive(containers, quantity, 0);
}

function getTotalCombinationsRecursive(containers, quantity, index) {
    var currentTotal = 0;
    for (var i = 0; i < quantity.length; ++i) {
        currentTotal += quantity[i] * containers[i];
    }
    var remainingTotal = 150 - currentTotal;

    if (index == containers.length-1) {
        if (remainingTotal % containers[index] == 0) {
            quantity.push(remainingTotal / containers[index]);
            //console.log(quantity);
            quantity.pop();
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        var total = 0;
        for (var i = 0; i <= remainingTotal / containers[index]; ++i) {
            quantity.push(i);
            total += getTotalCombinationsRecursive(containers, quantity, index + 1);
            quantity.pop();
        }
        return total;
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
