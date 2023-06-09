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
            .Wrap(InkscapePaths.InkscapeExecutablePath)
            .WithArguments(InkscapePaths.InkscapeExecutableRequiredArgs.Concat(new[] { "--version" }));

        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();
        }
        catch (Exception ex)
        {
            string errorMessage = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(errorMessage, ex);
        }

        string message = Encoding.UTF8.GetString(stdOut.ToArray());
        Assert.StartsWith("Inkscape ", message);
    }

    [Fact]
    public async Task Python_Should_Return_Version()
    {
        using MemoryStream stdOut = new();
        using MemoryStream stdError = new();

        Command command = Cli
            .Wrap(InkscapePaths.EmbeddedPythonExecutablePath)
            .WithArguments(InkscapePaths.EmbeddedPythonExecutableRequiredArgs.Concat(new[] { "--version" }));
        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();
        }
        catch (Exception ex)
        {
            string errorMessage = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(errorMessage, ex);
        }

        string message = Encoding.UTF8.GetString(stdOut.ToArray());
        Assert.StartsWith("Python ", message);
    }

    [Fact]
    public async Task Python_Extension_Should_Exist()
    {
        using MemoryStream stdOut = new();
        using MemoryStream stdError = new();

        string pytonCheckScript = $"""
        open('{InkscapePaths.ExtensionsBasePath.Replace("\\", "/")}/inkex/__init__.py')
        """;

        Command command = Cli
            .Wrap(InkscapePaths.EmbeddedPythonExecutablePath)
            .WithArguments(
                InkscapePaths.EmbeddedPythonExecutableRequiredArgs.Concat(new[] { "-c", pytonCheckScript, }));

        try
        {
            await (command | (stdOut, stdError))
                .ExecuteAsync();
        }
        catch (Exception ex)
        {
            string message = Encoding.UTF8.GetString(stdError.ToArray());
            throw new(message, ex);
        }
    }
}