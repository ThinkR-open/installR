#!/bin/bash
# bk-config.sh — pour rocker/geospatial:latest (Ubuntu noble 24.04)
#
# Liste des paquets calibrée sur le contenu réel de geospatial:latest :
# tout ce qui est déjà fourni par l'image (libgdal-dev, libcairo2-dev,
# libsqlite3-dev, pandoc, etc.) a été retiré pour réduire le bruit.
# Si l'image change, certains paquets peuvent revenir manquants — c'est
# alors apt qui te le dira au build.
#
# Optimisations :
# - Détection automatique d'Azure (via wget car curl n'est pas dans
#   geospatial:latest) → mirror azure.archive.ubuntu.com
# - Un seul apt-get update + un seul apt-get install consolidé

if [ -z "${BASH_VERSION:-}" ]; then
  if command -v bash >/dev/null 2>&1; then
    exec bash "$0" "$@"
  fi
  echo "ERROR: bk-config.sh doit être exécuté avec bash" >&2
  exit 1
fi

set -euo pipefail
trap 'echo "ERROR: bk-config.sh a échoué à la ligne $LINENO" >&2' ERR

export DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------------------------
# Détection Azure via IMDS. Utilise wget (présent dans rocker) car curl ne
# l'est pas. Le header `Metadata: true` + le path `/metadata/instance` sont
# spécifiques à Azure : ne matchera pas par accident sur AWS/GCP qui ont
# leurs propres endpoints au même 169.254.169.254 mais avec d'autres specs.
# Override possible via APT_MIRROR=azure / APT_MIRROR=default.
# ---------------------------------------------------------------------------
USE_AZURE_MIRROR=0

azure_imds_check() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsS -m 2 -H "Metadata:true" \
      "http://169.254.169.254/metadata/instance?api-version=2021-02-01" \
      >/dev/null 2>&1
  elif command -v wget >/dev/null 2>&1; then
    wget -q --timeout=2 --tries=1 \
      --header='Metadata: true' \
      -O /dev/null \
      "http://169.254.169.254/metadata/instance?api-version=2021-02-01" \
      2>/dev/null
  else
    return 1
  fi
}

case "${APT_MIRROR:-auto}" in
  azure)   USE_AZURE_MIRROR=1 ;;
  default) USE_AZURE_MIRROR=0 ;;
  auto)
    if azure_imds_check; then
      USE_AZURE_MIRROR=1
    fi
    ;;
esac

if [ "$USE_AZURE_MIRROR" = "1" ]; then
  echo "Azure detected — switching APT sources to azure.archive.ubuntu.com"
  # Sur noble, les sources sont en deb822 (.sources). On gère les deux
  # formats au cas où.
  for f in /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources; do
    if [ -f "$f" ]; then
      sed -i \
        -e 's|http://archive\.ubuntu\.com/ubuntu/\?|http://azure.archive.ubuntu.com/ubuntu/|g' \
        -e 's|http://security\.ubuntu\.com/ubuntu/\?|http://azure.archive.ubuntu.com/ubuntu/|g' \
        "$f"
    fi
  done
else
  echo "Non-Azure environment — keeping default APT mirrors"
fi

APT_GET="apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30"

# ---------------------------------------------------------------------------
# Liste réduite : uniquement ce qui MANQUE dans geospatial:latest.
#
# Ce qui est déjà dans l'image (et donc retiré) :
# ca-certificates, libcairo2-dev, libfftw3-dev, libfribidi-dev,
# libgdal-dev, libgeos-dev, libgit2-dev, libgl1-mesa-dev, libglu1-mesa-dev,
# libgsl-dev, libharfbuzz-dev, libhdf5-dev, libjq-dev, libnetcdf-dev,
# libnss3, libpq-dev, libproj-dev, libprotobuf-dev, libsqlite3-dev,
# libssl-dev, libudunits2-dev, libxrender1, netcdf-bin, pandoc, postgis,
# protobuf-compiler, sqlite3, tk-dev, tzdata, unixodbc-dev,
# default-libmysqlclient-dev.
# ---------------------------------------------------------------------------

$APT_GET update

$APT_GET install -y --no-install-recommends \
  cmake \
  cron \
  curl \
  default-jdk \
  default-mysql-client \
  imagemagick \
  language-pack-fr \
  libabsl-dev \
  libglpk-dev \
  libmagick++-dev \
  libnode-dev \
  libsecret-1-dev \
  libsodium-dev \
  libxpm4 \
  nano \
  nodejs \
  r-cran-rjava \
  texlive \
  tk-table \
  xclip \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-base \
  xfonts-cyrillic \
  xfonts-scalable \
  xvfb

# Timezone Europe/Paris (idempotent : -f force, -n no-deref)
ln -fsn /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# ---------------------------------------------------------------------------
# Chrome (pour {pagedown}). Le .deb déclare ses dépendances ; apt résout
# automatiquement ce qui manque (libgbm1, libxkbcommon0, etc.).
# ---------------------------------------------------------------------------
curl -fsSL --retry 3 --retry-connrefused \
  -o /tmp/google-chrome-stable_current_amd64.deb \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

$APT_GET install -y --no-install-recommends \
  /tmp/google-chrome-stable_current_amd64.deb

rm /tmp/google-chrome-stable_current_amd64.deb

# Cleanup
$APT_GET clean
rm -rf /var/lib/apt/lists/*