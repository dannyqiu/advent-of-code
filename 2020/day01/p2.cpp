#include <iostream>
#include <string>
#include <vector>
#include <unordered_set>

constexpr int GOLDEN_SUM = 2020;

void solve(const std::vector<std::string>& lines) {
    std::unordered_set<int> expenses;
    for (const std::string& line : lines) {
        expenses.insert(std::stoi(line));
    }

    for (int e1 : expenses) {
        for (int e2 : expenses) {
            int e3 = GOLDEN_SUM - e1 - e2;
            if (expenses.find(e3) != expenses.end()) {
                std::cout << "Product of three expenses: " << e1 * e2 * e3;
                return;
            }
        }
    }
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
