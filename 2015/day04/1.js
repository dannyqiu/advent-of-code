var crypto = require('crypto');

process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var i = 0;
    while (!checkHash(input + i)) {
        ++i;
    }
    console.log("Lowest positive number to create hash: " + i);
}

function getMd5Hash(value) {
    var md5sum = crypto.createHash('md5');
    md5sum.update(value);
    return md5sum.digest('hex');
}

function checkHash(value) {
    var hash = getMd5Hash(value);
    if (hash.substring(0, 5) == "00000") {
        console.log(hash + " " + value);
        return true;
    }
    return false;
}
