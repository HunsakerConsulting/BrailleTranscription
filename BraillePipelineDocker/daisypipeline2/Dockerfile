FROM daisyorg/pipeline-assembly
#######################################################################
LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
#######################################################################
ENV RUNNING_IN_DOCKER true
#######################################################################
RUN apt-get update && apt-get install -y \
    curl \
    software-properties-common \
    build-essential \
    libssl-dev \
    coreutils \
    tmux \
    screen \
    zsh
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - 
RUN apt-get install -y nodejs 
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
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]