FROM opensuse/leap:15.2

LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
ENV RUNNING_IN_DOCKER true

# Fetch build dependencies
RUN zypper addrepo https://download.opensuse.org/repositories/openSUSE:Leap:15.2:Update/standard/openSUSE:Leap:15.2:Update.repo
RUN zypper refresh && zypper -n install -t pattern \
    devel_C_C++ \
    devel_basis \
    devel_java \
    devel_python3 \
    devel_qt5 \
    devel_rpm_build console
RUN zypper -n install \
    glibc-devel \
    texlive \
    autoconf \
    automake \
    libtool \
    pkg-config \
    doxygen \
    ant \
    libxslt-devel \
    libxslt-tools\
    java-11-openjdk-devel \
    wget \
    freetype-devel \
    libwmf-devel \
    liblcms2-devel \
    libxml2-devel \
    libyaml-devel \
    libpng16-devel \
    libtiff-devel \
    libtiff5 \
    libopenjp2-7 \
    libopenjpeg1 \
    libgif7 \
    zlib-devel \
    zlibrary-devel \
    libicu-devel \
    libpango-1_0-0 \
    libpangomm-2_44-1 \
    libcairo2 \
    mozilla-nss-devel \
    pandoc \
    tree \
    zsh \
    cairo-devel \
    cairo-tools \
    libcairo2 \
    openjpeg2-devel \
    tmux \
    git \
    perl \
    libQt5Core5 \
    libQt5Gui5 \
    libQt5Xml5 \
    libQt5Widgets5 \
    libQt5Test5 \
    libQt5Script5 \
    libqt5-qtpaths \
    libqt5-qttools \
    libQt5Location5 \
    apache-pdfbox \
    alsa-devel \
    libpulse-devel \
    libjack-devel \
    portaudio-devel \
    libQt5Core-devel \
    libQt5Gui-devel \
    libQt5Network-devel \
    libQt5Test-devel \
    libQt5QuickControls2-devel \
    libQt5Xml-devel \
    libqt5-qtsvg-devel \
    libQt5Sql-devel \
    libQt5Widgets-devel \
    libQt5PrintSupport-devel \
    libQt5Concurrent-devel \
    libQt5OpenGL-devel \
    libqt5-linguist-devel \
    libQt5Help5 \
    libqt5-qttools-devel \
    libqt5-qtwebengine-devel \
    libmp3lame-devel \
    libsndfile-devel \
    portmidi-devel \
    libvorbis-devel \
    libboost_system1_66_0-32bit \
    poppler-tools \
    libxml2-tools \
    cmake-full \
    R-base \
    unpaper \
    ruby \
    nodejs14 \
    npm14 \
    vim \
    cmake \
    gradle \
    maven \
    maven-assembly-plugin
RUN ldconfig -v

# Download GitHub Repos via HTTPS

WORKDIR /home
    RUN git clone https://gitlab.freedesktop.org/freetype/freetype.git
    RUN git clone https://github.com/Audiveris/omr-dataset-tools.git
    RUN git clone https://github.com/Audiveris/audiveris.git
    RUN git clone https://github.com/tesseract-ocr/tessdata.git
    RUN git clone git://github.com/musescore/MuseScore.git
WORKDIR /home/freetype
    RUN sh ./autogen.sh
    RUN ./configure && make && make install
WORKDIR /home/audiveris
    RUN git checkout development
    RUN git pull --all
    RUN ./gradlew build
# WORKDIR /home/omr-datatset-tools.git
#    RUN ./gradle clean build
# WORKDIR /home/musescore
#    RUN make && make install

RUN zypper -n install python3-pip 

# Set up Python for Image Extraction
WORKDIR /usr/src/app
    RUN pip install wheel
    RUN pip install --upgrade pip && \
        pip install \
        numpy \
        opencv-python \
        python-math \
        argparse \
        argparse-utils \
        matplotlib \
        pytesseract \
        pylouis \
        cython \
        ipython \
        jupyter \
        pandas \
        Scipy \
        scikit-image \
        scikit-optimize \
        scikit-plot \
        glob2 \
        scipy \
        scikit-learn \
        pandas \
        music21 \
        pygame \
        wheel \
        Pillow 

WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]