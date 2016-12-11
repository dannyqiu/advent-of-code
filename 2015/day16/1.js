process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var aunts = parseAunts(input);
    var filteredAunts = filterAunts(aunts,
        { 
            children: 3,
            cats: 7,
            samoyeds: 2,
            pomeranians: 3,
            akitas: 0,
            vizslas: 0,
            goldfish: 5,
            trees: 3,
            cars: 2,
            perfumes: 1
        });
    console.log("The number of the Sue that got you the gift: " + filteredAunts);
}

function filterAunts(aunts, correctProperties) {
    possibleAunts = [];
    for (aunt in aunts) {
        var possible = true;
        for (prop in aunts[aunt]) {
            if (aunts[aunt][prop] != correctProperties[prop]) {
                possible = false;
                break;
            }
        }
        if (possible) {
            possibleAunts.push(aunt);
        }
    }
    return possibleAunts;
}

function parseAunts(input) {
    var aunts = {};
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        parseAunt(lines[i], aunts);
    }
    return aunts;
}

function parseAunt(line, aunts) {
    var tokens = line.split(" ");
    var num = parseInt(tokens[1]);
    aunts[num] = {}
    for (var i = 2; i < tokens.length-1; i += 2) {
        var prop = tokens[i].substring(0, tokens[i].length-1); // remove colon from property
        var value = parseInt(tokens[i+1]);
        aunts[num][prop] = value;
    }
}
