#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

// NB: Main difference between Part 1 and Part 2 is that Part 2 returns a
// list of possible remaining strings after consuming.
// This allows Part 2 to handle the case where there is a cyclic rule:
//     0: 8 11
//     8: 42 | 42 8
//    11: 42 31 | 42 11 31
//    42: "a"
//    31: "b"
// Giving all the possible strings from matchers in a sub rule allows
// subsequent matchers to try out all possible remaining strings.
// For example:
//     aaaaabb
// A possible matching starting from 0 is:
//      8: "aaa"
//     11: "aabb"
// This can only be achieved if we pass the notion that '8' can consume any
// of "a", "aa", "aaa", "aaaa", "aaaaa".

class Matcher {
  public:
    // returns the possible remaining string after consuming a string using this matcher
    virtual std::vector<std::string_view> consume(std::string_view s) = 0;
    virtual ~Matcher() = default;
};

using Rules = std::map<int, std::unique_ptr<Matcher>>;

class CharMatcher : public Matcher {
  public:
    CharMatcher(char c) : c_(c) {}

    std::vector<std::string_view> consume(std::string_view s) override {
        if (s.front() == c_) {
            return { s.substr(1) };
        } else {
            return {};
        }
    }
  private:
    char c_;
};

class MetaMatcher : public Matcher {
  public:
    MetaMatcher(std::shared_ptr<Rules> rules, std::vector<std::vector<int>> sub_rules) :
        rules_(std::move(rules)),
        sub_rules_(std::move(sub_rules)) {}

    std::vector<std::string_view> consume(std::string_view s) override {
        std::vector<std::string_view> possible_remaining_across_sub_rules;
        for (const auto& sub_rule : sub_rules_) {
            std::vector<std::string_view> attempts = { s };
            for (auto it = sub_rule.begin(); it != sub_rule.end(); ++it) {
                // stop matching on sub rule if there are no possible attempt strings
                if (attempts.empty()) {
                    break;
                }
                int rule_id  = *it;
                std::vector<std::string_view> possible_remaining_across_attempts;
                for (auto attempt : attempts) {
                    auto possible_remaining = rules_->at(rule_id)->consume(attempt);
                    possible_remaining_across_attempts.insert(possible_remaining_across_attempts.end(),
                                                              possible_remaining.begin(), possible_remaining.end());
                }
                attempts = possible_remaining_across_attempts;
            }
            // combine all possible remaining strings from sub rules consumption
            possible_remaining_across_sub_rules.insert(possible_remaining_across_sub_rules.begin(),
                                                       attempts.begin(), attempts.end());
        }
        return possible_remaining_across_sub_rules;
    }
  private:
    std::shared_ptr<Rules> rules_;
    std::vector<std::vector<int>> sub_rules_;
};

enum ParsingStage {
    RULES,
    MESSAGES
};

std::shared_ptr<Rules> parse_rules(const std::vector<std::string>& lines) {
    std::shared_ptr<Rules> rules = std::make_unique<Rules>();
    std::regex char_rule_regex("([0-9]+): \"([a-z])\"");
    std::regex meta_rule_regex("([0-9]+): ([0-9 ]+)( \\| ([0-9 ]+))?");
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, char_rule_regex)) {
            int rule_id = std::stoi(match_results[1]);
            char c = match_results[2].str().front();
            rules->insert({ rule_id, std::make_unique<CharMatcher>(c) });
        } else if (std::regex_match(line, match_results, meta_rule_regex)) {
            int rule_id = std::stoi(match_results[1]);
            std::vector<std::vector<int>> sub_rules;
            {
                std::vector<int> sub_rule1_tokens;
                for (const auto& id : str_split(match_results[2], ' ')) {
                    sub_rule1_tokens.emplace_back(std::stoi(id));
                }
                sub_rules.emplace_back(sub_rule1_tokens);
            }
            if (match_results[4].matched) {
                std::vector<int> sub_rule2_tokens;
                for (const auto& id : str_split(match_results[4], ' ')) {
                    sub_rule2_tokens.emplace_back(std::stoi(id));
                }
                sub_rules.emplace_back(sub_rule2_tokens);
            }
            rules->insert({ rule_id, std::make_unique<MetaMatcher>(rules, std::move(sub_rules)) });
        }
    }
    return rules;
}

void solve(const std::vector<std::string>& lines) {
    std::vector<std::string> rules_lines;
    std::vector<std::string> messages;
    ParsingStage parsing_stage = RULES;
    for (const auto& line : lines) {
        if (line == "") {
            parsing_stage = MESSAGES;
            continue;
        }
        switch (parsing_stage) {
            case RULES:
                if (line == "8: 42") {
                    rules_lines.push_back("8: 42 | 42 8");
                } else if (line == "11: 42 31") {
                    rules_lines.push_back("11: 42 31 | 42 11 31");
                } else {
                    rules_lines.push_back(line);
                }
                break;
            case MESSAGES:
                messages.push_back(line);
                break;
        }
    }
    std::shared_ptr<Rules> rules = parse_rules(rules_lines);
    int valid_messages = 0;
    for (const auto& message : messages) {
        auto remaining = rules->at(0)->consume(message);
        valid_messages += std::any_of(remaining.begin(), remaining.end(), [] (std::string_view s) { return s.empty(); });
    }
    std::cout << "Messages matching rule 0: " << valid_messages;
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
