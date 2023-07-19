
<div align="center">
  <img src="www/logo.svg" width="200"/>
  <div>&nbsp;</div>
  <b>A docker image-based tool to accomplish one-stop interactive analysis of quantitative phosphoproteomics.</b>
  <div>&nbsp;</div>
  
[![Docker Image CI](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml)
<img src="https://img.shields.io/github/license/liuzan-info/PhosMap">

[![R](https://img.shields.io/badge/-R%20package-276DC3?style=flat-square&logo=R&logoColor=white)](https://github.com/ecnuzdd/PhosMap) | 
[![Web](https://img.shields.io/badge/-Web%20server-FF7139?style=flat-square&logo=Google-Chrome&logoColor=white)](https://bio-inf.shinyapps.io/phosmap/) | 
[![Docker](https://img.shields.io/badge/-Docker%20image-2496ED?style=flat-square&logo=Docker&logoColor=white)](https://hub.docker.com/r/liuzandh/phosmap/tags)

[📘Doc for R package](https://github.com/liuzan-info/PhosMap/blob/main/www/package_manual.pdf)
[📙Doc for Web server and Docker image](https://github.com/liuzan-info/PhosMap/blob/main/www/manual.pdf)

<a href="https://www.youtube.com/watch?v=KGccNSmjhsk" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/218346691-ceb2116a-465a-40af-8424-9f30d2348ca9.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />
<a href="https://www.bilibili.com/video/BV1zh411F7vJ/" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/219026751-d7d14cce-a7c9-4e82-9942-8375fca65b99.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />

</div>
   
## Table of Contents
- [Brief Description](#brief-description)
- [How to install](#how-to-install)
  - [Docker-based installation](#installdocker)
  - [R-based installation](#installr)
- [How to use](#how-to-use)
- [Detail of R package "PhosMap"](#rpackage)
- [Friendly suggestion](#suggestion)
- [Reporting issues](#issues)

<p id="brief-description"></p>

## Brief Description

PhosMap supports multiple function modules for full landscape of 
phosphoproteomics data analyses including quality control, phosphosite 
mapping, dimension reduction analysis, time course analysis, kinase 
activity analysis and survival analysis. Various of publication ready 
figures and tables could be generated via PhosMap. We provided a downloadable
R package for local customized analysis of massive data in the R shiny environment
deploying on the Docker upon the Windows, Linux, and Mac system.


We provide a demo server at https://bio-inf.shinyapps.io/phosmap/. 
This server is single-thread and of low-level hardware, we do recommend
users to analyze the data using the demo server with small data sets. 
An upgraded hardware is necessary, according to the possible computational
cost of the data, to reach the potential of PhosMap.

<img src="www/main.svg" width = 70%>

<p id="how-to-install"></p>

## How to install
There are two different ways to launch PhosMap:

<p id="installdocker"></p>

### 1. Docker-based installation
We provide a docker image with PhosMap: https://hub.docker.com/r/liuzandh/phosmap

Pull the docker image of PhosMap:
```linux
docker pull liuzandh/phosmap:1.0.0
```
Create a docker container containing PhosMap:

```linux
docker run  -p HostPort:3838 liuzandh/phosmap:1.0.0
```
Then, you can enter PhosMap by visiting `HostIP:HostPort/PhosMap`.

For example: HostPort could be set to 8083. This parameter can be changed according to user needs. 
such as,
```linux
docker run -p 8083:3838 liuzandh/phosmap:1.0.0
```
Next, open `127.0.0.1:8083/PhosMap` in the local browser or `remotely access ip:8083/PhosMap` (you should ensure that the machine can be accessed remotely).

<p id="installr"></p>

### 2. R-based installation

This tool is developed with R, so if you want to run it locally, you may do some preparatory work:
- [1] **Install R.** You can download R from here: https://www.r-project.org/.
- [2] **Install RStudio.** You can download RStudio from here: https://www.rstudio.com/.
- [3] **Download the source code from github.**
- [4] **Download the necessary data.** Please download "PhosMap_datasets.zip" from module "Download" on https://bio-inf.shinyapps.io/phosmap/. Then unzip this file to phosmap folder like this pic.

<img src="www/unzip.jpg" width=30%>

- [5] **Check packages.** After installing R and RStudio, you should check whether you have installed these packages ("shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly","colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","readr","dplyr","DT","png","svglite","ggplotify","bslib","ksea","rmotifx","PhosMap","qpdf","pcaMethods","impute","rrcovNA","e1071"). 

  You can run the codes below to install them:
  ```linux
  if (!require("BiocManager", quietly = TRUE)){install.packages("BiocManager")}

  BiocManager::install(c("pcaMethods", "impute"))

  install.packages(c("shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly", "colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","dplyr","DT","png", "svglite","ggplotify","bslib","qpdf", "rrcovNA", "e1071"))

  install.packages('devtools')
  require(devtools)

  install_github('evocellnet/ksea')
  install_github('omarwagih/rmotifx')
  install_github('ecnuzdd/PhosMap')
  ```
- [6] **click "Run App".** View the file ui.R, then just click button "Run App", Phosmap will start.

<p id="how-to-use"></p>

## How to use
You can find comprehensive documentation and an in-depth video tutorial on this website.https://bio-inf.shinyapps.io/phosmap/

<p id="rpackage"></p>

## Detail of R package "PhosMap"
https://github.com/ecnuzdd/PhosMap

<p id="suggestion"></p>

## Friendly suggestion
1. Open PhosMap with Chrome.
2. The minimum operating system specifications are: RAM 8GB, Hard drive 100 GB.

<p id="issues"></p>

## Reporting issues
You could push an issue on this github if you have any problems.
