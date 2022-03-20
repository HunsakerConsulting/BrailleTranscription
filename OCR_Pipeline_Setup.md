# Set up in OpenSUSE 15.3 On Windows 11 running WSL2
## Set up Local Install Structure
### Step 1: Done as **user** 

Verify that **user** has read/write permissions for their **\$HOME** 

```bash
cd $HOME
ls -la
```

IFF **user** lacks read/write access, ask **root** to give permissions

```bash
chown -R <user> /home/<user>
```

### Step 2: Done as **user**

Set up basic directories in *\$HOME/.local* 

```bash
mkdir -p $HOME/.local/{scripts,bin,opt,share/man,include,lib/pkgconfig,lib64/pkgconfig,src}
```

Set up working directories in *\$HOME* 

```bash
mkdir -p $HOME/{braille,scripts}/{staging/{graphics,music,uebtechnical,uebliterary},transcribe}
```

## Set up ldconfig to be friendly for later local installs

```bash
sudo vi /etc/ld.so.conf
# add the following lines to the TOP of the file
/home/ryhunsaker/.local/lib
/home/ryhunsaker/.local/lib64
```

## Set up Sudoers list so I have to call su but never type my password

```bash
sudo visudo
# On the last line type the following, replacing <username>
<username> ALL=(ALL) NOPASSWD: ALL
```

## System-wide installations

```bash
sudo zypper dist-upgrade
sudo zypper refresh
sudo zypper install -t pattern devel_basis
sudo zypper install ant asciidoc autoconf automake cairo-devel cmake cmark coreutils discount dnf doxygen emacs freetype-devel gcc-c++ gcc-fortran git glibc-devel gradle graphviz lcms2 libdnf-devel libfreetype6 libgif7 libicu-devel liblcms2-devel libopenjp2-7 libpoppler-devel libpango-1_0-0 libpng16-devel libqt5-qtpaths libqt5-qttools libtiff-devel libtool libwmf-devel  libxml2-devel libxslt-devel libyaml-devel maven mozilla-nss-devel mtree nodejs14 npm14 opencv-devel openjpeg2-devel pandoc pango-devel perl pkg-config rclone rpm rpm-build ruby sbt screen tensorflow2-devel tmux tree vim wget wget-lang yum zlib-devel  zlibrary-devel zsh
```

## Set up zsh and set it as default user shell

I do this because I rely on the glob operator '(.)' in zsh *a lot* as well as
its built-in functions. This is done by **user**

```zsh
chsh -s $(which zsh)
```

### Set up .zshrc

This is done as user **(do not use 'sudo')** or else it will be saved under *root*

#### Open **~/.zshrc** for editing

```zsh
vi ~/.zshrc
```

#### Copy and paste the following to **~/.zshrc**

Sections commented out need to be uncommented as soon as the program is installed locally, then run 'source ~/.zshrc'

```zsh
cd $HOME
export PATH=$HOME/.local/bin:$PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib:$LIBRARY_PATH
export LIBRARY_PATH=$HOME/.local/lib64:$LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib64/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/.local/lib64:$LD_LIBRARY_PATH
export MANPATH=$HOME/.local/share/man:$MANPATH
###############################################################################
# Uncomment relevant sections once the programs are installed in $HOME/.local
###############################################################################
export PATH=$HOME/.local/python/Python3.9:$PATH
#export GS_FONTPATH=$HOME/.local/share/ghostscript/fonts
#export JAVA_HOME=$HOME/.local/opt/jdk17/bin
#alias python=$HOME/.local/bin/python3
#alias python3=$HOME/.local/bin/python3
#alias pip3=$HOME/.local/bin/pip3
#alias pip=$HOME/.local/bin/pip3
#alias java=$HOME/.local/opt/jdk17/bin/java
#alias javac=$HOME/.local/opt/jdk17/bin/javac
#export TESSDATA_PREFIX=/home/ryhunsaker/.local/share/
###############################################################################
# Alias for scripts to select specific java distributions as needed 
# many programs still require Java JDK 8 or 11
###############################################################################
# alias u8='source $HOME/.local/scripts/u8.sh'
# alias u11='source $HOME/.local/scripts/u11.sh'
# alias u17='source $HOME/.local/scriptsu17.sh'
###############################################################################
#export WORKON_HOME=$HOME/.local/bin/.virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/bin/python3
#export VIRTUALENVWRAPPER_VIRTUALENV=$HOME/.local/bin/virtualenv
#source $HOME/.local/bin/virtualenvwrapper.sh
###################################
# Configurations for zsh
###################################
setopt AUTO_CD
setopt NO_CASE_GLOB
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
autoload -Uz compinit && compinit
# case insensitive path-completion
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# Left Prompt (what folder am I currently in)
PROMPT='%n@%B%F{red}%d%f%b %# '
# Right Prompt (Status of Github Projects)
autoload -Uz vcs_info
precmd_vcs_info() {vcs_info}
precmd_functions+=(precmd_vcs_info)
setopt prompt_subst
RPROMPT= zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f%F{red}%r%f'
zstyle ':vcs_info:*' enable git
```

