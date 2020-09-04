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

#### Use pdftocairo in Poppler, CairoSVG (in Python), or Image Magick 7 to copnvert pdf to svg files 

The \**/\* searches recursively through the subdirectories and the (.) is a glob operator that tells zsh to search for files (same function as the  -f flag in find when using find within a bash shell)

#####Poppler

```zsh
PREVIOUS=poppler
for j in $HOME/transcribe/TactileGraphics/workdir/**/pdftotiff/$PREVIOUS/*.pdf(.); do
TYPE=`echo $i | /bin/awk -F / '{print $6}'`
TASK=`echo $i | /bin/awk -F / '{print $8}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`

pdftocairo -svg $i $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg/poppler/"$FILENAME".svg
echo -e `date` '\n Converted PDF into SVG files with Poppler\n' | tee -a $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

#####ImageMagick

Last option since it rasterizes the file prior to application of vectors

```zsh
PREVIOUS=poppler
for i in $HOME/transcribe/TactileGraphics/workdir/**/pdftotiff/$PREVIOUS/*.pdf(.); do
TYPE=`echo $i | /bin/awk -F / '{print $5}'`
TASK=`echo $i | /bin/awk -F / '{print $7}'`
FILENAME=`echo $i:t:r`
FILEPATH=`echo $i:h`
HOMEBASE=`echo $i | /bin/awk -F / '{print $9}'`

magick $i -density 1500 -despeckle -quality 100% -depth 8 -strip  -background white -alpha remove -alpha off -resize 50% $HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfsvg/magick/"$FILENAME".svg
echo -e `date` '\n Converted PDF into optimized TIFF files with ImageMagick\n' | tee -$HOME/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done
```

###