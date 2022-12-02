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
    int cur = 0;
    int max = 0;
    for (const auto& line : lines) {
        if (line == "") {
            max = std::max(max, cur);
            cur = 0;
        } else {
            cur += std::stoi(line);
        }
    }
    std::cout << "Elf calories max: " << max;
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
