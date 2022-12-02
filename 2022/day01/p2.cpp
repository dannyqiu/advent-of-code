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

void solve(const std::vector<std::string>& lines) {
    std::vector<int> sums;
    int cur = 0;
    for (const auto& line : lines) {
        if (line == "") {
            sums.push_back(cur);
            cur = 0;
        } else {
            cur += std::stoi(line);
        }
    }
    std::sort(sums.begin(), sums.end(), std::greater<>());
    int top3 = sums[0] + sums[1] + sums[2];
    std::cout << "Elf calories top 3 sum: " << top3;
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
