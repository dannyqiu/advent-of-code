#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <regex>

std::vector<std::string> split(const std::string& s, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream token_stream(s);
    while (std::getline(token_stream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

/* ===== SOLUTION BELOW ===== */

bool is_valid_passport(const std::vector<std::string>& lines) {
    // "cid" is optional
    std::unordered_set<std::string> required_fields { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
    for (const auto& line : lines) {
        auto fields = split(line, ' ');
        for (const auto& field : fields) {
            auto kv = split(field, ':');
            auto key = kv[0];
            auto value = kv[1];
            required_fields.erase(key);
        }
    }
    return required_fields.empty();
}

void solve(const std::vector<std::string>& lines) {
    int valid = 0;
    std::vector<std::string> passport;
    for (const auto& line : lines) {
        if (line == "") {
            valid += is_valid_passport(passport);
            passport.clear();
            continue;
        }
        passport.push_back(line);
    }
    // make sure that we check the last passport!
    valid += is_valid_passport(passport);
    std::cout << "Valid passports: " << valid;
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
