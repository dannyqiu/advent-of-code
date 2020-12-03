#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <unordered_set>
#include <regex>

void solve(const std::vector<std::string>& lines) {
    int valid_passwords = 0;
    std::regex password_regex("([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)");
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, password_regex)) {
            // their system indexes from 1 >:(
            int pos1 = std::stoi(match_results[1].str()) - 1;
            int pos2 = std::stoi(match_results[2].str()) - 1;
            char letter = *match_results[3].str().begin();
            std::string password = match_results[4];
            bool is_valid = (password[pos1] == letter) ^ (password[pos2] == letter);
            if (is_valid) {
                valid_passwords++;
            }
        } else {
            std::cerr << "Unrecognized password input: " << line << std::endl;
        }
    }
    std::cout << "Number of valid passwords: " << valid_passwords;
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
