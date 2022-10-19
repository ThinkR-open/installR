ARG FROM_IMAGE=rocker/geospatial:4.1.2
FROM ${FROM_IMAGE}
ARG BASHSCRIPT=install_base.sh
ARG RSCRIPT=install_base.R

COPY bk-config.sh bk-config.sh
COPY bk-install.R bk-install.R
RUN bash sc_bash.sh
RUN Rscript bk-install.R

COPY bk-rstudio.json /etc/rstudio/rstudio-prefs.json
