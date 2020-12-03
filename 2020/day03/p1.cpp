#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <unordered_set>
#include <regex>

void solve(const std::vector<std::string>& lines) {
    int trees = 0;
    int x = 0;
    for (const auto& line : lines) {
        if (line[x] == '#') {
            trees++;
        }
        x = (x + 3) % line.size();
    }
    std::cout << "Trees hit: " << trees;
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
