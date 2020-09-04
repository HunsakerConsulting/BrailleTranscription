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
cd poppler
git clone git://git.freedesktop.org/git/poppler/test  
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/home/mrhunsaker/.local -DCMAKE_BUILD_TYPE=release -DTESTDATADIR=/home/mrhunsaker/poppler/test
make && make install
cd
# Perl 5 from Repository uses a custom Configure script
git clone git@github.com:Perl/perl5.git
cd perl5
./Configure -des -Dprefix=$HOME/.local/perl5 -Dusedevel
make
make test
make install
ldconfig
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
LDFLAGS="-L/$HOME/.local/lib" CFLAGS="-I/$HOME/.local/include" make training && make training-install

cd $HOME/.local/share/tessdata
wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true 
mv $HOME/.local/share/tessdata/eng.traineddata?raw=true $HOME/.local/share/tessdata/eng.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true 
mv $HOME/.local/share/tessdata/fra.traineddata?raw=true $HOME/.local/share/tessdata/fra.traineddata

wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true 
mv $HOME/.local/share/tessdata/deu.traineddata?raw=true $HOME/.local/share/tessdata/deu.traineddata

cd 
cd $HOME/.local/tesseract
make training
make training-install 
ldconfig
```

#### Miscellaneous Git Repos to Clone

These are for other projects involving automated accessible textbook generation

```zsh
git clone https://github.com/rbeezer/mathbook.git
cd mathbook
git checkout -dev
git clone git@github.com:zorkow/speech-rule-engine.git
```





