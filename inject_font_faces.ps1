$file = "c:\Users\piyus\OneDrive\OO\lv\standalone.html"
$content = Get-Content $file -Raw -Encoding UTF8

$fontFaces = @"
  @font-face {
    font-family: 'Thalassia';
    src: url('./fonts/Thalassia-Regular.woff2') format('woff2');
    font-weight: 400;
    font-style: normal;
  }
  @font-face {
    font-family: 'Thalassia';
    src: url('./fonts/Thalassia-Medium.woff2') format('woff2');
    font-weight: 500;
    font-style: normal;
  }
  @font-face {
    font-family: 'Thalassia';
    src: url('./fonts/Thalassia-Bold.woff2') format('woff2');
    font-weight: 700;
    font-style: normal;
  }
  @font-face {
    font-family: 'Thalassia';
    src: url('./fonts/Thalassia-Bold.woff2') format('woff2');
    font-weight: 900;
    font-style: normal;
  }
  @font-face {
    font-family: 'Thalassia';
    src: url('./fonts/Thalassia-Bold.woff2') format('woff2');
    font-weight: 600;
    font-style: normal;
  }
  @font-face {
    font-family: 'Romena';
    src: url('./fonts/Romena-Regular.woff2') format('woff2');
    font-weight: 400;
    font-style: normal;
  }
  @font-face {
    font-family: 'Romena';
    src: url('./fonts/Romena-Medium.woff2') format('woff2');
    font-weight: 500;
    font-style: normal;
  }
  @font-face {
    font-family: 'Romena';
    src: url('./fonts/Romena-Medium.woff2') format('woff2');
    font-weight: 500;
    font-style: italic;
  }
  @font-face {
    font-family: 'Romena';
    src: url('./fonts/Romena-SemiBold.woff2') format('woff2');
    font-weight: 600;
    font-style: normal;
  }
  @font-face {
    font-family: 'Baustil';
    src: url('./fonts/Baustil-Light.woff2') format('woff2');
    font-weight: 300;
    font-style: normal;
  }
  @font-face {
    font-family: 'Baustil';
    src: url('./fonts/Baustil-Regular.woff2') format('woff2');
    font-weight: 400;
    font-style: normal;
  }
  @font-face {
    font-family: 'Baustil';
    src: url('./fonts/Baustil-Medium.woff2') format('woff2');
    font-weight: 500;
    font-style: normal;
  }
  @font-face {
    font-family: 'Magreb';
    src: url('./fonts/Magreb-Light.woff2') format('woff2');
    font-weight: 300;
    font-style: normal;
  }
  @font-face {
    font-family: 'Magreb';
    src: url('./fonts/Magreb-Regular.woff2') format('woff2');
    font-weight: 400;
    font-style: normal;
  }
  @font-face {
    font-family: 'Magreb';
    src: url('./fonts/Magreb-Medium.woff2') format('woff2');
    font-weight: 500;
    font-style: normal;
  }
"@

$content = $content.Replace("<style>", "<style>`n$fontFaces")

[IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)

Write-Host "Font faces injected successfully"
