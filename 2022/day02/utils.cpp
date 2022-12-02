#include <sstream>
#include <string>
#include <vector>
#include "utils.h"

std::vector<std::string> str_split(const std::string& s, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream token_stream(s);
    while (std::getline(token_stream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

std::string str_join(const std::vector<std::string>& strings, std::string_view delimiter) {
    std::ostringstream joined_stream;
    std::copy(strings.begin(), strings.end(), std::ostream_iterator<std::string>(joined_stream, delimiter.data()));
    return joined_stream.str();
}
