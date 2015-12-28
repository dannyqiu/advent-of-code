process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var presents = parseInt(input);
    var first = getFirstHouse(presents);
    console.log("The lowest house number to get " + presents + " presents: " + first);
}

function getFirstHouse(presents) {
    var n = Math.ceil(presents / 10); // total houses to go to, since 10 * i presents is given by each elf i
    // the nth house would receive n * 10 + 10 presents, which guarantees that it has the required presents
    var houses = new Array(n);
    for (var i = 1; i <= n; ++i) { // elves
        for (var j = i; j <= n; j += i) { // houses delivered to
            if (houses[j] === undefined) {
                houses[j] = i * 10;
            }
            else {
                houses[j] += i * 10;
            }
        }
    }
    for (var i = 1; i <= n; ++i) {
        if (houses[i] >= presents) {
            return i;
        }
    }
}
