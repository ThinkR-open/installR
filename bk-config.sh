#!/bin/bash

# Spatial stuff
apt-get update \
  && apt-get install -y --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libnode-dev \
    libcairo2-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libmagick++-dev \
    libjq-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev \
    imagemagick \
    libsecret-1-dev 

apt-get install -y \
    libmagick++-dev \
    libjq-dev  \
    libv8-dev  \
    libprotobuf-dev  \
    protobuf-compiler  \
    libsodium-dev  \
    imagemagick \
    libgit2-dev \
    xclip

# database ----
apt-get update \
    apt-get install -y --no-install-recommends \
  default-mysql-client \
  default-libmysqlclient-dev  

# Divers
apt-get install -y r-cran-rjava cron nano

# Locals
apt-get install -y tzdata
apt-get install -y language-pack-fr
mv /etc/localtime /etc/localtime_backup \
  && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata


# Chromium for {pagedown} ----
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
apt-get install -y gnupg2 \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
apt-get update
apt-get -y install libxpm4 \
    libxrender1 \
    libgtk2.0-0 \
    libnss3 \
    libgconf-2-4 \
    xvfb \
    gtk2-engines-pixbuf \
    xfonts-cyrillic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-scalable \
    google-chrome-stable

# NodeJS

apt-get -y install curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_14.x   | bash - && \
    apt-get -y --allow-unauthenticated install nodejs
