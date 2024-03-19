options(repos = c(CRAN = "http://cran.rstudio.com/"))

if (!require("BiocManager", quietly = TRUE)){install.packages("BiocManager")}

BiocManager::install(c("pcaMethods", "impute"))

# due to FactoMineR's update, dependency conflict occurs
install.packages("estimability_1.4.1.tar.gz", type="Source", repos=NULL)
install.packages("emmeans_1.8.9.tar.gz", type="Source", repos=NULL)
install.packages("FactoMineR_2.9.tar.gz", type="Source", repos=NULL)

install.packages(c("factoextra","data.table","tidyr","shiny","shinyjs","shinyBS","shinyWidgets","ggplot2","ggrepel","plotly","colourpicker","ggseqlogo","pheatmap","survminer","survival","zip","stringr","dplyr","DT","png","svglite","ggplotify","bslib","qpdf", "rrcovNA", "e1071", "heatmaply", "ggdendro"))
