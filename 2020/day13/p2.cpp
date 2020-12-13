#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sstream>
#include <regex>
#include <unordered_set>
#include <vector>

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

void solve(const std::vector<std::string>& lines) {
    // int t = std::stoi(lines[0]);
    auto bus_ids = split(lines[1], ',');

    // solve using Chinese Remainder Theorem
    unsigned long long running_wait = 0;
    unsigned long long running_mod = 1;
    for (size_t i = 0; i < bus_ids.size(); ++i) {
        const auto& id = bus_ids[i];
        if (id == "x") {
            continue;
        }
        int interval = std::stoi(id);
        int offset = i % interval;
        if (offset > 0) {
            while (interval - (running_wait % interval) != offset) {
                running_wait += running_mod;
            }
        }
        running_mod *= interval;
        // std::cout << "Cracked bus_id=" << id << " offset=" << i << " running_wait=" << running_wait << " running_mod=" << running_mod << std::endl;
    }

    std::cout << "Earliest timestamp where bus departures match offset: " << running_wait;
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
