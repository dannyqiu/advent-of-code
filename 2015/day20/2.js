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
    var n = Math.ceil(presents / 11); // total houses to go to, since 11 * i presents is given by each elf i
    // the nth house would receive n * 11 + 11 presents, which guarantees that it has the required presents
    var houses = new Array(n);
    for (var i = 1; i <= n; ++i) { // elves
        for (var j = i; j <= Math.min(i * 50, n); j += i) { // houses delivered to
            if (houses[j] === undefined) {
                houses[j] = i * 11;
            }
            else {
                houses[j] += i * 11;
            }
        }
    }
    for (var i = 1; i <= n; ++i) {
        if (houses[i] >= presents) {
            return i;
        }
    }
}
