# Base Image
FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

# Enable Networking on port 8080 (Tomcat)
EXPOSE 8080

# Copy files containing the necessary python dependencies
COPY requirements_py2.txt requirements_py3.txt /tmp/

# Installing dependencies and deleting cache
RUN apt-get update && apt-get install -y \
    locales \
    git \
    maven \
    tomcat8 \
    openjdk-8-jdk-headless \
    python3 python3-pip python3-pil python-tk \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Installing python dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade -r /tmp/requirements_py2.txt && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade -r /tmp/requirements_py3.txt && \
    rm /tmp/requirements_py2.txt /tmp/requirements_py3.txt

# Set the locale, Solve Tomcat issues with Ubuntu
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 CATALINA_HOME=/usr/share/tomcat8

# Force tomcat to use java 8
RUN rm /usr/lib/jvm/default-java && \
    ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /usr/lib/jvm/default-java && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

ARG ARTIFACTORY_URL=http://artifactory-ls6.informatik.uni-wuerzburg.de/artifactory/libs-snapshot/de/uniwue

# Create ocr4all directories and grant tomcat permissions
RUN mkdir -p /var/ocr4all/data && \
    mkdir -p /var/ocr4all/models/default && \
    mkdir -p /var/ocr4all/models/custom && \
    chmod -R g+w /var/ocr4all && \
    chgrp -R tomcat8 /var/ocr4all

# Make pretrained CALAMARI models available to the project environment
ARG CALAMARI_MODELS_VERSION="1.0"
RUN wget https://github.com/OCR4all/ocr4all_models/archive/${CALAMARI_MODELS_VERSION}.tar.gz -O /opt/ocr4all_models.tar.gz && \
    mkdir -p /opt/ocr4all_models/ && \
    tar -xvzf /opt/ocr4all_models.tar.gz -C /opt/ocr4all_models/ --strip-components=1 && \
    rm /opt/ocr4all_models.tar.gz && \
    ln -s /opt/ocr4all_models/default /var/ocr4all/models/default/default;


# Install ocropy, make all ocropy scripts available to JAVA environment
ARG OCROPY_COMMIT="d1472da2dd28373cda4fcbdc84956d13ff75569c"
RUN cd /opt && git clone -b master https://gitlab2.informatik.uni-wuerzburg.de/chr58bk/mptv.git ocropy && \
    cd ocropy && git reset --hard ${OCROPY_COMMIT} && \
    python2.7 setup.py install && \
    for OCR_SCRIPT in `cd /usr/local/bin && ls ocropus-*`; \
        do ln -s /usr/local/bin/$OCR_SCRIPT /bin/$OCR_SCRIPT; \
    done

# Install calamari, make all calamari scripts available to JAVA environment
## calamari from source with version: v1.0.5
ARG CALAMARI_COMMIT="d293871c40c105f38e5528944fc39f04eb7649a7"
RUN cd /opt && git clone -b feature/pageXML_word_level https://github.com/maxnth/calamari.git && \
    cd calamari && git reset --hard ${CALAMARI_COMMIT} && \
    python3 setup.py install && \
    for CALAMARI_SCRIPT in `cd /usr/local/bin && ls calamari-*`; \
        do ln -s /usr/local/bin/$CALAMARI_SCRIPT /bin/$CALAMARI_SCRIPT; \
    done

# Install helper scripts to make all scripts available to JAVA environment
ARG HELPER_SCRIPTS_COMMIT="36807ad07a933aac1e7b358b9cbb42325aef22d3"
RUN cd /opt && git clone -b master https://github.com/OCR4all/OCR4all_helper-scripts.git && \
    cd OCR4all_helper-scripts && git reset --hard ${HELPER_SCRIPTS_COMMIT} && \
    python3 setup.py install

# Download maven project
ENV OCR4ALL_VERSION="0.5.0" \
    LAREX_VERSION="0.5.0"
RUN cd /var/lib/tomcat8/webapps && \
    wget $ARTIFACTORY_URL/ocr4all/$OCR4ALL_VERSION/ocr4all-$OCR4ALL_VERSION.war -O ocr4all.war && \
    wget $ARTIFACTORY_URL/Larex/$LAREX_VERSION/Larex-$LAREX_VERSION.war -O Larex.war

# Add webapps to tomcat
RUN ln -s /var/lib/tomcat8/common $CATALINA_HOME/common && \
    ln -s /var/lib/tomcat8/server $CATALINA_HOME/server && \
    ln -s /var/lib/tomcat8/shared $CATALINA_HOME/shared && \
    ln -s /etc/tomcat8 $CATALINA_HOME/conf && \
    mkdir $CATALINA_HOME/temp && \
    mkdir $CATALINA_HOME/webapps && \
    mkdir $CATALINA_HOME/logs && \
    ln -s /var/lib/tomcat8/webapps/ocr4all.war $CATALINA_HOME/webapps && \
    ln -s /var/lib/tomcat8/webapps/Larex.war $CATALINA_HOME/webapps

# Put supervisor process manager configuration to container
COPY supervisord.conf .

# Create index.html for calling url without tool url part!
COPY index.html /usr/share/tomcat8/webapps/ROOT/index.html

# Copy larex.config
COPY larex.config /larex.config
ENV LAREX_CONFIG=/larex.config

# Start processes when container is started
ENTRYPOINT [ "supervisord", "-c", "supervisord.conf"]