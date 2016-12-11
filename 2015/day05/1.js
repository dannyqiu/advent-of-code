process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var strings = input.split("\n");
    var niceStrings = 0;
    strings.forEach(function(string) {
        nice = checkVowels(string) && checkLetters(string) && checkStringCombinations(string);
        if (nice) {
            niceStrings++;
        }
    });
    console.log("Nice strings: " + niceStrings);
}

/**
 * Checks that the string has at least 3 vowels
 */
function checkVowels(string) {
    var vowels = 0;
    for (var i = 0; i < string.length; ++i) {
        l = string[i];
        if (l == "a" || l == "e" || l == "i" || l == "o" || l == "u") {
            vowels++;
        }
    }
    return vowels >= 3;
}

/**
 * Checks that the string has at least one letter that appears twice in a row
 */
function checkLetters(string) {
    var prev = string[0];
    for (var i = 1; i < string.length; ++i) {
        if (string[i] == prev) {
            return true;
        }
        prev = string[i];
    }
    return false;
}

/**
 * Checks that the string doesn't contain the following string combinations:
 *     ab, cd, pq, xy
 */
badStrings = ["ab", "cd", "pq", "xy"];
function checkStringCombinations(string) {
    var good = true;
    badStrings.forEach(function(bad) {
        if (string.indexOf(bad) != -1) {
            good = false;
        }
    });
    return good;
}
