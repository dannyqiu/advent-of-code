process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var re = /(-?\d+)/g;
    var matches = input.match(re);
    var sum = matches.map(Number).reduce(function (res, item) {
        return res + item;
    });
    console.log("Sum of all the numbers: " + sum);
}
