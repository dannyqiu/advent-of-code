process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var machine = parseMachine(input);
    var replacements = machine[0];
    var end = 'e';
    var medicine = machine[1];
    // We greedily want to reduce the size of the medicine so that we can get to e
    var sortedOriginals = Object.keys(replacements).sort(function(a, b) {
        return a.length - b.length;
    }).reverse();
    var steps = getReplacementSteps(medicine, end, replacements, sortedOriginals);
    console.log("Steps to get from " + end + " to " + medicine + ": " + steps);
}

function getReplacementSteps(start, end, replacements, sortedOriginals) {
    if (start == end) {
        return 0;
    }
    else {
        //console.log(start);
        for (var i = 0; i < sortedOriginals.length; ++i) {
            var orig = sortedOriginals[i];
            if (start.indexOf(orig) != -1) {
                var replaced = start.replace(orig, replacements[orig]);
                // we don't need to check every replacement because the replacements are sorted by length. The first successful replacement at each iteration is the best.
                return 1 + getReplacementSteps(replaced, end, replacements, sortedOriginals);
            }
        }
    }
}

function parseMachine(input) {
    var replacements = {};
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            break;
        }
        parseReplacement(lines[i], replacements);
    }
    medicine = lines[++i];
    return [replacements, medicine]
}

function parseReplacement(line, replacements) {
    var tokens = line.split(" ");
    var original = tokens[2];
    var replacement = tokens[0];
    replacements[original] = replacement;
}
