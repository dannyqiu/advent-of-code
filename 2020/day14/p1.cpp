#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sstream>
#include <regex>
#include <unordered_set>
#include <vector>

std::pair<long, long> parse_mask(const std::string& mask) {
    long and_mask = -1; // sets bits to 0
    long or_mask = 0;   // sets bits to 1
    for (size_t i = 0; i < mask.size(); ++i) {
        switch (mask[mask.size() - i - 1]) {
            case 'X':
                break;
            case '0':
                and_mask &= ~(1L << i);
                break;
            case '1':
                or_mask |= (1L << i);
                break;
        }
    }
    return std::make_pair(and_mask, or_mask);
}

void solve(const std::vector<std::string>& lines) {
    std::regex mask_regex("mask = ([X01]+)");
    std::regex mem_regex("mem\\[([0-9]+)\\] = ([0-9]+)");

    long and_mask;  // sets bits to 0
    long or_mask;   // sets bits to 1
    std::map<long, long> memory;
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, mask_regex)) {
            std::tie(and_mask, or_mask) = parse_mask(match_results[1]);
        } else if (std::regex_match(line, match_results, mem_regex)) {
            auto address = std::stol(match_results[1]);
            auto value = std::stol(match_results[2]);
            memory[address] = (value & and_mask) | or_mask;
        } else {
            std::cerr << "Unrecognized line: " << line << std::endl;
        }
    }

    long sum = 0;
    for (const auto& kv : memory) {
        sum += kv.second;
    }
    std::cout << "Sum of all memory values: " << sum;
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
