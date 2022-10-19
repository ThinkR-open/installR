ARG FROM_IMAGE=rocker/geospatial:4.1.2
FROM ${FROM_IMAGE}
ARG BASHSCRIPT=install_base.sh
ARG RSCRIPT=install_base.R

COPY . .
ADD ./scripts/bash/$BASHSCRIPT sc_bash.sh
ADD ./scripts/r/$RSCRIPT sc_install.R
RUN chown 777 sc_install.R sc_bash.sh
RUN bash sc_bash.sh
RUN Rscript sc_install.R

COPY bk-rstudio.json /etc/rstudio/rstudio-prefs.json
