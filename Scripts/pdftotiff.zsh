#!/usr/bin/zsh
	emulate -LR zsh

# pdf to tiff file conversion
rclone mount Data:braille $HOME/.mount/braille --daemon
for i in $HOME/braille/transcribe/**/derivatives/**/pdfconversion/pdfpaginate/*.pdf(.); do
	TYPE=`echo $i | /bin/awk -F / '{print $6}'`
	TASK=`echo $i | /bin/awk -F / '{print $8}'`
	FILENAME=`echo $i:t:r`
	FILEPATH=`echo $i:h`
	HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

	pdftocairo -tiff -r 1024 -gray -antialias best $i $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/"$FILENAME"

echo -e `date` '\n Converted "$FILENAME" into TIF files with Poppler\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

	magick $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/"$FILENAME"*.tif -quality 100% -depth 8 -strip -background white -alpha remove -alpha off $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/magick/"$FILENAME".tiff

echo -e `date` '\n Optimized "$FILENAME".tif into TIFF with ImageMagick\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
	
# This process can run out of control and consume far too much memory if left unchecked, so I rclone and then delete files as they process in this script

rclone copy  $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/ Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/ -Pv --ignore-existing

if [ -e $HOME/.mount/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/magicck/"$FILENAME"*.tiff ]; then  
	rm -r $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/*.tif
	rm -r $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/magick/*.tiff
else
	echo -e `date` '\n "$FILENAME".tif does not exist on remote server\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt 
fi

	echo -e `date` '\n Removed large files once they were copied to remote server \n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

done

