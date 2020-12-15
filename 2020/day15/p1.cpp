#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

constexpr int TARGET_ELF = 2020;

void solve(const std::vector<std::string>& lines) {
    std::vector<int> history;
    auto nums = str_split(lines[0], ',');
    for (size_t i = 0; i < TARGET_ELF; ++i) {
        // elves first read from the list
        if (i < nums.size()) {
            history.push_back(std::stoi(nums[i]));
            continue;
        }

        auto last_occurrence = std::find(history.rbegin() + 1, history.rend(), history[i - 1]);
        if (last_occurrence == history.rend()) {
            // previous number has never been spoken before
            history.push_back(0);
        } else {
            // previous number was spoken X rounds ago
            history.push_back(last_occurrence - history.rbegin());
        }
    }
    std::cout << "Elf " << TARGET_ELF << " spoke: " << history.back();
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
