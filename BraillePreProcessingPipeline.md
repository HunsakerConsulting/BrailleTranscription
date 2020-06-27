## Performing OCR on Low-Quality or Scanned PDF files

#### Use sed to Remove Spaces from Filenames

This step is necessary since Unix-based shells do not appreciate spaces in file names. 

If at all possible, a dash or deleting a space is preferred to an underscore

```zsh
for oldname in *
do
#To Delete Spaces in Filename
  newname=`echo $oldname | sed -e 's/ //g'`
#To Replace Spaces in Filename with a dash
#  newname=`echo $oldname | sed -e 's/ /-/g'`
#To Replace Spaces in Filename with an underscore
#  newname=`echo $oldname | sed -e 's/ /_/g'`
  mv "$oldname" "$newname"
done
```

#### Import PDF file/Create Project Folders and Files

```zsh
for i in /home/mrhunsaker/storage/**/*.pdf(.); do
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
PROJECT=`echo ${${FILEPATH%/}##*/}`
mkdir -p $HOME/workdir/$PROJECT/{source/$FILENAME/,derivatives/$FILENAME/{pdfcompression,imagepreparation/{magick,opencv,python},ocr/{poppler/{html,txt,xml},pytesseract/txt,tesseractocr/{hocr,pdf,txt}},pdfconversion/{pdftotiff/{ghostscript,poppler},tiffprocessing/{cairo/optimized,magick,python}},textprocessing/{nimas,pretext,text,zhtml,xml},uebtranscription/{liblouisutdml,pretext}},code,finaltranscription/$FILENAME}
touch $HOME/workdir/$PROJECT/NOTES.txt
touch $HOME/workdir/$PROJECT/README.md
touch $HOME/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt
cp ${i} /home/mrhunsaker/workdir/$PROJECT/source/$FILENAME/
echo -e `date` '\n Created working directories and copied in source files\n' | tee -a $HOME/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt
done
```
#### Optimize PDF files with Ghostwriter

``` zsh
TASK=nextsteps
for i in /home/mrhunsaker/workdir/$TASK/source/**/*.pdf(.); do
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $7}'`
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH -sOutputFile=/home/mrhunsaker/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression/"$FILENAME".pdf ${i}
echo -e `date` '\n Optimized PDF files with Ghostscript' | tee -a $HOME/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done
```

#### Use Ghostwriter or Poppler to write multiple page pdf to individual files  

This method requires less RAM and does not generate as large of tmp files as a pure ImageMagick 7 pipeline. This works because ImageMagick uses Ghostscript to work with pdf files anyways. 

This is preferred over a straight pdftocairo output to reduce strain on computer memory for pdf files with >100 pages

#####Ghostwriter Method

```zsh
TASK=nextsteps
for i in /home/mrhunsaker/workdir/$TASK/derivatives/*/pdfcompression/*.pdf(.); do     
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $7}'`
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=/home/mrhunsaker/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/ghostscript/"$FILENAME"_%04d.pdf ${i}
echo -e `date` '\n Separated PDF into multiple files with Ghostscript\n' | tee -a $HOME/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done
```

#####Poppler Method

```zsh
TASK=nextsteps
for i in /home/mrhunsaker/workdir/$TASK/derivatives/*/pdfcompression/*.pdf(.); do  
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $7}'`
pdfseparate ${i} /home/mrhunsaker/workdir/nextsteps/derivatives/$HOMEBASE/pdfconversion/pdftotiff/poppler/"$FILENAME"_%04d.pdf
echo -e `date` '\n Separated PDF into multiple files with Poppler\n' | tee -a $HOME/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done
```

#### Use pdftocairo in Poppler  or Image Magick 7 to copnvert pdf to tiff files 

Poppler pdftocairo will make ~90MB .tif files. These files are reduced in physical size by ImageMagick 7. The \**/\* searches recursively through the subdirectories and the (.) is a glob operator that tells zsh to search for files (same function as the  -f flag in find when using find within a bash shell)

#####Poppler + ImageMagick

There is an optimization step after Poppler to reduce ~90MB TIF files into 3.5MB TIFF files using ImageMagick

```zsh
PREVIOUS=poppler
TASK=nextsteps
WORK=/home/mrhunsaker/workdir/$TASK/derivatives
for i in $WORK/*/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
pdftocairo -tiff -r 1024 -gray -antialias best $i $WORK/$HOMEBASE/pdfconversion/tiffprocessing/cairo/"$FILENAME"
echo -e `date` '\n Converted PDF into TIF files with Poppler\n' | sudo tee -a $HOME/workdir/$TASK/derivatives/$FILENAME/Updates.txt
magick $WORK/$HOMEBASE/pdfconversion/tiffprocessing/cairo/*.tif -quality 100% -depth 8 strip -bordercolor white -border 2 -background white -alpha remove -alpha off -resize 25% $WORK/$HOMEBASE/imagepreparation/poppler/optimized/"$FILENAME".tiff
echo -e `date` '\n Optimized TIF into TIFF files with ImageMagick\n' | sudo tee -a $HOME/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#####ImageMagick

It is imperative that files be visually scanned at this point to verify that any text is legible. Otherwise this needs to be rerun with a higher density and/or a less aggressive "resize"

```zsh
PREVIOUS=poppler
TASK=nextsteps
WORK=/home/mrhunsaker/workdir/$TASK/derivatives
for i in $WORK/*/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
HOMEBASE=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
magick $i -density 1500 -despeckle -quality 100% -depth 8 -strip  -background white -alpha remove -alpha off -resize 50% $WORK/$HOMEBASE/pdfconversion/tiffprocessing/magick/"$FILENAME".tiff
echo -e `date` '\n Converted PDF into optimized TIFF files with ImageMagick\n' | tee -a $HOME/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

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


