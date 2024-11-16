<div align="center">
   <img src="https://github.com/user-attachments/assets/c1e7c5be-6b62-46e5-ba43-aa326d57678e" width="150" alt="disney-stitch-logo">
</div>

<h3 align="center">
  PowerShell Image <ins>Stitcher</ins> GUI
</h3>


___
1. [Installing](#Installing)
2. [Usage](#Usage)
3. [History](#History)
4. [Possible features](#possible-features)


## Installing

1. Download [stich-images-gui.ps1](https://github.com/dimitryzub/powershell-image-stitcher/blob/main/stich-images-gui.ps1) PowerShell script.
2. Place it where you like.
3. Create a shortcut:
<img src="https://github.com/user-attachments/assets/acf79d76-dce3-4c8d-a5cf-72c0ed8b11af" alt="My GIF" width="700">

Paste this command to hide terminal when running the script and change the path to `stich-images-gui.ps1`:
```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "<ABSOLUTE_PATH_TO_SHELL_SCRIPT>\stich-images-gui.ps1"
```

## Usage

![image-stitcher-usage](https://github.com/user-attachments/assets/6e3dac08-61f8-4856-8fcb-c3152da561ee)

## History

I like [ImageMagick](https://www.imagemagick.org/) stitching because of its simplicity and ease of use.

This tool adds a GUI layer to ImageMagick functionality to easily drag and drop multiple images and stitch them without manually typing paths to each image.

Yes, there are a few free tools but they require several clicks to stitch images.

### Possible features
1. Mosaic AKA [montage](https://sinestesia.co/blog/tutorials/quick-n-easy-mosaics-with-imagemagick/) command via user-defined checkbox.