## Configure git

Done as **user** or else you cannot read any RSA keys

### Iff not using WSL2 and you want to manage Git from within linux

```zsh
git config --global user.name "mrhunsaker"
git config --global user.email "hunsakerconsulting@gmail.com"
ssh-keygen -t rsa -b 4096 -C "hunsakerconsulting@gmail.com"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa
xclip -sel clip < $HOME/.ssh/id_rsa.pub
# Paste this into GitHub under Settings > SSH and GPG Keys
```

### Iff Using WSL2

#### Set Git to use Windows Credential Manager

```zsh
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
```

# Local Install Program Set-UP
## Install Python 3.X.X locally

*Change Python-3.X.X to current Python3 you choose actually download*

```zsh
cd $HOME
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar -xvf Python-3.9.7.tgz
cd Python-3.9.7
sh ./configure --prefix $HOME/.local --enable-optimizations
make
make install
cd $HOME
sudo ldconfig
rm -rf ./Python-3.9.7.tgz
rm -rf ./Python-3.9.7
```
## Install java open jdk 17

When done, uncomment appropriate path and alias definitions in ~/.zshrc

```zsh
curl -O https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
tar -xvf jdk-17_linux-x64_bin.tar.gz
mv jdk-17.0.2 $HOME/.local/opt/jdk17.0.2
export JAVA_HOME=$HOME/.local/opt/jdk17.0.2/bin
sudo ldconfig
```



## Install Liblouis, then install Liblouisutdml from source

### Liblouis

```zsh
cd $HOME
git clone https://github.com/liblouis/liblouis.git
cd liblouis
sh ./autogen.sh  
./configure --prefix $HOME/.local
make
make install
cd python
python3 setup.py install
sudo ldconfig
cd $HOME
```

### Liblouisutdml

```zsh
cd $HOME
git clone https://github.com/liblouis/liblouisutdml.git
cd liblouisutdml
sh ./autogen.sh
./configure --prefix $HOME/.local
make
make install
cd java
ant
sudo ldconfig
cd $HOME
```

## Install Ghostscript

```zsh
cd $HOME
git clone git://git.ghostscript.com/ghostpdl.git
cd ghostpdl
sh ./autogen.sh
./configure --prefix $HOME/.local --with-modules --enable-shared
make
make install
mkdir -p $HOME/.local/shared/ghostscript/fonts
cp -rf $HOME/ghostpdl/Resource/Font/* $HOME/.local/shared/ghostscript/fonts
export GS_FONTPATH=$HOME/.local/shared/ghostscript/fonts
cd $HOME
sudo ldconfig
```

## Install Image-Magick 7

Uncomment lines in .zshrc to reveal the location of Ghostscript fonts before running the following installation

