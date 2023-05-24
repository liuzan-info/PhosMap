options(repos = c(CRAN = "http://cran.rstudio.com/"))

if (!require("BiocManager", quietly = TRUE)){install.packages("BiocManager")}

BiocManager::install(c("pcaMethods", "impute"))

install.packages(c("shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly","colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","dplyr","DT","png","svglite","ggplotify","bslib","qpdf", "rrcovNA", "e1071"))
