#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

int score_round(char opponent, char player) {
    // 0 points for loss, 3 for draw, 6 for win
    // 1 point for rock, 2 for paper, 3 for scissors
    // A = rock
    // B = paper
    // C = scissors
    //
    // X = loss
    // Y = draw
    // Z = win
    std::map<std::pair<char, char>, int> scoring = {
        {std::make_pair('A', 'X'), 0 + 3},
        {std::make_pair('A', 'Y'), 3 + 1},
        {std::make_pair('A', 'Z'), 6 + 2},
        {std::make_pair('B', 'X'), 0 + 1},
        {std::make_pair('B', 'Y'), 3 + 2},
        {std::make_pair('B', 'Z'), 6 + 3},
        {std::make_pair('C', 'X'), 0 + 2},
        {std::make_pair('C', 'Y'), 3 + 3},
        {std::make_pair('C', 'Z'), 6 + 1},
    };
    return scoring[std::make_pair(opponent, player)];

}

void solve(const std::vector<std::string>& lines) {
    int score = 0;
    for (const auto& line : lines) {
        score += score_round(line[0], line[2]);
    }
    std::cout << "Your score: " << score;
}

int main() {
    std::vector<std::string> lines;
    for (std::string line; getline(std::cin, line);) {
        lines.push_back(line);
    }
    solve(lines);
    std::cout << std::endl;
    return 0;
}