```zsh
cd $HOME
git clone https://github.com/ImageMagick/ImageMagick.git
cd ./ImageMagick
./configure --prefix $HOME/.local --with-modules --enable-shared --with-gslib --enable-hdri
make
make install
sudo ldconfig
cd $HOME
```
## Install Tesseract-OCR and Leptonica
### Install Leptonica

```zsh
cd $HOME
git clone https://github.com/DanBloomberg/leptonica.git
cd ./leptonica
sh ./autogen.sh
./configure --prefix $HOME/.local
make
make install
sudo ldconfig
cd $HOME
```

### Install Tesseract OCR
#### Build Tesseract

```zsh
cd $HOME
git clone https://github.com/tesseract-ocr/tesseract.git
cd tesseract
sh ./autogen.sh
LIBLEPT_HEADERSDIR=$HOME/.local/include ./configure --prefix $HOME/.local  --with-extra-libraries=$HOME/.local/lib
LDFLAGS="-L/$HOME/.local/lib" CFLAGS="-I/$HOME/.local/include" make
make install
sudo ldconfig
```

#### Make and install training tools

```zsh
LDFLAGS="-L/$HOME/.local/lib" CFLAGS="-I/$HOME/.local/include" make training
make training-install
sudo ldconfig
cd $HOME
```

#### Install language files
##### Actual wget / basic language install

```zsh
cd $HOME/.local/share/tessdata
wget https://github.com/tesseract-ocr/tessdata/blob/main/eng.traineddata\?raw=true -O eng.traineddata
wget https://github.com/tesseract-ocr/tessdata/blob/main/fra.traineddata\?raw=true -O fra.traineddata
wget https://github.com/tesseract-ocr/tessdata/blob/main/deu.traineddata\?raw=true -O deu.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata -O osd.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/equ.traineddata -O equ.traineddata
cd $HOME
sudo ldconfig
```

### Install Audiveris

```zsh
cd $HOME
git clone https://github.com/Audiveris/audiveris.git
cd $HOME/audiveris
git checkout development
git pull --all
./gradlew run
cd $HOME
```

### Install Olena

```zsh
cd $HOME
wget https://www.lrde.epita.fr/dload/olena/2.1/olena-2.1.tar.bz2
tar xjf olena-2.1.tar.bz2
cd $HOME/olena-2.1
./configure --prefix $HOME/.local
make
make install
sudo ldconfig

rm -rf $HOME/olena*
cd $HOME
```

# Python OCR Setiup for PyTesseract, TesserOCR, EasyOCR, and Calamari
## Create Virtual Environment for OCR
### Install virtual environment tools

```zsh
pip install wheel setuptools
pip install virtualenv virtualenvwrapper
```

### Modify **~/.zshrc**

Uncomment lines in **~/.zshrc** to alias **virtualenv**, **virtualenvwrapper**, and define **workon**

### Configure virtual environment

- **ocr_pipelines** = name of virtual environment

- **python3** = python distribution to use

```zsh
mkvirtualenv ocr_pipelines -p python3
```
### Install and configure Tools within environment

```zsh
workon ocr_pipelines
pip install numpy opencv-contrib-python pytesseract pillow scipy scikit-learn scikit-image imutils matplotlib requests beautifulsoup4 h5py tensorflow textblob scons
```

---
---

# UEB Pre-Processing 
## Move files into Pipeline

All files **$FILENAME.pdf** should be copied to appropriate folder **$PROJECT** within $HOME/braille/staging/ as below:

This can be verified with the 'tree' command from within the $HOME folder

```zsh
**$HOME**
└── braille
	├── staging
	    ├── graphics
	    ├── music
	    ├── uebliterary
	    │   └── **$PROJECT**
	    │       └── **$FILENAME.pdf**
	    └── uebtechnical
```

## Use sed to Remove Spaces from Filenames

This step is necessary since Unix-based shells do not appreciate spaces in file names. Spaces also completely throw a monkey wrench in any 'mkdir -p' commands used later on.

*Hint:** CamelCase will save your butt here if filenames get long

