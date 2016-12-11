process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    if (process.argv.length <= 2) {
        console.log("Usage:", process.argv.join(" "), "<groups>");
    }
    var groups = process.argv[2] || 3;
    var gifts = parseGifts(input);
    var minGiftCombinations = getMinGiftCombinations(gifts, groups);
    if (minGiftCombinations == null) {
        console.log("There is no best gift combination for", groups, "groups");
    }
    else {
        var bestGiftCombination = selectLowestQuantumEntanglement(minGiftCombinations);
        var bestQE = calculateQuantumEntanglement(bestGiftCombination);
        console.log("The best gift combination for", groups, "groups is:", bestGiftCombination, "with QE =", bestQE);
    }
}

function getMinGiftCombinations(gifts, groups) {
    var sum = sumArray(gifts);
    if (sum % groups == 0) {
        for (var i = 1; i < gifts.length; ++i) {
            var giftCombination = getMinGiftsRecursive(gifts, sum / groups, i, [], -1);
            if (giftCombination.length != 0) {
                return giftCombination;
            }
        }
    }
    else {
        return null;
    }
}

function getMinGiftsRecursive(gifts, total, numGifts, curGifts, prevSelectedGift) {
    if (numGifts == 0) {
        if (sumArray(curGifts) == total) {
            return [curGifts.slice()]; // makes a copy of the gifts selected
        }
        else {
            return []; // combination does not equal desired total, so we get nothing
        }
    }
    else {
        var bestCombination = [];
        for (var i = prevSelectedGift + 1; i < gifts.length; ++i) {
            curGifts.push(gifts[i]);
            var combination = getMinGiftsRecursive(gifts, total, numGifts - 1, curGifts, i);
            if (combination.length != 0) {
                bestCombination = bestCombination.concat(combination); // add all the possible gift combinations together
            }
            curGifts.pop();
        }
        return bestCombination;
    }
}

function selectLowestQuantumEntanglement(giftCombinations) {
    var bestQE = Number.MAX_SAFE_INTEGER;
    var bestCombination;
    for (var i = 0; i < giftCombinations.length; ++i) {
        var QE = calculateQuantumEntanglement(giftCombinations[i]);
        if (QE < bestQE) {
            bestQE = QE;
            bestCombination = giftCombinations[i];
        }
    }
    return bestCombination;
}

function calculateQuantumEntanglement(giftCombination) {
    var product = 1;
    for (var i = 0; i < giftCombination.length; ++i) {
        product *= giftCombination[i];
    }
    return product;
}

function sumArray(arr) {
    var sum = 0;
    for (var i = 0; i < arr.length; ++i) {
        sum += arr[i];
    }
    return sum;
}

function parseGifts(input) {
    var lines = input.split("\n");
    var gifts = [];
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        gifts.push(parseInt(lines[i]));
    }
    return gifts;
}
