#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

using Ticket = std::vector<int>;

enum ParsingStage {
    RULES = 1,
    YOUR_TICKET = 2,
    NEARBY_TICKETS = 3,
};

struct ParsedInput {
    std::map<std::string, std::vector<std::pair<int, int>>> rules;
    Ticket your_ticket;
    std::vector<Ticket> nearby_tickets;
};

ParsedInput parse_input(const std::vector<std::string>& lines) {
    std::regex rule_regex("([a-z ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)");
    std::map<std::string, std::vector<std::pair<int, int>>> rules;
    Ticket your_ticket;
    std::vector<Ticket> nearby_tickets;
    std::smatch match_results;
    ParsingStage parsing_stage = ParsingStage::RULES;
    for (const auto& line : lines) {
        if (line == "your ticket:") {
            parsing_stage = ParsingStage::YOUR_TICKET;
            continue;
        } else if (line == "nearby tickets:") {
            parsing_stage = ParsingStage::NEARBY_TICKETS;
            continue;
        } else if (line == "") {
            continue;
        }
        switch (parsing_stage) {
            case RULES:
                if (std::regex_match(line, match_results, rule_regex)) {
                    auto field_name = match_results[1];
                    int lower1 = std::stoi(match_results[2]);
                    int upper1 = std::stoi(match_results[3]);
                    int lower2 = std::stoi(match_results[4]);
                    int upper2 = std::stoi(match_results[5]);
                    rules[field_name].emplace_back(lower1, upper1);
                    rules[field_name].emplace_back(lower2, upper2);
                }
                break;
            case YOUR_TICKET:
                for (const auto& val : str_split(line, ',')) {
                    your_ticket.emplace_back(std::stoi(val));
                }
                break;
            case NEARBY_TICKETS:
                nearby_tickets.push_back({});
                for (const auto& val : str_split(line, ',')) {
                    nearby_tickets.back().emplace_back(std::stoi(val));
                }
                break;
        }
    }
    return ParsedInput {
        .rules = rules,
        .your_ticket = your_ticket,
        .nearby_tickets = nearby_tickets,
    };
}

void solve(const std::vector<std::string>& lines) {
    ParsedInput parsed_input = parse_input(lines);
    int error_rate = 0;
    for (const auto& ticket : parsed_input.nearby_tickets) {
        for (int n : ticket) {
            bool is_valid_for_any_field = false;
            for (const auto& rule : parsed_input.rules) {
                const auto& field_rules = rule.second;
                bool is_valid_for_field = std::any_of(field_rules.begin(), field_rules.end(),
                                                      [&] (std::pair<int, int> range) {
                                                          return range.first <= n && n <= range.second;
                                                      });
                is_valid_for_any_field |= is_valid_for_field;
            }
            if (!is_valid_for_any_field) {
                error_rate += n;
            }
        }
    }
    std::cout << "Ticket scanning error rate: " << error_rate;;
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
