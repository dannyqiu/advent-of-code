process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var wrappingPaper = 0;
    var boxes = input.split("\n");
    boxes.forEach(function(box) {
        if (box == '') {
            return;
        }
        var dim = box.split('x').map(Number);
        wrappingPaper += getWrappingPaperForDimensions(dim[0], dim[1], dim[2]);
    });
    console.log("It takes this many square feet of wrapping paper: " + wrappingPaper);
}

function getWrappingPaperForDimensions(l, w, h) {
    var side1 = l * w;
    var side2 = w * h;
    var side3 = h * l;
    return 2 * side1 + 2 * side2 + 2 * side3 + Math.min(side1, side2, side3);
}