```zsh
for i in $HOME/braille/staging/ueb*/**/*.png(.); do
    j=`echo $i | sed -e 's/ //g'`
    cp "$i" "$j"
    tar -czvf archive.tar.gz $i
    rm $i
done
```

## Import PDF file/Create Project Folders and Files

``` zsh
for i in $HOME/braille/staging/ueb*/**/*.png(.); do
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

rclone copy -Pvz --create-empty-src-dirs --dry-run $HOME/braille/transcribe remote:braille/transcribe 
    rclone copy -Pvz --create-empty-src-dirs $HOME/braille/transcribe remote:braille/transcribe
```

### Resulting file structure:

This can be verified with the 'tree' command

```zsh
$HOME
└── braille
	├── staging					
	│   ├── graphics
	│   ├── music
	│   ├── uebtechnical
	│   └──  uebliterary
	│        └── $PROJECT
	│           └── $FILENAME.pdf
	└── transcribe				
		└── graphics
		└── music
		└── uebtechnical
		└── uebliterary
			└── workdir
				└── $PROJECT
					├── derivatives
					│   └── $FILENAME
					│       ├── imagepreparation
					│       │   ├── magick
					│       │   ├── opencv
					│       │   └── python
					│       ├── ocr
					│       │   ├── poppler
					│       │   │   ├── html
					│       │   │   ├── txt
					│       │   │   └── xml
					│       │   ├── pytesseract
					│       │   │   └── txt
					│       │   └── tesseractocr
					│       │       ├── hocr
					│       │       ├── pdf
					│       │       └── txt
					│       ├── pdfconversion
					│       │   ├── pdfpaginate
					│       │   │   ├── cairo
					│       │   │   └── ghostscript
					│       │   └── pdftotiff
					│       │       ├── cairo
					│       │       │   └── optimized
					│       │       ├── magick
					│       │       └── python
					│       ├── pdfsvg
					│       │   ├── magick
					│       │   └── poppler
					│       ├── textprocessing
					│       │   ├── nimas
					│       │   ├── pretext
					│       │   ├── text
					│       │   ├── xhtml
					│       │   └── xml
					│       ├── uebtranscription
					│       │   ├── liblouisutdml
					│       │   └── pretext
					│       └── Updates.txt
					├── finaltranscription
 					│   └── $FILENAME
					├── NOTES.txt
					├── README.md
					├── scripts
					└── source
						└──$PROJECT
						  └── $FILENAME.pdf
```

## Use Ghostwriter or Poppler to write multiple page pdf to individual pdf files for each page  

These methods require less RAM and does not generate as large of tmp files as a pure ImageMagick pipeline. This works because ImageMagick uses Ghostscript to work with pdf files anyways. This is preferred over a straight pdftocairo output to reduce strain on computer memory for pdf files with >100 pages

### Ghostwriter

```zsh
for i in $HOME/braille/transcribe/**/source/**/*.pdf(.); do
    TYPE=`echo $i | /bin/awk -F / '{print $6}'`
    TASK=`echo $i | /bin/awk -F / '{print $8}'`
    FILENAME=`echo $i:t:r`
    FILEPATH=`echo $i:h`
    HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
    gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/ghostscript/"$FILENAME"_%04d.pdf ${i}
    echo -e `date` '\n Separated PDF into multiple files with Ghostscript\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done

rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate  remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate
    rclone copy -Pv --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate  remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate
```

### Poppler

```zsh
for i in $HOME/braille/transcribe/**/source/**/*.pdf(.); do
    TYPE=`echo $i | /bin/awk -F / '{print $6}'`
    TASK=`echo $i | /bin/awk -F / '{print $8}'`
    FILENAME=`echo $i:t:r`
    FILEPATH=`echo $i:h`
    HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
    pdfseparate ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/"$FILENAME"_%04d.pdf
    echo -e `date` '\n Separated PDF into multiple files with Poppler\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$FILENAME/Updates.txt
done

rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/
    rclone copy -Pvz --create-empty-dirs --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdfpaginate/cairo/

rm -r $HOME/braille/transcribe/**/derivatives/**/pdfcompression/*.pdf(.)
```

