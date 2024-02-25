#include <chrono>
#include <string>
#include <ctime>
#include "greeter.h"

void exports_pizza4dotnet_example_greeting_greet(greeter_string_t *name, greeter_string_t *ret)
{
    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);

    std::string name_str(reinterpret_cast<char *>(name->ptr), name->len);
    std::string markdown_str = "**Hello, " + name_str + "!**\n`This message was generated at " + std::ctime(&now_time) + ".`";

    greeter_string_t markdown;
    greeter_string_dup(&markdown, markdown_str.c_str());

    // Convert our markdown message to html by calling the import converter and placing the result into the return value
    pizza4dotnet_example_converter_to_html(&markdown, ret);
}