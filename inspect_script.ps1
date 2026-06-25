$standalone = "c:\Users\piyus\OneDrive\OO\lv\scroll-animation\standalone.html"
$standalone1 = "c:\Users\piyus\OneDrive\OO\lv\standalone.html"
$galleryFile = "c:\Users\piyus\OneDrive\OO\lv\gallery-before-after (1).html"

function InspectFile($path) {
    if (-not (Test-Path $path)) { return }
    $content = Get-Content $path -Raw
    Write-Host "File: $path"
    if ($content -match '(?s)<body[^>]*>(.*?)</body>') {
        $body = $matches[1]
        Write-Host "BODY START: " $body.Substring(0, [math]::Min(500, $body.Length))
        
        $classes = @()
        $regex = [regex]'class="([^"]+)"'
        $match = $regex.Match($body)
        while ($match.Success) {
            $classes += $match.Groups[1].Value
            $match = $match.NextMatch()
        }
        $uniqueClasses = $classes | Select-Object -Unique | Select-Object -First 30
        Write-Host "Classes found: " ($uniqueClasses -join ", ")
        
        $sections = @()
        $regexId = [regex]'id="([^"]+)"'
        $matchId = $regexId.Match($body)
        while ($matchId.Success) {
            $sections += $matchId.Groups[1].Value
            $matchId = $matchId.NextMatch()
        }
        $uniqueSections = $sections | Select-Object -Unique | Select-Object -First 30
        Write-Host "IDs found: " ($uniqueSections -join ", ")
    }
    Write-Host "==========================="
}

InspectFile $standalone
InspectFile $standalone1
InspectFile $galleryFile
