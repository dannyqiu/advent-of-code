process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var machine = parseMachine(input);
    var replacements = machine[0];
    var start = machine[1];
    var distinctMolecules = getDistinctReplaced(start, replacements);
    console.log("Distinct molecules created after one replacement: " + distinctMolecules.length);
}

function getDistinctReplaced(start, replacements) {
    var distinct = {};
    for (var orig in replacements) {
        var possibleReplacements = replacements[orig];
        var re = new RegExp(orig, "g");
        var res;
        // goes through every instance of orig in start and adds the replaced to distinct
        while ((res = re.exec(start)) != null) {
            for (var i = 0; i < possibleReplacements.length; ++i) {
                var repl = possibleReplacements[i];
                var replaced = start.substring(0, res.index) + repl + start.substring(re.lastIndex);
                distinct[replaced] = true;
            }
        }
    }
    return Object.keys(distinct);
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
    start = lines[++i];
    return [replacements, start]
}

function parseReplacement(line, replacements) {
    var tokens = line.split(" ");
    var original = tokens[0];
    var replacement = tokens[2];
    if (replacements[original] === undefined) {
        replacements[original] = [];
    }
    replacements[original].push(replacement);
}
