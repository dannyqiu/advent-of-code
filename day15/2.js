process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    if (process.argv.length <= 2) {
        console.log("Usage: " + process.argv.join(" ") + " <calories>");
    }
    var calories = process.argv[2] || 500;
    var ingredients = parseIngredients(input);
    var best = getBestScore(ingredients, calories);
    console.log("The best score of a cookie with " + calories + " calories is: " + best);
}

function getBestScore(ingredients, calories) {
    var ingredientNames = Object.keys(ingredients);
    var quantity = [];
    return getBestScoreRecursive(ingredients, ingredientNames, quantity, calories);
}

function getBestScoreRecursive(ingredients, ingredientNames, quantity, calories) {
    var totalQuantitySoFar = 0;
    for (var i = 0; i < quantity.length; ++i) {
        totalQuantitySoFar += quantity[i];
    }
    var remainingQuantity = 100 - totalQuantitySoFar; // max quantity of the current ingredient

    // when we are determining the quantity of the final ingredient, we can calculate the score
    if (quantity.length == ingredientNames.length-1) {
        quantity.push(remainingQuantity);
        var score;
        if (calculateCalories(ingredients, ingredientNames, quantity) != calories) {
            score = 0;
        }
        else {
            score = calculateScore(ingredients, ingredientNames, quantity);
        }
        quantity.pop();
        return score;
    }
    // otherwise, we will loop through all the possible quantities of the middle ingredients
    else {
        var bestScore = Number.MIN_SAFE_INTEGER;
        for (var i = 0; i < remainingQuantity; ++i) {
            quantity.push(i);
            var score = getBestScoreRecursive(ingredients, ingredientNames, quantity, calories);
            if (score > bestScore) {
                bestScore = score;
            }
            quantity.pop();
        }
        return bestScore;
    }
}

function calculateCalories(ingredients, ingredientNames, quantity) {
    var calories = 0;
    for (var i = 0; i < ingredientNames.length; ++i) {
        calories += quantity[i] * ingredients[ingredientNames[i]]["calories"];
    }
    return calories;
}

function calculateScore(ingredients, ingredientNames, quantity) {
    var c = d = f = t = 0;
    for (var i = 0; i < ingredientNames.length; ++i) {
        c += quantity[i] * ingredients[ingredientNames[i]]["capacity"];
        d += quantity[i] * ingredients[ingredientNames[i]]["durability"];
        f += quantity[i] * ingredients[ingredientNames[i]]["flavor"];
        t += quantity[i] * ingredients[ingredientNames[i]]["texture"];
    }
    // any negative total is considered 0 (which means cookie gets a score of 0!)
    c = Math.max(0, c);
    d = Math.max(0, d);
    f = Math.max(0, f);
    t = Math.max(0, t);
    return c * d * f * t;
}

function parseIngredients(input) {
    var ingredients = {};
    var lines = input.split("\n");
    for (var i = 0; i < lines.length; ++i) {
        if (lines[i] == '') {
            continue;
        }
        parseIngredient(lines[i], ingredients);
    }
    return ingredients;
}

function parseIngredient(line, ingredients) {
    var tokens = line.split(" ");
    var name = tokens[0].substring(0, tokens[0].length-1); // remove colon
    var capacity = parseInt(tokens[2]);
    var durability = parseInt(tokens[4]);
    var flavor = parseInt(tokens[6]);
    var texture = parseInt(tokens[8]);
    var calories = parseInt(tokens[10]);
    ingredients[name] = {
        "capacity": capacity,
        "durability": durability,
        "flavor": flavor,
        "texture": texture,
        "calories": calories
    }
}
