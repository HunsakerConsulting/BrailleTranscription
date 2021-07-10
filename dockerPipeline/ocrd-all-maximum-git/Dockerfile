FROM opensuse/leap:15.2
#######################################################################
LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
#######################################################################
ENV RUNNING_IN_DOCKER true
#######################################################################
# Add necessary rpm repositories
#######################################################################
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
#######################################################################
RUN zypper refresh && zypper -n install -t pattern \
    devel_C_C++ \
    devel_basis \
    devel_java \
    devel_python3 \
    devel_qt5 \
    devel_rpm_build \
    console
RUN ldconfig -v
#######################################################################
# Fetch and install library dependencies
#######################################################################
RUN zypper -n install \
    ant \
    ant-contrib \
    ant-scripts \
    apache-pdfbox \
    asciidoc \
    autoconf \
    autoconf213 \
    automake \
    cairo-devel \
    cairo-tools \
    cmake \
    cmake-full \
    cmark \
    coreutils \
    cuneiform \
    discount \
    docbook_5 \
    doxygen \
    doxygen \
    extra-cmake-modules \
    freetype \
    freetype-devel \
    freetype-tools \
    git \
    glibc-devel \
    glibc-devel-static \
    glibc-extra \
    glibc-utils \
    gradle \
    gradle-local \
    GraphicsMagick \
    java-11-openjdk-devel \
    javapackages-gradle \
    lcms2 \
    libboost_system1_66_0-32bit \
    libcairo-gobject2 \
    libcairo-script-interpreter2 \
    libcairo2 \
    libcuneiform1 \
    libfreetype6 \
    libgif7 \
    libGraphicsMagick-Q16-3 \
    libicu-devel \
    libinsighttoolkit4 \
    liblcms2-devel \
    liblcms2-doc \
    libopencv4_5 \
    libopenjp2-7 \
    libopenjpeg1 \
    libpango-1_0-0 \
    libpangomm-2_44-1 \
    libpng16-devel \
    libpng16-tools \
    libprotobuf20 \
    libprotoc20 \
    libqt5-qtpaths \
    libqt5-qttools \
    libtensorflow2 \
    libtiff-devel \
    libtiff5 \
    libtool \
    libwmf-0_2-7 \
    libwmf-devel \
    libwmf-tools \
    libxml2-devel \
    libxml2-tools \
    libxslt-devel \
    libxslt-python \
    libxslt-tools \
    libxslt-tools\
    libxslt1 \
    libyaml-0-2 \
    libyaml-devel \
    maven \
    maven-assembly-plugin \
    maven-lib \
    maven-local \
    maven-parent \
    maven-plugins-pom \
    maven-shared \
    mozilla-nss \
    mozilla-nss-certs \
    mozilla-nss-devel \
    mozilla-nss-sysinit \
    mozilla-nss-tools \
    mtree \
    MultiMarkdown-6 \
    musescore \
    nodejs14 \
    npm14 \
    opencv \
    openjpeg2 \
    openjpeg2-devel \
    pandoc \
    pango-devel \
    pdfsandwich \
    pdftk \
    perl \
    perl-XML-LibXML \
    pkg-config \
    poppler-tools \
#    protobuf \
    protobuf-c \
    protobuf-java \
    python3-libxml2-python \
    python3-pip \
    python3-protobuf \
#    python3-venv \
    R-base \
    rclone \
    redis \
    redis-server \
    rpm \
    rpm-build \
    ruby \
    screen \
    texlive \
    texlive-context \
    tmux \
    tree \
    unpaper \
    vim \
    vsftpd \
    wget \
    wget-lang \
    wkhtmltopdf \
    xalan-j2-xsltc \
    xclip \
    zlib-devel \
    poppler-tools \
    zlibrary-data \
    zlibrary-devel \
    ghostscript \
    mupdf \
    zsh 
RUN ldconfig -v
#######################################################################
# Install Protobuf System Wide
#######################################################################
    WORKDIR /home
        RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-all-3.17.3.tar.gz
        RUN tar xvf protobuf-all-3.17.3.tar.gz -C /bin
    RUN ldconfig -v
#######################################################################
# Set up Python for Image Optimization
#######################################################################
WORKDIR /usr/src/app
    RUN pip install --upgrade pip
    RUN pip install wheel
    RUN pip install setuptools
    RUN pip install apache-beam[gcp,aws,test,docs]
    RUN pip install argparse 
    RUN pip install argparse-utils 
    RUN pip install calamari-ocr 
    RUN pip install camelot-py
    RUN pip install celery
    RUN pip install click
    RUN pip install coremltools
    RUN pip install cython 
    RUN pip install excalibur-py 
    RUN pip install future
    RUN pip install glob2 
    RUN pip install hocr-tools
    RUN pip install ipython 
    RUN pip install jinja2
    RUN pip install jsonschema
    RUN pip install jupyter 
    RUN pip install lxml
    RUN pip install matplotlib 
    RUN pip install numpy 
    RUN pip install opencv-python 
    RUN pip install pandas 
    RUN pip install pdf2image 
    RUN pip install PDFMiner 
    RUN pip install PDFQuery
    RUN pip install pdftabextract 
    RUN pip install Pillow
    RUN pip install pretextbook 
    RUN pip install protobuf
    RUN pip install pyforest
    RUN pip install pylouis 
    RUN pip install PyPDF2 
    RUN pip install pytesseract 
    RUN pip install pytesstrain 
    RUN pip install python-bidi
    RUN pip install python-math 
    RUN pip install pyvips
    RUN pip install regex
    RUN pip install requests
    RUN pip install scikit-image
    RUN pip install scikit-learn
    RUN pip install scikit-optimize 
    RUN pip install scikit-plot 
    RUN pip install scipy 
    RUN pip install shapely
    RUN pip install table-ocr 
    RUN pip install Tabula-py 
    RUN pip install kraken
    RUN pip install https://github.com/celery/celery/zipball/master#egg=celery
    RUN pip install https://github.com/celery/billiard/zipball/master#egg=billiard
    RUN pip install https://github.com/celery/py-amqp/zipball/master#egg=amqp
    RUN pip install https://github.com/celery/kombu/zipball/master#egg=kombu
    RUN pip install https://github.com/celery/vine/zipball/master#egg=vine
    RUN pip install stevedore
    RUN pip install celery>=4.1
    RUN pip install click>=4.0
    RUN pip install lxml
    RUN pip install redis
    RUN pip install pyxDamerauLevenshtein==1.3.2
    RUN pip install regex
    RUN pip install numpy
    RUN pip install Pillow>=4.0
    RUN pip install PyYAML
    RUN pip install beautifulsoup4
    RUN pip install waitress
    RUN pip install Flask
    RUN pip install Flask-RESTful
    RUN pip install requests-toolbelt
