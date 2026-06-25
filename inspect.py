import re

def inspect(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find body content
    body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL | re.IGNORECASE)
    if body_match:
        body = body_match.group(1)
        # find main tags or classes inside body
        print(f"File: {file_path}")
        # print first 500 chars of body
        print("BODY START:", body[:500].strip())
        print("---")
        # Find sections or divs
        divs = re.findall(r'<section[^>]*>|<div[^>]*class="([^"]+)"', body)
        print("Classes found:", list(set([d for d in divs if d]))[:30])
        print("=====\n")

inspect(r"c:\Users\piyus\OneDrive\OO\lv\standalone.html")
inspect(r"c:\Users\piyus\OneDrive\OO\lv\gallery-before-after (1).html")
