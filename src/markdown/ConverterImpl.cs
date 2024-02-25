using Markdig;

namespace MarkdownWorld.wit.exports.pizza4dotnet.example.v0_1_0;

public class ConverterImpl : IConverter
{
    public static string ToHtml(string markdown)
    {
        return Markdown.ToHtml(markdown);
    }
}