## Use pdftocairo in Poppler or Image Magick 7 to convert pdf to tiff files 

Poppler pdftocairo will make ~90MB .tif files. These files are reduced in physical size by ImageMagick 7. The \**/\* searches recursively through the subdirectories and the (.) is a glob operator that tells zsh to search for files (same function as the  -f flag in find when using find within a bash shell)

There is an optimization step after Poppler to reduce ~90MB TIF files into 3.5MB TIFF files using ImageMagick

### Poppler + ImageMagick

```zsh
#Previous is ( cairo | ghostscript )
PREVIOUS=ghostscript
for i in $HOME/braille/transcribe/**/derivatives/**/pdfconversion/pdfpaginate/$PREVIOUS/*.pdf(.); do
    TYPE=`echo $i | /bin/awk -F / '{print $6}'`
    TASK=`echo $i | /bin/awk -F / '{print $8}'`
    FILENAME=`echo $i:t:r`
    FILEPATH=`echo $i:h`
    HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
    pdftocairo -tiff -r 1024 -gray -antialias best $i $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/"$FILENAME"

    echo -e `date` '\n Converted PDF into TIF files with Poppler\n' | tee $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

    magick $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/*.tif -quality 100% -depth 8 -strip -bordercolor white -border 2 -background white -alpha remove -alpha off $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/optimized/"$FILENAME".tiff

    echo -e `date` '\n Optimized TIF into TIFF files with ImageMagick\n' | tee $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt

done

rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/ 

rclone copy -Pvz --create-empty-dirs ---ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/
```

### ImageMagick only

It is imperative that files be visually scanned at this point to verify that any text is legible. Otherwise this needs to be rerun with a higher sampling density

```zsh
#Previous is (cairo | ghostscript)
PREVIOUS=ghostscript
for i in $HOME/braille/transcribe/**/pdfconversion/pdftotiff/$PREVIOUS/*.pdf; do
    TYPE=`echo $i | /bin/awk -F / '{print $6}'`
    TASK=`echo $i | /bin/awk -F / '{print $8}'`
    FILENAME=`echo $i:t:r`
    FILEPATH=`echo $i:h`
    HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
    magick $i -density 1500 -despeckle -quality 100% -depth 8 -strip -background white -bordercolor white -border 1x1 -alpha remove -alpha off -resize 50% $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/"$FILENAME".tiff
    echo -e `date` '\n Converted PDF into optimized TIFF files with ImageMagick\n' | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/Updates.txt
done

rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/ 
    rclone copy -Pvz --create-empty-dirs --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/tiffprocessing/magick/
```

## Use Tesseract-OCR to perform Optical Character Recognition

```zsh
for i in $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/pdfconversion/pdftotiff/cairo/optimized/*.tiff(.); do
    TYPE=`echo $i | /bin/awk -F / '{print $6}'`
    TASK=`echo $i | /bin/awk -F / '{print $8}'`
    FILENAME=`echo $i:t:r`
    FILEPATH=`echo $i:h`
    HOMEBASE=`echo $i | /bin/awk -F / '{print $10}'`
    tesseract --oem 3 --psm 6 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$FILENAME" pdf
    tesseract --oem 3 --psm 6 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/"$FILENAME""hocr" hocr
    tesseract --oem 3 --psm 6 ${i} $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/"$FILENAME"
    touch$HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt
    tesseract --oem 3 --psm 6 ${i} stdout | tee -a $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/"$HOMEBASE"_textout.txt
done

rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/
    rclone copy -Pvz --create-empty-dirs --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/pdf/
rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/
    rclone copy -Pvz --create-empty-dirs --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/hocr/
rclone copy -Pvz --create-empty-dirs --ignore-existing --dry-run $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/
    rclone copy -Pvz --create-empty-dirs --ignore-existing $HOME/braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/ remote:braille/transcribe/$TYPE/workdir/$TASK/derivatives/$HOMEBASE/ocr/tesseractocr/txt/
```

---
---
