FROM opensuse/leap:15.2
#######################################################################
LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
#######################################################################
ENV RUNNING_IN_DOCKER true
#######################################################################
# Make RUN commands use `bash --login`:
SHELL ["/bin/bash", "--login", "-c"]


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
#######################################################################
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
WORKDIR /home
    RUN git clone  --recurse-submodules https://github.com/DanBloomberg/leptonica.git
    RUN git clone --recurse-submodules https://github.com/ImageMagick/ImageMagick.git
#######################################################################
# Install Olena 2.1
WORKDIR /home
    RUN wget https://www.lrde.epita.fr/dload/olena/2.1/olena-2.1.tar.bz2
RUN tar xjf olena-2.1.tar.bz2
    WORKDIR /home/olena-2.1
RUN ./configure && make && make install
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
# Set up Python for Image Optimization
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
RUN rm -rf /home/Leptonica
RUN rm -rf /home/ImageMagick
RUN rm -rf /home/Olena
RUN zypper clean
#######################################################################
WORKDIR /home
ENTRYPOINT [ "/bin/zsh" ]