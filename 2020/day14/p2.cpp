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

void permute_floating_bits(const std::vector<int>& floating_bit_positions, long or_mask, long and_mask, std::vector<std::pair<long, long>>& output_masks) {
    // all floating bits have been resolved
    if (floating_bit_positions.empty()) {
        output_masks.push_back(std::make_pair(and_mask, or_mask));
        return;
    }
    int position = *floating_bit_positions.begin();
    std::vector<int> sub_floating_bit_positions(floating_bit_positions.begin() + 1, floating_bit_positions.end());
    // floating bit is set to 0
    permute_floating_bits(sub_floating_bit_positions, or_mask, and_mask & ~(1L << position), output_masks);
    // floating bit is set to 1
    permute_floating_bits(sub_floating_bit_positions, or_mask | (1L << position), and_mask, output_masks);
}

std::vector<std::pair<long, long>> parse_mask(const std::string& mask) {
    std::vector<int> floating_bit_positions;
    long or_mask = 0;   // sets bits to 1
    for (size_t i = 0; i < mask.size(); ++i) {
        switch (mask[mask.size() - i - 1]) {
            case 'X':
                floating_bit_positions.push_back(i);
                break;
            case '0':
                break;
            case '1':
                or_mask |= (1L << i);
                break;
        }
    }
    std::vector<std::pair<long, long>> permuted_masks;
    permute_floating_bits(floating_bit_positions, or_mask, -1, permuted_masks);
    return permuted_masks;
}

void solve(const std::vector<std::string>& lines) {
    std::regex mask_regex("mask = ([X01]+)");
    std::regex mem_regex("mem\\[([0-9]+)\\] = ([0-9]+)");

    std::vector<std::pair<long, long>> masks;
    std::map<long, long> memory;
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, mask_regex)) {
            masks = parse_mask(match_results[1]);
        } else if (std::regex_match(line, match_results, mem_regex)) {
            auto address = std::stol(match_results[1]);
            auto value = std::stol(match_results[2]);
            for (auto [and_mask, or_mask] : masks) {
                memory[(address & and_mask) | or_mask] = value;
            }
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
