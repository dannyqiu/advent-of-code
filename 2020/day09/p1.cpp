#include <functional>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sstream>
#include <regex>
#include <unordered_set>
#include <vector>

constexpr int XMAS_PREAMBLE_LENGTH = 25;

void solve(const std::vector<std::string>& lines) {
    std::vector<long> previous_nums;
    int preamble_left = XMAS_PREAMBLE_LENGTH;
    for (auto it = lines.begin(); it != lines.end(); ++it) {
        long n = std::stol(*it);
        if (preamble_left > 0) {
            previous_nums.push_back(n);
            --preamble_left;
            continue;
        }

        bool is_valid = false;
        for (size_t i = 0; i < previous_nums.size(); ++i) {
            for (size_t j = i; j < previous_nums.size(); ++j) {
                if (previous_nums[i] + previous_nums[j] == n) {
                    is_valid = true;
                }
            }
        }
        if (is_valid) {
            previous_nums[(it - lines.begin()) % XMAS_PREAMBLE_LENGTH] = n;
        } else {
            std::cout << "First number that is not a sum of the previous " << XMAS_PREAMBLE_LENGTH << " numbers: " << n;
            return;
        }
    }
    throw std::logic_error("Could not find XMAS weakness");
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
