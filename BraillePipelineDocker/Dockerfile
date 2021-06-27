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
    cairo-devel \
    libgif7 \
    libicu-devel \
    liblcms2-devel \
    libopenjp2-7 \
    libopenjpeg1 \
    libpango-1_0-0 \
    pango-devel \
    libpangomm-2_44-1 \
    libpng16-devel \
    libprotobuf26 \
    libprotoc26 \
    libqt5-qtpaths \
    libqt5-qttools \
    libQt5Core5 \
    libQt5Gui5 \
    libQt5Location5 \
    libQt5Script5 \
    libQt5Test5 \
    libQt5Widgets5 \
    libQt5Xml5 \
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
    maven \
    maven-assembly-plugin \
    maven-plugins-pom \
    maven-parent \
    maven-lib \
    maven-local \
    mozilla-nss-devel \
    nodejs14 \
    npm14 \
    opencv \
    libopencv4_5 \
    openjpeg2-devel \
    pandoc \
    perl \
    pkg-config \
    poppler-tools \
    R-base \
    rclone \
    rpm \
    rpm-build \
    ruby \
    tensorflow2 \
    texlive \
    tmux \
    tree \
    unpaper \
    vim \
    wget \
    zlib-devel \
    zlibrary-devel \
    zsh 
# Install tensorflow-devel for integration into tesseract-ocr
RUN wget  https://download.opensuse.org/distribution/leap/15.2/repo/oss/x86_64/tensorflow-devel-1.15.2-lp152.3.6.x86_64.rpm 
RUN zypper -n install \
    tensorflow-devel-1.15.2-lp152.3.6.x86_64.rpm
RUN ldconfig -v

#######################################################################
ENV PATH="/opt/apache-maven-3.8.1/bin:${PATH}"
ENV mvn="/opt/apache-maven-3.8.1/bin/mvn"
#######################################################################
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
WORKDIR /home
    RUN git clone --recurse-submodules https://github.com/HunsakerConsulting/pipeline-assembly.git
    RUN git clone --recurse-submodules git://git.ghostscript.com/ghostpdl.git
    RUN git clone  --recurse-submodules git://github.com/musescore/MuseScore.git
    RUN git clone  --recurse-submodules https://github.com/Audiveris/audiveris.git
    RUN git clone  --recurse-submodules https://github.com/Audiveris/omr-dataset-tools.git
    RUN git clone  --recurse-submodules https://github.com/DanBloomberg/leptonica.git
    RUN git clone --recurse-submodules https://github.com/ImageMagick/ImageMagick.git
    RUN git clone --recurse-submodules https://github.com/liblouis/liblouis.git
    RUN git clone --recurse-submodules https://github.com/liblouis/liblouisutdml.git
    RUN git clone --recurse-submodules https://github.com/rbeezer/mathbook.git
    RUN git clone --recurse-submodules https://github.com/tesseract-ocr/tessdata.git
    RUN git clone --recurse-submodules https://github.com/tesseract-ocr/tesseract.git
    RUN git clone --recurse-submodules  https://github.com/zorkow/speech-rule-engine.git
    RUN git clone --recurse-submodules https://github.com/OCR-D/ocrd_all.git
#######################################################################
# Install Daisy Pipeline 2
#WORKDIR /home/pipeline-assembly
#    RUN git submodule update --init --recursive
#    RUN make
RUN ldconfig -v
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
RUN ldconfig -v
#######################################################################
# Install Training Tools for Tesseract-OCR
WORKDIR /home/tesseract
    RUN make training
    RUN make training-install
RUN ldconfig -v
#######################################################################
# Install Audiveris OMR
WORKDIR /home/audiveris
    RUN git checkout development
    RUN git pull --all
    RUN ./gradlew build
RUN ldconfig -v
#######################################################################
# Install MuseScore
#WORKDIR /home/musescore
#    ENV qmake='exec qmake-qt5 ${*}'
#RUN ./build.cmake && make && make install
#######################################################################
# Install up OCROPUS/OCROPY
WORKDIR /home
    RUN wget -nd https://github.com/zuphilip/ocropy-models/raw/master/en-default.pyrnn.gz
    RUN mkdir ./models
    RUN mv en-default.pyrnn.gz models/
    RUN python3 setup.py install
RUN ldconfig -v
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
        wrapt --upgrade --ignore-installed wrapt \
        tensorflow \
		torch \
		torchvision \
		torchaudio
#######################################################################
# Install OCR-D pipeline
WORKDIR /ocrd_all
    RUN make
    RUN make all
#######################################################################
# Clean up unneeded directories and files
WORKDIR /home
    RUN rm -rf /home/liblouis
    RUN rm -rf /home/liblouisutdml
    RUN rm -rf /home/ghostpdl
    RUN rm -rf /home/ImageMagick
    RUN rm -rf /home/leptonica
    RUN rm -rf /home/tesseract
    RUN rm -rf /home/pipeline-assembly
    RUN rm -rf /home/audiveris
    RUN rm -rf /home/freetype
    RUN rm -rf /home/MuseScore 
#######################################################################
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]