#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <unordered_set>
#include <regex>

int trees_hit(const std::vector<std::string>& lines, int dx, int dy) {
    int trees = 0;
    int x = 0;
    int y = 0;
    for (const auto& line : lines) {
        if (y++ % dy != 0) {
            continue;
        }

        if (line[x] == '#') {
            trees++;
        }
        x  = (x + dx) % line.size();
    }
    return trees;
}

void solve(const std::vector<std::string>& lines) {
    long product = 1;
    product *= trees_hit(lines, 1, 1);
    product *= trees_hit(lines, 3, 1);
    product *= trees_hit(lines, 5, 1);
    product *= trees_hit(lines, 7, 1);
    product *= trees_hit(lines, 1, 2);
    std::cout << "Product of trees hit: " << product;
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
