FROM rocker/shiny-verse:4.2.3
COPY . /srv/shiny-server
RUN chown -R shiny:shiny /srv/shiny-server
WORKDIR /srv/shiny-server

# Config aliyunpan for download PhosMap datasets
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=${GITHUB_TOKEN}
ENV ALIYUNPAN_CONFIG_DIR=/srv/shiny-server/.github/workflows/
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN sudo apt-get update && sudo apt-get install -y python3-pip libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev libsodium-dev curl && apt-get clean
RUN sudo curl -fsSL http://file.tickstep.com/apt/pgp | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg > /dev/null && echo "deb [signed-by=/etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg arch=amd64,arm64] http://file.tickstep.com/apt aliyunpan main" | sudo tee /etc/apt/sources.list.d/tickstep-aliyunpan.list > /dev/null && sudo apt-get update && sudo apt-get install -y aliyunpan
RUN aliyunpan download PhosMap_datasets.zip --save && unzip PhosMap_datasets.zip && rm PhosMap_datasets.zip

# Install dependencies
RUN R -e "devtools::install_github(c('evocellnet/ksea', 'omarwagih/rmotifx', 'ecnuzdd/PhosMap'))"
RUN sudo apt-get install -y libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev libsodium-dev && apt-get clean
RUN wget https://cran.r-project.org/src/contrib/Archive/estimability/estimability_1.4.1.tar.gz && wget https://cran.r-project.org/src/contrib/Archive/emmeans/emmeans_1.8.9.tar.gz && wget https://cran.r-project.org/src/contrib/Archive/FactoMineR/FactoMineR_2.9.tar.gz
RUN Rscript /srv/shiny-server/r_packages_install.R
RUN R -e "remove.packages('Matrix')"
RUN R -e "devtools::install_version('Matrix', version='1.5-3')"

EXPOSE 3838 
