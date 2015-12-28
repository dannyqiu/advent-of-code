process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var boss = parseBoss(input);
    var player = {"hp": 50, "mana": 500};
    var spells = {
        "missile": 53,
        "drain": 73,
        "shield": 113,
        "poison": 173,
        "recharge": 229
    };
    var mana = minManaSpent(spells, player, boss);
    console.log("The least amount of mana spent to win the fight: " + mana);
}

function minManaSpent(spells, player, boss) {
    var casted = [];
    var state = {};
    return minManaSpentRecursive(spells, player, boss, casted, state);
}

globalMinCost = Number.MAX_SAFE_INTEGER;

function minManaSpentRecursive(spells, player, boss, casted, state) {
    var outcome = isPlayerWin(player, casted, boss, state);
    var res = outcome[0];
    state = outcome[1];
    if (res == true) {
        var cost = casted.map(function(s) { return spells[s]; })
                            .reduce(function(a, b) { return a + b; });
        return cost;
    }
    else if (res == false) {
        return Number.MAX_SAFE_INTEGER;
    }
    else {
        var rechargeCount = 0;
        var shieldCount = 0;
        for (var i = 0; i < casted.length; ++i) {
            switch(casted[i]) {
                case "shield":
                    shieldCount++;
                    break;
                case "recharge":
                    rechargeCount++;
                    break;
            }
        }

        var minCost = Number.MAX_SAFE_INTEGER;
        for (var spell in spells) {
            // let's not be stupid (from trial and error). this causes the spells cast to skyrocket
            if (rechargeCount == 2 && spell == "recharge") {
                break;
            }
            else if (shieldCount == 3 && spell == "shield") {
                break;
            }

            // we cannot cast an effect spell while the effect is still active
            if (spell == "shield" || spell == "poison" || spell == "recharge") {
                if (casted[casted.length-1] == spell || casted[casted.length-2] == spell) {
                    continue;
                }
            }
            casted.push(spell);
            var cost = minManaSpentRecursive(spells, player, boss, casted, state);
            if (cost < minCost) {
                minCost = cost;
                if (cost < globalMinCost) {
                    globalMinCost = cost;
                    //console.log(casted);
                }
            }
            casted.pop();
        }
        return minCost;
    } 
}

/**
 * Checks whether the given player + casted spells and boss stats allows the player to win
 */
function isPlayerWin(player, casted, boss, state) {
    var playerHp = state.playerHp || player.hp;
    var playerMana = state.playerMana || player.mana;
    var playerArmor = state.playerArmor || 0;
    var bossHp = state.bossHp || boss.hp;
    var bossDamage = state.bossDamage || boss.damage;
    var shieldCountDown = state.shieldCountDown || 0;
    var poisonCountDown = state.poisonCountDown || 0;
    var rechargeCountDown = state.rechargeCountDown || 0;
    var turn = state.turn || 0;
    var finished = false;
    while (!finished && playerHp > 0 && bossHp > 0) {
        if (turn % 2 == 0 && turn / 2 >= casted.length) { // player did not have enough spells queued up
            finished = true;
            break;
        }
        //console.log("---");
        //console.log("Player: HP: " + playerHp + " Mana: " + playerMana + " Armor: " + playerArmor);
        //console.log("Boss: HP: " + bossHp);
        if (shieldCountDown > 0) {
            playerArmor = 7;
            shieldCountDown--;
            if (shieldCountDown == 0) {
                playerArmor = 0;
            }
        }
        if (poisonCountDown > 0) {
            bossHp -= 3;
            poisonCountDown--;
        }
        if (rechargeCountDown > 0) {
            playerMana += 101;
            rechargeCountDown--;
        }

        if (turn % 2 == 0) {
            var spell = casted[turn / 2];
            //console.log("Player casts: " + spell);
            if (spell == "missile") {
                playerMana -= 53;
                bossHp -= 4;
            }
            else if (spell == "drain") {
                playerMana -= 73;
                bossHp -= 2;
                playerHp += 2;
            }
            else if (spell == "shield") {
                playerMana -= 113;
                if (shieldCountDown > 0) {
                    throw new Error("Cannot cast shield while shield is still active!");
                }
                shieldCountDown = 6;
            }
            else if (spell == "poison") {
                playerMana -= 173;
                if (poisonCountDown > 0) {
                    throw new Error("Cannot cast poison while poison is still active!");
                }
                poisonCountDown = 6;
            }
            else if (spell == "recharge") {
                playerMana -= 229;
                if (rechargeCountDown > 0) {
                    throw new Error("Cannot cast recharge while recharge is still active!");
                }
                rechargeCountDown = 5;
            }
            else {
                console.log("Unknown spell: " + spell);
            }
            if (playerMana < 53) {
                playerHp = 0; // player dies if they run out of mana
                //throw new Error("Player ran out of mana!");
            }
        }
        else {
            playerHp -= Math.max(1, bossDamage - playerArmor);
            // console.log("Boss hits: " + Math.max(1, bossDamage - playerArmor));
        }

        turn++;
    }
    if (finished) {
        return [undefined, {
            "playerHp": playerHp,
            "playerMana": playerMana,
            "playerArmor": playerArmor,
            "bossHp": bossHp,
            "bossDamage": bossDamage,
            "shieldCountDown": shieldCountDown,
            "poisonCountDown": poisonCountDown,
            "rechargeCountDown": rechargeCountDown,
            "turn": turn
        }]
    }
    else {
        if (playerHp <= 0) {
            //console.log("---");
            //console.log("Player died. Boss HP: " + bossHp);
            return [bossHp <= 0, {}]; // we have to check that if boss kills player, that it didn't die first
        }
        else {
            //console.log("---");
            //console.log("Boss dies. Player: HP: " + playerHp + " Mana: " + playerMana + " Armor: " + playerArmor);
            return [true, {}];
        }
    }
}

function parseBoss(input) {
    var tokens = input.split('\n');
    var hp = parseInt(tokens[0].split(" ")[2]);
    var damage = parseInt(tokens[1].split(" ")[1]);
    return {"hp": hp, "damage": damage};
}
