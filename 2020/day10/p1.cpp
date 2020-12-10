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

void solve(const std::vector<std::string>& lines) {
    std::vector<int> nums;
    std::transform(lines.begin(), lines.end(), std::back_inserter(nums),
                   [] (const std::string& line) {
                       return std::stoi(line);
                   });
    std::sort(nums.begin(), nums.end());
    int prev_jolts = 0;
    int one_diff = 0;
    int three_diff = 0;
    for (int n : nums) {
        switch (n - prev_jolts) {
            case 1:
                ++one_diff;
                break;
            case 2:
                break;
            case 3:
                ++three_diff;
                break;
            default:
                std::cerr << "Unexpected adapter with jolts " << n << " with difference " << (n - prev_jolts);
                break;
        }
        prev_jolts = n;
    }
    // Remember the 3-jolt difference between your device and highest adapter!
    ++three_diff;
    std::cout << "1-jolt differences multiplied by the number of 3-jolt differences: " << (one_diff * three_diff);
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
