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
    int max = *std::max_element(nums.begin(), nums.end());
    std::vector<long> dp(max + 1, 0);
    dp[0] = 1;
    for (int n : nums) {
        dp[n] = 0;
        for (int i = 1; i <= 3 && n - i >= 0; ++i) {
            dp[n] += dp[n - i];
        }
    }
    std::cout << "Number of distinct arrangements of adapters to connect your device: " << dp[max];
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
