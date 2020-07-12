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

	pdftocairo -svg $i $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg/"$FILENAME"

echo -e `date` '\n Converted' "$FILENAME" 'into TIF files with Poppler\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

# This process can run out of control and consume far too much memory if left unchecked, so I rclone and then delete files as they process in this script

rclone copy  $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg -Pv --ignore-existing

if [ -e $HOME/.mount/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg/"$FILENAME"*.svg ]; then  
	rm -r $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg/"$FILENAME"*.svg
else
	echo -e `date` '\n' "$FILENAME" 'does not exist on remote server\n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt 
fi
	echo -e `date` '\n Removed large files once they were copied to remote server \n' | sudo tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

done
