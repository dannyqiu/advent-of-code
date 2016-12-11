process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    input = input.trim();
    if (process.argv.length != 3) {
        console.log("Usage: " + process.argv.join(" ") + " <iterations>");
    }
    var iters = parseInt(process.argv[2]) || 1;
    for (var i = 0; i < iters; ++i) {
        input = lookAndSay(input);
    }
    //console.log("Result of " + iters + " iterations of look-and-say: " + input);
    console.log("Length of result of " + iters + " iterations of look-and-say: " + input.length);
}

function lookAndSay(input) {
    output = [];
    var count = 0;
    var cur = input[0];
    for (var i = 0; i < input.length; ++i) {
        if (input[i] == cur) {
            count++;
        }
        else {
            output.push(count);
            output.push(cur);
            count = 1;
            cur = input[i];
        }
    }
    output.push(count);
    output.push(cur);
    return output.join('');
}
