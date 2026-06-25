$file = "c:\Users\piyus\OneDrive\OO\lv\scroll-animation\standalone.html"
$content = Get-Content $file -Raw -Encoding UTF8

$target = @"
    document.getElementById('hero-content-end').style.opacity = endOpacity;
    document.getElementById('hero-content-end').style.pointerEvents = endOpacity > 0.5 ? 'auto' : 'none';
"@

$replacement = @"
    document.getElementById('hero-content-end').style.opacity = endOpacity;
    document.getElementById('hero-content-end').style.pointerEvents = endOpacity > 0.5 ? 'auto' : 'none';
    
    // Decrease canvas opacity as end text fades in
    canvas.style.opacity = canvasOpacity * (1 - (endOpacity * 0.7));
"@

if ($content.IndexOf($target) -ne -1) {
    $content = $content.Replace($target, $replacement)
    [IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Opacity logic replaced successfully."
} else {
    Write-Host "Target string not found!"
}
