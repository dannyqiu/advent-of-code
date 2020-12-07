#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <regex>

template <class SetType>
std::unordered_set<SetType> set_intersect(const std::unordered_set<SetType>& s1, const std::unordered_set<SetType>& s2) {
    std::unordered_set<SetType> intersection;
    for (const auto& e : s1) {
        if (s2.find(e) != s2.end()) {
            intersection.insert(e);
        }
    }
    return intersection;
}

int count_answered_yes(const std::vector<std::string_view>& group) {
    std::unordered_set<char> answered_yes;
    bool is_first = true;
    for (const auto& person : group) {
        if (is_first) {
            for (char q : person) {
                answered_yes.insert(q);
            }
            is_first = false;
        } else {
            std::unordered_set<char> person_yes;
            for (char q : person) {
                person_yes.insert(q);
            }
            answered_yes = set_intersect(answered_yes, person_yes);
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
    std::cout << "Total questions where everyone in a group answered yes: " << total_answered_yes;
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
