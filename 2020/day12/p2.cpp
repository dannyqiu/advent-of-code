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

#define PI 3.14159265

class Ship {
  public:
    // waypoint relative to the ship's position
    struct Waypoint {
        int x;
        int y;
    };

    Ship(Waypoint waypoint) : waypoint_(waypoint) {}

    void rotate_waypoint_left(int degrees) {
        for (; degrees > 0; degrees -= 90) {
            std::tie(waypoint_.x, waypoint_.y) = std::make_pair(-waypoint_.y, waypoint_.x);
        }
    }

    void rotate_waypoint_right(int degrees) {
        rotate_waypoint_left(360-degrees);
    }

    void move_waypoint_east(int val) {
        waypoint_.x += val;
    }

    void move_waypoint_south(int val) {
        waypoint_.y -= val;
    }

    void move_waypoint_west(int val) {
        waypoint_.x -= val;
    }

    void move_waypoint_north(int val) {
        waypoint_.y += val;
    }

    void move_towards_waypoint(int val) {
        xpos_ += waypoint_.x * val;
        ypos_ += waypoint_.y * val;
    }

    std::pair<int, int> get_position() {
        return std::make_pair(xpos_, ypos_);
    }

  private:
    Waypoint waypoint_;
    int xpos_ = 0;
    int ypos_ = 0;
};

void solve(const std::vector<std::string>& lines) {
    std::regex action_regex("([NSEWLRF])([0-9]+)");
    Ship ship(Ship::Waypoint{.x = 10, .y = 1});
    for (const auto& line : lines) {
        std::smatch match_results;
        if (std::regex_match(line, match_results, action_regex)) {
            char action = match_results[1].str()[0];
            int val = std::stoi(match_results[2]);
            switch (action) {
                case 'N':
                    ship.move_waypoint_north(val);
                    break;
                case 'S':
                    ship.move_waypoint_south(val);
                    break;
                case 'E':
                    ship.move_waypoint_east(val);
                    break;
                case 'W':
                    ship.move_waypoint_west(val);
                    break;
                case 'L':
                    ship.rotate_waypoint_left(val);
                    break;
                case 'R':
                    ship.rotate_waypoint_right(val);
                    break;
                case 'F':
                    ship.move_towards_waypoint(val);
                    break;
            }
        } else {
            std::cerr << "Unrecognized action: " << line << std::endl;
        }
    }
    auto [xpos, ypos] = ship.get_position();
    int manhattan_distance = std::abs(xpos) + std::abs(ypos);
    std::cout << "Manhattan distance to final position using waypoints: " << manhattan_distance;
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
