FROM ocrd/all:maximum-git
#######################################################################
LABEL maintainer="Hunsaker Consulting <hunsakerconsulting@gmail.com>"
#######################################################################
ENV RUNNING_IN_DOCKER true
#######################################################################
RUN apt-get install -y --fix-missing \
    screen \
    tmux \
    tree \
    vim \
    zsh 
#######################################################################
# Install Okralact for OCR Training
RUN apt-get install -y --fix-missing \
    redis \
    redis-server 
RUN ldconfig
# Download GitHub Repos via HTTPS
    RUN git config --global url."https://github.com/".insteadOf git@github.com:
    RUN git config --global url."https://".insteadOf git://
WORKDIR /home
RUN git clone --recurse-submodules https://github.com/OCR-D/okralact.git
WORKDIR /home/okralact
RUN pip install -r requirements.txt
#######################################################################
WORKDIR /home
    RUN /bin/zsh
ENTRYPOINT [ "/bin/zsh" ]