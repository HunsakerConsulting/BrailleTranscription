## General Braille Pre-Processing 

#### Use sed to Remove Spaces from Filenames

This step is necessary since Unix-based shells do not appreciate spaces in file names. Spaces also completely throw a monkey wrench in any mkdir -p commands used later on.

If at all possible, a dash or deleting a space is preferred to an underscore

```zsh
for oldname in *; do
# To Delete Spaces in Filename
newname=`echo $oldname | sed -e 's/ //g'`
# To Replace Spaces in Filename with a dash
#  newname=`echo $oldname | sed -e 's/ /-/g'`
# To Replace Spaces in Filename with an underscore
#  newname=`echo $oldname | sed -e 's/ /_/g'`
mv "$oldname" "$newname"
done
```

#### Import PDF file/Create Project Folders and Files

``` zsh
for i in $HOME/braille/staging/ueb*/**/*.pdf(.); do
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
PROJECT=`echo ${${FILEPATH%/}##*/}`
mkdir -p $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/{source/$FILENAME/,derivatives/$FILENAME/{pdfsvg/{poppler,magick},pdfcompression,imagepreparation/{magick,opencv,python},ocr/{poppler/{html,txt,xml},pytesseract/txt,tesseractocr/{hocr,pdf,txt}},pdfconversion/{pdfpaginate/{ghostscript,cairo},pdftotiff/{cairo/optimized,magick,python}},textprocessing/{nimas,pretext,text,xhtml,xml},uebtranscription/{liblouisutdml,pretext}},scripts,finaltranscription/$FILENAME}
touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/NOTES.txt
touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/README.md
touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt
cp ${i} $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/source/$FILENAME/
echo -e `date` '\n Created working directories and copied in source files\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt
done

rclone copy -Pvz --create-empty-src-dirs --dry-run $HOME/braille/transcribe Data:braille/transcribe 
rclone copy -Pvz --create-empty-src-dirs $HOME/braille/transcribe Data:braille/transcribe 

```
#### Optimize PDF files with Ghostwriter

``` zsh
for i in $HOME/braille/transcribe/**/source/**/*.pdf(.); do

TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH -sOutputFile=$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression/"$FILENAME".pdf ${i}

echo -e `date` '\n Optimized PDF files with Ghostscript' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt

rclone copy -Pvz --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression

done

```

#### Use Ghostwriter or Poppler to write multiple page pdf to individual files  

This method requires less RAM and does not generate as large of tmp files as a pure ImageMagick 7 pipeline. This works because ImageMagick uses Ghostscript to work with pdf files anyways. 

This is preferred over a straight pdftocairo output to reduce strain on computer memory for pdf files with >100 pages

#####Ghostwriter Method

```zsh
for i in $HOME/braille/transcribe/**/pdfcompression/*.pdf(.); do     
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/ghostscript/"$FILENAME"_%04d.pdf ${i}
echo -e `date` '\n Separated PDF into multiple files with Ghostscript\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
rclone copy -Pv --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate  Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate
done
```

#####Poppler Method

```zsh
for i in $HOME/braille/transcribe/**/derivatives/**/pdfcompression/*.pdf(.); do  
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

pdfseparate ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/"$FILENAME"_%04d.pdf

echo -e `date` '\n Separated PDF into multiple files with Poppler\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt

rclone copy -Pvz --create-empty-dirs ---ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/ Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/
done

rm -r $HOME/braille/transcribe/**/derivatives/**/pdfcompression/*.pdf(.)
```

#### Use pdftocairo in Poppler  or Image Magick 7 to convert pdf to tiff files 

Poppler pdftocairo will make ~90MB .tif files. These files are reduced in physical size by ImageMagick 7. The \**/\* searches recursively through the subdirectories and the (.) is a glob operator that tells zsh to search for files (same function as the  -f flag in find when using find within a bash shell)

#####Poppler + ImageMagick

There is an optimization step after Poppler to reduce ~90MB TIF files into 3.5MB TIFF files using ImageMagick

```zsh
#Previous is ( cairo | ghostscript )
PREVIOUS=cairo

for i in $HOME/braille/transcribe/**/derivatives/**/pdfconversion/pdfpaginate/$PREVIOUS/*.pdf(.); do
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

pdftocairo -tiff -r 1024 -gray -antialias best $i $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/"$FILENAME"

echo -e `date` '\n Converted PDF into TIF files with Poppler\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

magick $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/*.tif -quality 100% -depth 8 -strip -bordercolor white -border 2 -background white -alpha remove -alpha off $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/optimized/"$FILENAME".tiff

echo -e `date` '\n Optimized TIF into TIFF files with ImageMagick\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#####ImageMagick

It is imperative that files be visually scanned at this point to verify that any text is legible. Otherwise this needs to be rerun with a higher density and/or a less aggressive "resize"

```zsh
#Previous is (cairo | ghostscript)
PREVIOUS=Poppler

for i in $HOME/braille/transcribe/**/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

magick $i -density 1500 -despeckle -quality 100% -depth 8 -strip -background white -bordercolor white -border 1x1 -alpha remove -alpha off -resize 50% $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/"$FILENAME".tiff

echo -e `date` '\n Converted PDF into optimized TIFF files with ImageMagick\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#### Use Tesseract-OCR and Leptonica to perform Optical Character Recognition

```zsh
for i in $HOME/braille/transcribe/**/pdfconversion/tiffprocessing/magick/*.tiff(.); do
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

tesseract --oem 1 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$FILENAME"  pdf

tesseract --oem 1 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/"$FILENAME""hocr"  hocr

tesseract --oem 1 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/"$FILENAME" 

touch $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt

tesseract --oem 1 ${i} stdout | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt

done
```

### Python + OpenCV + Tesseract

```python
import cv2 
import pytesseract 
pytesseract.pytesseract.tesseract_cmd ='/home/mrhunsaker/.local/bin/tesseract'
img = cv2.imread("/home/mrhunsaker/Development/opencv-text-recognition/Book07_0041.tiff") 
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) 
ret, thresh1 = cv2.threshold(gray, 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY_INV) 
rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (100,100)) 
dilation = cv2.dilate(thresh1, rect_kernel, iterations = 1)  
contours, hierarchy = cv2.findContours(dilation, cv2.RETR_EXTERNAL,  
                                                 cv2.CHAIN_APPROX_NONE) 
im2 = img.copy() 
file = open("recognized.txt", "w+") 
file.write("") 
file.close() 
for cnt in contours: 
    x, y, w, h = cv2.boundingRect(cnt) 
    rect = cv2.rectangle(im2, (x, y), (x + w, y + h), (0, 255, 0), 2) 
    cropped = im2[y:y + h, x:x + w] 
    file = open("recognized.txt", "a") 
    text = pytesseract.image_to_string(cropped) 
    file.write(text) 
    file.write("\n") 
    file.close 
```

