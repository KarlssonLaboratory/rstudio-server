FROM rocker/rstudio:4.5.0
# rocker/rstudio already has R + RStudio Server installed and configured.

# Common system libs for typical R packages (spatial, text, Arrow, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
  libxml2-dev libssl-dev libcurl4-openssl-dev libgit2-dev libhdf5-dev \
  libfontconfig1-dev libharfbuzz-dev libfribidi-dev libglpk-dev libxt-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libgdal-dev \
  libproj-dev libudunits2-dev libcairo2-dev uuid-runtime \
  patch procps git less \
  && rm -rf /var/lib/apt/lists/*

# Use Posit Package Manager for faster binary installs
ENV CRAN_REPO="https://packagemanager.posit.co/cran/__linux__/jammy/latest"

# Install CRAN packages
RUN R -e "install.packages(c('Seurat', 'tidyverse', 'Matrix', 'patchwork', 'remotes', 'hdf5r'), repos='${CRAN_REPO}')"

# Install DoubletFinder from GitHub at the pinned commit
RUN R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder@3b420df68b8e2a0cc6ebd4c5c1c7ea170464c97f', upgrade=FALSE, dependencies=TRUE)"

# Entrypoint that works in both Docker (as root) and Apptainer (rootless)
COPY start-rserver.sh /usr/local/bin/start-rserver.sh
RUN chmod +x /usr/local/bin/start-rserver.sh

EXPOSE 8787
CMD ["/usr/local/bin/start-rserver.sh"]
