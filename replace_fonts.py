import os
import sys

filename = r"c:\Users\piyus\OneDrive\OO\lv\standalone.html"
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

replacements = [
    (
        '<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,400;0,9..144,600;0,9..144,900;1,9..144,500&amp;family=Cormorant+Garamond:ital@1&amp;family=Marcellus&amp;family=Jost:wght@300;400;500;600&amp;display=swap" rel="stylesheet"/>',
        '<!-- Custom fonts applied: Thalassia, Romena, Baustil, Magreb -->'
    ),
    (
        '''                    fontFamily: {
                        display: ["Fraunces", "serif"],
                        sans: ["Jost", "sans-serif"],
                        italic: ["Cormorant Garamond", "serif"],
                        accent: ["Marcellus", "serif"]
                    },''',
        '''                    fontFamily: {
                        display: ["Thalassia", "serif"],
                        sans: ["Magreb", "sans-serif"],
                        italic: ["Romena", "serif"],
                        accent: ["Baustil", "sans-serif"]
                    },'''
    ),
    (
        '''  .eyebrow{
    font-family:'Jost',sans-serif;''',
        '''  .eyebrow{
    font-family:'Baustil',sans-serif;'''
    ),
    (
        '''  .gallery-h{
    font-family:'Fraunces', serif;''',
        '''  .gallery-h{
    font-family:'Thalassia', serif;'''
    ),
    (
        '''  .gallery-h em{
    font-family:'Cormorant Garamond', serif;''',
        '''  .gallery-h em{
    font-family:'Romena', serif;'''
    ),
    (
        '''  .gallery-desc{
    font-family:'Jost',sans-serif;''',
        '''  .gallery-desc{
    font-family:'Magreb',sans-serif;'''
    ),
    (
        '''  .tab{
    font-family:'Marcellus', serif;''',
        '''  .tab{
    font-family:'Baustil', sans-serif;'''
    ),
    (
        '''  .idle-hint{
    position:absolute; top:50%; left:50%;
    transform: translate(-50%,-50%);
    background: rgba(23,17,9,0.78);
    color: var(--cream-text);
    font-family:'Marcellus', serif;''',
        '''  .idle-hint{
    position:absolute; top:50%; left:50%;
    transform: translate(-50%,-50%);
    background: rgba(23,17,9,0.78);
    color: var(--cream-text);
    font-family:'Baustil', sans-serif;'''
    ),
    (
        '''  .detail-title{
    font-family:'Fraunces', serif;''',
        '''  .detail-title{
    font-family:'Thalassia', serif;'''
    ),
    (
        '''  .detail-meta{
    display:flex; justify-content:center; gap: 1.1rem;
    flex-wrap:wrap;
    font-family:'Jost',sans-serif;''',
        '''  .detail-meta{
    display:flex; justify-content:center; gap: 1.1rem;
    flex-wrap:wrap;
    font-family:'Magreb',sans-serif;'''
    ),
    (
        '''  .detail-desc{
    font-family:'Jost', sans-serif;''',
        '''  .detail-desc{
    font-family:'Magreb', sans-serif;'''
    ),
    (
        '''  .ba-eyebrow{
    font-family:'Jost',sans-serif;''',
        '''  .ba-eyebrow{
    font-family:'Baustil',sans-serif;'''
    ),
    (
        '''  .ba-h{
    font-family:'Fraunces', serif;''',
        '''  .ba-h{
    font-family:'Thalassia', serif;'''
    ),
    (
        '''  .ba-h em{
    font-family:'Cormorant Garamond', serif;''',
        '''  .ba-h em{
    font-family:'Romena', serif;'''
    ),
    (
        '''  .ba-desc{
    max-width:48ch;
    font-family:'Jost',sans-serif; font-weight:300;''',
        '''  .ba-desc{
    max-width:48ch;
    font-family:'Magreb',sans-serif; font-weight:300;'''
    ),
    (
        '''  .ba-pair-btn{
    font-family:'Marcellus', serif;''',
        '''  .ba-pair-btn{
    font-family:'Baustil', sans-serif;'''
    ),
    (
        '''  .ba-mode-btn{
    font-family:'Jost',sans-serif;''',
        '''  .ba-mode-btn{
    font-family:'Baustil',sans-serif;'''
    ),
    (
        '''  .ba-tag{
    position:absolute; top:1.1rem;
    font-family:'Jost',sans-serif;''',
        '''  .ba-tag{
    position:absolute; top:1.1rem;
    font-family:'Baustil',sans-serif;'''
    ),
    (
        '''  .ba-toggle-btn{
    margin: 1.6rem auto 0; display:flex;
    font-family:'Marcellus', serif;''',
        '''  .ba-toggle-btn{
    margin: 1.6rem auto 0; display:flex;
    font-family:'Baustil', sans-serif;'''
    ),
    (
        '''  .ba-caption{
    text-align:center; margin-top:1.4rem;
    font-family:'Jost',sans-serif;''',
        '''  .ba-caption{
    text-align:center; margin-top:1.4rem;
    font-family:'Magreb',sans-serif;'''
    )
]

for target, repl in replacements:
    content = content.replace(target, repl)

with open(filename, "w", encoding="utf-8") as f:
    f.write(content)

print("Replaced successfully")
