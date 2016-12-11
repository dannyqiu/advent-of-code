process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var boss = parseBoss(input);
    var player = {"hp": 100, "damage": 0, "armor": 0};
    store = {
        "weapons": {
            "dagger": [8, 4, 0],
            "shortsword": [10, 5, 0],
            "warhammer": [25, 6, 0],
            "longsword": [40, 7, 0],
            "greataxe": [74, 8, 0]
        },
        "armor": {
            "leather": [13, 0, 1],
            "chainmail": [31, 0, 2],
            "splintmail": [53, 0, 3],
            "bandedmail": [75, 0, 4],
            "platemail": [102, 0, 5]
        },
        "rings": {
            "damage +1": [25, 1, 0],
            "damage +2": [50, 2, 0],
            "damage +3": [100, 3, 0],
            "defense +1": [20, 0, 1],
            "defense +2": [40, 0, 2],
            "defense +3": [80, 0, 3]
        }
    }
    var gold = minGoldSpent(store, player, boss);
    console.log("The least amount of gold spent to win the fight: " + gold);
}

function minGoldSpent(store, player, boss) {
    var items = []
    return minGoldSpentRecursive(store, player, boss, items);
}

function minGoldSpentRecursive(store, player, boss, items) {
    if (items.length == 4) {
        var playerStore = getPlayerStats(store, player, items);
        var cost = playerStore[0];
        var playerStats = playerStore[1];
        if (isPlayerWin(playerStats, boss)) {
            //console.log(cost, items, playerStats);
            return cost;
        }
        else {
            return 999999; // if player loses, then we disregard this configuration
        }
    }
    else {
        var cost = Number.MAX_SAFE_INTEGER;
        if (items.length == 0) { // must buy at least one weapon
            for (var i = 0; i < 5; ++i) {
                items.push(i);
                cost = Math.min(cost, minGoldSpentRecursive(store, player, boss, items));
                items.pop();
            }
            return cost;
        }
        // other items are optional, so we can push undefined, which is not buying
        items.push(undefined);
        cost = minGoldSpentRecursive(store, player, boss, items);
        items.pop();
        if (items.length == 1) { // weapons and armor have 5 choices
            for (var i = 0; i < 5; ++i) {
                items.push(i);
                cost = Math.min(cost, minGoldSpentRecursive(store, player, boss, items));
                items.pop();
            }
        }
        else if (items.length == 2) { // first ring has all 6 choices
            for (var i = 0; i < 6; ++i) {
                items.push(i);
                cost = Math.min(cost, minGoldSpentRecursive(store, player, boss, items));
                items.pop();
            }
        }
        else if (items.length == 3) { // second ring has one less choice
            for (var i = items[2] + 1; i < 6; ++i) {
                items.push(i);
                cost = Math.min(cost, minGoldSpentRecursive(store, player, boss, items));
                items.pop();
            }
        }
        return cost;
    }
}

/**
 * Gets the new player stats given the items from the store
 * items is an array of max 4 numbers, each representing the index of the item to be bought in the store from each category
 * ex. [1, 1, 1, 2] would be the first weapon, armor, and first and second rings
 *     [0, 0, 1, 0] would be the first ring
 *     [0, 1, 0, 0] would be the first armor
 */
function getPlayerStats(store, player, items) {
    var hp = player["hp"];
    var damage = player["damage"];
    var defense = player["armor"];
    var cost = 0;
    var weaponIndex = items[0];
    if (weaponIndex !== undefined) {
        var weapon = store["weapons"][Object.keys(store["weapons"])[weaponIndex]];
        damage += weapon[1];
        cost += weapon[0];
    }
    var armorIndex = items[1];
    if (armorIndex !== undefined) {
        var armor = store["armor"][Object.keys(store["armor"])[armorIndex]];
        defense += armor[2];
        cost += armor[0];
    }
    var ring1Index = items[2];
    var ring2Index = items[3];
    if (ring1Index !== undefined) {
        var rings = Object.keys(store["rings"]);
        var ring1 = store["rings"][rings[ring1Index]];
        damage += ring1[1];
        defense += ring1[2];
        cost += ring1[0];
        if (ring2Index !== undefined) {
            var ring2 = store["rings"][rings[ring2Index]];
            damage += ring2[1];
            defense += ring2[2];
            cost += ring2[0];
        }
    }
    return [cost, {"hp": hp, "damage": damage, "armor": defense}];
}

/**
 * Checks whether the given player and boss stats allows the player to win
 */
function isPlayerWin(player, boss) {
    var playerTurns = Math.ceil(boss["hp"] / Math.max(1, player["damage"] - boss["armor"]));
    var bossTurns = Math.ceil(player["hp"] / Math.max(1, boss["damage"] - player["armor"]));
    return playerTurns - 1 < bossTurns;
}

function parseBoss(input) {
    var tokens = input.split('\n');
    var hp = parseInt(tokens[0].split(" ")[2]);
    var damage = parseInt(tokens[1].split(" ")[1]);
    var armor = parseInt(tokens[2].split(" ")[1]);
    return {"hp": hp, "damage": damage, "armor": armor};
}
