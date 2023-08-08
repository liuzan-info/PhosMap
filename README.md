
<div align="center">
  <img src="www/logo.svg" width="200"/>
  <div>&nbsp;</div>
  <b>An Ensemble Bioinformatic Platform to Empower One-stop Interactive Analysis of Quantitative Phosphoproteomics.</b>
  <div>&nbsp;</div>

[![Web Server CD](https://github.com/liuzan-info/PhosMap/actions/workflows/shinyapp.yml/badge.svg)](https://github.com/liuzan-info/PhosMap/actions/workflows/shinyapp.yml)
[![Docker Image CI](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml)
<img src="https://img.shields.io/github/license/liuzan-info/PhosMap">

[![R](https://img.shields.io/badge/-R%20package-276DC3?style=flat-square&logo=R&logoColor=white)](https://github.com/ecnuzdd/PhosMap) | 
[![Web](https://img.shields.io/badge/-Web%20server-FF7139?style=flat-square&logo=Google-Chrome&logoColor=white)](https://bio-inf.shinyapps.io/phosmap/) | 
[![Docker](https://img.shields.io/badge/-Docker%20image-2496ED?style=flat-square&logo=Docker&logoColor=white)](https://hub.docker.com/r/liuzandh/phosmap/tags)

[📘Doc for R package](https://github.com/liuzan-info/PhosMap/blob/main/www/package_manual.pdf)
[📙Doc for Web server and Docker image](https://liuzan-info.github.io/)

<a href="https://youtu.be/2ZlMqMJjNU8" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/218346691-ceb2116a-465a-40af-8424-9f30d2348ca9.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />
<a href="https://www.bilibili.com/video/BV1tj411z7Fe/" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/219026751-d7d14cce-a7c9-4e82-9942-8375fca65b99.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />

</div>
   
## Table of Contents
- [Table of Contents](#table-of-contents)
- [Brief Description](#brief-description)
- [How to install](#how-to-install)
  - [1. Docker-based installation](#1-docker-based-installation)
  - [2. R-based installation](#2-r-based-installation)
- [How to use](#how-to-use)
- [Detail of R package "PhosMap"](#rpackage)
- [Friendly suggestion](#suggestion)
- [Reporting issues](#issues)
- [Contributing](#contributing)🥰
- [Citation](#citation)

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

<div align="center">
  <img src="www/main.svg" width = 70%>
</div>

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
Then, you can enter PhosMap by visiting `HostIP:HostPort`.

For example: HostPort could be set to 8083. This parameter can be changed according to user needs. 
such as,
```linux
docker run -p 8083:3838 liuzandh/phosmap:1.0.0
```
Next, open `127.0.0.1:8083` in the local browser or `remotely access ip:8083` (you should ensure that the machine can be accessed remotely).

<p id="installr"></p>

### 2. R-based installation

This tool is developed with R, so if you want to run it locally, you may do some preparatory work:
- [1] **Install R.** You can download R from here: https://www.r-project.org/.
- [2] **Install RStudio.** You can download RStudio from here: https://www.rstudio.com/.
- [3] **Download the source code from github.**
- [4] **Download the necessary data.**
  <img src="www/unzip.jpg" width=18% align="right">
  Please download "PhosMap_datasets.zip" from https://github.com/liuzan-info/PhosMap_datasets. Using 'git clone' is recommended. If you are not familiar with Git or experience network issues, you may download from <a href="https://pan.baidu.com/s/1o3CVRjvCIHnqfY0Bh9X-qw?pwd=7d2k" target="_blank">here</a> instead.  Then unzip this file to phosmap folder like this pic.

- [5] **Check packages.** After installing R and RStudio, you should check whether you have installed these packages ("shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly","colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","readr","dplyr","DT","png","svglite","ggplotify","bslib","ksea","rmotifx","PhosMap","qpdf","pcaMethods","impute","rrcovNA","e1071","heatmaply"). 

  You can run the codes below to install them:
  ```linux
  if (!require("BiocManager", quietly = TRUE)){install.packages("BiocManager")}

  BiocManager::install(c("pcaMethods", "impute"))

  install.packages(c("shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly", "colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","dplyr","DT","png", "svglite","ggplotify","bslib","qpdf", "rrcovNA", "e1071", "heatmaply"))

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

<p id="contributing"></p>

## Contributing 
The data input/output (IO) stream adhering to the PhosMap standard ensures the scalability of the functionality. Although we have already included well-established phosphoproteomics methods, there are still many algorithms being continuously developed, and therefore, we appreciate your valuable contributions! 

Please feel free to submit a pull request, and we will respond promptly to review and merge it.

<p id="citation"></p>

## Citation
If you find this project useful in your research, please consider cite:
```
Forthcoming...
```
