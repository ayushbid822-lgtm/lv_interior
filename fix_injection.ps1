$saPath = "c:\Users\piyus\OneDrive\OO\lv\scroll-animation\standalone.html"
$gbaPath = "c:\Users\piyus\OneDrive\OO\lv\gallery-before-after (1).html"

$sa = Get-Content $saPath -Raw -Encoding UTF8
$gba = Get-Content $gbaPath -Raw -Encoding UTF8

# Extract GBA HTML safely
$startGba = $gba.IndexOf('<!-- ===================== GALLERY ===================== -->')
$endGba = $gba.IndexOf('</section>', $gba.IndexOf('<section class="ba-section">')) + 10
$gbaHtml = $gba.Substring($startGba, $endGba - $startGba)

# Find injection point in SA
# It should be injected right before: <section class="py-24 px-6" id="process">
$insertPoint = $sa.IndexOf('<section class="py-24 px-6" id="process">')

if ($insertPoint -eq -1) {
    Write-Host "Could not find process section in SA!"
    exit 1
}

$sa = $sa.Substring(0, $insertPoint) + $gbaHtml + "`n`n" + $sa.Substring($insertPoint)

[IO.File]::WriteAllText($saPath, $sa, [System.Text.Encoding]::UTF8)
Write-Host "Fixed HTML injection."
