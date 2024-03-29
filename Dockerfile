FROM ubuntu:16.04

# Make sure that all updates are in place
RUN apt-get clean && apt-get update -y && apt-get upgrade -y \
        && apt-get dist-upgrade -y && apt-get autoremove -y

# Install needed packages
RUN apt-get install git python-dev build-essential \
       libffi-dev libssl-dev libfuzzy-dev wget sudo -y

# Adding sudo command
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Installing AIL dependencies
RUN mkdir /opt/AIL
ADD . /opt/AIL
WORKDIR /opt/AIL
RUN chmod +x  ./installing_deps.sh
WORKDIR /opt/AIL

# Installing Web dependencies,
# remove all the parts below if you dont need the Web UI
WORKDIR /opt/AIL/var/www
RUN ./update_thirdparty.sh
WORKDIR /opt/AIL

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV AIL_HOME /opt/AIL
ENV AIL_BIN ${AIL_HOME}/bin
ENV AIL_FLASK ${AIL_HOME}/var/www
ENV AIL_REDIS ${AIL_HOME}/redis/src
ENV AIL_ARDB ${AIL_HOME}/ardb/src
ENV AIL_VENV ${AIL_HOME}/AILENV

ENV PATH ${AIL_VENV}/bin:${AIL_HOME}:${AIL_REDIS}:${AIL_ARDB}:${AIL_BIN}:${AIL_FLASK}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN ./pystemon/install.sh
RUN pip install -r /opt/pystemon/requirements.txt
RUN pip install -r /opt/AIL/crawler_requirements.txt

COPY docker_start.sh /docker_start.sh
ENTRYPOINT ["/bin/bash", "docker_start.sh"]
