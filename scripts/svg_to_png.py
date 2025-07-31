#!/usr/bin/env python3
import subprocess
import sys
import os

def convert_svg_to_png():
    svg_path = "/Users/rohansharma/Documents/GitHub/dlms-bcs/dlms-cloud/urjaview-web/public/urjaview-logo.svg"
    output_path = "/Users/rohansharma/Documents/GitHub/dlms-bcs/dlms-cloud/urjaview-mobile/assets/icon/app_icon_source.png"
    
    # Try using cairosvg if available
    try:
        import cairosvg
        print("Using cairosvg...")
        cairosvg.svg2png(url=svg_path, write_to=output_path, 
                        output_width=1024, output_height=1024)
        print(f"Successfully converted to {output_path}")
        return True
    except ImportError:
        print("cairosvg not installed, trying alternative methods...")
    
    # Try using svglib + reportlab
    try:
        from svglib.svglib import svg2rlg
        from reportlab.graphics import renderPDF, renderPM
        print("Using svglib...")
        drawing = svg2rlg(svg_path)
        renderPM.drawToFile(drawing, output_path, fmt="PNG")
        print(f"Successfully converted to {output_path}")
        return True
    except ImportError:
        print("svglib not installed, trying alternative methods...")
    
    # Try using Pillow with cairosvg
    try:
        from PIL import Image
        import io
        import cairosvg
        print("Using Pillow + cairosvg...")
        png_data = cairosvg.svg2png(url=svg_path, output_width=1024, output_height=1024)
        img = Image.open(io.BytesIO(png_data))
        img.save(output_path)
        print(f"Successfully converted to {output_path}")
        return True
    except ImportError:
        print("Required libraries not installed")
    
    return False

if __name__ == "__main__":
    # First, let's try to install cairosvg
    print("Installing cairosvg...")
    subprocess.run([sys.executable, "-m", "pip", "install", "cairosvg"], 
                   capture_output=True, text=True)
    
    if convert_svg_to_png():
        print("Conversion successful!")
    else:
        print("Failed to convert SVG. Please install: pip install cairosvg")
        sys.exit(1)