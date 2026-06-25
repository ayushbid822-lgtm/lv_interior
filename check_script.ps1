$text = Get-Content "c:\Users\piyus\OneDrive\OO\lv\gallery-before-after.html" -Raw
$match = [regex]::Match($text, '(?s)<script>(.*?)</script>')
if ($match.Success) {
    Write-Host $match.Groups[1].Value.Substring(0, [math]::Min(500, $match.Groups[1].Value.Length))
}
