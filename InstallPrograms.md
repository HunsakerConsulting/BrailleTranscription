#### Install Liblouis, then install Liblouisutdml from source

```zsh
git clone --depth 1 git@github.com:liblouis/liblouis.git
cd liblouis
sh ./autogen.sh
./configure --prefix $HOME/.local
make 
make install
ldconfig -v 
cd

git clone --depth 1 git@github.com:liblouis/liblouisutdml.git
cd liblouisutdml
sh ./autogen.sh
./configure --prefix $HOME/.local
make 
make install 
# Install java bindings
cd java
ant
ldconfig -v 
cd
 
```

####Install Python3 from Source with Virtual Environments

```zsh
wget https://www.python.org/ftp/python/3.XXXXX/Python-3.XXXXX.tar.xz
tar -zxvf Python-3.XXXXX.tgz
cd Python-3.XXXXX
./configure --enable-shared --enable-optimizations --prefix $HOME/.local
make && make install
ldconfig -v
cd

#make life easier - shortcut for your zshrc file to default any Python3 calls to the local install
export python3=$HOME/.local/bin/python3.XXXXX
export pip3=$HOME/.local/bin/pip3.XXXXX

pip3 install virtualenv
virtualenv -p python3 ocr_env
course ocr_env/bin/activate

pip3 install pillow
pi3p install imutils
pip3 install opencv-python
pip3 install pytesseract

```

#### Install Ghostscript, Poppler,  and ImageMagick-7 from Source

```zsh
# Ghostscript from Repository compiles with autogen and gnu make
git clone git://git.ghostscript.com/ghostpdl.git
cd ghostpdl
sh autogen.sh
./configure --enable-debug --prefix $HOME/.local
make && make install
ldconfig 
cd

# Poppler compiles with CMAKE
git clone https://anongit.freedesktop.org/git/poppler/poppler.git
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/home/mrhunsaker/.local -DCMAKE_BUILD_TYPE=release -DTESTDATADIR=/home/mrhunsaker/poppler/test
make && make install
cd

# Image-Magick 7 from Repository compiles with gnu make
git clone --depth 1 https://github.com/ImageMagick/ImageMagick.git
cd ./ImageMagick
./configure --prefix $HOME/.local --with-modules --enable-shared --with-gslib=/home/mrhunsaker/.local/share/ghostscript/9.53/lib --with-gs-font-dir=/home/mrhunsaker/.local/share/ghostscript/9.53/fonts --with-perl-options=PREFIX=/home/mrhunsaker/.local
make && make install
ldconfig
cd
```

#### Install Leptonica, then install Tesseract-OCR from source

```zsh
# Clone Leptonica Git Repository
cd
git clone --depth 1 https://github.com/DanBloomberg/leptonica.git
cd /leptonica
sh ./autogen.sh
./configure --enable-debug --prefix $HOME/.local
make && make install
ldconfig 
cd

# Clone Tesseract Git Repository to penultimate update
git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git
cd tesseract
sh ./autogen.sh
./configure --enable-debug --prefix $HOME/.local
LDFLAGS="-L/$HOME/.local/lib" CFLAGS="-I/$HOME/.local/include" make && make install
ldconfig 

cd $HOME/.local/share/tessdata
wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true 
ln -s $HOME/.local/share/tessdata/eng.traineddata?raw=true $HOME/.local/share/tessdata/eng.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true 
ln -s $HOME/.local/share/tessdata/fra.traineddata?raw=true $HOME/.local/share/tessdata/fra.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true 
ln -s /home/mrhunsaker/.local/share/tessdata/deu.traineddata?raw=true /home/mrhunsaker/.local/share/tessdata/deu.traineddata

cd 
cd $HOME/.local/tesseract
make training
make training-install 
ldconfig
```

####Miscellaneous Git Repos to Clone

These are for other projects involving automated accessible textbook generation

```zsh
git clone https://github.com/rbeezer/mathbook.git
cd mathbook
git checkout -dev
git clone git@github.com:zorkow/speech-rule-engine.git
```





