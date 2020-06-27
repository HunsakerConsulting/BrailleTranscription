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
./configure --prefix 
make 
make install 
# Install java bindings
cd java
ant
ldconfig -v 
cd
 
```

#### Install Ghostscript, Poppler,  and ImageMagick-7 from Source

```zsh
#Ghostscript from Repository compiles with autogen and gnu make
git clone git://git.ghostscript.com/ghostpdl.git
cd ghostpdl
sh autogen.sh
./configure --enable-debug --prefix $HOME/.local
make && make install
ldconfig 
cd

#Poppler compiles with CMAKE
git clone https://anongit.freedesktop.org/git/poppler/poppler.git
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/home/mrhunsaker/.local -DCMAKE_BUILD_TYPE=release -DTESTDATADIR=/home/mrhunsaker/poppler/test
make && make install
cd

#Image-Magick 7 from Repository compiles with gnu make
git clone --depth 1 https://github.com/ImageMagick/ImageMagick.git
cd ./ImageMagick
./configure --prefix $HOME/.local --with-modules --enable-shared --with-perl --with-gslib --with-gs-font-dir 
make && make install
ldconfig
cd
```

#### Install Leptonica, then install Tesseract-OCR from source

```zsh
#Clone Leptonica Git Repository
cd
git clone --depth 1 https://github.com/DanBloomberg/leptonica.git
cd /leptonica
sh ./autogen.sh
./configure --enable-debug --prefix $HOME/.local
make && make install
ldconfig 
cd

#Clone Tesseract Git Repository to penultimate update
git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git
cd tesseract
sh ./autogen.sh
./configure --enable-debug --prefix $HOME/.local
LDFLAGS="-L/$HOME/.local/lib" CFLAGS="-I/$HOME/.local/include" make && make install
ldconfig 

cd /home/mrhunsaker/.local/share/tessdata
wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true 
ln -s /home/mrhunsaker/.local/share/tessdata/eng.traineddata?raw=true /home/mrhunsaker/.local/share/tessdata/eng.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true 
ln -s /home/mrhunsaker/.local/share/tessdata/fra.traineddata?raw=true /home/mrhunsaker/.local/share/tessdata/fra.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true 
ln -s /home/mrhunsaker/.local/share/tessdata/deu.traineddata?raw=true /home/mrhunsaker/.local/share/tessdata/deu.traineddata

cd 
cd $HOME/.local/tesseract
make training
make training-install 
ldconfig
```

Miscellaneous Git Repos to Clone

```
git clone https://github.com/rbeezer/mathbook.git
git clone git@github.com:zorkow/speech-rule-engine.git

```

```
chown -R mrhunsaker /home/mrhunsaker/
```



PreTextBook

git clone https://github.com/rbeezer/mathbook.git

Mathjax SRE

git clone git@github.com:zorkow/speech-rule-engine.git