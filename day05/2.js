process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    strings = input.split("\n");
    niceStrings = 0;
    strings.forEach(function(string) {
        nice = checkRepeatingPair(string) && checkRepeatingLetter(string);
        if (nice) {
            niceStrings++;
        }
    });
    console.log("Nice strings: " + niceStrings);
}

/**
 * Checks that the string contains a pair of letters that appears at least twice in the string without overlapping
 */
function checkRepeatingPair(string) {
    pairs = {}
    prev = string.substring(0, 2);
    pairs[prev] = 1;
    for (var i = 1; i < string.length-1; ++i) {
        cur = string.substring(i, i+2);
        if (cur != prev) {
            if (pairs[cur] === undefined) {
                pairs[cur] = 1;
            }
            else {
                pairs[cur]++;
            }
            prev = cur;
        }
        else {
            prev = "reset"; // to account for cases when the same letter repeats four times, ex. "aaaa"
        }
    }
    var pairKeys = Object.keys(pairs);
    for (var i = 0; i < pairKeys.length; ++i) {
        if (pairs[pairKeys[i]] > 1) {
            return true;
        }
    }
    return false;
}

/**
 * Checks that the string contains at least one letter repeats with exactly one letter between them
 */
function checkRepeatingLetter(string) {
    for (var i = 0; i < string.length-2; ++i) {
        if (string[i] == string[i+2]) {
            return true;
        }
    }
    return false;
}
