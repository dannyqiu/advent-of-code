process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var ribbon = 0;
    boxes = input.split("\n");
    boxes.forEach(function(box) {
        if (box == '') {
            return;
        }
        dim = box.split('x').map(Number);
        ribbon += getRibbonForDimensions(dim[0], dim[1], dim[2]);
    });
    console.log("It takes this many feet of ribbon: " + ribbon);
}

function getRibbonForDimensions(l, w, h) {
    shortest = l;
    shorter = w;
    if (w < l) {
        shortest = w;
        shorter = l;
    }
    if (h < l) {
        shorter = shortest;
        shortest = h;
    }
    else if (h < w) {
        shorter = h;
    }
    return 2 * (shortest + shorter) + getVolume(l, w, h);
}

function getVolume(l, w, h) {
    return l * w * h;
}
