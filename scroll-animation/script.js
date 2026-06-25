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
const currentFrame = index => (
    `frames/ezgif-frame-${index.toString().padStart(3, '0')}.jpg`
);

const images = [];

// Preload all images
for (let i = 1; i <= frameCount; i++) {
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
    const maxScrollTop = document.documentElement.scrollHeight - window.innerHeight;
    const scrollFraction = scrollTop / maxScrollTop;
    const frameIndex = Math.min(
        frameCount - 1,
        Math.ceil(scrollFraction * (frameCount - 1))
    );
    
    requestAnimationFrame(() => drawFrame(frameIndex));
});

window.addEventListener('resize', () => {
    setCanvasDimensions();
    
    const scrollTop = document.documentElement.scrollTop;
    const maxScrollTop = document.documentElement.scrollHeight - window.innerHeight;
    const scrollFraction = maxScrollTop > 0 ? scrollTop / maxScrollTop : 0;
    const frameIndex = Math.min(
        frameCount - 1,
        Math.ceil(scrollFraction * (frameCount - 1))
    );
    
    drawFrame(frameIndex);
});
