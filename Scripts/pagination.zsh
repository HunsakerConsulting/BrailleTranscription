#!/usr/bin/zsh
	emulate -LR zsh
rclone mount Data:braille $HOME/.mount/braille --daemon
# Optimize pdf files to remove redundant data (reduces sizes at next step with pdfseaprate)
for i in $HOME/braille/transcribe/**/source/**/*.pdf(.); do
	TYPE=`echo $i | /bin/awk -F / '{print $6}'`
	TASK=`echo $i | /bin/awk -F / '{print $8}'`
	FILENAME=`echo $i:t:r`
	FILEPATH=`echo $i:h`
	HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH -sOutputFile=$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression/"$FILENAME".pdf ${i}

	echo -e `date` '\n Optimized PDF "$FILENAME" with Ghostscript' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt

# Write multiple page pdf files to single-page pdfs (using %04d syntax)

## Using Ghostwriter
#for i in $HOME/braille/transcribe/**/pdfcompression/*.pdf(.); do     
#TYPE=`echo $i | /bin/awk -F / '{print $6}'`
#TASK=`echo $i | /bin/awk -F / '{print $8}'`
#FILENAME=`echo $i:t:r`
#FILEPATH=`echo $i:h`
#HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
#gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/"$FILENAME"_%04d.pdf ${i}
#echo -e `date` '\n Separated PDF into multiple files with Ghostscript\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
#$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
#rclone copy -Pv --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate  Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate
#done

# Using pdfseparate in Poppler
for i in $HOME/braille/transcribe/**/derivatives/**/pdfcompression/*.pdf(.); do  
	TYPE=`echo $i | /bin/awk -F / '{print $6}'`
	TASK=`echo $i | /bin/awk -F / '{print $8}'`
	FILENAME=`echo $i:t:r`
	FILEPATH=`echo $i:h`
	HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
	pdfseparate ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/"$FILENAME"_%04d.pdf
	echo -e `date` '\n Separated PDF into multiple files with Poppler\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done

# Move resulting data from this script to remote server

rclone copy $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE -Pv --ignore-existing

# Verify items no longer required locally exist on remote server and delete on local machine



For i in $HOME/.mount/braille/transcribe/**/derivatives/pdfcompression/*.pdf(.); do
	TYPE=`echo $i | /bin/awk -F / '{print $7}'`
	TASK=`echo $i | /bin/awk -F / '{print $9}'`
	FILENAME=`echo $i:t:r`
	FILEPATH=`echo $i:h`
	HOMEBASE=`echo $i | /bin/awk -F / '{print $11}'`
rm -r $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression Data:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfcompression/"$FILENAME"*.pdf
done



