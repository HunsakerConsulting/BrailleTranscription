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
    RUN git clone --recurse-submodules https://github.com/daisy/pipeline-assembly.git
WORKDIR /home/pipeline-assembly
    RUN git submodule update --init --recursive
    RUN make
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]
