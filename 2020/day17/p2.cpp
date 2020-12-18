#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

constexpr int SIM_CYCLES = 6;

using Coord4D = std::tuple<int, int, int, int>;

std::set<Coord4D> parse_input(const std::vector<std::string>& lines) {
    std::set<Coord4D> initial_cubes;
    int row = 0;
    for (const auto& line : lines) {
        int col = 0;
        for (char c : line) {
            if (c == '#') {
                initial_cubes.emplace(std::make_tuple(row, col, 0, 0));
            }
            ++col;
        }
        ++row;
    }
    return initial_cubes;
}

inline std::vector<Coord4D> get_neighbors4D(const Coord4D& cube) {
    std::vector<Coord4D> neighbors;
    for (int i = -1; i <= 1; ++i) {
        for (int j = -1; j <= 1; ++j) {
            for (int k = -1; k <= 1; ++k) {
                for (int l = -1; l <= 1; ++l) {
                    // ignore self
                    if (i == 0 && j == 0 && k == 0 && l == 0) {
                        continue;
                    }
                    neighbors.emplace_back(std::make_tuple(std::get<0>(cube) + i,
                                                           std::get<1>(cube) + j,
                                                           std::get<2>(cube) + k,
                                                           std::get<3>(cube) + l));
                }
            }
        }
    }
    return neighbors;
}

void solve(const std::vector<std::string>& lines) {
    std::set<Coord4D> active_cubes = parse_input(lines);
    for (int i = 0; i < SIM_CYCLES; ++i) {
        std::set<Coord4D> next_active_cubes;
        std::map<Coord4D, int> neighbors_count;
        for (const auto& cube : active_cubes) {
            for (const auto& neighbor : get_neighbors4D(cube)) {
                ++neighbors_count[neighbor];
            }
        }
        for (const auto& nc : neighbors_count) {
            if (nc.second == 3
                || (nc.second == 2 && active_cubes.find(nc.first) != active_cubes.end())) {
                next_active_cubes.insert(nc.first);
            }
        }
        active_cubes = next_active_cubes;
    }
    std::cout << "Active hypercubes after " << SIM_CYCLES << " cycles: " << active_cubes.size();
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
