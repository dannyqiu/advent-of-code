#include <algorithm>
#include <array>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <unordered_map>
#include <vector>
#include "utils.h"

constexpr int TARGET_ELF = 30000000;

void solve_with_map(const std::vector<std::string>& lines) {
    std::unordered_map<int, int> history_index;
    history_index.reserve(TARGET_ELF / 2);
    int previous_number;
    // elves first read from the list
    auto nums = str_split(lines[0], ',');
    assert(TARGET_ELF > nums.size());
    for (size_t i = 0; i < nums.size(); ++i) {
        int next_number = std::stoi(nums[i]);
        if (i < nums.size() - 1) {
            // place every number in the list, except the last in the index
            history_index[next_number] = i;
        }
        previous_number = next_number;
    }
    for (int i = nums.size(); i < TARGET_ELF; ++i) {
        int next_number;
        auto search = history_index.find(previous_number);
        if (search == history_index.end()) {
            // previous number has never been spoken before
            next_number = 0;
            history_index[previous_number] = i - 1;
        } else {
            // previous number was spoken X rounds ago
            next_number = i - 1 - search->second;
            // update the position of the previous number in the index
            search->second = i - 1;
        }
        previous_number = next_number;
    }
    std::cout << "Elf " << TARGET_ELF << " spoke: " << previous_number;
}

void solve_with_vector(const std::vector<std::string>& lines) {
    // std::vector lookup is 4x faster than std::map lookup
    // std::vector<int> history_index(TARGET_ELF, -1);
    // raw int array is 2x faster than std::vector
    int* history_index = new int[TARGET_ELF];
    memset(history_index, -1, sizeof(int) * TARGET_ELF);
    int previous_number;
    // elves first read from the list
    auto nums = str_split(lines[0], ',');
    assert(TARGET_ELF > nums.size());
    for (size_t i = 0; i < nums.size(); ++i) {
        int next_number = std::stoi(nums[i]);
        if (i < nums.size() - 1) {
            // place every number in the list, except the last in the index
            history_index[next_number] = i;
        }
        previous_number = next_number;
    }
    for (int i = nums.size(); i < TARGET_ELF; ++i) {
        int next_number;
        auto prev_index = history_index[previous_number];
        if (prev_index == -1) {
            // previous number has never been spoken before
            next_number = 0;
        } else {
            // previous number was spoken X rounds ago
            next_number = i - 1 - prev_index;
        }
        // update the position of the previous number in the index
        history_index[previous_number] = i - 1;
        previous_number = next_number;
    }
    std::cout << "Elf " << TARGET_ELF << " spoke: " << previous_number;
    delete[] history_index;
}

auto solve = solve_with_vector;

int main() {
    std::vector<std::string> lines;
    for (std::string line; getline(std::cin, line);) {
        lines.push_back(line);
    }
    solve(lines);
    std::cout << std::endl;
    return 0;
}