#######################################################################
# Set GitHub to only download repos via HTTPS
#######################################################################
# Configure Git
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
#######################################################################
# Install Image Preprocessors
#######################################################################
# Image-Magick 7
    WORKDIR /home
        RUN git clone https://github.com/ImageMagick/ImageMagick.git
    WORKDIR /home/ImageMagick
        RUN ./configure --with-modules --enable-shared && make && make install
    RUN ldconfig
#######################################################################
# Leptonica
    WORKDIR /home
        RUN git clone https://github.com/DanBloomberg/leptonica.git
    WORKDIR /home/leptonica
        RUN bash ./autogen.sh
        RUN ./configure && make && make install
    RUN ldconfig 
#######################################################################
# Olena 2.1
    WORKDIR /home
        RUN wget https://www.lrde.epita.fr/dload/olena/2.1/olena-2.1.tar.bz2
        RUN tar xjf olena-2.1.tar.bz2
    WORKDIR /home/olena-2.1
        RUN ./configure && make && make install
#######################################################################
# Install OCR Engines and Models
#######################################################################
# Install Okralact
    WORKDIR /home
        RUN git clone --recurse-submodules https://github.com/Doreenruirui/okralact.git
    WORKDIR /home/okralact
        RUN pip install -r requirements.txt
#######################################################################
# Install OCROPUS/OCROPY
    WORKDIR /home
        RUN git clone --recurse-submodules https://github.com/ocropus/ocropy.git
    WORKDIR /home/ocropy
        RUN wget -nd https://github.com/zuphilip/ocropy-models/raw/master/en-default.pyrnn.gz
        RUN mv en-default.pyrnn.gz models/
        RUN  python setup.py install
#######################################################################
# Install Calimari OCR
#    WORKDIR /home
#        RUN git clone --recurse-submodules https://github.com/calamari-OCR/calamari
#    WORKDIR /home/calamari
#        RUN python setup.py install
#######################################################################
# Install Kraken OCR
#    WORKDIR /home
#        RUN git clone --recurse-submodules https://github.com/mittagessen/kraken.git
#    WORKDIR /home/kraken
#        RUN pip install .
#######################################################################
# Install Nidaba OCR
#    WORKDIR /home
#        RUN git clone --recurse-submodules https://github.com/OpenPhilology/nidaba.git
#    WORKDIR /home/nidaba
3        RUN pip install .
#######################################################################
# Install Tesseract-OCR
    RUN git clone --recurse-submodules https://github.com/tesseract-ocr/tesseract.git
# Copy files from Okralact into Tesseract /src/training directory
    RUN cp /home/okralact/install/tesseract_patch/{lstmtrainer.cpp,lstmtrainer.h,lstmtraining,lstmtraining.cpp} /home/tesseract/src/training
    WORKDIR /home/tesseract
        RUN bash ./autogen.sh
        RUN ./configure && make && make install
    RUN ldconfig
# Make and install training tools
    RUN make training && make training-install
#Install languages
    ENV TESSDATA_PREFIX=/usr/local/share
    ENV SCROLLVIEW_PATH=/usr/local/share/scrollview
    WORKDIR $TESSDATA_PREFIX/tessdata
        RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true -O eng.traineddata
        RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true -O fra.traineddata
        RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true -O deu.traineddata
        RUN wget https://github.com/tesseract-ocr/tessdata/blob/3.04.00/equ.traineddata?raw=true -O equ.traineddata
#######################################################################
# Install MathFinder Module for Equation Detection in Tesseract
        WORKDIR /home
            RUN git clone --recurse-submodules https://github.com/jrbruce86/MathFinder.git
        WORKDIR /home/MathFinder
            RUN autoreconf -vfi
            RUN ./configure && make &&make install
#######################################################################
# Install dhSegment
#https://github.com/dhlab-epfl/dhSegment.git
#######################################################################
# Install ocr-d (my forked version)
#WORKDIR /home
#    RUN git clone --recurse-submodules https://github.com/hunsakerconsulting/ocrd_all.git
#WORKDIR /home/ocrd_all
#    RUN make all 
#######################################################################
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]
#######################################################################
# EOF
#######################################################################