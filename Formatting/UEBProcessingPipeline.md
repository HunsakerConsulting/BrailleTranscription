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

```zsh
for i in $HOME/storage/**/*.pdf(.); do

TYPE=`echo $i | /bin/awk -F / '{print $5}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
PROJECT=`echo ${${FILEPATH%/}##*/}`

mkdir -p $HOME/transcribe/$TYPE/workdir/$PROJECT/{source/$FILENAME/,derivatives/$FILENAME/{pdfsvg/{python,poppler,magick},pdfcompression,imagepreparation/{magick,opencv,python},ocr/{poppler/{html,txt,xml},pytesseract/txt,tesseractocr/{hocr,pdf,txt}},pdfconversion/{pdftotiff/{ghostscript,poppler},tiffprocessing/{cairo/optimized,magick,python}},textprocessing/{nimas,pretext,text,zhtml,xml},uebtranscription/{liblouisutdml,pretext}},code,finaltranscription/$FILENAME}

touch $HOME/transcribe/$TYPE/workdir/$PROJECT/NOTES.txt

touch $HOME/transcribe/$TYPE/workdir/$PROJECT/README.md

touch $HOME/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt

cp ${i} $HOME/transcribe/$TYPE/workdir/$PROJECT/source/$FILENAME/

echo -e `date` '\n Created working directories and copied in source files\n' | tee -a $HOME/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt

done

```
#### Optimize PDF files with Ghostwriter

``` zsh
for i in $HOME/transcribe/**/source/**/*.pdf(.); do

TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH -sOutputFile=$HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression/"$FILENAME".pdf ${i}

echo -e `date` '\n Optimized PDF files with Ghostscript' | tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#### Use Ghostwriter or Poppler to write multiple page pdf to individual files  

This method requires less RAM and does not generate as large of tmp files as a pure ImageMagick 7 pipeline. This works because ImageMagick uses Ghostscript to work with pdf files anyways. 

This is preferred over a straight pdftocairo output to reduce strain on computer memory for pdf files with >100 pages

#####Ghostwriter Method

```zsh
for i in $HOME/transcribe/**/pdfcompression/*.pdf(.); do     
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/ghostscript/"$FILENAME"_%04d.pdf ${i}
echo -e `date` '\n Separated PDF into multiple files with Ghostscript\n' | tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#####Poppler Method

```zsh
for i in $HOME/transcribe/**/derivatives/**/pdfcompression/*.pdf(.); do  
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`
pdfseparate ${i} $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/poppler/"$FILENAME"_%04d.pdf
echo -e `date` '\n Separated PDF into multiple files with Poppler\n' | tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#### Use pdftocairo in Poppler  or Image Magick 7 to convert pdf to tiff files 

Poppler pdftocairo will make ~90MB .tif files. These files are reduced in physical size by ImageMagick 7. The \**/\* searches recursively through the subdirectories and the (.) is a glob operator that tells zsh to search for files (same function as the  -f flag in find when using find within a bash shell)

#####Poppler + ImageMagick

There is an optimization step after Poppler to reduce ~90MB TIF files into 3.5MB TIFF files using ImageMagick

```zsh
#Previous is ( Poppler | Ghostscript )
PREVIOUS=

for i in $HOME/transcribe/**/derivatives/**/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`

pdftocairo -tiff -r 1024 -gray -antialias best $i $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/cairo/"$FILENAME"
echo -e `date` '\n Converted PDF into TIF files with Poppler\n' | sudo tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

