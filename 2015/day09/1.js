process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var locations = parseLocations(input);
    //console.log(locations);
    var shortest = findShortestPath(locations);
    console.log("The distance of the shortest route: " + shortest);
}

function findShortestPath(locations) {
    var cities = Object.keys(locations);
    var permutations = getPermutations(cities);
    var shortestPath = Number.MAX_SAFE_INTEGER;
    for (var i = 0; i < permutations.length; ++i) {
        shortestPath = Math.min(shortestPath, getPathDistance(permutations[i], locations));
    }
    return shortestPath;
}

/**
 * Gets the distance of the path given an array of cities and their corresponding distance table
 */
function getPathDistance(path, locations) {
    var distance = 0;
    for (var i = 0; i < path.length-1; ++i) {
        distance += locations[path[i]][path[i+1]];
    }
    return distance;
}

// from http://stackoverflow.com/a/22063440/3026621
function getPermutations( inputArray ) {
    var permutations = inputArray.reduce(function permute(res, item, key, arr) {
        return res.concat(arr.length > 1 && arr.slice(0, key).concat(arr.slice(key + 1)).reduce(permute, []).map(function(perm) { return [item].concat(perm); }) || item);
    }, []);
    return permutations;
}

function parseLocations(input) {
    var locations = {};
    var mappings = input.split("\n");
    for (var i = 0; i < mappings.length; ++i) {
        parseLocation(locations, mappings[i]);
    }
    return locations;
}

function parseLocation(locations, mapping) {
    var tokens = mapping.split(" ");
    var start = tokens[0];
    var end = tokens[2];
    var distance = parseInt(tokens[4]);
    if (locations[start] === undefined) {
        locations[start] = {};
    }
    locations[start][end] = distance;
    if (locations[end] === undefined) {
        locations[end] = {};
    }
    locations[end][start] = distance;
}
