#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <stdexcept>
#include <string>
#include <string_view>
#include <regex>
#include <unordered_set>
#include <vector>
#include "utils.h"

enum OpType {
    ADD,
    MULTIPLY
};

using ExprIt = std::vector<std::string>::iterator;

std::pair<long, ExprIt> eval_expression(ExprIt start, ExprIt end) {
    long running_result = 0;
    OpType current_op = ADD;
    auto eval_op = [&] (long value) {
        switch (current_op) {
            case ADD:
                running_result += value;
                break;
            case MULTIPLY:
                running_result *= value;
                break;
        }
    };
    for (auto it = start; it != end; ++it) {
        const auto& token = *it;
        // std::cerr << token << " " << std::distance(start, it) << "\n";
        if (token == "+") {
            current_op = ADD;
        } else if (token == "*") {
            current_op = MULTIPLY;
        } else if (token == "(") {
            auto [inner_result, next_it] = eval_expression(std::next(it), end);
            eval_op(inner_result);
            // iterator is moved to the ending parenthesis
            it = std::prev(next_it);
        } else if (token == ")") {
            // indicate that this ends at the point past the closing parenthesis
            return std::make_pair(running_result, std::next(it));
        } else {
            eval_op(std::stoi(token));
        }
    }
    return std::make_pair(running_result, end);
}

long eval_expression(const std::string& line) {
    std::string normalized_line = std::accumulate(line.begin(), line.end(), std::string(""),
                                                  [] (std::string a, char b) {
                                                      if (b == '(') {
                                                          return std::move(a) + "( ";
                                                      } else if (b == ')') {
                                                          return std::move(a) + " )";
                                                      } else {
                                                          return std::move(a) + b;
                                                      }
                                                  });
    std::vector<std::string> tokens = str_split(normalized_line, ' ');
    auto [result, _] = eval_expression(tokens.begin(), tokens.end());
    return result;
}

void solve(const std::vector<std::string>& lines) {
    long sum = 0;
    for (const auto& line : lines) {
        sum += eval_expression(line);
    }
    std::cout << "Sum of all resulting values: " << sum;
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
