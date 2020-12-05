#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <regex>

void solve(const std::vector<std::string>& lines) {
    int max_seat_id = 0;
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
        if (seat_id > max_seat_id) {
            max_seat_id = seat_id;
        }
    }
    std::cout << "Max seat ID: " << max_seat_id;
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
