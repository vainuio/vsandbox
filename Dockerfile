############################################################
# Dockerfile to build sandbox for executing user code
# Based on Ubuntu
############################################################

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

# Install C combiler and dev packages
RUN apt-get install -y gcc libxml2-dev libxslt1-dev zlib1g-dev libffi-dev \
    libpulse-dev swig libxml2 libxslt1-dev curl libnss3 libgconf-2-4 unzip

# Install python libraries
RUN apt-get install -y python python-pip python-lxml python-dev \
    python-bs4 python-pandas python-setuptools python-six \
    python-magic python-requests python-openssl ipython \
    python-dateutil python-appdirs python-beautifulsoup \
    python-feedparser python-scrapy python-pdfminer

# Install nodejs and libs
RUN apt-get install -y nodejs npm
RUN npm install -g webpage underscore request express jade shelljs passport http sys jquery lodash async mocha moment connect validator restify ejs ws co when helmet wrench brain mustache should backbone forever  debug && export NODE_PATH=/usr/local/lib/node_modules/

# Install other utilities
RUN apt-get install -y git whois sudo bc catdoc antiword

# Install not packaged Python libraries
RUN pip install --no-cache-dir selenium textract html requests pyPdf \
    git+https://github.com/timClicks/slate.git

#Install Phantom JS:
RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev wget
RUN apt-get install -y libfreetype6 libfreetype6-dev
RUN apt-get install -y libfontconfig1 libfontconfig1-dev
RUN export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64 /usr/local/share
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin


# Python 3
RUN apt-get install -y python3-pip python3-lxml
RUN pip3 install --no-cache-dir selenium requests
RUN ln -sf /usr/bin/pdf2txt /usr/local/bin/pdf2txt.py
ENV PYTHONWARNINGS ignore

# Install Chrome Driver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable
