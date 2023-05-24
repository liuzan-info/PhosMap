FROM rocker/shiny-verse:4.1.3
COPY . /srv/shiny-server
RUN chown -R shiny:shiny /srv/shiny-server
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN R -e "devtools::install_github(c('evocellnet/ksea', 'omarwagih/rmotifx', 'ecnuzdd/PhosMap'))"
RUN sudo apt-get update && sudo apt-get install -y libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev libsodium-dev&& apt-get clean
RUN Rscript /srv/shiny-server/r_packages_install.R

EXPOSE 3838 