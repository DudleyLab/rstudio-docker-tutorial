FROM rocker/tidyverse:latest

RUN apt-get update && \
  apt-get -y install \
  bzip2

RUN install2.r \
  rstan \ 
  brms \
  bayesplot \ 
  tidybayes \
  DiagrammeR \
  Hmisc \
  corrplot \
  ape

RUN installGithub.r \
    https://github.com/mvuorre/brmstools \
    https://github.com/yihui/xaringan

# run R code as root
RUN Rscript -e "BiocManager::install('GEOquery')"
RUN Rscript -e "tinytex::install_tinytex()"
RUN Rscript -e "webshot::install_phantomjs()"

# set up environment as ${USER}
USER ${USER}
COPY install.R /home/${USER}/install.R
WORKDIR /home/${USER}
RUN Rscript /home/${USER}/install.R
USER root

