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
    int t = std::stoi(lines[0]);
    auto bus_ids = split(lines[1], ',');

    int min_wait = t;
    int bus_id_of_min_wait = -1;
    for (auto id : bus_ids) {
        if (id == "x") {
            continue;
        }
        int interval = std::stoi(id);
        int wait = interval - (t % interval);
        if (wait < min_wait) {
            min_wait = wait;
            bus_id_of_min_wait = interval;
        }
    }

    std::cout << "Bus ID * number of minutes to wait: " << (min_wait * bus_id_of_min_wait);
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
