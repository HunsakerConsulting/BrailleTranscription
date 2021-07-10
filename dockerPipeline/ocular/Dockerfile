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
    ant \
    apache-pdfbox \
    autoconf \
    automake \
    coreutils \
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
    sbt \
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
WORKDIR /home 
RUN git clone https://github.com/tberg12/ocular.git
WORKDIR /home/ocular
    RUN sh ./make_jar.sh
#    RUN sh ./make_run_script.sh

WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]