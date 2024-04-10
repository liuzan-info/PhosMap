
<div align="center">
  <img src="www/logo.svg" width="200"/>
  <div>&nbsp;</div>
  <b>An Ensemble Bioinformatic Platform to Empower Interactive Analysis of Quantitative Phosphoproteomics.</b>
  <div>&nbsp;</div>

[![Docker Image CI](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/liuzan-info/PhosMap/actions/workflows/docker-image.yml)
<img src="https://img.shields.io/github/license/liuzan-info/PhosMap">

[![R](https://img.shields.io/badge/-R%20package-276DC3?style=flat-square&logo=R&logoColor=white)](https://github.com/ecnuzdd/PhosMap) | 
[![Web](https://img.shields.io/badge/-Web%20server-FF7139?style=flat-square&logo=Google-Chrome&logoColor=white)](https://huggingface.co/spaces/Bio-Add/PhosMap) | 
[![Docker](https://img.shields.io/badge/-Docker%20image-2496ED?style=flat-square&logo=Docker&logoColor=white)](https://hub.docker.com/r/liuzandh/phosmap/tags)

[📘Doc for R package](https://liuzan-info.github.io/phosmap_r)
[📙Doc for Web server and Local UI](https://liuzan-info.github.io/phosmap_manual)

<a href="https://youtu.be/2ZlMqMJjNU8" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/218346691-ceb2116a-465a-40af-8424-9f30d2348ca9.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />
<a href="https://www.bilibili.com/video/BV1tj411z7Fe/" style="text-decoration:none;">
  <img src="https://user-images.githubusercontent.com/25839884/219026751-d7d14cce-a7c9-4e82-9942-8375fca65b99.png" width="3%" alt="" /></a>
<img src="https://user-images.githubusercontent.com/25839884/218346358-56cc8e2f-a2b8-487f-9088-32480cceabcf.png" width="3%" alt="" />

</div>
   
<b>Table of Contents</b>
- [Brief Description](#brief-description)
- [How to install](#how-to-install)
  - [1. Docker-based installation](#1-docker-based-installation)
  - [2. R-based installation](#2-r-based-installation)
- [How to use](#how-to-use)
- [How to extend](#how-to-extend)
- [Detail of R package "PhosMap"](#detail-of-r-package-phosmap)
- [Friendly suggestion](#friendly-suggestion)
- [Reporting issues](#reporting-issues)
- [Contributing](#contributing)
- [Citation](#citation)

<p id="brief-description"></p>

## Brief Description

PhosMap emerges as an all-encompassing bioinformatic framework meticulously architected to bestow researchers with a harmonious and interactive data analysis experience within the domain of MS-based phosphoproteomics. 

PhosMap is capable to handle both label-free and label-based phosphoproteomics. Moreover, PhosMap supports both the DDA- or DIA-MS phosphoproteomics data preprocessed by various types of commonly used softwares, including MaxQuant, Firmiana, Spectronaut and DIA-NN.

Serving as a versatile and user-friendly platform, PhosMap extends its prowess through a trifecta of deployment options: a web server, a local graphical interface, and an R package. For users without bioinformatics skills, the web server is suitable for analyzing small data volumes. When dealing with larger data volumes, it is recommended to utilize the local graphical interface of PhosMap. Meanwhile, for users with programming skills, the locally installed graphical interface allows for convenient customization and expansion. Moreover, the PhosMap R package offers a highly flexible platform for advanced analysis.


The PhosMap web server can be accessed at the following URL: https://huggingface.co/spaces/Bio-Add/PhosMap.


<div align="center">
  <img src="www/main.svg" width = 70%>
</div>

<p id="how-to-install"></p>

## How to install
To fully unleash the potential of PhosMap, we recommend users to utilize the local version.
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

  install.packages(c("FactoMineR","factoextra","data.table","tidyr","shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly", "colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","dplyr","DT","png", "svglite","ggplotify","bslib","qpdf", "rrcovNA", "e1071", "heatmaply", "ggdendro))

  install.packages('devtools')
  require(devtools)

  install_github('evocellnet/ksea')
  install_github('ecnuzdd/PhosMap')

  remove.packages('Matrix')
  install_version('Matrix', version='1.5-3')
  ```
- [6] **click "Run App".** View the file ui.R, then just click button "Run App", Phosmap will start.

<p id="how-to-use"></p>

## How to use
You can find comprehensive documentation and an in-depth video tutorial on this website. https://github.com/liuzan-info/PhosMap

<p id="rpackage"></p>

## How to extend
Due to its clear design and reliance solely on the _R_ language, PhosMap allows for easy customization of user-defined features. Basic knowledge of _R_ is sufficient, without the need to understand the shiny framework. We provide a step-by-step tutorial available here.

1. Follow the instructions in `How to install --> R-based installation` for installation. Additionally, install the packages required for your customized functionalities.
2. Open the `ui.R` file inside the PhosMap folder and search for the term '**Customization**.' You will then see a template with detailed annotations. You only need to **selectively** modify **the lines with annotations** according to the instructions. These codes determine the display of the graphical interface.
   ```R
   # If you want to expand the software's functionality, 
   # please uncomment the code below. 
   # Tip: You can use the Ctrl+Shift+C shortcut to uncomment or comment the selectedcode.
   tabPanel(
     "Customization",
     h2("User-defined Tool", class = "tooltitle"),
     h4("This module is designed for implementing user-defined functionalities. 
        If you have any questions, please submit an issue on Github.", class = "toolsubtitle"),
     fluidRow(
       column(
         4,
         panel(
           "",
           heading = "Parameters Setting",
           numericInput(
             inputId = "user_num1",  # id to be used in server.R, must be unique, is not recommended to change.
             label = "user_num1",  # label to show that can be changed.
             value = 1,  # default number that can be changed.
           ),
           numericInput(
             inputId = "user_num2",  # id to be used in server.R, must be unique, is not recommended to change.
             label = "user_num2",  # label to show that can be changed.
             value = 1,  # default number that can be changed.
           ),
           actionButton(
             inputId = "user_button",  # id to be used in server.R, must be unique, is not recommended to change.
             label = "Run", # label to show that can be changed.
           )
         )
       ),
       column(
         8,
         h4("Result--Table:"),  # instruction, not recommended to change.
         dataTableOutput(
           outputId = "user_table",  # id to be used in server.R, must be unique, is not recommended to change.
         ),
         h4("Result--Plot:"),  # instruction, not recommended to change.
         plotOutput(
           outputId = "user_plot",  # id to be used in server.R, must be unique, is not recommended to change.
         )
       )
     )
   )
   ```
3. Open the `server.R` file inside the PhosMap folder and search for the term '**Customization**.' You will then see a template with detailed annotations. We demonstrate the **data retrieval** and utilization, along with the computational core code that you can modify as desired, and how to ultimately **display data frames and images** in the UI interface. These codes determine how the calculations are performed.
   ```R
   # If you want to expand the software's functionality, 
   # please uncomment the code below. 
   # Tip: You can use the Ctrl+Shift+C shortcut to uncomment or comment the selected code.
   observeEvent(
     input$user_button, {
       # you can directly work with the data on the data upload interface, whether it is   "pipeline data" or "your data".
       # a total of four datasets are as follows:
       # (To facilitate user understanding of the data, we have defined the functionality to   display different data based on the input in the 'define operation logic' section)
       ## fileset()[[1]]: experimental design dataframe
       ## fileset()[[2]]: expression dataframe, the partial of PhosMap matrix
       ## fileset()[[3]]: dataframe including peptide sequences, the partial of PhosMap matrix
       ## fileset()[[4]]: clinical dataframe
       
       # define operation logic
       ## load dependency
       library(ggplot2)
       ## retrieve input data
       user_num1 = input$user_num1  # retrieve the value of the corresponding input box with   id using input$id
       user_num2 = input$user_num2
       ## write core code to perform any operation that can be tested in advance in a normal   R environment
       inter_value = user_num2 + 1 - 1
       plot_data <- data.frame(
         x = c(1, 2, 3, 4, 5),
         y = c(2, 4, 6, 8, 10)
       )
       
       if(user_num1 == 1){
         # output a table to UI
         output$user_table <- renderDataTable(fileset()[[1]])  # show data
       } else{
         output$user_table <- renderDataTable(fileset()[[inter_value]])  # show data
         
         p <- ggplot(plot_data, aes(x, y)) +
           geom_point()
         # output a plot to UI
         output$user_plot <- renderPlot(p)  # show plot
       }
     }
   )
   ```
It's straightforward, give it a try. Feel free to submit any questions as issues or contribute interesting features through pull requests. :)

## Detail of R package "PhosMap"
https://github.com/ecnuzdd/PhosMap

<p id="suggestion"></p>

## Friendly suggestion
1. Open PhosMap with Chrome or Firefox.
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
<b>If you find this project useful in your research, please consider cite:</b>

Mengsha Tong, Zan Liu, Jiaao Li, Xin Wei, Wenhao Shi, Chenyu Liang, Chunyu Yu, Rongting Huang, Yuxiang Lin, Xinkang Wang, Shun Wang, Yi Wang, Jialiang Huang, Yini Wang, Tingting Li, Jun Qin, Dongdong Zhan, Zhi-Liang Ji,
PhosMap: An ensemble bioinformatic platform to empower interactive analysis of quantitative phosphoproteomics,
Computers in Biology and Medicine,
2024,
108391,
ISSN 0010-4825,
https://doi.org/10.1016/j.compbiomed.2024.108391.
(https://www.sciencedirect.com/science/article/pii/S001048252400475X)

