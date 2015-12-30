process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var coords = parseRowCol(input);
    var code = getCode(coords[0], coords[1]);
    console.log("The code at row " + coords[0] + ", col " + coords[1] + " is: " + code);
}

/**
 * Finds the code that exists at the given row and column
 */
function getCode(row, col) {
    var num = 1;
    for (var r = 1; r < row; ++r) {
        num += r;
    }
    for (var c = 1; c < col; ++c) {
        num += c + row;
    }
    return generateCode(num);
}

/**
 * Generates the nth code
 */
function generateCode(n) {
    var code = 20151125
    while (--n > 0) {
        code = (code * 252533) % 33554393;
    }
    return code;
}

function parseRowCol(input) {
    var re = /row (\d+).*column (\d+)/;
    var matches = input.match(re);
    var row = parseInt(matches[1]);
    var col = parseInt(matches[2]);
    return [row, col];
}
