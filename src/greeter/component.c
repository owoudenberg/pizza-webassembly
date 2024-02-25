#include <time.h>
#include "greeter.h"

const char* greeting = "**Hello, %s!**\n`This message was generated at %s.`";

void exports_pizza4dotnet_example_greeting_greet(greeter_string_t *name, greeter_string_t *ret)
{
    time_t now = time(NULL);
    char* now_str = ctime(&now);

    // Determine the length of the formatted string
    int length = snprintf(NULL, 0, greeting, name, now_str);
    

    greeter_string_t markdown;

    // Convert our markdown message to html by calling the import converter and placing the result into the return value
    pizza4dotnet_example_converter_to_html(&markdown, ret);
}