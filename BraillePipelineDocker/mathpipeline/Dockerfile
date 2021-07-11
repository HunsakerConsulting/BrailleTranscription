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
RUN zypper -n install \
    ant \
    apache-pdfbox \
    autoconf \
    automake \
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
    libqt5-qtpaths \
    libqt5-qttools \
    libQt5Xml5 \
    python3-qt5 \
    libQt5Svg5 \
    libQt5Sql5 \
    libQt5Core5 \
    libQt5Test5 \
    libQt5Test5 \
    libqwt-qt5-6 \
    libQt5WebKit5 \
    libQt5OpenGL5 \
    libQt5Script5 \
    libqt5-qtbase \
    libQt5Widgets5 \
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
    rclone \
    rpm \
    rpm-build \
    ruby \
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
RUN zypper -n install \
    https://rpmfind.net/linux/opensuse/update/leap/15.2/oss/x86_64/libjpeg62-devel-62.2.0-lp152.8.6.1.x86_64.rpm
RUN ldconfig
#######################################################################
WORKDIR /usr/src/app
    RUN zypper -n install python3-pip 
    RUN pip install --upgrade pip
    RUN pip install wheel
    RUN pip install setuptools
    RUN pip install argparse 
    RUN pip install argparse-utils 
    RUN pip install calamari-ocr 
    RUN pip install cython 
    RUN pip install glob2 
    RUN pip install hocr-tools
    RUN pip install ipython 
    RUN pip install jupyter 
    RUN pip install lxml 
    RUN pip install matplotlib 
    RUN pip install numpy 
    RUN pip install opencv-python 
    RUN pip install pandas 
    RUN pip install Pillow 
    RUN pip install pretextbook 
    RUN pip install pylouis 
    RUN pip install pytesseract 
    RUN pip install pytesstrain 
    RUN pip install python-math 
    RUN pip install scikit-image
    RUN pip install scikit-learn
    RUN pip install scikit-optimize 
    RUN pip install scikit-plot 
    RUN pip install Scipy 
    RUN pip install scipy 
    RUN pip install pdftabextract 
    RUN pip install PDFMiner 
    RUN pip install PyPDF2 
    RUN pip install pdf2image 
    RUN pip install Tabula-py 
    RUN pip install PDFQuery
    RUN pip install camelot-py
    RUN pip install pyforest
    RUN pip install excalibur-py 
    RUN pip install table-ocr 
    RUN pip install wrapt --upgrade --ignore-installed wrapt 
    RUN pip install tensorflow 
    RUN pip install torch 
    RUN pip install	torchvision 
    RUN pip install torchaudio
#######################################################################
# Make RUN commands use `bash --login`:
SHELL ["/bin/bash", "--login", "-c"]
#######################################################################
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
#######################################################################
WORKDIR /home
# Clone Leptonica Git Repository
RUN git clone https://github.com/DanBloomberg/leptonica.git
WORKDIR /home/leptonica
RUN bash ./autogen.sh
RUN ./configure && make && make install
RUN ldconfig 
#######################################################################
# Clone Tesseract Git Repository to penultimate update
WORKDIR /home
RUN git clone --recurse-submodules https://github.com/tesseract-ocr/tesseract.git
WORKDIR /home/tesseract
RUN bash ./autogen.sh
RUN ./configure && make && make install
RUN ldconfig
# Make and install training tools
RUN make training && make training-install
RUN ldconfig
#######################################################################
#install languages
WORKDIR /usr/local/sharetessdata
RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata\?raw=true -O eng.traineddata
RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/fra.traineddata\?raw=true -O fra.traineddata
RUN wget https://github.com/tesseract-ocr/tessdata_best/blob/master/deu.traineddata\?raw=true -O deu.traineddata
#######################################################################
ENV export TESSDATA_PREFIX=/usr/local/share
ENV export SCROLLVIEW_PATH=/usr/local/share/scrollview
RUN export TESSDATA_PREFIX=/usr/local/share >> /.bashrc
RUN export SCROLLVIEW_PATH=/usr/local/share/scrollview  >> /.bashrc
RUN exec bash
#######################################################################
WORKDIR /home
RUN git clone --recurse-submodules https://github.com/hunsakerconsulting/MathFinder.git
WORKDIR /home/MathFinder
RUN autoreconf -vfi
RUN ./configure && make sudo make install
#######################################################################
#Misc Uninstalled Math OCR Tools
RUN git clone --recurse-submodules https://github.com/varunkodathala/math-ocr.git
RUN git clone --recurse-submodules https://github.com/MkdmOmar/Mathematical-Symbol-Recognition.git
RUN git clone --recurse-submodules https://github.com/DPRL/ImageRecognizer.git
RUN git clone --recurse-submodules https://github.com/DPRL/MathSymbolRecognizer.git
RUN git clone --recurse-submodules https://github.com/DPRL/HMM_Math_Symbol_Classifier.git
RUN git clone --recurse-submodules https://github.com/briancherin/SimpleMathOCR.git
RUN git clone --recurse-submodules https://github.com/kasim95/OCR_Math_Expressions.git
RUN git clone --recurse-submodules https://github.com/MathLearningMachine/MLModel.git
RUN git clone --recurse-submodules https://github.com/appanp/ocr_en_formula.git
RUN git clone --recurse-submodules https://github.com/mahimna/MathCam.git
RUN git clone --recurse-submodules https://github.com/MouazSalah/Salvar-master.git
RUN git clone --recurse-submodules https://github.com/martius-lab/EQL_Tensorflow.git
RUN git clone --recurse-submodules https://github.com/martius-lab/EQL.git
RUN git clone --recurse-submodules https://github.com/UW-COSMOS/Cosmos.git
RUN git clone --recurse-submodules https://github.com/falvaro/seshat.git
RUN git clone --recurse-submodules https://github.com/falvaro/pme_parser.git
RUN git clone --recurse-submodules https://github.com/salvacarrion/yolo4math.git
RUN git clone --recurse-submodules https://github.com/zanibbi/SymbolScraper.git
RUN git clone --recurse-submodules https://github.com/zanibbi/ScanSSD.git
RUN git clone --recurse-submodules https://github.com/jungomi/math-formula-recognition.git
RUN git clone --recurse-submodules https://github.com/bilal2vec/math-recognition.git
RUN git clone --recurse-submodules https://github.com/bilal2vec/math-expression-recognition.git
RUN git clone --recurse-submodules https://github.com/lukas-blecher/LaTeX-OCR.git
#######################################################################
# Table OCR Tools (uninstalled)
RUN git clone --recurse-submodules https://github.com/cseas/ocr-table.git
RUN git clone --recurse-submodules https://github.com/ExtractTable/ExtractTable-py.git
RUN git clone --recurse-submodules https://github.com/brian-yang/table-parser-opencv.git
RUN git clone --recurse-submodules https://github.com/eihli/image-table-ocr.git
RUN git clone --recurse-submodules https://github.com/texttechnologylab/Multi-Type-TD-TSR.git
RUN git clone --recurse-submodules https://github.com/Psarpei/Multi-Type-TD-TSR.git
RUN git clone --recurse-submodules https://github.com/Psarpei/Recognition-of-logical-document-structures.git
#######################################################################
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]