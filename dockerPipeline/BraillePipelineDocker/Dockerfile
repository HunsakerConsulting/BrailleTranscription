FROM opensuse/leap:15.2
#######################################################################
LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
#######################################################################
ENV RUNNING_IN_DOCKER true
#######################################################################
# Add necessary rpm repositories
RUN zypper ar -f -G  https://download.opensuse.org/repositories/openSUSE:Leap:15.2:Update/standard/openSUSE:Leap:15.2:Update.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/devel:/tools:/building/openSUSE_Leap_15.2/devel:tools:building.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/science/openSUSE_Leap_15.2/science.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/mozilla:/experimental/openSUSE_Leap_15.2/mozilla:experimental.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/science:/machinelearning/openSUSE_Leap_15.2/science:machinelearning.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/Java:/packages/openSUSE_Leap_15.2/Java:packages.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/Apache/openSUSE_Leap_15.2/Apache.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/Apache:/Modules/Apache_openSUSE_Leap_15.2/Apache:Modules.repo
RUN zypper ar -f -G  http://download.opensuse.org/repositories/utilities/openSUSE_Leap_15.2/utilities.repo
RUN zypper ar -f -G https://download.opensuse.org/repositories/devel:languages:python:backports/openSUSE_Leap_15.2/devel:languages:python:backports.repo
RUN zypper ar -f -G https://download.opensuse.org/repositories/Publishing/openSUSE_Leap_15.2/Publishing.repo

#######################################################################
# Fetch and install build tools
RUN zypper refresh && zypper -n install -t pattern \
    devel_basis \
    devel_C_C++ \
    devel_java \
    devel_python3 \
    devel_qt5 \
    devel_rpm_build console
RUN ldconfig -v
#######################################################################
# Fetch and install library dependencies
RUN zypper -n install \
    R-base \
    ant \
    apache-pdfbox \
    autoconf \
    automake \
    cairo-devel \
    cairo-devel \
    cairo-tools \
    cmake \
    cmake-full \
    coreutils \
    doxygen \
    freetype-devel \
    ghostscript \
    git \
    glibc-devel \
    gradle \
    java-11-openjdk-devel \
    libboost_system1_66_0-32bit \
    libcairo2 \
    libgif7 \
    libicu-devel \
    liblcms2-devel \
    libopencv4_5 \
    libopenjp2-7 \
    libopenjpeg1 \
    libpango-1_0-0 \
    libpangomm-2_44-1 \
    libpng16-devel \
    libprotobuf26 \
    libprotoc26 \
    libqt5-qtpaths \
    libqt5-qttools \
    libtensorflow2 \
    libtiff-devel \
    libtiff5 \
    libtool \
    libwmf-devel \
    libxml2-devel \
    libxml2-tools \
    libxslt-devel \
    libxslt-tools\
    libyaml-devel \
    libGraphicsMagick-Q16-3 \
    GraphicsMagick \
    cuneiform \
    libcuneiform1 \
    maven \
    maven-assembly-plugin \
    maven-lib \
    maven-local \
    maven-parent \
    maven-plugins-pom \
    mozilla-nss-devel \
    nodejs14 \
    npm14 \
    opencv \
    openjpeg2-devel \
    pandoc \
    pango-devel \
    perl \
    pdftk \
    pdfsandwich \
    pkg-config \
    poppler-tools \
    protobuf \
    rclone \
    rpm \
    rpm-build \
    ruby \
    rubygems \
    screen \
    texlive \
    tmux \
    tree \
    unpaper \
    vim \
    wget \
    zlib-devel \
    zlibrary-devel \
    zsh 
RUN ldconfig -v
#######################################################################
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
WORKDIR /home
    RUN git clone  --recurse-submodules https://github.com/DanBloomberg/leptonica.git
    RUN git clone --recurse-submodules https://github.com/ImageMagick/ImageMagick.git
    RUN git clone --recurse-submodules https://github.com/liblouis/liblouis.git
    RUN git clone --recurse-submodules https://github.com/liblouis/liblouisutdml.git
    RUN git clone --recurse-submodules https://github.com/rbeezer/mathbook.git
    RUN git clone --recurse-submodules  https://github.com/zorkow/speech-rule-engine.git
    RUN git clone --recurse-submodules https://github.com/OCR-D/ocrd_all.git
#######################################################################
# Install LibLouis
WORKDIR /home/liblouis
    RUN sh ./autogen.sh
    RUN ./configure --enable-ucs4 &&  make && make install 
RUN ldconfig -v
#######################################################################
# Install Python Bindings for LibLouis
WORKDIR /home/liblouis/python
    RUN python3 setup.py install
RUN ldconfig -v
#######################################################################
# Install LibLouisUTDML
WORKDIR /home/liblouisutdml
    RUN sh ./autogen.sh
    RUN ./configure && make && make install  
RUN ldconfig -v
#######################################################################
# Install java bindings for LibLouisUTDML (uses apache-ant)
WORKDIR /home/liblouisutdml/java
    RUN ant
RUN ldconfig -v
#######################################################################
# Install Image-Magick 7
WORKDIR /home/ImageMagick
    RUN ./configure && make && make install
RUN ldconfig -v
#######################################################################
# Install Leptonica
WORKDIR /home/leptonica
    RUN sh ./autogen.sh
    RUN ./configure && make && make install
RUN ldconfig -v
#######################################################################
# Install Tesseract-OCR with TensorFlow
WORKDIR /home/tesseract
    RUN autoupdate --verbose
    RUN sh ./autogen.sh
#    RUN ./configure --with-tensorflow && make && make install 
#    RUN ./configure && make && make install 
RUN ldconfig -v
#######################################################################
# Install Language Files for Tesseract-OCR
WORKDIR /usr/local/share/tessdata
    RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true -O eng.traineddata
    RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true -O fra.traineddata
    RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true -O deu.traineddata
    RUN wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata -O osd.traineddata
    RUN wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/equ.traineddata -O equ.traineddata
RUN ldconfig -vhttps://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
#######################################################################
# Set up MathJax and SRE
WORKDIR /usr/src/app
    RUN npm install --global npm@latest -y
    RUN npm install --global mathjax-full -y
    RUN npm install --global mathjax-node -y
    RUN npm install --global mathjax-node-sre -y
    RUN npm install --global speech-rule-engine -y
    RUN npm install --global @daisy/ace -y
RUN ldconfig -v
#######################################################################
# Set up Python for Image Extraction
WORKDIR /usr/src/app
    RUN zypper -n install python3-pip 
    RUN pip install --upgrade pip
    RUN pip install wheel 
    RUN pip install \
        argparse \
        argparse-utils \
        calamari-ocr \
        cython \
        glob2 \
        hocr-tools \
        ipython \
        jupyter \
        lxml \
        matplotlib \
        numpy \
        opencv-python \
        pandas \
        Pillow \
        pretextbook \
        pylouis \
        pytesseract \
        pytesstrain \
        python-math \
        scikit-image \
        scikit-learn \
        scikit-optimize \
        scikit-plot \
        Scipy \
        scipy \
        pdf2image \
        pdftabextract \
        PDFMiner \
        PyPDF2 \
        Tabula-py \
        Slate \
        PDFQuery \
        xpdf \
        camelot \
        excalibur \
        table-ocr \
        wrapt --upgrade --ignore-installed wrapt \
        tensorflow \
		torch \
        PyTorch \
		torchvision \
		torchaudio
#######################################################################
# Clean up unneeded directories and files
WORKDIR /home
    RUN rm -rf /home/liblouis
    RUN rm -rf /home/liblouisutdml
    RUN rm -rf /home/ImageMagick
#######################################################################
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]