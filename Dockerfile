FROM quay.io/openshift/origin-jenkins-agent-base:v4.0
FROM openjdk:8-jdk
LABEL Pablo Lopez <pablo.lopez.sanchez@accenture.com>

ENV SCRIPTS_SFDIST_VERSION isa-butterfly-scripts-deploy

USER root
RUN apt-get update
RUN apt-get upgrade -y
RUN apt install -y zip
RUN apt install -y curl
RUN apt-get install python3.6 python3-pip -y

#Install Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

# Install tools
ENV PROGRAMS_FOLDER /programs
RUN mkdir -p ${PROGRAMS_FOLDER}

# SalesforceCLI installation
# RUN wget -q --no-proxy --no-check-certificate <we need to obtain the sfdx url and use the one that redirect to sfdx-linux-amd64.tar.xz> \
#         && mkdir sfdx \
#         && tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1 \
#         && ./sfdx/install

#Install Salesforce Bundle
RUN echo $PROGRAMS_FOLDER
ENV DEVOPS_HOME_FOLDER ${PROGRAMS_FOLDER}/devops_dist
RUN mkdir -p ${DEVOPS_HOME_FOLDER}

#updated the url - check 
RUN cd /tmp \
  && wget -q --no-proxy --no-check-certificate https://github.com/liquidstudiospain/altice_scripts/archive/refs/heads/main.zip -O ${SCRIPTS_SFDIST_VERSION}.zip  \
  && mkdir -p ${SCRIPTS_SFDIST_VERSION} && unzip -q ${SCRIPTS_SFDIST_VERSION}.zip -d ${SCRIPTS_SFDIST_VERSION} && ls -la && mv ${SCRIPTS_SFDIST_VERSION} ${DEVOPS_HOME_FOLDER} && rm ${SCRIPTS_SFDIST_VERSION}.zip  && rm -rf ${SCRIPTS_SFDIST_VERSION}