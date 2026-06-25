$file = "c:\Users\piyus\OneDrive\OO\lv\standalone.html"
$content = Get-Content $file -Raw -Encoding UTF8

$content = $content.Replace(
    '<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,400;0,9..144,600;0,9..144,900;1,9..144,500&amp;family=Cormorant+Garamond:ital@1&amp;family=Marcellus&amp;family=Jost:wght@300;400;500;600&amp;display=swap" rel="stylesheet"/>',
    '<!-- Custom fonts applied: Thalassia, Romena, Baustil, Magreb -->'
)

$content = $content.Replace(
    '                    fontFamily: {
                        display: ["Fraunces", "serif"],
                        sans: ["Jost", "sans-serif"],
                        italic: ["Cormorant Garamond", "serif"],
                        accent: ["Marcellus", "serif"]
                    },',
    '                    fontFamily: {
                        display: ["Thalassia", "serif"],
                        sans: ["Magreb", "sans-serif"],
                        italic: ["Romena", "serif"],
                        accent: ["Baustil", "sans-serif"]
                    },'
)

$content = $content.Replace(
    "  .eyebrow{`r`n    font-family:'Jost',sans-serif;",
    "  .eyebrow{`r`n    font-family:'Baustil',sans-serif;"
)

$content = $content.Replace(
    "  .gallery-h{`r`n    font-family:'Fraunces', serif;",
    "  .gallery-h{`r`n    font-family:'Thalassia', serif;"
)

$content = $content.Replace(
    "  .gallery-h em{`r`n    font-family:'Cormorant Garamond', serif;",
    "  .gallery-h em{`r`n    font-family:'Romena', serif;"
)

$content = $content.Replace(
    "  .gallery-desc{`r`n    font-family:'Jost',sans-serif;",
    "  .gallery-desc{`r`n    font-family:'Magreb',sans-serif;"
)

$content = $content.Replace(
    "  .tab{`r`n    font-family:'Marcellus', serif;",
    "  .tab{`r`n    font-family:'Baustil', sans-serif;"
)

$content = $content.Replace(
    "  .idle-hint{`r`n    position:absolute; top:50%; left:50%;`r`n    transform: translate(-50%,-50%);`r`n    background: rgba(23,17,9,0.78);`r`n    color: var(--cream-text);`r`n    font-family:'Marcellus', serif;",
    "  .idle-hint{`r`n    position:absolute; top:50%; left:50%;`r`n    transform: translate(-50%,-50%);`r`n    background: rgba(23,17,9,0.78);`r`n    color: var(--cream-text);`r`n    font-family:'Baustil', sans-serif;"
)

$content = $content.Replace(
    "  .detail-title{`r`n    font-family:'Fraunces', serif;",
    "  .detail-title{`r`n    font-family:'Thalassia', serif;"
)

$content = $content.Replace(
    "  .detail-meta{`r`n    display:flex; justify-content:center; gap: 1.1rem;`r`n    flex-wrap:wrap;`r`n    font-family:'Jost',sans-serif;",
    "  .detail-meta{`r`n    display:flex; justify-content:center; gap: 1.1rem;`r`n    flex-wrap:wrap;`r`n    font-family:'Magreb',sans-serif;"
)

$content = $content.Replace(
    "  .detail-desc{`r`n    font-family:'Jost', sans-serif;",
    "  .detail-desc{`r`n    font-family:'Magreb', sans-serif;"
)

$content = $content.Replace(
    "  .ba-eyebrow{`r`n    font-family:'Jost',sans-serif;",
    "  .ba-eyebrow{`r`n    font-family:'Baustil',sans-serif;"
)

$content = $content.Replace(
    "  .ba-h{`r`n    font-family:'Fraunces', serif;",
    "  .ba-h{`r`n    font-family:'Thalassia', serif;"
)

$content = $content.Replace(
    "  .ba-h em{`r`n    font-family:'Cormorant Garamond', serif;",
    "  .ba-h em{`r`n    font-family:'Romena', serif;"
)

$content = $content.Replace(
    "  .ba-desc{`r`n    max-width:48ch;`r`n    font-family:'Jost',sans-serif; font-weight:300;",
    "  .ba-desc{`r`n    max-width:48ch;`r`n    font-family:'Magreb',sans-serif; font-weight:300;"
)

$content = $content.Replace(
    "  .ba-pair-btn{`r`n    font-family:'Marcellus', serif;",
    "  .ba-pair-btn{`r`n    font-family:'Baustil', sans-serif;"
)

$content = $content.Replace(
    "  .ba-mode-btn{`r`n    font-family:'Jost',sans-serif;",
    "  .ba-mode-btn{`r`n    font-family:'Baustil',sans-serif;"
)

$content = $content.Replace(
    "  .ba-tag{`r`n    position:absolute; top:1.1rem;`r`n    font-family:'Jost',sans-serif;",
    "  .ba-tag{`r`n    position:absolute; top:1.1rem;`r`n    font-family:'Baustil',sans-serif;"
)

$content = $content.Replace(
    "  .ba-toggle-btn{`r`n    margin: 1.6rem auto 0; display:flex;`r`n    font-family:'Marcellus', serif;",
    "  .ba-toggle-btn{`r`n    margin: 1.6rem auto 0; display:flex;`r`n    font-family:'Baustil', sans-serif;"
)

$content = $content.Replace(
    "  .ba-caption{`r`n    text-align:center; margin-top:1.4rem;`r`n    font-family:'Jost',sans-serif;",
    "  .ba-caption{`r`n    text-align:center; margin-top:1.4rem;`r`n    font-family:'Magreb',sans-serif;"
)

[IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)

Write-Host "Fonts replaced successfully"
