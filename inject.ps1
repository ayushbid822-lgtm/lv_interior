$ErrorActionPreference = "Stop"

$galleryHtml = [System.IO.File]::ReadAllText("c:\Users\piyus\OneDrive\OO\lv\gallery-before-after.html", [System.Text.Encoding]::UTF8)
$codeHtml = [System.IO.File]::ReadAllText("c:\Users\piyus\OneDrive\OO\lv\code.html", [System.Text.Encoding]::UTF8)

# Extract style block specifically for the gallery and ba-section (excluding root and body defaults)
$styleMatch = [regex]::Match($galleryHtml, '(?s)<style>.*?</style>')
$styleBlock = $styleMatch.Value

# Update style variables to use Tailwind theme or generic CSS vars matching the theme
# --parchment -> #F9F8F6 (light)
# --parchment-deep -> #e5e5e5 (light)
# --parchment-line -> rgba(0,0,0,0.1)
# --ink -> #1e293b (slate-800)
# --mahogany -> #8B8E72 (primary)
# --mahogany-deep -> #5c5e4b
# --brass -> #C5A059 (accent)
# --brass-light -> #EAD196
# --brass-dim -> rgba(197,160,89,0.35)
# --cream-text -> #F9F8F6

# Wait, we can just replace the variables inside the style block:
$styleBlock = $styleBlock -replace '--parchment:#f4eedf;', '--parchment: #F9F8F6;'
$styleBlock = $styleBlock -replace '--ink:#171109;', '--ink: #1e293b;'
$styleBlock = $styleBlock -replace '--mahogany:#3a2517;', '--mahogany: #8B8E72;'
$styleBlock = $styleBlock -replace '--mahogany-deep:#241409;', '--mahogany-deep: #5c5e4b;'
$styleBlock = $styleBlock -replace '--brass:#b08a4e;', '--brass: #C5A059;'
$styleBlock = $styleBlock -replace '--brass-light:#dcb978;', '--brass-light: #EAD196;'
$styleBlock = $styleBlock -replace '--brass-dim: rgba\(176,138,78,0.35\);', '--brass-dim: rgba(197,160,89,0.35);'
$styleBlock = $styleBlock -replace '--parchment-line: rgba\(23,17,9,0.13\);', '--parchment-line: rgba(30,41,59,0.13);'
$styleBlock = $styleBlock -replace '--cream-text:#efe7d6;', '--cream-text: #F9F8F6;'
$styleBlock = $styleBlock -replace '--parchment-deep:#e8ddc3;', '--parchment-deep: #e2e8f0;'

# We also need a dark mode overwrite for these variables
$darkVars = @"
  .dark {
    --parchment: #0F110E;
    --ink: #e2e8f0;
    --mahogany: #8B8E72;
    --mahogany-deep: #1a1c18;
    --brass: #C5A059;
    --brass-light: #EAD196;
    --brass-dim: rgba(197,160,89,0.35);
    --parchment-line: rgba(226,232,240,0.13);
    --cream-text: #e2e8f0;
    --parchment-deep: #1e293b;
  }
"@
$styleBlock = $styleBlock -replace '  \*\{box-sizing:border-box;\}', "$darkVars`n  *{box-sizing:border-box;}"

# Remove the body {} and html,body {} from styleBlock as it conflicts with main site
$styleBlock = [regex]::Replace($styleBlock, '(?s)html,body\{.*?\}', '')
$styleBlock = [regex]::Replace($styleBlock, '(?s)body\s*\{.*?\}', '')

# Extract HTML content
$htmlStartMatch = [regex]::Match($galleryHtml, '(?s)<div class="wrap">.*?</section>')
# Wait, the sections are `.gallery-section` and `.ba-section`.
# Let's extract between `</style>` and `<script>`
$bodyMatch = [regex]::Match($galleryHtml, '(?s)<body>(.*?)<script>')
$galleryBody = $bodyMatch.Groups[1].Value
# Remove the <div class="wrap"> and just keep the sections?
# Actually galleryBody contains `<section class="gallery-section">` and `<section class="ba-section">`. This is perfect.

# Extract Script
$scriptMatch = [regex]::Match($galleryHtml, '(?s)<script>(.*?)</script>\s*</body>')
$galleryScript = ""
if ($scriptMatch.Success) {
    $galleryScript = "<script>`n" + $scriptMatch.Groups[1].Value + "`n</script>"
}

# Now inject these into code.html
# 1. Inject styleBlock into <head>
$codeHeadEnd = $codeHtml.IndexOf('</head>')
if ($codeHeadEnd -ge 0) {
    $codeHtml = $codeHtml.Substring(0, $codeHeadEnd) + "`n" + $styleBlock + "`n" + $codeHtml.Substring($codeHeadEnd)
}

# 2. Inject galleryBody between 'services' and 'process'
$servicesEndStr = '</section>'
$processStartStr = '<section class="py-24 px-6" id="process">'
$processStartIndex = $codeHtml.IndexOf($processStartStr)

if ($processStartIndex -ge 0) {
    $codeHtml = $codeHtml.Substring(0, $processStartIndex) + "`n<!-- INTEGRATED GALLERY -->`n" + $galleryBody + "`n<!-- END GALLERY -->`n" + $codeHtml.Substring($processStartIndex)
}

# 3. Inject script at the end before </body>
$codeBodyEnd = $codeHtml.IndexOf('</body>')
if ($codeBodyEnd -ge 0) {
    $codeHtml = $codeHtml.Substring(0, $codeBodyEnd) + "`n" + $galleryScript + "`n" + $codeHtml.Substring($codeBodyEnd)
}

[System.IO.File]::WriteAllText("c:\Users\piyus\OneDrive\OO\lv\code.html", $codeHtml, [System.Text.Encoding]::UTF8)
Write-Host "Injected gallery into code.html"
