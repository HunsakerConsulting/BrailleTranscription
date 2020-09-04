### USEFUL SCRIPTS

#### POWERSHELL 

Extract Multiple .ZIP files into the same directory

```powershell
# File path
$filepath = Get-ChildItem -Path 'C:\Users\<user>\<path>\' -Filter *.zip -Recurse
# convert filepath to NameSpace object
$shell = new-object -com shell.application
# ForEach Loop processes each ZIP file located within the $filepath variable
foreach($file in $filepath)
{
    $zip = $shell.NameSpace($file.FullName)
    foreach($item in $zip.items())
    {
        $shell.Namespace($file.DirectoryName).copyhere($item)
    }
    Remove-Item $file.FullName

```

####ZSH



####TEST Pytesseract

```python
import cv2
import numpy as np
import pytesseract
from PIL import Image

# Path of working folder on Disk
src_path = /home/mrhunsaker/Development/opencv-text-recognition

def get_string(img_path):
    # Read image with opencv
    img = cv2.imread(img_path)

    # Convert to gray
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Apply dilation and erosion to remove some noise
    kernel = np.ones((1, 1), np.uint8)
    img = cv2.dilate(img, kernel, iterations=1)
    img = cv2.erode(img, kernel, iterations=1)

    # Write image after removed noise
    cv2.imwrite(src_path + "removed_noise.png", img)

    #  Apply threshold to get image with only black and white
	img = cv2.adaptiveThreshold(img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 31, 2)

    # Write the image after apply opencv to do some ...
    
    cv2.imwrite(src_path + "thres.png", img)
	
    custom_config = r'-l eng --psm 6 --oem 3'
    # Recognize text with tesseract for python
    result = pytesseract.image_to_string(Image.open(img_path))#src_path+ "thres.png"), custom_config)

    # Remove template file
    #os.remove(temp)

    return result

print '--- Start recognize text from image ---'
print get_string(src_path + "test.jpg")
print "------ Done -------"
```

