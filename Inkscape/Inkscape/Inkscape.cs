using System.Runtime.InteropServices;

namespace Inkscape;

public static class Inkscape
{
    public static string InkscapeExecutablePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-linux/AppRun")
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "bin", "inkscape.exe");

    public static string[] InkscapeExecutableRequiredArgs = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? new[] { "--appimage-extract-and-run" }
        : Array.Empty<string>();

    public static string EmbeddedPythonExecutablePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-linux/AppRun")
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "bin", "python.exe");

    public static string[] EmbeddedPythonExecutableRequiredArgs = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? new[] { "--appimage-extract-and-run", "python3.8" }
        : Array.Empty<string>();

    public static string ExtensionsBasePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? "/usr/share/inkscape/extensions"
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "share/inkscape/extensions");
}