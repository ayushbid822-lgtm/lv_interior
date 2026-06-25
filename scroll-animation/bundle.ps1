$dir = "c:\Users\piyus\OneDrive\OO\lv\scroll-animation"
$outFile1 = "$dir\standalone.html"
$outFile2 = "c:\Users\piyus\OneDrive\OO\lv\standalone.html"
$framesDir = "$dir\frames"

$codeHtml = Get-Content "c:\Users\piyus\OneDrive\OO\lv\code.html" -Raw

# Extract sections
$servicesStartStr = '<section class="py-24 px-6 bg-stone-100 dark:bg-stone-900/50 transition-colors" id="services">'
$bodyEndStr = '</body>'
$servicesStartIndex = $codeHtml.IndexOf($servicesStartStr)
$bodyEndIndex = $codeHtml.IndexOf($bodyEndStr)

$sectionsContent = ""
if ($servicesStartIndex -ge 0 -and $bodyEndIndex -gt $servicesStartIndex) {
    $sectionsContent = $codeHtml.Substring($servicesStartIndex, $bodyEndIndex - $servicesStartIndex)
}

# Extract style block from code.html
$codeStyleMatches = [regex]::Matches($codeHtml, '(?s)<style>(.*?)</style>')
$codeStyleContent = ""
foreach ($match in $codeStyleMatches) {
    $codeStyleContent += $match.Groups[1].Value + "`n"
}

$cssContent = Get-Content "$dir\style.css" -Raw
# Remove body block from cssContent
$cssContent = [regex]::Replace($cssContent, '(?s)body\s*{.*?}', '')

$jsImageData = "const imageData = {"
for ($i = 1; $i -le 208; $i++) {
    $numStr = $i.ToString("D3")
    $imgPath = "$framesDir\ezgif-frame-$numStr.jpg"
    if (Test-Path $imgPath) {
        $bytes = [System.IO.File]::ReadAllBytes($imgPath)
        $base64 = [Convert]::ToBase64String($bytes)
        $jsImageData += "`n    `"$i`": `"data:image/jpeg;base64,$base64`","
    }
}
$jsImageData += "`n};`n"

$jsContent = @"
const canvas = document.getElementById('scroll-canvas');
const context = canvas.getContext('2d');

function setCanvasDimensions() {
    const dpr = window.devicePixelRatio || 1;
    canvas.width = window.innerWidth * dpr;
    canvas.height = window.innerHeight * dpr;
    context.imageSmoothingEnabled = true;
    context.imageSmoothingQuality = 'high';
}
setCanvasDimensions();

const frameCount = 208;
const currentFrame = index => imageData[index + 1];

const images = [];

// Preload all images
for (let i = 0; i < frameCount; i++) {
    const img = new Image();
    img.src = currentFrame(i);
    images.push(img);
}

// Draw the first frame when loaded
images[0].onload = function() {
    drawFrame(0);
}

function drawFrame(index) {
    if(!images[index] || !images[index].complete) return;
    
    // Fill background with black
    context.fillStyle = '#000';
    context.fillRect(0, 0, canvas.width, canvas.height);
    
    const img = images[index];
    
    // Calculate aspect ratio and draw image covering the canvas (object-fit: cover)
    const canvasAspect = canvas.width / canvas.height;
    const imgAspect = img.width / img.height;
    
    let drawWidth, drawHeight, offsetX = 0, offsetY = 0;
    
    if (canvasAspect > imgAspect) {
        drawWidth = canvas.width;
        drawHeight = canvas.width / imgAspect;
        offsetY = (canvas.height - drawHeight) / 2;
    } else {
        drawHeight = canvas.height;
        drawWidth = canvas.height * imgAspect;
        offsetX = (canvas.width - drawWidth) / 2;
    }
    
    context.drawImage(img, offsetX, offsetY, drawWidth, drawHeight);
}

