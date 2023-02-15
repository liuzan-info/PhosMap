FROM rocker/rstudio:4.2.1
WORKDIR /home/rstudio/PhosMap
COPY .  /home/rstudio/PhosMap
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN sudo apt-get update && sudo apt-get install -y libxml2 libodbc1 && apt-get clean
RUN Rscript /home/rstudio/PhosMap/r_packages_install.R
