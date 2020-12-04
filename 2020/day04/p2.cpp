#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
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

bool is_valid_byr(const std::string& value) {
    int byr = std::stoi(value);
    return 1920 <= byr && byr <= 2002;
}

bool is_valid_iyr(const std::string& value) {
    int iyr = std::stoi(value);
    return 2010 <= iyr && iyr <= 2020;
}

bool is_valid_eyr(const std::string& value) {
    int eyr = std::stoi(value);
    return 2020 <= eyr && eyr <= 2030;
}

bool is_valid_hgt(const std::string& value) {
    std::regex hgt_regex("([0-9]+)(cm|in)");
    std::smatch match_results;
    if (std::regex_match(value, match_results, hgt_regex)) {
        int height = std::stoi(match_results[1]);
        std::string units = match_results[2];
        if (units == "cm") {
            return 150 <= height && height <= 193;
        } else if (units == "in") {
            return 59 <= height && height <= 76;
        }
    }
    return false;
}

bool is_valid_hcl(const std::string& value) {
    std::regex hcl_regex("#([0-9a-f]+)");
    std::smatch match_results;
    if (std::regex_match(value, match_results, hcl_regex)) {
        std::string hcl = match_results[1];
        return hcl.size() == 6;
    }
    return false;
}

bool is_valid_ecl(const std::string& value) {
    std::unordered_set<std::string> allowed_ecls { "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };
    return allowed_ecls.find(value) != allowed_ecls.end();
}

bool is_valid_pid(const std::string& value) {
    std::regex pid_regex("([0-9]+)");
    std::smatch match_results;
    if (std::regex_match(value, match_results, pid_regex)) {
        std::string pid = match_results[1];
        return pid.size() == 9;
    }
    return false;
}

bool is_valid_passport(const std::vector<std::string>& lines) {
    // "cid" is optional
    std::unordered_map<std::string, bool(*)(const std::string&)> field_validators {
        { "byr", &is_valid_byr },
        { "iyr", &is_valid_iyr },
        { "eyr", &is_valid_eyr },
        { "hgt", &is_valid_hgt },
        { "hcl", &is_valid_hcl },
        { "ecl", &is_valid_ecl },
        { "pid", &is_valid_pid },
    };
    for (const auto& line : lines) {
        auto fields = split(line, ' ');
        for (const auto& field : fields) {
            auto kv = split(field, ':');
            auto key = kv[0];
            auto value = kv[1];
            if (field_validators.find(key) != field_validators.end()) {
                // exit early if validation fails
                if (!field_validators[key](value)) {
                    return false;
                }
            }
            field_validators.erase(key);
        }
    }
    return field_validators.empty();
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
