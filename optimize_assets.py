import os
from PIL import Image
import subprocess
import sys

def optimize_image(file_path):
    try:
        with Image.open(file_path) as img:
            # Only process if it's an image
            if img.format in ['JPEG', 'PNG', 'WEBP']:
                # Get original size
                original_size = os.path.getsize(file_path)
                
                # Optimize the image
                if img.format == 'JPEG':
                    img = img.convert('RGB')
                    img.save(file_path, 'JPEG', quality=85, optimize=True, progressive=True)
                elif img.format == 'PNG':
                    img = img.convert('P', palette=Image.ADAPTIVE, colors=256)
                    img.save(file_path, 'PNG', optimize=True)
                
                # Get optimized size
                optimized_size = os.path.getsize(file_path)
                
                # Calculate savings
                savings = original_size - optimized_size
                savings_percent = (savings / original_size) * 100
                
                print(f"Optimized: {file_path}")
                print(f"  Original: {original_size/1024:.2f} KB")
                print(f"  Optimized: {optimized_size/1024:.2f} KB")
                print(f"  Savings: {savings/1024:.2f} KB ({savings_percent:.1f}%)")
                
    except Exception as e:
        print(f"Error processing {file_path}: {str(e)}")

def find_and_optimize_images(directory):
    # Supported image extensions
    image_extensions = ['.jpg', '.jpeg', '.png', '.webp']
    
    # Walk through the directory
    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.lower().endswith(ext) for ext in image_extensions):
                file_path = os.path.join(root, file)
                optimize_image(file_path)

if __name__ == "__main__":
    # Default directory is 'assets'
    target_dir = 'assets'
    
    # Use command line argument if provided
    if len(sys.argv) > 1:
        target_dir = sys.argv[1]
    
    if os.path.exists(target_dir):
        print(f"Optimizing images in {target_dir}...")
        find_and_optimize_images(target_dir)
    else:
        print(f"Directory {target_dir} does not exist.")
