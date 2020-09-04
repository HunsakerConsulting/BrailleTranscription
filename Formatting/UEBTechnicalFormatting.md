## UEB Technical Braille Transcription

####Image Refinement with Python and OpenCV (NEED TO TWEAK AND TROUBLESHOOT)

```
gray = get_grayscale(image)
thresh = thresholding(gray)
opening = opening(gray)
canny = canny(gray)
images = {'gray': gray, 
          'thresh': thresh, 
          'opening': opening, 
          'canny': canny}
          
import cv2
import numpy as np

img = cv2.imread('image.jpg')

# get grayscale image
def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
# noise removal
def remove_noise(image):
    return cv2.medianBlur(image,5)
 
#thresholding
def thresholding(image):
    # threshold the image, setting all foreground pixels to
    # 255 and all background pixels to 0
    return cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

#dilation
def dilate(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.dilate(image, kernel, iterations = 1)
    
#erosion
def erode(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.erode(image, kernel, iterations = 1)

#opening - erosion followed by dilation
def opening(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

#canny edge detection
def canny(image):
    return cv2.Canny(image, 100, 200)

#skew correction
def deskew(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.bitwise_not(gray)
    thresh = cv2.threshold(gray, 0, 255,
        cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    coords = np.column_stack(np.where(thresh > 0))
    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h),
        flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)    
    return rotated

#template matching
def match_template(image, template):
    return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED)           
   
   deskew = deskew(image)
gray = get_grayscale(deskew)
thresh = thresholding(gray)
rnoise = remove_noise(gray)
dilate = dilate(gray)
erode = erode(gray)
opening = opening(gray)
canny = canny(gray)
```

#### Use Tesseract-OCR and Leptonica to perform Optical Character Recognition

```zsh
TASK=nextsteps

WORK=/home/mrhunsaker/workdir/$TASK/derivatives

for i in $WORK/*/pdfconversion/tiffprocessing/magick/*.tiff; do
HOMEBASE=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
/home/mrhunsaker/.local/bin/tesseract ${i} $WORK/$HOMEBASE/ocr/tesseractocr/pdf/"$FILENAME"  pdf
/home/mrhunsaker/.local/bin/tesseract ${i} $WORK/$HOMEBASE/ocr/tesseractocr/hocr/"$FILENAME""hocr"  hocr
/home/mrhunsaker/.local/bin/tesseract ${i} $WORK/$HOMEBASE/ocr/tesseractocr/txt/"$FILENAME" 
touch $WORK/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt
$HOME/.local/bin/tesseract ${i} stdout | sudo tee -a
done
```

#### Use the pdftotext application from Poppler to convert the PDF files processed by Tesseract-OCR into formatted text file

```zsh
for l in $WORK/PDFconverted/*.pdf; do
pdftotext ${l} $WORK/TXTtemp/$(basename "${l}" .pdf).txt
done
cat $WORK/TXTtemp/*txt >> $WORK/TXTconverted/TXTfinal/OUTPUT.txt
```

#### Move txt files into a new location for processing into an .xml file

```zsh
for n in $WORK/TXTfinal/*; do
cp ${n} $WORK/TXTTRANSCRIBE/
done
```

### Process .txt to /xml files

#### Copy and Paste the following as the first line(s) of the file

```xml-dtd
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<book>
```

#### Use the following tags to format the document as needed:

```xml-dtd
<h1> ... </h1>
<h2> ... </h2>
<h3> ... </h3> 
<list>
	<li> ... </li>
	<li> ... </li> 
</list>
<p> ... </p>
<blockquote> ... <blockquote>
```

#### End file by by closing the \<book> tag on the last line

```
</book>
```

### LiblouisUTDML transcription into UEB

```zsh
# For .xml files
for i in [file path]/*.xml; do
file2brl -f [path to preferences.cfg] ${i} [path to output]"Rough".brf
done

```



## Helpful Scripts

#### Increment Page Numbers

To add 1 to page numbers at the end of page to generate page change indicators for braille transcriptions

 "~" is a character that does not appear in the file and was put there solely to mark page numbers to greatly reduce the stress on my limited sed skills

```zsh
sed -i -r 's/(~)([0-9]*)/echo "\1$((\2+1))"/ge' [file path]
```

####Python and OpenCV for Image Tweaking

```
gray = get_grayscale(image)
thresh = thresholding(gray)
opening = opening(gray)
canny = canny(gray)
images = {'gray': gray, 
          'thresh': thresh, 
          'opening': opening, 
          'canny': canny}
          
import cv2
import numpy as np

img = cv2.imread('image.jpg')

# get grayscale image
def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
# noise removal
def remove_noise(image):
    return cv2.medianBlur(image,5)
 
#thresholding
def thresholding(image):
    # threshold the image, setting all foreground pixels to
    # 255 and all background pixels to 0
    return cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

#dilation
def dilate(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.dilate(image, kernel, iterations = 1)
    
#erosion
def erode(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.erode(image, kernel, iterations = 1)

#opening - erosion followed by dilation
def opening(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

#canny edge detection
def canny(image):
    return cv2.Canny(image, 100, 200)

#skew correction
def deskew(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.bitwise_not(gray)
    thresh = cv2.threshold(gray, 0, 255,
        cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    coords = np.column_stack(np.where(thresh > 0))
    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h),
        flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)    
    return rotated

#template matching
def match_template(image, template):
    return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED)           
   
   deskew = deskew(image)
gray = get_grayscale(deskew)
thresh = thresholding(gray)
rnoise = remove_noise(gray)
dilate = dilate(gray)
erode = erode(gray)
opening = opening(gray)
canny = canny(gray)

```