magick $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/cairo/*.tif -quality 100% -depth 8 strip -bordercolor white -border 2 -background white -alpha remove -alpha off -resize 25% $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/imagepreparation/poppler/optimized/"$FILENAME".tiff
echo -e `date` '\n Optimized TIF into TIFF files with ImageMagick\n' | sudo tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#####ImageMagick

It is imperative that files be visually scanned at this point to verify that any text is legible. Otherwise this needs to be rerun with a higher density and/or a less aggressive "resize"

```zsh
#Previous is ( Poppler | Ghostscript )
PREVIOUS=Poppler

for i in $HOME/transcribe/**/derivatives/**/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`

magick $i -density 1500 -despeckle -quality 100% -depth 8 -strip -background white -bordercolor white -border 5x5 -alpha remove -alpha off -resize 50% $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/"$FILENAME".tiff

echo -e `date` '\n Converted PDF into optimized TIFF files with ImageMagick\n' | tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#### Use Tesseract-OCR and Leptonica to perform Optical Character Recognition

```zsh
for i in $HOME/transcribe/**/derivatives/**/pdfconversion/tiffprocessing/magick/*.tiff(.); do
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`

tesseract -c preserve_interword_spaces= 1 --oem 1 ${i} $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$FILENAME"  pdf

tesseract -c preserve_interword_spaces= 1 --oem 1 ${i} $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/"$FILENAME""hocr"  hocr

tesseract -c preserve_interword_spaces= 1  --oem 1 ${i} $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/"$FILENAME" 

touch $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt
OUTPUT=$HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt

tesseract -c preserve_interword_spaces=1 --oem 1 ${i} stdout | sudo tee -a $OUTPUT

done
```

---



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

####Set up Python Environment

```python
virtualenv -p python3 ocr_env
course ocr_env/bin/activate


```



####Image Refinement with Python and OpenCV (NEED TO TWEAK AND TROUBLESHOOT)

```python
# USAGE
# python text_recognition.py --east frozen_east_text_detection.pb --image images/example_01.jpg
# python text_recognition.py --east frozen_east_text_detection.pb --image images/example_04.jpg --padding 0.05

# import the necessary packages
from imutils.object_detection import non_max_suppression
import numpy as np
import pytesseract
import argparse
import cv2

def decode_predictions(scores, geometry):
	# grab the number of rows and columns from the scores volume, then
	# initialize our set of bounding box rectangles and corresponding
	# confidence scores
	(numRows, numCols) = scores.shape[2:4]
	rects = []
	confidences = []

	# loop over the number of rows
	for y in range(0, numRows):
		# extract the scores (probabilities), followed by the
		# geometrical data used to derive potential bounding box
		# coordinates that surround text
		scoresData = scores[0, 0, y]
		xData0 = geometry[0, 0, y]
		xData1 = geometry[0, 1, y]
		xData2 = geometry[0, 2, y]
		xData3 = geometry[0, 3, y]
		anglesData = geometry[0, 4, y]

		# loop over the number of columns
		for x in range(0, numCols):
			# if our score does not have sufficient probability,
			# ignore it
			if scoresData[x] < args["min_confidence"]:
				continue

			# compute the offset factor as our resulting feature
			# maps will be 4x smaller than the input image
			(offsetX, offsetY) = (x * 4.0, y * 4.0)

			# extract the rotation angle for the prediction and
			# then compute the sin and cosine
			angle = anglesData[x]
			cos = np.cos(angle)
			sin = np.sin(angle)

			# use the geometry volume to derive the width and height
			# of the bounding box
			h = xData0[x] + xData2[x]
			w = xData1[x] + xData3[x]

			# compute both the starting and ending (x, y)-coordinates
			# for the text prediction bounding box
			endX = int(offsetX + (cos * xData1[x]) + (sin * xData2[x]))
			endY = int(offsetY - (sin * xData1[x]) + (cos * xData2[x]))
			startX = int(endX - w)
			startY = int(endY - h)

			# add the bounding box coordinates and probability score
			# to our respective lists
			rects.append((startX, startY, endX, endY))
			confidences.append(scoresData[x])

	# return a tuple of the bounding boxes and associated confidences
	return (rects, confidences)

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", type=str,
	help="path to input image")
ap.add_argument("-east", "--east", type=str,
	help="path to input EAST text detector")
ap.add_argument("-c", "--min-confidence", type=float, default=0.5,
	help="minimum probability required to inspect a region")
ap.add_argument("-w", "--width", type=int, default=320,
	help="nearest multiple of 32 for resized width")
ap.add_argument("-e", "--height", type=int, default=320,
	help="nearest multiple of 32 for resized height")
ap.add_argument("-p", "--padding", type=float, default=0.0,
	help="amount of padding to add to each border of ROI")
args = vars(ap.parse_args())

# load the input image and grab the image dimensions
image = cv2.imread(args["image"])
orig = image.copy()
(origH, origW) = image.shape[:2]

# set the new width and height and then determine the ratio in change
# for both the width and height
(newW, newH) = (args["width"], args["height"])
rW = origW / float(newW)
rH = origH / float(newH)

# resize the image and grab the new image dimensions
image = cv2.resize(image, (newW, newH))
(H, W) = image.shape[:2]

# define the two output layer names for the EAST detector model that
# we are interested -- the first is the output probabilities and the
# second can be used to derive the bounding box coordinates of text
layerNames = [
	"feature_fusion/Conv_7/Sigmoid",
	"feature_fusion/concat_3"]

# load the pre-trained EAST text detector
print("[INFO] loading EAST text detector...")
net = cv2.dnn.readNet(args["east"])

# construct a blob from the image and then perform a forward pass of
# the model to obtain the two output layer sets
blob = cv2.dnn.blobFromImage(image, 1.0, (W, H),
	(123.68, 116.78, 103.94), swapRB=True, crop=False)
net.setInput(blob)
(scores, geometry) = net.forward(layerNames)

# decode the predictions, then  apply non-maxima suppression to
# suppress weak, overlapping bounding boxes
(rects, confidences) = decode_predictions(scores, geometry)
boxes = non_max_suppression(np.array(rects), probs=confidences)

# initialize the list of results
results = []

# loop over the bounding boxes
for (startX, startY, endX, endY) in boxes:
	# scale the bounding box coordinates based on the respective
	# ratios
	startX = int(startX * rW)
	startY = int(startY * rH)
	endX = int(endX * rW)
	endY = int(endY * rH)

	# in order to obtain a better OCR of the text we can potentially
	# apply a bit of padding surrounding the bounding box -- here we
	# are computing the deltas in both the x and y directions
	dX = int((endX - startX) * args["padding"])
	dY = int((endY - startY) * args["padding"])

	# apply padding to each side of the bounding box, respectively
	startX = max(0, startX - dX)
	startY = max(0, startY - dY)
	endX = min(origW, endX + (dX * 2))
	endY = min(origH, endY + (dY * 2))

	# extract the actual padded ROI
	roi = orig[startY:endY, startX:endX]

	# in order to apply Tesseract v4 to OCR text we must supply
	# (1) a language, (2) an OEM flag of 4, indicating that the we
	# wish to use the LSTM neural net model for OCR, and finally
	# (3) an OEM value, in this case, 7 which implies that we are
	# treating the ROI as a single line of text
	config = ("-l eng --oem 1 --psm 7")
	text = pytesseract.image_to_string(roi, config=config)

	# add the bounding box coordinates and OCR'd text to the list
	# of results
	results.append(((startX, startY, endX, endY), text))

# sort the results bounding box coordinates from top to bottom
results = sorted(results, key=lambda r:r[0][1])

# loop over the results
for ((startX, startY, endX, endY), text) in results:
	# display the text OCR'd by Tesseract
	print("OCR TEXT")
	print("========")
	print("{}\n".format(text))

	# strip out non-ASCII text so we can draw the text on the image
	# using OpenCV, then draw the text and a bounding box surrounding
	# the text region of the input image
	text = "".join([c if ord(c) < 128 else "" for c in text]).strip()
	output = orig.copy()
	cv2.rectangle(output, (startX, startY), (endX, endY),
		(0, 0, 255), 2)
	cv2.putText(output, text, (startX, startY - 20),
		cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 255), 3)

	# show the output image
	cv2.imshow("Text Detection", output)
	cv2.waitKey(0)
```

#### 