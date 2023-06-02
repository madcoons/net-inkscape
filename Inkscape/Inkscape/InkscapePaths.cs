using System.Runtime.InteropServices;
using System.Security.Cryptography;

namespace Inkscape;

public static class InkscapePaths
{
    public static string InkscapeExecutablePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? Path.Join(AppDomain.CurrentDomain.BaseDirectory, "Inkscape-x86_64.AppImage")
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "bin", "inkscape.exe");

    public static string[] InkscapeExecutableRequiredArgs = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? new[] { "--appimage-extract-and-run" }
        : Array.Empty<string>();

    public static string EmbeddedPythonExecutablePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? Path.Join(AppDomain.CurrentDomain.BaseDirectory, "Inkscape-x86_64.AppImage")
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "bin", "python.exe");

    private static string pytonCheckScript = $"""
        import os
        # raise Exception(os.getcwd())
        raise Exception(os.environ['INKSCAPE_COMMAND'])
        open('{ExtensionsBasePath}/inkex/__init__.py')
        """;

    public static string[] EmbeddedPythonExecutableRequiredArgs = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? new[] { "--appimage-extract-and-run", "python3.8", }
        : Array.Empty<string>();

    public static string ExtensionsBasePath = RuntimeInformation.IsOSPlatform(OSPlatform.Linux)
        ? $"/tmp/appimage_extracted_{GetAppImageHash()}/usr/share/inkscape/extensions"
        : Path.Join(AppDomain.CurrentDomain.BaseDirectory, "inkscape-win", "share/inkscape/extensions");

    private static string GetAppImageHash()
    {
        using MD5 md5 = MD5.Create();
        using FileStream fileStream = File.Open(InkscapeExecutablePath, FileMode.Open);
        byte[] hashBytes = md5.ComputeHash(fileStream);
        return Convert.ToHexString(hashBytes).ToLower();
    }
}