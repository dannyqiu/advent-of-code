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

class Ship {
  public:
    enum Direction {
        EAST = 0,
        SOUTH = 1,
        WEST = 2,
        NORTH = 3,
    };
#define NUM_DIRECTIONS 4

    Ship(Direction starting_direction) : dir_(starting_direction) {}

    void turn_left(int degrees) {
        dir_ = Direction((dir_ - (degrees / 90) + NUM_DIRECTIONS) % NUM_DIRECTIONS);
    }

    void turn_right(int degrees) {
        turn_left(360-degrees);
    }

    void move_east(int val) {
        xpos_ += val;
    }

    void move_south(int val) {
        ypos_ -= val;
    }

    void move_west(int val) {
        xpos_ -= val;
    }

    void move_north(int val) {
        ypos_ += val;
    }

    void move_forward(int val) {
        switch(dir_) {
            case EAST:
                move_east(val);
                break;
            case SOUTH:
                move_south(val);
                break;
            case WEST:
                move_west(val);
                break;
            case NORTH:
                move_north(val);
                break;
        }
    }

    std::pair<int, int> get_position() {
        return std::make_pair(xpos_, ypos_);
    }

  private:
    Direction dir_;
    int xpos_ = 0;
    int ypos_ = 0;
};

void solve(const std::vector<std::string>& lines) {
    std::regex action_regex("([NSEWLRF])([0-9]+)");
    Ship ship(Ship::EAST);
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, action_regex)) {
            char action = match_results[1].str()[0];
            int val = std::stoi(match_results[2]);
            switch (action) {
                case 'N':
                    ship.move_north(val);
                    break;
                case 'S':
                    ship.move_south(val);
                    break;
                case 'E':
                    ship.move_east(val);
                    break;
                case 'W':
                    ship.move_west(val);
                    break;
                case 'L':
                    ship.turn_left(val);
                    break;
                case 'R':
                    ship.turn_right(val);
                    break;
                case 'F':
                    ship.move_forward(val);
                    break;
            }
        } else {
            std::cerr << "Unrecognized action: " << line << std::endl;
        }
    }
    auto [xpos, ypos] = ship.get_position();
    int manhattan_distance = std::abs(xpos) + std::abs(ypos);
    std::cout << "Manhattan distance to final position: " << manhattan_distance;
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
