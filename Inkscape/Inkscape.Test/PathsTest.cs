using System.Text;
using CliWrap;
using Xunit;

namespace Inkscape.Test;

public class PathsTest
{
    [Fact]
    public async Task Inkscape_Should_Return_Version()
    {
        using MemoryStream stdOut = new();
        using MemoryStream stdError = new();

        Command command = Cli
            .Wrap(Inkscape.InkscapeExecutablePath)
            .WithArguments(Inkscape.InkscapeExecutableRequiredArgs.Concat(new[] { "--version" }));

        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();

            string message = Encoding.UTF8.GetString(stdOut.ToArray());

            Assert.StartsWith("Inkscape ", message);
        }
        catch (Exception ex)
        {
            string message = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(message, ex);
        }
    }

    [Fact]
    public async Task Python_Should_Return_Version()
    {
        using MemoryStream stdOut = new();
        using MemoryStream stdError = new();

        Command command = Cli
            .Wrap(Inkscape.EmbeddedPythonExecutablePath)
            .WithArguments(Inkscape.EmbeddedPythonExecutableRequiredArgs.Concat(new[] { "--version" }));
        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();

            string message = Encoding.UTF8.GetString(stdOut.ToArray());

            Assert.StartsWith("Python ", message);
        }
        catch (Exception ex)
        {
            string message = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(message, ex);
        }
    }

    [Fact]
    public async Task Python_Extension_Should_Exist()
    {
        using MemoryStream stdOut = new();
        using MemoryStream stdError = new();

        string pytonCheckScript = $"""
        open('{Inkscape.ExtensionsBasePath}/inkex/__init__.py')
        """;

        Command command = Cli
            .Wrap(Inkscape.EmbeddedPythonExecutablePath)
            .WithArguments(Inkscape.EmbeddedPythonExecutableRequiredArgs.Concat(new[] { "-c", pytonCheckScript }));

        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();

            string message = Encoding.UTF8.GetString(stdOut.ToArray());

            Assert.StartsWith("Python ", message);
        }
        catch (Exception ex)
        {
            string message = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(message, ex);
        }
    }
}