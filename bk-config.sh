#!/bin/bash
# bk-config.sh — installation des dépendances système (R/spatial/Chrome/Node)

if [ -z "${BASH_VERSION:-}" ]; then
  if command -v bash >/dev/null 2>&1; then
    exec bash "$0" "$@"
  fi
  echo "ERROR: bk-config.sh doit être exécuté avec bash" >&2
  exit 1
fi

set -euo pipefail
trap 'echo "ERROR: bk-config.sh a échoué à la ligne $LINENO" >&2' ERR

# Make apt a bit more resilient in CI/container networking
APT_GET="apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30"

# Spatial stuff
$APT_GET update \
  && $APT_GET install -y --no-install-recommends \
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

$APT_GET install -y \
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
$APT_GET update \
  && $APT_GET install -y --no-install-recommends \
    default-mysql-client \
    default-libmysqlclient-dev

# Divers
$APT_GET install -y r-cran-rjava cron nano

# Locals
$APT_GET install -y tzdata
$APT_GET install -y language-pack-fr
mv /etc/localtime /etc/localtime_backup \
  && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata


# Chromium for {pagedown} ----

$APT_GET update

# Outils requis pour télécharger Chrome.
# DOIT être avant la section Chrome — l'ordre inverse d'origine cassait tout.
$APT_GET install -y --no-install-recommends \
    curl \
    ca-certificates

# Libs historiquement installées pour Chrome.
# libgconf-2-4 retiré (n'existe plus depuis Ubuntu 22.04).
# Les vraies deps de Chrome sont de toute façon résolues par apt via le .deb.
$APT_GET -y install \
    libxpm4 \
    libxrender1 \
    libgtk2.0-0 \
    libnss3 \
    xvfb \
    gtk2-engines-pixbuf \
    xfonts-cyrillic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-scalable

curl -fSLO --retry 3 --retry-connrefused https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$APT_GET install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# NodeJS
# Installer directement le paquet NodeJS fourni par l'OS pour éviter
# l'exécution d'un script distant NodeSource EOL pendant le build.
$APT_GET -y install nodejs
