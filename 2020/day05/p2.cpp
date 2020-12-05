#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <regex>

void solve(const std::vector<std::string>& lines) {
    std::unordered_set<int> seats;
    for (int i = 0; i < 127 * 8 + 7; i++) {
        seats.insert(i);
    }

    for (const auto& line : lines) {
        int f = 0;
        int b = 127;
        int l = 0;
        int r = 7;
        for (size_t i = 0; i < line.size(); i++) {
            switch(line[i]) {
                case 'F':
                    b = (f + b - 1) / 2;
                    break;
                case 'B':
                    f = (f + b + 1) / 2;
                    break;
                case 'L':
                    r = (l + r - 1) / 2;
                    break;
                case 'R':
                    l = (l + r + 1) / 2;
                    break;
            }
        }
        int seat_id = f * 8 + r;
        if (seats.find(seat_id) == seats.end()) {
            std::cout << "Wrong: " << line << std::endl;
        }
        seats.erase(seat_id);
    }

    for (int s : seats) {
        if (seats.find(s - 1) == seats.end() && seats.find(s + 1) == seats.end()) {
            std::cout << "Your seat ID: " << s;
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
