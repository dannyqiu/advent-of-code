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

using Seats = std::vector<std::vector<char>>;

void print(const Seats& seats) {
    std::cout << std::endl;
    for (size_t i = 0; i < seats.size(); ++i) {
        for (size_t j = 0; j < seats[0].size(); ++j) {
            std::cout << seats[i][j];
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

constexpr int deltas[8][2] = {
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1},
};

inline char get_occupancy(const Seats& seats, size_t i, size_t j) {
    if (0 <= i && i < seats.size() && 0 <= j && j < seats[0].size()) {
        return seats[i][j];
    }
    return ' ';
}

Seats next_round(const Seats& seats) {
    Seats next = seats;
    for (size_t i = 0; i < seats.size(); ++i) {
        for (size_t j = 0; j < seats[0].size(); ++j) {
            int occupied_neighbors = 0;
            for (const auto& d : deltas) {
                for (size_t m = 1; ; ++m) {
                    char neighbor = get_occupancy(seats, i + d[0] * m, j + d[1] * m);
                    if (neighbor == '.') {
                        continue;
                    }
                    occupied_neighbors += neighbor == '#';
                    break;
                }
            }
            switch (seats[i][j]) {
                case '#':
                    next[i][j] = (occupied_neighbors >= 5) ? 'L' : '#';
                    break;
                case 'L':
                    next[i][j] = (occupied_neighbors == 0) ? '#' : 'L';
                    break;
            }
        }
    }
    return next;
}

void solve(const std::vector<std::string>& lines) {
    Seats seats;
    std::transform(lines.begin(), lines.end(), std::back_inserter(seats),
                   [] (const std::string& line) {
                       return std::vector<char>(line.begin(), line.end());
                   });

    Seats next;
    while ((next = next_round(seats)) != seats) {
        seats = next;
    }

    int num_occupied = 0;
    for (size_t i = 0; i < seats.size(); ++i) {
        for (size_t j = 0; j < seats[0].size(); ++j) {
            num_occupied += (seats[i][j] == '#');
        }
    }
    std::cout << "Number of occupied seats after stabilizing: " << num_occupied;
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
