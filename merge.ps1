$saPath = "c:\Users\piyus\OneDrive\OO\lv\scroll-animation\standalone.html"
$gbaPath = "c:\Users\piyus\OneDrive\OO\lv\gallery-before-after (1).html"

$sa = Get-Content $saPath -Raw -Encoding UTF8
$gba = Get-Content $gbaPath -Raw -Encoding UTF8

# Extract GBA parts
$cssMatch = [regex]::Match($gba, '(?s)<style>.*?:root\{(.*?)</style>')
$gbaCss = ":root{" + $cssMatch.Groups[1].Value.Trim()

$htmlMatch = [regex]::Match($gba, '(?s)(<section class="gallery-section".*?</section>\s*<section class="ba-section">.*?</section>)')
$gbaHtml = $htmlMatch.Groups[1].Value.Trim()

$jsMatch = [regex]::Match($gba, '(?s)<script>\s*(\(function\(\)\{.*?\)\(\);)\s*</script>')
$gbaJs = $jsMatch.Groups[1].Value.Trim()

# Find SA replacement ranges
$saCssStart = $sa.IndexOf(':root{')
$saCssEnd = $sa.IndexOf('.canvas-container {')

$saHtmlStart = $sa.IndexOf('<section class="gallery-section"')
$saHtmlEnd = $sa.IndexOf('<section class="py-24 px-6" id="process">')

$saJsStart = $sa.IndexOf('(function(){', $sa.IndexOf('</footer>'))
$saJsEnd = $sa.IndexOf('})();', $saJsStart) + 5

if ($saCssStart -eq -1 -or $saCssEnd -eq -1 -or $saHtmlStart -eq -1 -or $saHtmlEnd -eq -1 -or $saJsStart -eq -1) {
    Write-Host "Failed to find boundaries in SA"
    exit 1
}

# Replace CSS
$sa = $sa.Substring(0, $saCssStart) + $gbaCss + "`n`n" + $sa.Substring($saCssEnd)

# Replace HTML
$saHtmlStart = $sa.IndexOf('<section class="gallery-section"')
$saHtmlEnd = $sa.IndexOf('<section class="py-24 px-6" id="process">')
$sa = $sa.Substring(0, $saHtmlStart) + $gbaHtml + "`n`n" + $sa.Substring($saHtmlEnd)

# Replace JS
$saJsStart = $sa.IndexOf('(function(){', $sa.IndexOf('</footer>'))
$saJsEnd = $sa.IndexOf('})();', $saJsStart) + 5
$sa = $sa.Substring(0, $saJsStart) + $gbaJs + "`n" + $sa.Substring($saJsEnd)

[IO.File]::WriteAllText($saPath, $sa, [System.Text.Encoding]::UTF8)

Write-Host "Successfully merged GBA into SA"
