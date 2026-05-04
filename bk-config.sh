#!/bin/bash
# bk-config.sh — installation des dépendances système (R/spatial/Chrome/Node)
#
# Modifications par rapport à la version d'origine :
#   - set -euo pipefail + trap ERR : tout échec de commande coupe le build
#     proprement, plus rien ne passe en silence.
#   - curl + gnupg installés AVANT la section Chrome (l'inversion d'ordre
#     d'origine empêchait le téléchargement du .deb).
#   - libgconf-2-4 retiré : paquet supprimé depuis Ubuntu 22.04
#     (gconf déprécié, plus présent sur noble 24.04).
#   - bloc "database" : "&&" rétabli entre `apt-get update` et `apt-get install`
#     (le backslash isolé d'origine collait les deux commandes en une seule
#     et l'install MySQL n'était jamais exécuté silencieusement).
#   - curl -fLO / -fsSL : `-f` fait échouer curl sur HTTP 4xx/5xx au lieu
#     d'enregistrer la page d'erreur HTML sous le nom attendu.

set -euo pipefail
trap 'echo "ERROR: bk-config.sh a échoué à la ligne $LINENO" >&2' ERR

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
  && apt-get install -y --no-install-recommends \
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

apt-get update

# Outils requis pour télécharger Chrome (curl) et configurer le repo Node (gnupg).
# DOIT être avant la section Chrome — l'ordre inverse d'origine cassait tout.
apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates

# Libs historiquement installées pour Chrome.
# libgconf-2-4 retiré (n'existe plus depuis Ubuntu 22.04).
# Les vraies deps de Chrome sont de toute façon résolues par apt via le .deb.
apt-get -y install \
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

curl -fLO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# NodeJS
# Note: setup_14.x est EOL côté NodeSource depuis avril 2023. Le script ne
# configure plus le repo, il affiche un avis de migration et exit 0. Du coup
# `apt-get install nodejs` installe le Node packagé par Ubuntu (18.x sur noble).
# À migrer vers setup_lts.x / setup_20.x quand l'occasion se présente.
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt-get -y --allow-unauthenticated install nodejs
