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
    autoconf \
    automake \
	bazel0.19 \
    coreutils \
    git \
    pkg-config \
    python3-pip \
    zsh 
#######################################################################
#######################################################################
# Set up Python for Image Optimization
WORKDIR /usr/src/app
    RUN pip install --upgrade pip
    RUN pip install wheel

############
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
WORKDIR /home
# Tensorflow Moonlight (Apoache Beam throughput)
RUN git clone --recurse-submodules https://github.com/tensorflow/moonlight
    WORKDIR /home/moonlight
        # You may want to run this inside a virtualenv.
    RUN python3 -m venv env
    RUN source ./env/bin/activate
    RUN pip install absl-py 
    RUN pip install apache_beam==2.11.0
    RUN pip install enum34
    RUN pip install librosa==0.4.0
    RUN pip install lxml
    RUN pip install joblib==0.11.0
    RUN pip install Mako
    RUN pip install numpy>=1.14.2
    RUN pip install pandas
    RUN pip install Pillow
    RUN pip install protobuf==3.6.1
    RUN pip install scipy
    RUN pip install tensorflow==1.15.4
    RUN pip install tensorflow-estimator==1.15.1
# Builds dependencies and sets up the symlinks that we point to.
RUN bazel build moonlight:omr

WORKDIR //home/moonlight
    RUN /bin/zsh
#	CMD ["source ./env/bin/activate"]
ENTRYPOINT [ "/bin/zsh" ]