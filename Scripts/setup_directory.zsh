#!/usr/bin/zsh
	emulate -LR zsh

# remove spaces from filenames
for oldname in ./*; do
	newname=`echo $oldname | sed -e 's/ //g'`
	mv $oldname $newname
done

# Create project folders and files and import pdf files
for i in $HOME/braille/staging/uebtechnical/**/*.pdf(.); do
	TYPE=`echo $i | /bin/awk -F / '{print $6}'`
	FILENAME=`echo $i:t:r`
	FILEPATH=`echo $i:h`
	PROJECT=`echo ${${FILEPATH%/}##*/}`
	
	mkdir -p $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/{source/$FILENAME,derivatives/$FILENAME/{pdfsvg,pdfcompression,imagepreparation,ocr/{python/txt,tesseractocr/{hocr,pdf,txt}},pdfconversion/{pdfpaginate,pdftotiff},textprocessing/{nimas,pretext,text,xhtml,xml},uebtranscription/{liblouisutdml,pretext}},scripts,finaltranscription/$FILENAME}
	touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/NOTES.txt
	touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/README.md
	touch $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt
	cp -r $HOME/BrailleTranscription/Scripts/*.zsh $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/scripts
	
	cp ${i} $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/source/$FILENAME/
	
	echo -e `date` '\n Created working directories and copied in' "$FILENAME" '\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$PROJECT/derivatives/$FILENAME/Updates.txt

done

# RClone to remote (prefer copy to sync)

rclone copy $HOME/braille/transcribe Data:braille/transcribe -Pv --create-empty-src-dirs --dry-run
rclone copy $HOME/braille/transcribe Data:braille/transcribe -Pv --create-empty-src-dirs



