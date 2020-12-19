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

class Matcher {
  public:
    // returns the remaining string after consuming a string using this matcher
    virtual std::string_view consume(std::string_view s) = 0;
    virtual ~Matcher() = default;
};

using Rules = std::map<int, std::unique_ptr<Matcher>>;

class CharMatcher : public Matcher {
  public:
    CharMatcher(char c) : c_(c) {}

    std::string_view consume(std::string_view s) override {
        if (s.front() == c_) {
            return s.substr(1);
        } else {
            return s;
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

    std::string_view consume(std::string_view s) override {
        for (const auto& sub_rule : sub_rules_) {
            bool matches_sub_rule = true;
            std::string_view attempt = s;
            for (int rule_id : sub_rule) {
                auto remaining = rules_->at(rule_id)->consume(attempt);
                // stop matching on sub rule if nothing was consumed
                if (remaining == attempt) {
                    matches_sub_rule = false;
                    break;
                }
                attempt = remaining;
            }
            // sub rules were able to match this string, so remaining string is returned
            if (matches_sub_rule) {
                return attempt;
            }
        }
        // no sub rules match this string
        return s;
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
                rules_lines.push_back(line);
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
        valid_messages += remaining.empty();
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
