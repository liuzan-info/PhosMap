FROM rocker/shiny-verse:4.3
COPY . /srv/shiny-server
RUN chown -R shiny:shiny /srv/shiny-server
WORKDIR /srv/shiny-server

# Config python and bypy for download PhosMap datasets
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=${GITHUB_TOKEN}
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN sudo apt-get update && sudo apt-get install -y python3-pip libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev libsodium-dev git && apt-get clean && pip install bypy
RUN git clone https://$GITHUB_TOKEN@github.com/liuzan-info/bypy_json.git
RUN mkdir -p ~/.bypy && mv bypy_json/bypy.json ~/.bypy/ && bypy downfile PhosMap_datasets.zip . && unzip PhosMap_datasets.zip && rm PhosMap_datasets.zip

# !!!Delete bypy.json
RUN rm ~/.bypy/bypy.json && unset GITHUB_TOKEN

# Install dependencies
RUN R -e "devtools::install_github(c('evocellnet/ksea', 'omarwagih/rmotifx', 'ecnuzdd/PhosMap'))"
RUN sudo apt-get install -y libgtk-3-dev cmake build-essential libcurl4-gnutls-dev libxml2 libxml2-dev libodbc1 libssl-dev libv8-dev libsodium-dev&& apt-get clean
RUN Rscript /srv/shiny-server/r_packages_install.R

EXPOSE 3838 
