# Builds index.html (local site) and a single self-contained file with images embedded (entrega\).
param([string]$InlineOut)
$root = $PSScriptRoot
$src = Get-Content "$root\src.html" -Raw -Encoding UTF8

# Icons -> SVG sprite
$symbols = Get-ChildItem "$root\icons\*.svg" | ForEach-Object {
  $svg = Get-Content $_.FullName -Raw
  $inner = [regex]::Match($svg, '(?s)<svg[^>]*>(.*)</svg>').Groups[1].Value
  "<symbol id=""i-$($_.BaseName)"" viewBox=""0 0 256 256"">$inner</symbol>"
}
$sprite = "<svg xmlns=""http://www.w3.org/2000/svg"" style=""display:none"">" + ($symbols -join '') + "</svg>"
$html = $src.Replace('<!--ICONS-->', $sprite)

$doc = "<!doctype html>`n<html lang=""es"">`n<head>`n<meta charset=""utf-8"">`n<meta name=""viewport"" content=""width=device-width, initial-scale=1, viewport-fit=cover"">`n"
$headEnd = $html.IndexOf('</style>') + 8
$full = $doc + $html.Substring(0, $headEnd) + "`n</head>`n<body>`n" + $html.Substring($headEnd) + "`n</body>`n</html>`n"
[IO.File]::WriteAllText("$root\index.html", $full, [Text.UTF8Encoding]::new($false))

if (-not $InlineOut) { $InlineOut = "$root\entrega\petit-muu.html"; New-Item -ItemType Directory -Force "$root\entrega" | Out-Null }
$inline = [regex]::Replace($full, '(src|href)="img/([^"]+)"', {
  param($m) $f = $m.Groups[2].Value; $mime = if ($f -like '*.png') { 'image/png' } else { 'image/jpeg' }
  $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$root\img\$f")); "$($m.Groups[1].Value)=""data:$mime;base64,$b""" })
[IO.File]::WriteAllText($InlineOut, $inline, [Text.UTF8Encoding]::new($false))
