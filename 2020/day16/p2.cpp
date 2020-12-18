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

    // remove tickets that are invalid (ones that have a field that is outside of all ranges)
    std::vector<Ticket> valid_nearby_tickets;
    for (const auto& ticket : parsed_input.nearby_tickets) {
        bool is_valid_ticket = true;
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
            is_valid_ticket &= is_valid_for_any_field;
        }
        if (is_valid_ticket) {
            valid_nearby_tickets.emplace_back(ticket);
        }
    }

    // a mapping of fields to a set of field numbers that it can possibly correspond to
    std::map<std::string, std::unordered_set<int>> possible_field_mappings;
    for (const auto& rule : parsed_input.rules) {
        for (size_t i = 0; i < parsed_input.rules.size(); ++i) {
            possible_field_mappings[rule.first].insert(i);
        }
    }
    for (const auto& ticket : valid_nearby_tickets) {
        for (auto it = ticket.begin(); it != ticket.end(); ++it) {
            int n = *it;
            int i = std::distance(ticket.begin(), it);
            for (const auto& rule : parsed_input.rules) {
                const auto& field_rules = rule.second;
                bool is_valid_for_field = std::any_of(field_rules.begin(), field_rules.end(),
                                                      [&] (std::pair<int, int> range) {
                                                          return range.first <= n && n <= range.second;
                                                      });
                if (!is_valid_for_field) {
                    possible_field_mappings[rule.first].erase(i);
                }
            }
        }
    }

    // determine the possible field numbers, after removing known field numbers
    // once a set has only one possible field number, it can be placed in the true_field_mappings
    std::map<std::string, int> true_field_mappings;
    std::unordered_set<int> known_field_numbers;
    while (true_field_mappings.size() != possible_field_mappings.size()) {
        bool has_change = false;
        for (const auto& field_mapping : possible_field_mappings) {
            if (true_field_mappings.find(field_mapping.first) != true_field_mappings.end()) {
                // already know the field mapping
                continue;
            }
            auto remaining_field_numbers = set_difference(field_mapping.second, known_field_numbers);
            if (remaining_field_numbers.size() == 1) {
                int field_number = *remaining_field_numbers.begin();
                true_field_mappings[field_mapping.first] = field_number;
                known_field_numbers.insert(field_number);
                has_change = true;
            }
        }
        assert(has_change);
    }

    long departure_product = 1;
    std::cout << "Your parsed (and decoded) ticket:\n";
    for (const auto& field_mapping : true_field_mappings) {
        int field_number = field_mapping.second;
        if (field_mapping.first.find("departure") == 0) {
            departure_product *= parsed_input.your_ticket[field_number];
        }
        std::cout << "\t" << field_mapping.first << " : " << parsed_input.your_ticket[field_number] << "\n";
    }
    std::cout << "Product of six fields starting with 'departure': " << departure_product;
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
