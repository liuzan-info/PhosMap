FROM rocker/shiny-verse:4.1.3
COPY . /srv/shiny-server
RUN chown -R shiny:shiny /srv/shiny-server
WORKDIR /srv/shiny-server
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN R -e "devtools::install_github(c('evocellnet/ksea', 'omarwagih/rmotifx', 'ecnuzdd/PhosMap'))"
RUN sudo apt-get update && sudo apt-get install -y libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev git git-lfs libsodium-dev&& apt-get clean
RUN Rscript /srv/shiny-server/r_packages_install.R
RUN git clone https://github.com/liuzan-info/PhosMap_datasets.git
RUN unzip PhosMap_datasets/PhosMap_datasets.zip && rm PhosMap_datasets/PhosMap_datasets.zip
EXPOSE 3838 