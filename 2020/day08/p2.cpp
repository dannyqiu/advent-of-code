#include <functional>
#include <iostream>
#include <map>
#include <string>
#include <string_view>
#include <sstream>
#include <regex>
#include <vector>
#include <unordered_set>

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

class CPU {
  public:
    struct CPUState {
        int acc = 0;
        size_t pc = 0;
    };

    CPU(const std::vector<std::string>& instructions) : instructions_(instructions) {}

    // Run the provided set of instructions on the cpu.
    // If a callback is provided, the cpu will call it before executing each
    // instruction. The callback returning true continues execution.
    void run(std::function<bool(const CPU&)> cb = nullptr) {
        while (0 <= state_.pc && state_.pc < instructions_.size() && (cb == nullptr || cb(*this))) {
            const auto& cur = instructions_[state_.pc];
            auto tokens = split(cur, ' ');
            if (tokens[0] == "nop") {
                nop();
            } else if (tokens[0] == "acc") {
                acc(std::stoi(tokens[1]));
            } else if (tokens[0] == "jmp") {
                jmp(std::stoi(tokens[1]));
                continue;
            } else {
                std::cerr << "Unexpected instruction: " << cur << std::endl;
            }
            ++state_.pc;
        }
    }

    void nop() {}

    void acc(int val) {
        state_.acc += val;
    }

    void jmp(int val) {
        state_.pc += val;
    }

    void set_state(CPUState state) {
        state_ = state;
    }

    const CPUState& get_state() const {
        return state_;
    }

    const std::string& get_current_insn() const {
        return instructions_[state_.pc];
    }

  private:
    std::vector<std::string> instructions_;
    CPUState state_;
};

void solve(const std::vector<std::string>& lines) {
    std::vector<std::string> mutated_lines(lines);
    for (auto it = mutated_lines.begin(); it != mutated_lines.end(); ++it) {
        auto before = *it;
        auto tokens = split(before, ' ');
        // Wwitch nop <-> jmp, and attempt run. Otherwise, skip.
        if (tokens[0] == "nop") {
            tokens[0] = "jmp";
        } else if (tokens[0] == "jmp") {
            tokens[0] = "nop";
        } else {
            continue;
        }
        auto after = tokens[0] + " " + tokens[1];
        *it = after;

        CPU cpu(mutated_lines);
        std::unordered_set<int> already_run;
        cpu.run([&](const CPU& cpu) -> bool {
            auto& state = cpu.get_state();
            if (already_run.find(state.pc) != already_run.end()) {
                //std::cout << "Executed PC " << state.pc << " twice. Current accumulator value is: " << state.acc;
                return false;
            }
            already_run.insert(cpu.get_state().pc);
            return true;
        });

        *it = before;
        if (cpu.get_state().pc >= mutated_lines.size()) {
            std::cout << "Changed PC " << it - mutated_lines.begin() << " from '" << before << "' to '" << after << "'. Ending accumulator value is: " << cpu.get_state().acc;
        }
    }
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
