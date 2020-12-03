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
            int min_count = std::stoi(match_results[1].str());
            int max_count = std::stoi(match_results[2].str());
            char letter = *match_results[3].str().begin();
            std::string password = match_results[4];
            int count = std::count(password.begin(), password.end(), letter);
            // should print the original line if we parsed it correctly.
            // std::cout << min_count << "-" << max_count << " " << letter << ": " << password << std::endl;
            if (min_count <= count && count <= max_count) {
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
