#include <iostream>
#include <string>
#include <vector>

void solve(const std::vector<std::string>& lines) {
    int total_fuel = 0;
    for (const std::string& line : lines) {
        int mass = std::stoi(line);
        total_fuel += mass / 3 - 2;
    }
    std::cout << "Total fuel requirement: " << total_fuel;
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
