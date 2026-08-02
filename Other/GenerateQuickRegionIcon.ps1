param(
    [Parameter(Mandatory = $true)]
    [string] $OutputPath
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$size = 256
$bitmap = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::Transparent)

$backgroundPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$backgroundPath.AddArc(16, 16, 64, 64, 180, 90)
$backgroundPath.AddArc(176, 16, 64, 64, 270, 90)
$backgroundPath.AddArc(176, 176, 64, 64, 0, 90)
$backgroundPath.AddArc(16, 176, 64, 64, 90, 90)
$backgroundPath.CloseFigure()

$backgroundBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 209, 52, 56))
$graphics.FillPath($backgroundBrush, $backgroundPath)

$scanPen = [System.Drawing.Pen]::new([System.Drawing.Color]::White, 16)
$scanPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$scanPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$scanPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

$graphics.DrawLines($scanPen, [System.Drawing.Point[]] @(
    [System.Drawing.Point]::new(104, 58),
    [System.Drawing.Point]::new(78, 58),
    [System.Drawing.Point]::new(58, 78),
    [System.Drawing.Point]::new(58, 104)
))
$graphics.DrawLines($scanPen, [System.Drawing.Point[]] @(
    [System.Drawing.Point]::new(152, 58),
    [System.Drawing.Point]::new(178, 58),
    [System.Drawing.Point]::new(198, 78),
    [System.Drawing.Point]::new(198, 104)
))
$graphics.DrawLines($scanPen, [System.Drawing.Point[]] @(
    [System.Drawing.Point]::new(198, 152),
    [System.Drawing.Point]::new(198, 178),
    [System.Drawing.Point]::new(178, 198),
    [System.Drawing.Point]::new(152, 198)
))
$graphics.DrawLines($scanPen, [System.Drawing.Point[]] @(
    [System.Drawing.Point]::new(104, 198),
    [System.Drawing.Point]::new(78, 198),
    [System.Drawing.Point]::new(58, 178),
    [System.Drawing.Point]::new(58, 152)
))

$pngStream = [System.IO.MemoryStream]::new()
$bitmap.Save($pngStream, [System.Drawing.Imaging.ImageFormat]::Png)
$pngBytes = $pngStream.ToArray()

$outputDirectory = Split-Path -Parent $OutputPath
if ($outputDirectory)
{
    [System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
}

$fileStream = [System.IO.File]::Create($OutputPath)
$writer = [System.IO.BinaryWriter]::new($fileStream)
$writer.Write([uint16] 0)
$writer.Write([uint16] 1)
$writer.Write([uint16] 1)
$writer.Write([byte] 0)
$writer.Write([byte] 0)
$writer.Write([byte] 0)
$writer.Write([byte] 0)
$writer.Write([uint16] 1)
$writer.Write([uint16] 32)
$writer.Write([uint32] $pngBytes.Length)
$writer.Write([uint32] 22)
$writer.Write($pngBytes)

$writer.Dispose()
$fileStream.Dispose()
$pngStream.Dispose()
$scanPen.Dispose()
$backgroundBrush.Dispose()
$backgroundPath.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
