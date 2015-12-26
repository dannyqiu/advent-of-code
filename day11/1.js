process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    input = input.trim();
    newPassword = getNextPassword(input);
    console.log("Santa's next password after " + input + ": " + newPassword);
}

function getNextPassword(password) {
    password = password.split("");
    incrementPassword(password);
    while (!isValidPassword(password.join(''))) {
        incrementPassword(password);
    }
    return password.join('');
}

function incrementPassword(password) {
    password[password.length-1] = String.fromCharCode(password[password.length-1].charCodeAt(0) + 1);
    for (var i = password.length-1; i >= 0; --i) {
        if (password[i] <= 'z') {
            break;
        }
        else {
            password[i] = 'a';
            if (i > 0) {
                password[i-1] = String.fromCharCode(password[i-1].charCodeAt(0) + 1);
            }
            else {
                password.unshift('a');
            }
        }
    }
}

/**
 * Checks that the given password is valid based on the following conditions:
 *  - includes one increasing straight of at least three letters
 *  - cannot contain the letters i, o, or l
 *  - contains at least two different, non-overlapping pairs
 */
function isValidPassword(password) {
    return checkStraight(password) && checkContainsLetters(password) && checkContainsPairs(password);
}

function checkStraight(password) {
    for (var i = 0; i < password.length-2; ++i) {
        if (password.charCodeAt(i) + 1 == password.charCodeAt(i+1) &&
                password.charCodeAt(i) + 2 == password.charCodeAt(i+2)) {
            return true;
        }
    }
    return false;
}

blacklist = ["i", "o", "l"]
function checkContainsLetters(password) {
    for (var i = 0; i < blacklist.length; ++i) {
        if (password.indexOf(blacklist[i]) != -1) {
            return false;
        }
    }
    return true;
}

function checkContainsPairs(password) {
    var pairs = {}
    for (var i = 0; i < password.length-1; ++i) {
        if (password[i] == password[i+1]) {
            var pair = password.substring(i, i+2);
            if (pairs[pair] === undefined) {
                pairs[pair] = 1;
            }
            else {
                pairs[pair]++;
            }
            ++i;
        }
    }
    var pairKeys = Object.keys(pairs);
    return pairKeys.length >= 2;
}
