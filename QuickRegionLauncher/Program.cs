using System.Diagnostics;

var directory = AppContext.BaseDirectory;
var executable = Path.Combine(directory, "ScreenToGif.exe");

if (!File.Exists(executable))
    return;

Process.Start(new ProcessStartInfo
{
    FileName = executable,
    Arguments = "-quick-region",
    WorkingDirectory = directory,
    UseShellExecute = true
});
