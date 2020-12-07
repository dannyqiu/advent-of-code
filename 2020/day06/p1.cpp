#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <regex>

int count_answered_yes(const std::vector<std::string_view>& group) {
    std::unordered_set<char> answered_yes;
    for (const auto& person : group) {
        for (char q : person) {
            answered_yes.insert(q);
        }
    }
    return answered_yes.size();
}

void solve(const std::vector<std::string>& lines) {
    int total_answered_yes = 0;
    std::vector<std::string_view> group;
    for (const auto& line : lines) {
        if (line == "") {
            total_answered_yes += count_answered_yes(group);
            group.clear();
        } else {
            group.push_back(line);
        }
    }
    // Don't forget the last group!
    total_answered_yes += count_answered_yes(group);
    std::cout << "Total questions where anyone in a group answered yes: " << total_answered_yes;
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
