#include <algorithm>
#include <iostream>
#include <iterator>
#include <string>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <regex>

using BagQuantity = std::pair<std::string, int>;
using RulesMap = std::unordered_map<std::string, std::vector<BagQuantity>>;
using MemoizerMap = std::unordered_map<std::string, bool>;

bool contains_shiny_gold(MemoizerMap& memoizer, const RulesMap& rules, const std::string& parent_bag) {
    if (memoizer.find(parent_bag) != memoizer.end()) {
        return memoizer[parent_bag];
    }
    const auto& child_bags = rules.at(parent_bag);
    memoizer[parent_bag] = std::any_of(
            child_bags.begin(), child_bags.end(),
            [&] (const BagQuantity& child_bag) {
                return child_bag.first == "shiny gold" || contains_shiny_gold(memoizer, rules, child_bag.first);
            });
    return memoizer[parent_bag];
}

void solve(const std::vector<std::string>& lines) {
    std::regex rule_regex("(.+) bags contain (.+)\\.");
    std::regex rule_contains_regex("([0-9]+) ([a-z ]+) bags?");
    RulesMap rules;
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, rule_regex)) {
            std::string parent_bag = match_results[1];
            std::string child_bags = match_results[2];
            if (child_bags == "no other bags") {
                rules[parent_bag] = {};
            } else {
                auto child_bags_begin = std::sregex_iterator(child_bags.begin(), child_bags.end(), rule_contains_regex);
                auto child_bags_end = std::sregex_iterator();
                for (auto i = child_bags_begin; i != std::sregex_iterator(); ++i) {
                    match_results = *i;
                    int quantity = std::stoi(match_results[1]);
                    std::string child_bag = match_results[2];
                    rules[parent_bag].emplace_back(std::make_pair(child_bag, quantity));
                }
            }
        }
    }

    MemoizerMap memoizer;
    int count = 0;
    for (const auto& rule : rules) {
        count += contains_shiny_gold(memoizer, rules, rule.first);
    }
    std::cout << "Number of bags that can contain a shiny gold bag: " << count;
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
