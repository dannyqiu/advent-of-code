#include <algorithm>
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

long solve1(const std::vector<std::string>& lines) {
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
            return n;
        }
    }
    throw std::logic_error("Could not find XMAS weakness");
}

void solve(const std::vector<std::string>& lines) {
    long target_sum = solve1(lines);
    std::vector<long> nums;
    std::transform(lines.begin(), lines.end(), std::back_inserter(nums), [] (const std::string& line) -> long {
        return std::stol(line);
    });
    long running_sum = 0;
    size_t start_index = 0;
    size_t end_index = 0;  // exclusive
    while (end_index < nums.size()) {
        if (running_sum < target_sum) {
            running_sum += nums[end_index++];
        } else if (running_sum > target_sum) {
            running_sum -= nums[start_index++];
        } else {
            // running_sum == target_sum
            break;
        }
    }
    long min = *std::min_element(nums.begin() + start_index, nums.begin() + end_index);
    long max = *std::max_element(nums.begin() + start_index, nums.begin() + end_index);
    std::cout << "XMAS encryption weakness: " << (min + max);
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
