#ifndef AOC_2020_UTILS_H
#define AOC_2020_UTILS_H

#include <string>
#include <string_view>
#include <unordered_set>
#include <vector>

std::vector<std::string> str_split(const std::string& s, char delimiter);

std::string str_join(const std::vector<std::string>& strings, std::string_view delimiter);

template <class SetType>
std::unordered_set<SetType> set_difference(const std::unordered_set<SetType>& s1, const std::unordered_set<SetType>& s2) {
    std::unordered_set<SetType> difference;
    for (const auto& e : s1) {
        if (s2.find(e) == s2.end()) {
            difference.insert(e);
        }
    }
    return difference;
}

#endif
