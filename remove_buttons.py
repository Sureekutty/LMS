import os
import re

directory = r"C:\Users\Asus\Projects\LMS\frontend\src\pages"
pattern = re.compile(r'<button[^>]*>\s*<ArrowLeft[^>]*/>\s*Back to Dashboard\s*</button>', re.MULTILINE | re.DOTALL)

for filename in os.listdir(directory):
    if filename.endswith(".jsx"):
        filepath = os.path.join(directory, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_content = pattern.sub('', content)
        
        if content != new_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
