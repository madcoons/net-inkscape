# Inkscape executable for linux and windows

Example usage:
```cs
using System.Text;
using CliWrap;
using Inkscape;

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
Console.WriteLine(message);
```