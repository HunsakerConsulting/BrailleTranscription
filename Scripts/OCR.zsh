#!/usr/bin/zsh
	emulate -LR zsh
# This is assuming the pdf->tiff was a clean transfer. If not, magic, python, or openCV are needed to fix the tiff image That code is commented out below

# Tesseract OCR and Leptonica for Optical Character Recognition
for i in $HOME/braille/transcribe/**/pdfconversion/pdftotiff/cairo/magick/*.tiff(.); do
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

	echo -e `date` '\n Performed OCR on "$FILENAME" with Leptonica and Tesseract OCR 5 (alpha) \n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

done

#Move results to remote server

rclone copy  $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr -Pv --ignore-existing

# Code for insufficient tiff
## TO DO

