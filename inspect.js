const fs = require('fs');

function inspect(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    const bodyMatch = content.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
    if (bodyMatch) {
        const body = bodyMatch[1];
        console.log(`File: ${filePath}`);
        console.log(`BODY START: ${body.substring(0, 500).trim()}`);
        console.log("---");
        
        const divRegex = /<div[^>]*class="([^"]+)"/g;
        let match;
        const classes = new Set();
        while ((match = divRegex.exec(body)) !== null) {
            classes.add(match[1]);
        }
        
        const sectionRegex = /<section[^>]*id="([^"]*)"/g;
        const sections = new Set();
        while ((match = sectionRegex.exec(body)) !== null) {
            sections.add(match[1]);
        }
        
        console.log("Sections found:", Array.from(sections).slice(0, 30));
        console.log("Classes found:", Array.from(classes).slice(0, 30));
        console.log("=====\n");
    }
}

inspect('c:\\Users\\piyus\\OneDrive\\OO\\lv\\standalone.html');
inspect('c:\\Users\\piyus\\OneDrive\\OO\\lv\\gallery-before-after (1).html');
