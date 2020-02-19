############################################################
# Dockerfile to build sandbox for executing user code
# Based on Ubuntu
############################################################

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONWARNINGS=ignore
ENV PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"

COPY fin.traineddata /usr/share/tesseract-ocr/4.00/tessdata/fin.traineddata

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    gcc libxml2-dev libxslt1-dev zlib1g-dev libffi-dev \
    libpulse-dev swig libxml2 libxslt1-dev curl libnss3 libgconf-2-4 unzip \
    git whois bc catdoc antiword nano vim awscli sshpass \
    #Python2
    python python-pip python-lxml python-dev \
    python-bs4 python-pandas python-setuptools python-six \
    python-magic python-requests python-openssl ipython \
    python-dateutil python-appdirs python-beautifulsoup \
    python-feedparser python-scrapy python-pdfminer \
    #python3
    python3 python3-pip python3-lxml \
    python3-numpy python3-setuptools python3-dev python3-wheel \
    python3-requests python3-dateutil python3-openssl python3-xlrd \
    python3-xmltodict python3-sparqlwrapper \
    libxft-dev \
    tesseract-ocr \
    tesseract-ocr-swe \
    tesseract-ocr-nor \
    tesseract-ocr-dan \
    tesseract-ocr-nld \
    #tesseract-ocr-fin \
    libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev

# Install not packaged Python2 libraries
RUN pip install --no-cache-dir textract html pytesseract selenium pyPdf \
    git+https://github.com/timClicks/slate.git
# Install not packaged Python3 libraries
RUN pip3 install --no-cache-dir aiohttp motor pandas selenium
#Install Phantom JS:
RUN curl -SL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xvj -C /usr/local/share/ \
&& ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

RUN ln -sf /usr/bin/pdf2txt /usr/local/bin/pdf2txt.py

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