window.addEventListener('scroll', () => {
    const scrollTop = document.documentElement.scrollTop;
    const vh = window.innerHeight;
    
    const phase1End = 0.5 * vh; // Fade out initial text and fade in canvas
    const animEnd = 2.5 * vh; // End of animation
    const phase2End = 3.0 * vh; // Fade in final text
    
    // 1. Start Phase: Fade out start text, fade in canvas
    let startOpacity = 1 - (scrollTop / phase1End);
    if (startOpacity < 0) startOpacity = 0;
    if (startOpacity > 1) startOpacity = 1;
    
    let canvasOpacity = scrollTop / phase1End;
    if (canvasOpacity < 0) canvasOpacity = 0;
    if (canvasOpacity > 1) canvasOpacity = 1;
    
    document.getElementById('hero-content-start').style.opacity = startOpacity;
    document.getElementById('hero-content-start').style.pointerEvents = startOpacity > 0.5 ? 'auto' : 'none';
    canvas.style.opacity = canvasOpacity;
    
    // 2. Animation Phase
    let scrollFraction = 0;
    if (scrollTop > phase1End) {
        scrollFraction = (scrollTop - phase1End) / (animEnd - phase1End);
    }
    if (scrollFraction < 0) scrollFraction = 0;
    if (scrollFraction > 1) scrollFraction = 1;
    
    const frameIndex = Math.min(
        frameCount - 1,
        Math.max(0, Math.ceil(scrollFraction * (frameCount - 1)))
    );
    requestAnimationFrame(() => drawFrame(frameIndex));
    
    // 3. End Phase: Fade in end text
    let endOpacity = 0;
    if (scrollTop > animEnd) {
        endOpacity = (scrollTop - animEnd) / (phase2End - animEnd);
    }
    if (endOpacity < 0) endOpacity = 0;
    if (endOpacity > 1) endOpacity = 1;
    
    document.getElementById('hero-content-end').style.opacity = endOpacity;
    document.getElementById('hero-content-end').style.pointerEvents = endOpacity > 0.5 ? 'auto' : 'none';
    
    // Header and Scroll Indicator opacity
    let commonOpacity = Math.max(startOpacity, endOpacity);
    document.getElementById('header').style.opacity = commonOpacity;
    document.getElementById('scroll-indicator').style.opacity = commonOpacity;
});

window.addEventListener('resize', () => {
    setCanvasDimensions();
    window.dispatchEvent(new Event('scroll'));
});
"@

$finalHtml = @"
<!DOCTYPE html>
<html lang="en" class="scroll-smooth" style="overflow-x: hidden;">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LV Interior Design Studio | Scroll Animation</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,400;0,9..144,600;0,9..144,900;1,9..144,500&amp;family=Cormorant+Garamond:ital@1&amp;family=Marcellus&amp;family=Jost:wght@300;400;500;600&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#8B8E72", // Muted Sage/Green Highlight
                        accent: "#C5A059", // Soft Gold
                        "background-light": "#F9F8F6",
                        "background-dark": "#0F110E",
                    },
                    fontFamily: {
                        display: ["Fraunces", "serif"],
                        sans: ["Jost", "sans-serif"],
                        italic: ["Cormorant Garamond", "serif"],
                        accent: ["Marcellus", "serif"]
                    },
                    borderRadius: {
                        DEFAULT: "0.5rem",
                    },
                },
            },
        };
    </script>
    <style>
$codeStyleContent
$cssContent
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-800 dark:text-slate-200 font-sans transition-colors duration-300 m-0 p-0 overflow-x-hidden">
    <!-- Navigation / Header -->
    <div id="header" class="fixed top-0 left-0 w-full flex justify-between items-center px-6 md:px-10 py-6 md:py-8 z-20 pointer-events-none opacity-100 transition-opacity duration-300">
        <div class="font-display text-white text-3xl md:text-4xl drop-shadow-lg">LV</div>
        <div class="flex items-center gap-3 md:gap-4 text-white pointer-events-auto cursor-pointer group hover:text-accent transition-colors">
            <span class="font-sans tracking-widest text-xs md:text-sm uppercase">Menu</span>
            <span class="material-icons-outlined transition-transform group-hover:scale-110">menu</span>
        </div>
    </div>

    <!-- Start Content (Old way) -->
    <div id="hero-content-start" class="fixed top-0 left-0 w-full h-full flex flex-col justify-center items-center z-10 opacity-100 transition-opacity duration-300" style="padding-top: 5vh;">
        <!-- Big Logo -->
        <h1 class="font-display text-white drop-shadow-2xl mb-2" style="font-size: clamp(6rem, 15vw, 10rem); line-height: 1;">LV</h1>
        <h2 class="font-sans text-white tracking-[0.3em] md:tracking-[0.5em] text-sm md:text-xl uppercase mb-6 md:mb-10 drop-shadow-md text-center">Interior Designer</h2>
        
        <!-- Subheading -->
        <p class="font-sans text-slate-200 text-base md:text-xl text-center max-w-3xl px-6 drop-shadow-md mb-8 leading-relaxed">
            Start your design journey<br class="md:hidden"/> — every beautiful space begins with a conversation.
        </p>

        <!-- CTA -->
        <button class="bg-[#657362]/90 hover:bg-[#4f5c4d] text-white px-8 md:px-10 py-3 md:py-4 rounded-md font-sans tracking-[0.15em] text-xs md:text-sm uppercase transition-all duration-300 pointer-events-auto shadow-lg border border-white/20 backdrop-blur-sm hover:shadow-xl hover:-translate-y-1">
            Let's design your space
        </button>
    </div>

    <!-- End Content (New design) -->
    <div id="hero-content-end" class="fixed top-0 left-0 w-full h-full flex flex-col justify-center items-center z-10 pointer-events-none opacity-0 transition-opacity duration-300" style="padding-top: 5vh;">
        <!-- Big Logo -->
        <h1 class="font-display text-white mb-2" style="font-size: clamp(6rem, 15vw, 10rem); line-height: 1; text-shadow: 0px 4px 20px rgba(0,0,0,0.5);">LV</h1>
        <h2 class="font-sans text-white text-sm md:text-xl uppercase mb-6 md:mb-10 text-center" style="letter-spacing: 0.6em; text-shadow: 0px 2px 10px rgba(0,0,0,0.5); margin-left: 0.6em;">INTERIOR DESIGNER</h2>
        
        <!-- Subheading -->
        <p class="font-sans text-slate-200 text-base md:text-xl text-center max-w-3xl px-6 mb-8 leading-relaxed" style="text-shadow: 0px 2px 10px rgba(0,0,0,0.5);">
            Designing spaces that embody luxury,<br/>functionality and timeless beauty.
        </p>

        <!-- CTA -->
        <button class="bg-[#657362]/80 hover:bg-[#4f5c4d] text-white px-8 md:px-10 py-3 md:py-4 rounded font-sans text-xs md:text-sm uppercase transition-all duration-300 pointer-events-auto border border-white/30 backdrop-blur-sm hover:shadow-xl hover:-translate-y-1" style="letter-spacing: 0.15em;">
            START YOUR DESIGN JOURNEY
        </button>
    </div>

    <!-- Scroll Indicator -->
    <div id="scroll-indicator" class="fixed bottom-8 md:bottom-12 left-1/2 -translate-x-1/2 flex flex-col items-center gap-3 z-20 pointer-events-none opacity-100 transition-opacity duration-300">
        <span class="font-sans text-white/80 text-[10px] md:text-xs tracking-widest uppercase">Scroll to explore</span>
        <div class="w-[1px] h-10 md:h-16 bg-gradient-to-b from-white/60 to-transparent"></div>
    </div>
    
    <div class="canvas-container" style="position: fixed; top: 0; left: 0; width: 100%; height: 100vh; z-index: -1; background-color: #000;">
        <canvas id="scroll-canvas" style="width: 100%; height: 100%; opacity: 0;"></canvas>
    </div>
    
    <!-- Spacer for the scroll animation to play out (500vh) -->
    <div style="height: 500vh; pointer-events: none;"></div>

    <div style="position: relative; z-index: 10; background-color: #F9F8F6;" class="dark:bg-background-dark">
$sectionsContent
    </div>

    <script>
$jsImageData
$jsContent
    </script>
</body>
</html>
"@

Set-Content -Path $outFile1 -Value $finalHtml -Encoding UTF8
Set-Content -Path $outFile2 -Value $finalHtml -Encoding UTF8
Write-Host "Created merged standalone.html at both locations"
