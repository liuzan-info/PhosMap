#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(shinyBS)
library(ggplot2)
library(ggrepel)
library(PhosMap)
library(plotly)
library(colourpicker)
library(ggseqlogo)
library(pheatmap)
library(survminer)
library(survival)
library(zip)
library(stringr)
library(dplyr)
library(DT)
library(png)
library(svglite)
library(ggplotify)
library(shinyWidgets)
library(bslib)
library(PhosMap)
library(qpdf)
library(uwot)


ui <- renderUI(
  fluidPage(
    shinyjs::useShinyjs(),
    useSweetAlert(),
    tags$head(
      HTML("<title>PhosMap</title>"),
      tags$style(type = "text/css", "
    body {padding-top: 70px;}
                           #loadmessage {
                     position: fixed;
                     top: -20px;
                     left: 0px;
                     width: 100%;
                     height:100%;
                     padding: 300px 0px 5px 0px;
                     text-align: center;
                     font-weight: bold;
                     font-size: 40px;
                     color: #000000;
                     background-color: #D6D9E4;
                     opacity:0.7;
                     z-index: 1050;
                     }
                     ",
                 HTML("
          .navbar-nav {float: right; font-size: 16px}
          .warning {border-left: 8px solid;}
          .tooltitle {text-align:center;}
          .toolsubtitle {text-align:center;}
          .downloadbutton {}
          .viewbutton {}
          .runbutton {color: #fff; background-color: #5DA61E; border-color: #ffacae;}
          .loadfiledescription {text-align:left;margin-top:15px;margin-left:10px;margin-right:300px;font-size:190%;}
          .analysisbutton {color: #fff; background-color: #7650E6; border-color: #ffacae; width:200px; height:40px; }
          .plotbutton{color: #fff; background-color:#da5151; border-color: #ffacae; width:150px; height:40px; }
          .warningbutton {color: #fff; background-color: #F01616; border-color: #ffacae;}
          .runbuttondiv {text-align: right;}
          
          #limmastatic{height:70vh !important;}
          #limmainter{height:70vh !important;}
          #samstatic{height:70vh !important;}
          #saminter{height:70vh !important;}
          #anovastatic{height:70vh !important;}
          #anovainter{height:70vh !important;}
          #timecourse{height:70vh !important;}
          #kaptimecourseplot{height:70vh !important;}
          #kapstep2plot{height:70vh !important;}
          #kseastep2plot{height:70vh !important;}
          #kseastep2plotmid{height:110vh !important;}
          #kseastep2plotmini{height:140vh !important;}
          #kseastep2plotxs{height:200vh !important;}
          #resultnav {float: left;}
          #resultnavdroppro {float: left;}
          #mascotdemodropproresultnav {float: left;}
          #usermascotnoproresultnav {float: left;}
          #usermascotresultnav {float: left;}
          #usermascotdropproresultnav {float: left;}
          #demomaxresultnav {float: left;}
          #demomaxdropproresultnav {float: left;}
          #usermaxnoproresultnav {float: left;}
          #usermaxresultnav {float: left;}
          #usermaxdropproresultnav {float: left;}
          #kapresultnav {float: left;}
        ")
      )
    ),
    
    conditionalPanel(
      condition = "$('html').hasClass('shiny-busy')",
      div(h2(strong("PhosMap Calculating..."), img(src = "rmd_loader.gif"), id = "loadmessage"))
    ),

    navbarPage(
      div("",img(src = "logo.svg", height = "60px", width = "115px", style = "padding-bottom:10px; padding-right:10px; margin-top: -12px")),
      inverse = T,
      id = "navbarpage",
      position = "fixed-top",
      tabPanel(
        "Home",
        icon = icon("house"),
        h1(style = "text-align: center;", "PhosMap"),
        h3(style = "text-align: center;", "A Webserver for Comprehensive Analysis of Quantitative Phosphoproteomics"),
        div(style = "text-align:center;", img(src = "main.svg", height = "500px", width = "1400px", style = "")),
        br(),
        br(),
        br(),
        br(),
        hr(),
        h5(style = "text-align: center;","This website is free and open to all users and there is no login requirement.")
      ),
      tabPanel(
        "Import Data",
        icon = icon("upload", class = "fa-solid fa-upload"),
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3("Import Data",),
            wellPanel(
              materialSwitch(
                inputId = "loaddatatype",
                label = "Load example data", 
                value = FALSE,
                status = "success",
                right = TRUE
              ),
              radioGroupButtons(
                inputId = "softwaretype",
                label = NULL,
                choices = list("MaxQuant" = 1, "Firmiana" = 2),
                # direction = "vertical",
                individual = TRUE,
                selected = 1,
                checkIcon = list(
                  yes = tags$i(class = "fa fa-circle", 
                               style = "color: steelblue"),
                  no = tags$i(class = "fa fa-circle-o", 
                              style = "color: steelblue")),
              )
            ),
            conditionalPanel(
              condition = "input.loaddatatype == true",
              h4("1. Experimental design file: "),
              actionButton("viewbt1", "view", icon("eye"), class = "viewbutton"),
              hr(style = "border-style: dashed;border-color: grey;")
            ),
            conditionalPanel(
              condition = "input.loaddatatype == true  & input.softwaretype == 2",
              h4("2. Mascot xml file: "),
              selectInput("mascotdemoxmlid", NULL, choices = c("Exp027012_F1_R1", "Exp027020_F1_R1", "Exp027028_F1_R1", "Exp027036_F1_R1", "Exp027044_F1_R1")),
              hr(style = "border-style: dashed;border-color: grey;"),
              # hr(),
              h4("3. Phosphoproteomics peptide file: "),
              selectInput("mascotdemopeptidefileid", NULL, choices = c("Exp027012_peptide", "Exp027020_peptide", "Exp027028_peptide", "Exp027036_peptide", "Exp027044_peptide")),
              hr(style = "border-style: dashed;border-color: grey;"),
              h4("4. Proteomics data[optional]"),
              br(style = "line-height:1px;"),
              h4("4.1 Proteomics experimental design file: "),
              actionButton("viewbt5", "view", icon("eye"), class = "viewbutton"),
              h4("4.2 Profiling file: "),
              selectInput("mascotdemoproid", NULL, choices = c("Exp026921_gene", "Exp026986_gene", "Exp026993_gene", "Exp026999_gene", "Exp027006_gene"))
            ),

            #Maxquant
            conditionalPanel(
              condition = "input.loaddatatype == true  & input.softwaretype == 1",
              h4("2. Phospho (STY)Sites.txt: "),
              actionButton("viewdemomaxphosbt", "view", icon("eye"), class = "viewbutton"),
              hr(style = "border-style: dashed;border-color: grey;"),
              # hr(),
              h4("3. Proteomics data[optional]"),
              br(),
              h4("3.1 Proteomics experimental design file: "),
              actionButton("viewdemomaxprodesignbt", "view", icon("eye"), class = "viewbutton"),
              h4("3.2 proteinGroups.txt: "),
              actionButton("viewdemomaxprobt", "view", icon("eye"), class = "viewbutton"),
            ),
            
            ## user data
            # shared phosphoproteomics design file
            conditionalPanel(
              condition = "input.loaddatatype == false",
              h4("1. Experimental design file: "),
              fileInput("updesign", NULL, accept = ".txt"),
              hidden(
                div(
                  id = "hiddenview1",
                  actionButton("viewbt4", "view", icon("eye"))
                )
              ),
              hr(style = "border-style: dashed;border-color: grey;")
            ),
            
            # mascot
            conditionalPanel(
              condition = "input.loaddatatype == false & input.softwaretype == 2",
              h4("2. Mascot xml file: "),
              fileInput("upmascot", NULL, accept = "application/zip"),
              uiOutput("masui"),
              hr(style = "border-style: dashed;border-color: grey;"),
              h4("3. Phosphoproteomics peptide file: "),
              fileInput("uppeptide", NULL, accept = "application/zip"),
              uiOutput("pepui"),
              hr(style = "border-style: dashed;border-color: grey;"),
              
              h4("4. Proteomics data[optional]"),
              br(),
              h4("4.1 Proteomics experimental design file: "),
              fileInput("upprodesign", NULL, accept = ".txt"),
              uiOutput("prodesignui"),
              hidden(
                div(
                  id = "prohiddenview",
                  actionButton("proviewbt", "view", icon("eye"))
                )
              ),
              
              h4("4.2 Profiling file: "),
              fileInput("upprogene", NULL, accept = "application/zip"),
              uiOutput("progeneui"),
            ),
            
            # Maxquant
            conditionalPanel(
              condition = "input.loaddatatype == false & input.softwaretype == 1",
              h4("2. Phospho (STY)Sites.txt: "),
              fileInput("upusermaxphos", NULL, accept = ".txt"),
              hidden(
                div(
                  id = "hidviewusermaxphosbt",
                  actionButton("viewusermaxphosbt", "view", icon("eye"), class = "viewbutton")
                ),
                div(
                  id = "hidviewusermaxphosbtwarning",
                  actionButton("viewusermaxphosbtwarning", "error...", icon("triangle-exclamation"), class = "warningbutton")
                )
              ),
              hr(style = "border-style: dashed;border-color: grey;"),
              h4("3. Proteomics data[optional]"),
              br(),
              h4("3.1 Proteomics experimental design file: "),
              fileInput("upusermaxprodesign", NULL, accept = ".txt"),
              hidden(
                div(
                  id = "hidviewusermaxprodesignbt",
                  actionButton("viewusermaxprodesignbt", "view", icon("eye"), class = "viewbutton")
                )
              ),
              h4("3.2 proteinGroups.txt: "),
              fileInput("upusermaxpro", NULL, accept = ".txt"),
              hidden(
                div(
                  id = "hidviewusermaxprobt",
                  actionButton("viewusermaxprobt", "view", icon("eye"), class = "viewbutton")
                ),
                div(
                  id = "hidviewusermaxprobtwarning",
                  actionButton("viewusermaxprobtwarning", "error...", icon("triangle-exclamation"), class = "warningbutton")
                )
              )
            ),
            
            conditionalPanel(
              condition = "input.loaddatatype == false & input.softwaretype == 3",
              h4("another user data")
            )
          ),
          mainPanel(
            width = 9,
            hr(),
            conditionalPanel(
              condition = "input.loaddatatype == true",
              htmlOutput("html"),
              dataTableOutput("viewedfile")
            ),
            conditionalPanel(
              condition = "input.loaddatatype == false",
              htmlOutput("html2"),
              dataTableOutput("viewedfile2"),
            )
          )
        )
      ),
      tabPanel(
        "Preprocessing",
        icon = icon("laptop-code"),
        fluidRow(
          conditionalPanel(
            condition = "input.softwaretype == 2",
            column(2, NULL),
            column(8, h2(style = "text-align: center;", "Preprocessing")),
            column(2, actionButton("pre2analysis", "Go to analysis tools", icon = icon("paper-plane"))),
            column(
              12,
              conditionalPanel(
                condition = "input.loaddatatype == true",
                progressBar(id = "preprobar", value = 0, status = "success")
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                progressBar(id = "userpreprobar", value = 0, status = "success")
              ),
            ),
            
            column(
              3,
              panel(
                heading = "Step1: Parser",
                status = "primary",
                h5("no parameter"),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "parserbt01",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "parserbt11",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              ),
              panel(
                heading = "Step2: Quality Control & Merging",
                status = "warning",
                numericInput(
                  "qcscore",
                  "minimum score:",
                  20,
                  max = 100,
                  min = 0,
                  step = 0.5
                ),
                bsTooltip(
                  "qcscore", 
                  "the minimum score of credible peptides",
                  placement = "right", 
                  options = list(container = "body")
                ),
                numericInput(
                  "qcfdr",
                  "minimum FDR:",
                  0.01,
                  max = 0.02,
                  min = 0,
                  step = 0.002
                ),
                bsTooltip(
                  "qcfdr", 
                  "the minimum FDR of credible peptides",
                  placement = "right", 
                  options = list(container = "body")
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "mergingbt0",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "mergingbt1",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              ),
              panel(
                heading = "Step3: Mapping",
                status = "danger",
                selectInput("species", "species:", choices = c("human", "mouse", "rattus")),
                selectInput("idtype", "id type", choices = c("RefSeq_Protein_GI", "RefSeq_Protein_Accession", "Uniprot_Protein_Accession", "GeneID")),
                selectInput("fastatype", "fasta type", choices = c("refseq", "uniprot")),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "mappingbt01",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "mappingbt11",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              )
            ),
            column(
              3,
              panel(
                heading = "Step4: Filtering & Normalization & Imputation",
                footer = "This step also filters modification types, remaining only 'S/T/Y'",
                status = "info",
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  numericInput("masphosNAthre", label = "minimum detection frequency: ", value = 3),
                ),
                bsTooltip(
                  "masphosNAthre",
                  # "xxxx",
                  "minimum detection frequency for per locus, equivalents to the number of samples minus the number of ‘0’ value",
                  placement = "right",
                  options = list(container = "body")
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  numericInput("usermasphosNAthre", label = "minimum detection frequency: ", value = 3),
                ),
                bsTooltip(
                  "usermasphosNAthre",
                  "minimum detection frequency for per locus, equivalents to the number of samples minus the number of ‘0’ value",
                  placement = "right",
                  options = list(container = "body")
                ),
                selectInput("mascotnormmethod", label = "normalization method: ", choices = c("global", "median")),
                selectInput("mascotimputemethod", label = "imputation method: ", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10"),
                numericInputIcon(
                  inputId = "top",
                  label = "top",
                  value = 90,
                  step = 1,
                  max = 100,
                  min = 1,
                  icon = list(NULL, icon("percent"))
                ),
                bsTooltip(
                  "top", 
                  "compute row maximum each psites, sort row maximum in decreasing order and keep top N (percentage).",
                  placement = "right", 
                  options = list(container = "body")
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "normalizationbt01",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "normalizationbt11",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == true",
                panel(
                  heading = "Step5: Normalization based on proteomics data",
                  status = "success",
                  prettyToggle(
                    inputId = "useprocheck1",
                    label_on = "With proteomics data", 
                    icon_on = icon("check"),
                    status_on = "info",
                    status_off = "warning", 
                    label_off = "Without proteomics data",
                    icon_off = icon("xmark"),
                    value = TRUE
                  ),
                  conditionalPanel(
                    condition = "input.useprocheck1 == 1",
                    wellPanel(
                      h5("Proteomics data preprocessing parameters", style = "color: grey;"),
                      numericInput("masuscutoff", label = "US cutoff: ", value = 1),
                      numericInput("masproNAthre", label = "minimum detection frequency: ", value = 3),
                      bsTooltip(
                        "masproNAthre",
                        "minimum detection frequency for per locus, equivalents to the number of samples minus the number of ‘0’ value",
                        placement = "right",
                        options = list(container = "body")
                      ),
                      selectInput("mascotpronormmethod", label = "normalization method: ", choices = c("global", "median")),
                      selectInput("mascotproimputemethod", label = "imputation method: ", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10")
                    ),
                    selectInput("mascotcontrol", label = "control label: ", choices = c("0", "2", "6", "24", "48", "no control")),
                    div(
                      class = "runbuttondiv",
                      actionButton(
                        "normalizationbt02",
                        "",
                        icon("play"),
                        class = "runbutton"
                      )
                    )
                  ),
                  conditionalPanel(
                    condition = "input.useprocheck1 == 0",
                    wellPanel(
                      h5("After 'Step1-Step2-Step3-Step4' have been run, you can click 'Go to analysis tools'", style = "color: grey;")
                    )
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                uiOutput("userusepro")
              )
            ),
            column(
              6,
              conditionalPanel(
                condition = "input.loaddatatype == true & input.useprocheck1 == 1",
                navbarPage(
                  title = "Result",
                  id = "resultnav",
                  tabPanel(
                    "Step 1",
                    value = "demomascotstep1val",
                    h4("Peptide identification files with psites scores:"),
                    uiOutput("demomascotparserui")
                  ),
                  tabPanel(
                    "Step 2",
                    value = "demomascotstep2val",
                    h4("Peptide data frame through phosphorylation sites quality control:"),
                    uiOutput("mergingui0"),
                    column(11,dataTableOutput("viewedmerging")),
                    column(1,downloadBttn(
                      outputId = "viewedmerging_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 3",
                    value = "demomascotstep3val",
                    h4("Data frame mapped ID to Gene Symbol:"),
                    uiOutput("mapping02"),
                    column(11,dataTableOutput("viewedmapping02")),
                    column(1,downloadBttn(
                      outputId = "viewedmapping02_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 4",
                    value = "demomascotstep4val",
                    h4("Phosphorylation data frame:"),
                    column(11,dataTableOutput("viewednorm01")),
                    column(1,downloadBttn(
                      outputId = "viewednorm01_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 5",
                    value = "demomascotstep5val",
                    h4("Phosphorylation data frame:"),
                    column(11,dataTableOutput("viewednorm02")),
                    column(1,downloadBttn(
                      outputId = "viewednorm02_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    )),
                    br(),
                    h4("Proteomics data frame:"),
                    column(11,dataTableOutput("viewednorm02pro")),
                    column(1,downloadBttn(
                      outputId = "viewednorm02pro_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == true & input.useprocheck1 == 0",
                navbarPage(
                  title = "Result",
                  id = "resultnavdroppro",
                  tabPanel(
                    "Step 1",
                    value = "demomascotdropprostep1val",
                    h4("Peptide identification files with psites scores:"),
                    uiOutput("demomascotdropproparserui")
                  ),
                  tabPanel(
                    "Step 2",
                    value = "demomascotdropprostep2val",
                    h4("Peptide data frame through phosphorylation sites quality control:"),
                    column(11,dataTableOutput("viewedmergingdroppro")),
                    column(1,downloadBttn(
                      outputId = "viewedmergingdroppro_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 3",
                    value = "demomascotdropprostep3val",
                    h4("Data frame mapped ID to Gene Symbol:"),
                    column(11,dataTableOutput("viewedmapping02droppro")),
                    column(1,downloadBttn(
                      outputId = "viewedmapping02droppro_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 4",
                    value = "demomascotdropprostep4val",
                    h4("Phosphorylation data frame:"),
                    column(11,dataTableOutput("viewednorm01droppro")),
                    column(1,downloadBttn(
                      outputId = "viewednorm01droppro_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                uiOutput("userresultpanelui")
              )
            )
          ),
          conditionalPanel(
            condition = "input.softwaretype == 1",
            column(2, NULL),
            column(8, h2(style = "text-align: center;", "Preprocessing")),
            column(2, actionButton("maxpre2analysis", "Go to analysis tools", icon = icon("paper-plane"))),
            column(
              12,
              conditionalPanel(
                condition = "input.loaddatatype == true",
                progressBar(id = "demomaxpreprobar", value = 0, status = "success")
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                progressBar(id = "usermaxpreprobar", value = 0, status = "success")
              )
            ),
            column(
              3,
              panel(
                heading = "Step1: Quality Control",
                status = "primary",
                numericInput(
                  "minqcscore",
                  "minimum score:",
                  40,
                  max = 200,
                  min = 40,
                  step = 1
                ),
                numericInput(
                  "minqclocalizationprob",
                  "minimum localization probability:",
                  0.75,
                  max = 1,
                  min = 0,
                  step = 0.01
                ),
                numericInput(
                  "maxphosNAthre",
                  "minimum detection frequency:",
                  3,
                  min = 0,
                  step = 1
                ),
                bsTooltip(
                  "maxphosNAthre",
                  # "xxxx",
                  "minimum detection frequency for per locus, equivalents to the number of samples minus the number of ‘0’ value",
                  placement = "right",
                  options = list(container = "body")
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "demomaxqcbt",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "usermaxqcbt",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              ),
              panel(
                heading = "Step2: Normalizaiton & Imputation & Filtering",
                status = "warning",
                selectInput("maxphosnormmethod", "normalization method:", choices = c("global", "median")),
                selectInput("maxphosimputemethod", "imputation method:", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10"),
                numericInputIcon(
                  inputId = "maxtop",
                  label = "top:",
                  value = 90,
                  step = 1,
                  max = 100,
                  min = 1,
                  icon = list(NULL, icon("percent"))
                ),
                bsTooltip(
                  "maxtop", 
                  "compute row maximum each psites, sort row maximum in decreasing order and keep top N (percentage).",
                  placement = "right", 
                  options = list(container = "body")
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "demomaxnormbt",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  div(
                    class = "runbuttondiv",
                    actionButton(
                      "usermaxnormbt",
                      "",
                      icon("play"),
                      class = "runbutton"
                    )
                  )
                )
              )
            ),
            column(
              3,
              conditionalPanel(
                condition = "input.loaddatatype == true",
                panel(
                  heading = "Step3: Normalization based on proteomics data",
                  status = "danger",
                  prettyToggle(
                    inputId = "maxuseprocheck1",
                    label_on = "With proteomics data", 
                    icon_on = icon("check"),
                    status_on = "info",
                    status_off = "warning", 
                    label_off = "Without proteomics data",
                    icon_off = icon("xmark"),
                    value = TRUE
                  ),
                  conditionalPanel(
                    condition = "input.maxuseprocheck1 == 1",
                    wellPanel(
                      h5("Proteomics data preprocessing parameters", style = "color: grey;"),
                      selectInput("maxintensitylist", "intensity type: ", choices = c("Intensity", "iBAQ", "LFQ.intensity"), selected = "iBAQ"),
                      numericInput(
                        "maxuniquepeptide",
                        "minimum unique peptide:",
                        1,
                        min = 0,
                        step = 1
                      ),
                      numericInput(
                        "maxproNAthre",
                        "minimum detection frequency:",
                        3,
                        min = 0,
                        step = 1
                      ),
                      bsTooltip(
                        "maxproNAthre",
                        "minimum detection frequency for per protein, equivalents to the number of samples minus the number of ‘0’ value",
                        placement = "right",
                        options = list(container = "body")
                      ),
                      selectInput("maxnormmethod", "normalization method:", choices = c("global", "median")),
                      selectInput("maximputemethod", "imputation method:", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10")
                    ),
                    selectInput("maxcontrol", label = "control label: ", choices = c("0", "2", "6", "24", "48", "no control")),
                    div(
                      class = "runbuttondiv",
                      actionButton(
                        "demomaxnormprobt",
                        "",
                        icon("play"),
                        class = "runbutton"
                      )
                    )
                  ),
                  conditionalPanel(
                    condition = "input.maxuseprocheck1 == 0",
                    wellPanel(
                      h5("After 'Step1-Step2' have been run, you can click 'Go to analysis tools'", style = "color: grey;")
                    )
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                panel(
                  heading = "Step3: Normalization based on proteomics data",
                  status = "danger",
                  uiOutput("maxuserusepro")
                )
              )
            ),
            column(
              6,
              conditionalPanel(
                condition = "input.maxuseprocheck1 == 1 & input.loaddatatype == true",
                navbarPage(
                  title = "Result",
                  id = "demomaxresultnav",
                  tabPanel(
                    "Step 1",
                    value = "demomaxstep1val",
                    h4("QC result: "),
                    column(11,dataTableOutput("demomaxresult1")),
                    column(1,downloadBttn(
                      outputId = "demomaxresult1_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                    
                  ),
                  tabPanel(
                    "Step 2",
                    value = "demomaxstep2val",
                    h4("Phosphorylation data frame: "),
                    column(11,dataTableOutput("demomaxresult2")),
                    column(1,downloadBttn(
                      outputId = "demomaxresult2_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 3",
                    value = "demomaxstep3val",
                    h4("Phosphorylation data frame: "),
                    column(11,dataTableOutput("demomaxresult3")),
                    column(1,downloadBttn(
                      outputId = "demomaxresult3_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    )),
                    br(),
                    h4("Proteomics data frame:"),
                    column(11,dataTableOutput("demomaxresult3pro")),
                    column(1,downloadBttn(
                      outputId = "demomaxresult3pro_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  )
                )
              ),
              conditionalPanel(
                condition = "input.maxuseprocheck1 == 0 & input.loaddatatype == true",
                navbarPage(
                  title = "Result",
                  id = "demomaxdropproresultnav",
                  tabPanel(
                    "Step 1",
                    value = "demomaxdropprostep1val",
                    h4("QC result: "),
                    column(11,dataTableOutput('demomaxdropproresult1')),
                    column(1,downloadBttn(
                      outputId = "demomaxdropproresult1_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  ),
                  tabPanel(
                    "Step 2",
                    value = "demomaxdropprostep2val",
                    h4("Phosphorylation data frame: "),
                    column(11,dataTableOutput("demomaxdropproresult2")),
                    column(1,downloadBttn(
                      outputId = "demomaxdropproresult2_dl",
                      label = "",
                      style = "material-flat",
                      color = "default",
                      size = "sm"
                    ))
                  )
                )
              ),
              conditionalPanel(
                condition = "input.loaddatatype == false",
                uiOutput("maxuserresultpanelui")
              )
            )
          )
        )
      ),
      navbarMenu(
        "Analysis",
        menuName = "analysisnavbar",
        icon = icon("share-nodes"),
        tabPanel(
          "UPLOAD DATA [ prerequisite ]",
          sidebarLayout(
            sidebarPanel(
              width = 3,
              h3("Analysis Data Upload"),
              div(
                id = "pcadatatypediv",
                radioGroupButtons(
                  inputId = "analysisdatatype",
                  label = NULL,
                  choices = list("your data" = 1, "pipeline data" = 2, "example data" = 3),
                  individual = TRUE,
                  selected = 2,
                  checkIcon = list(
                    yes = tags$i(class = "fa fa-circle", 
                                 style = "color: steelblue"),
                    no = tags$i(class = "fa fa-circle-o", 
                                style = "color: steelblue")),
                )
              ),
              bsTooltip(
                "pcadatatypediv", "1. pipeline data: data obtained through the above preprocessing process; 2. example data: data we provide; 3. your data: formated phosphoomics data",
                placement = "right",
                options = list(container = "body")
              ),
              hr(style = "border-color: grey;"),
              conditionalPanel(
                condition = "input.analysisdatatype == 3",
                h4("1. Experimental design file: "),
                actionButton("viewanalysisexamdesign", "view", icon("eye")),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("2. Phosphorylation data frame: "),
                actionButton("viewanalysisexamdf", "view", icon("eye")),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("3. Clinical data file[optional]: "),
                actionButton("viewanalysisexamclin", "view", icon("eye"))
              ),
              
              
              conditionalPanel(
                # pipeline
                condition = "input.analysisdatatype == 2",
                h4("1. Experimental design file: "),
                actionButton("viewanalysispipedesign", "view", icon("eye")),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("2. Phosphorylation data frame: "),
                actionButton("viewanalysispipedf", "view", icon("eye")),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("3. Clinical data file[optional]: "),
                conditionalPanel(
                  condition = "input.loaddatatype == true",
                  actionButton("viewanalysispipeclin", "view", icon("eye"))
                ),
                conditionalPanel(
                  condition = "input.loaddatatype == false",
                  fileInput(
                    inputId = "annalysisupload24",
                    label = NULL,
                    accept = ".csv"
                  ),
                  uiOutput("viewanalysispipeclinui")
                )
              ),
              
              conditionalPanel(
                # any
                condition = "input.analysisdatatype == 1",
                h4("1. Experimental design file: "),
                fileInput(
                  inputId = "analysisupload11",
                  label = NULL,
                  accept = ".txt"
                ),
                uiOutput("viewanalysisyourdesign"),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("2. Phosphorylation data frame: "),
                fileInput(
                  inputId = "analysisupload12",
                  label = NULL,
                  accept = ".csv"
                ),
                uiOutput("viewanalysisyourexpre"),
                hr(style = "border-style: dashed;border-color: grey;"),
                h4("3. Clinical data file[optional]: "),
                fileInput(
                  inputId = "analysisupload14",
                  label = NULL,
                  accept = ".csv"
                ),
                uiOutput("viewanalysisyourclin")
              )
            ),
            mainPanel(
              width = 9,
              hr(),
              htmlOutput("htmlanalysis"),
              conditionalPanel(
                condition = "input.analysisdatatype == 2 | input.analysisdatatype == 3",
                uiOutput("viewedfileanalysisui"),
                dataTableOutput("viewedfileanalysis")
              ),
              conditionalPanel(
                condition = "input.analysisdatatype == 1",
                uiOutput("viewedfileanalysisuiuser"),
                dataTableOutput("viewedfileanalysisuser")
              )
            )
          )
        ),
        tabPanel(
          "Dimension Reduction Analysis",
          h2("Dimension Reduction Analysis", class = "tooltitle"),
          h4("This module is used to reduce the dimension of phosphosites and visualize samples.", class = "toolsubtitle"),
          fluidRow(
            column(
              4,
              panel(
                "",
                heading = "Parameters Setting",
                status = "info",
                column(12, h4("PCA:")),
                column(6, textInput("pcamain", "main", "PCA")),
                column(12, h4("t-SNE:")),
                column(6, textInput("tsnemain", "main", "t-SNE")),
                column(6,numericInput("tsneseed", "random seed", 42)),
                column(6, numericInput('tsneperplexity','perplexity',3,min = 1,step = 1)),
                column(12, h4("UMAP:")),
                column(6, textInput("umapmain", "main", "Simple UMAP")),
                column(6, numericInput('umapneighbors','neighbors',15,min = 1,step = 1)),
                column(12, div(actionButton("drbt", "Analysis", icon("magnifying-glass-chart"), class='analysisbutton'), style = "display:flex; justify-content:center; align-item:center;"))
              )
            ),
            column(
              8,
              column(6, plotOutput("pca2")),
              column(5, plotOutput("pca1")),
              column(1, downloadBttn(
                outputId = "pcaplotdl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
              column(5, plotOutput("tsne")),
              column(1, downloadBttn(
                outputId = "tsneplotdl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
              column(5, plotOutput("umap")),
              column(1, downloadBttn(
                outputId = "umapplotdl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
            )
          )
        ),
        tabPanel(
          "Differential Expression Analysis",
          h2("Differential Expression Analysis", class = "tooltitle"),
          h4("This module is used to identify differentially expressed phosphorylation sites.", class = "toolsubtitle"),
          radioGroupButtons(
            inputId = "detools",
            label = "",
            choices = c("limma", 
                        "SAM", "ANOVA"),
            justified = TRUE,
            checkIcon = list(
              yes = icon("ok", 
                         lib = "glyphicon"))
          ),
          conditionalPanel(
            condition = "input.detools == 'limma'",
            column(
              4,
              panel(
                "",
                heading = "Limma Parameters Setting",
                status = "info",
                column(6,uiOutput('limmaselect1')),
                column(6,uiOutput('limmaselect2')),
                column(6, numericInput("limmapvalue", h5("pvalue threshold:"), 0.05, max = 0.05, min = 0.0000001, step = 0.0000001)),
                column(
                  6,
                  selectInput("limmaadjust", h5("pvalue adjust method:"), choices = c("none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"),selected = 'BH')
                ),
                column(6, numericInput("limmafc", h5("FC threshold:"), 2, min = 1, step = 0.5)),
                column(6, textAreaInput("limmamain", h5("title:"), "Differentially expressed phosphosites with limma")),
                column(6, textAreaInput("limmaxaxis", h5("x axis label:"), "logFC")),
                
                column(6, textAreaInput("limmayaxis", h5("y axis label:"), "-log10(pvalue)")),
                
                column(4, colourInput("limmaupcolor", h5('"UP" colour'), "#FC5C00")),
                column(4, colourInput("limmadowncolor", h5('"DOWN" colour'), "#31BDE0")),
                column(4, colourInput("limmanotcolor", h5('"NOT" colour'), "#858080")),
                conditionalPanel(
                  condition = "input.deadisplaymode == true",
                  column(6, numericInput("limmalabelfc", h5("FC threshold for labeling:"), 2, max = 10, min = 1, step = 0.5)),
                  column(6, numericInput("limmalabelpvalue", h5("pvalue threshold for labeling:"), 0.05, max = 0.05, min = 0.0000001, step = 0.0000001)),
                  column(12, textAreaInput("limmalabelspec", h5("specified points:"), "NUP35_S279\nPCNP_T139\nSEPTIN9_S30\n"))
                ),
                column(12, div(actionButton("limmabt", "Analysis", icon("magnifying-glass-chart"), class='analysisbutton'), style = "display:flex; justify-content:center; align-item:center;"))
              )
            ),
            column(
              5,
              column(3,actionButton("viewlimmafile", "view result file", icon("eye"))),
              column(3, NULL),
              column(4, switchInput(
                inputId = "deadisplaymode",
                label = "mode", 
                labelWidth = "50px",
                size = "mini",
                onLabel = "static",
                offLabel = "interactive"
              )),
              column(
                1,
                conditionalPanel(
                  condition = "input.deadisplaymode == true",
                  downloadBttn(
                    outputId = "limmaplotdl",
                    label = "",
                    style = "material-flat",
                    color = "default",
                    size = "sm"
                  )
                )
              ),
              column(1, NULL),
              column(
                12,
                conditionalPanel(
                  condition = "input.deadisplaymode == true",
                  plotOutput("limmastatic", width = "100%"),
                ),
                conditionalPanel(
                  condition = "input.deadisplaymode == false",
                  plotlyOutput("limmainter", width = "100%")
                )
              )
            ),
            column(
              3,
              panel(
                "",
                heading = "Heatmap Parameters Setting",
                status = "warning",
                column(12, selectInput("limmaphscale", h5("scale:"), choices = c("none", "row", "column"), selected = "row")),
                column(6, prettyToggle(
                  inputId = "limmaphcluster",
                  label_on = "cluster by row", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "no cluster",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                column(6, prettyToggle(
                  inputId = "limmaphrowname",
                  label_on = "display row name", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "miss row name",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                conditionalPanel(
                  condition = "input.limmaphcluster == 1",
                  column(6, selectInput("limmaphdistance", h5("clustering distance rows:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                  column(6, selectInput("limmaphclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                ),
                column(12, div(actionButton("limmaphbt", "Plot Heatmap", icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            )
          ),
          conditionalPanel(
            condition = "input.detools == 'SAM'",
            column(
              4,
              panel(
                "",
                heading = "SAM Parameters Setting",
                status = "info",
                column(6,uiOutput('samselect1')),
                column(6,uiOutput('samselect2')),
                column(
                  6,
                  numericInput("samnperms",
                               label = h5("nperms:"),
                               value = 100,
                               min = 0,
                               max = 10000,
                               step = 10)
                ),
                column(
                  6,
                  numericInput("samfdr",
                               label = h5("minimum FDR:"),
                               value = 0.05,
                               min = 0,
                               max = 0.05,
                               step = 0.0000001)
                ),
                column(12,div(actionButton('sambt','Analysis', icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            ),
            column(
              5,
              column(3,actionButton("viewsamfile", "view result file", icon("eye"))),
              column(8, NULL),
              column(
                1,
                downloadBttn(
                  outputId = "samplotdl",
                  label = "",
                  style = "material-flat",
                  color = "default",
                  size = "sm"
                )
              ),
              column(
                12,
                plotOutput("samstatic", width = "100%")
              )
            ),
            column(
              3,
              panel(
                "",
                heading = "Heatmap Parameters Setting",
                status = "warning",
                column(12, selectInput("samphscale", h5("scale:"), choices = c("none", "row", "column"), selected = "row")),
                column(6, prettyToggle(
                  inputId = "samphcluster",
                  label_on = "cluster by row", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "no cluster",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                column(6, prettyToggle(
                  inputId = "samphrowname",
                  label_on = "display row name", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "miss row name",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                conditionalPanel(
                  condition = "input.samphcluster == 1",
                  column(6, selectInput("samphdistance", h5("clustering distance rows:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                  column(6, selectInput("samphclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                ),
                column(12,div(actionButton('samphbt','Plot Heatmap', icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            )
          ),
          conditionalPanel(
            condition = "input.detools == 'ANOVA'",
            column(
              4,
              panel(
                "",
                heading = "ANOVA Parameters Setting",
                status = "info",
                column(6, numericInput("anovafc", h5("FC threshold:"), 20, min = 1, step = 0.5)),
                column(
                  6,
                  selectInput("anovaadjust", h5("p-values adjust method:"), choices = c("none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"), selected = "BH")
                ),
                column(12, numericInput("anovapvalue", h5("pvalue threshold:"), 0.01, max = 0.05, min = 0.0000001, step = 0.0000001)),
                column(12, div(actionButton("anovabt", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
              )
            ),
            column(
              5,
              dataTableOutput("anovaresult")
            ),
            column(
              3,
              panel(
                "",
                heading = "Heatmap Parameters Setting",
                status = "warning",
                column(12, selectInput("anovaphscale", h5("scale:"), choices = c("none", "row", "column"), selected = "row")),
                column(6, prettyToggle(
                  inputId = "anovaphcluster",
                  label_on = "cluster by row", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "no cluster",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                column(6, prettyToggle(
                  inputId = "anovaphrowname",
                  label_on = "display row name", 
                  icon_on = icon("check"),
                  status_on = "info",
                  status_off = "warning", 
                  label_off = "miss row name",
                  icon_off = icon("xmark"),
                  value = TRUE
                )),
                conditionalPanel(
                  condition = "input.anovaphcluster == 1",
                  column(6, selectInput("anovaphdistance", h5("clustering distance rows:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                  column(6, selectInput("anovaphclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                ),
                column(12,div(actionButton('anovaphbt','Plot Heatmap', icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            )
          )
        ),
        tabPanel(
          "Time Course Analysis(fuzzy clustering)",
          h2("Time Course Analysis(fuzzy clustering)", class = "tooltitle"),
          h4("Fuzzy clustering is applied to time course analysis for discovering patterns associated with time points in PhosMap.", class = "toolsubtitle"),
          fluidRow(
            column(
              4,
              panel(
                "",
                heading = "Parameters Setting",
                status = "info",
                column(6, numericInput("tcpvalue", h5("pvalue threshold:"), 0.1, max = 0.05, min = 0.0000001, step = 0.0000001)),
                column(6, selectInput("tcadjust", h5("pvalue adjust method:"), choices = c("none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"), selected = "BH")),
                column(6, numericInput("tcfc", h5("FC threshold:"), 2, min = 1, step = 0.5)),
                column(6, numericInput("tcminmem", h5("minimun membership value:"), 0.1, max = 1, min = 0.0000001, step = 0.0000001)),
                column(6, numericInput("tciteration", h5("iteration:"), 100, max = 1000, min = 10, step = 10)),
                column(6, numericInput("tckcluster", h5("number of clusters:"), 9, max = 20, min = 2, step = 1)),
                column(12, div(actionButton("tcanalysis", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
              )
            ),
            column(
              8,
              column(
                3,
                actionButton("viewtcfile", "view result file", icon("eye"))
              ),
              column(8, NULL),
              column(
                1,
                downloadBttn(
                  outputId = "tcplotdl",
                  label = "",
                  style = "material-flat",
                  color = "default",
                  size = "sm"
                )
              ),
              column(12, plotOutput("timecourse"))
            )
          )
        ),
        tabPanel(
          "Kinase-Substrate Enrichment Analysis",
          h2("Kinase-Substrate Enrichment Analysis", class = "tooltitle"),
          h4("This module is used to predict kinase activity.", class = "toolsubtitle"),
          fluidRow(
            column(
              4,
              radioGroupButtons(
                inputId = "kseamode",
                label = "",
                choices = c("Multiple groups", 
                            "Two groups"),
                justified = TRUE,
                checkIcon = list(
                  yes = icon("ok", 
                             lib = "glyphicon"))
              ),
              conditionalPanel(
                condition = "input.kseamode == 'Multiple groups'",
                panel(
                  "",
                  heading = "Parameters Setting [Step 1]",
                  status = "info",
                  column(6, numericInput("kappvalue", h5("pvalue threshold:"), 0.1, max = 0.05, min = 0.0000001, step = 0.0000001)),
                  column(6, selectInput("kapadjust", h5("pvalue adjust method:"), choices = c("none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"), selected = "BH")),
                  column(6, numericInput("kapfc", h5("FC threshold:"), 2, min = 1, step = 0.5)),
                  column(6, numericInput("kapminmem", h5("minimun membership value:"), 0.1, max = 1, min = 0.0000001, step = 0.0000001)),
                  column(6, numericInput("kapiteration", h5("iteration:"), 100, max = 1000, min = 10, step = 10)),
                  column(6, numericInput("kapkcluster", h5("number of clusters:"), 9, max = 20, min = 2, step = 1)),
                  column(12, div(actionButton("kapanalysisbt1", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
                ),
                panel(
                  "",
                  heading = "Parameters Setting [Step 2]",
                  status = "warning",
                  column(6, uiOutput("kapstep2cluster")),
                  column(6, selectInput("kapspecies", h5("species:"), choices = c("human", "mouse", "rattus"))),
                  column(6, selectInput("kapscale", h5("scale:"), choices = c("none", "row", "column"), selected = "none")),
                  column(6, selectInput("kapdistance", h5("clustering distance rows:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                  column(6, selectInput("kapclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                  column(6, uiOutput("kapmainui")),
                  column(12, div(actionButton("kapanalysisbt2", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
                )
              ),
              conditionalPanel(
                condition = "input.kseamode == 'Two groups'",
                panel(
                  "",
                  heading = "Parameters Setting [Step 1]",
                  status = "info",
                  column(6,uiOutput('kseaselect1')),
                  column(6,uiOutput('kseaselect2')),
                  column(6, numericInput("kseafc", h5("FC threshold:"), 4, min = 1, step = 0.5)),
                  column(12, div(actionButton("kseaanalysisbt1", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
                ),
                panel(
                  "",
                  heading = "Parameters Setting [Step 2]",
                  status = "warning",
                  column(12, selectInput("kseaspecies", h5("species:"), choices = c("human", "mouse", "rattus"))),
                  column(6, selectInput("kseascale", h5("scale:"), choices = c("none", "row", "column"), selected = "none")),
                  column(6, selectInput("kseadistance", h5("clustering distance rows:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                  column(6, selectInput("kseaclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                  column(6, textAreaInput("kseamain", h5("title:"), value = "Kinase-Substrate Enrichment Analysis")),
                  column(12, div(actionButton("kseaanalysisbt2", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
                )
              )
            ),
            column(
              8,
              navbarPage(
                title = "Result",
                id = "kapresultnav",
                tabPanel(
                  "Step 1",
                  value = "kapstep1val",
                  conditionalPanel(
                    condition = "input.kseamode == 'Multiple groups'",
                    column(
                      3,
                      actionButton("viewkaptimecoursefile", "view result file", icon("eye"))
                    ),
                    column(8, NULL),
                    column(
                      1,
                      downloadBttn(
                        outputId = "kaptcplotdl",
                        label = "",
                        style = "material-flat",
                        color = "default",
                        size = "sm"
                      )
                    ),
                    column(12, plotOutput("kaptimecourseplot"))
                  ),
                  conditionalPanel(
                    condition = "input.kseamode == 'Two groups'",
                    dataTableOutput("kseastep1df")
                  )
                ),
                tabPanel(
                  "Step 2",
                  value = "kapstep2val",
                  conditionalPanel(
                    condition = "input.kseamode == 'Multiple groups'",
                    column(11, NULL),
                    column(
                      1,
                      downloadBttn(
                        outputId = "kapplotdl",
                        label = "",
                        style = "material-flat",
                        color = "default",
                        size = "sm"
                      )
                    ),
                    column(12, plotOutput("kapstep2plot")),
                    column(12, dataTableOutput("kapstep2df"))
                  ),
                  conditionalPanel(
                    condition = "input.kseamode == 'Two groups'",
                    uiOutput("kseastep2plotui"),
                    dataTableOutput("kseastep2df")
                  )
                )
              )
            )
          )
        ),
        tabPanel(
          "Motif Enrichment Analysis",
          h2("Motif Enrichment Analysis", class = "tooltitle"),
          h4("This module is used to find and visualize enriched motifs.", class = "toolsubtitle"),
          fluidRow(
            column(
              4,
              panel(
                "",
                heading = "Parameters Setting",
                status = "info",
                column(6, selectInput("motifspecies", h5("species:"), choices = c("human", "mouse", "rattus"))),
                column(6, selectInput("motiffastatype", h5("fasta type:"), choices = c("refseq", "uniprot"))),
                column(6, numericInput("motifpvalue", h5("pvalue threshold:"), 0.01, max = 0.05, min = 0.0000001, step = 0.0000001)),
                column(12, div(actionButton("motifanalysisbt", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
              ),
              panel(
                "",
                heading = "Motif Selection",
                status = "warning",
                uiOutput("motifenrichrank"),
                column(6,div(actionButton('motifplotbt','Plot', icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;"),
                column(6,div(actionButton('motifviewbt','View matched sites')), style = "display:flex; justify-content:center; align-item:center;")
                
              ),
              panel(
                "",
                heading = "Heatmap Parameters Setting",
                status = "danger",
                h5("Assign quantitative values of peptides to their motif", style = "color: grey;"),
                column(12, numericInput("minseqs", h5("matched seqs threshold"), 50, min = 1, step = 1)),
                column(6, selectInput("motifscale", h5("scale:"), choices = c("none", "row", "column"), selected = "none")),
                column(6, selectInput("motifdistance", h5("distance metric:"), choices = c("euclidean", "correlation"), selected = "euclidean")),
                column(6, selectInput("motifclusmethod", h5("clustering method:"), choices = c("ward.D2", "ward.D", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "ward.D2")),
                column(12, textAreaInput("motifmain", h5("title:"), "Heatmap of Motif Quantification")),
                column(12,div(actionButton('motifplotbt2','Plot', icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            ),
            column(8, 
                   column(
                     12, 
                     hidden(
                       div(
                         id = "motifenrichhidden1",
                         hr(),
                         h4("Motif enrichment analysis result:"),
                         dataTableOutput("motifdfresult")
                       )
                     )
                   )
            )
            
          )
        ),
        tabPanel(
          "Survival Analysis",
          h2("Survival Analysis", class = "tooltitle"),
          h4("This module is used to identify phosphorylation sites or kinases associated with clinical outcomes of patients.", class = "toolsubtitle"),
          fluidRow(
            column(
              4,
              panel(
                "",
                heading = "Parameters Setting",
                status = "info",
                column(6, selectInput("survivalpajust", h5("pvalue adjust method:"), choices = c("none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"), selected = "BH")),
                column(6, numericInput("survivalpthreshold", h5("pvalue threshold:"), 0.01, max = 1, min = 0.0000001, step = 0.0000001)),
                column(12, div(actionButton("survivalanalysis", "Analysis", icon("magnifying-glass-chart"), class="analysisbutton")), style = "display:flex; justify-content:center; align-item:center;"),
              ),
              panel(
                "",
                heading = "Feature Selection",
                status = "warning",
                column(12, uiOutput("survivalui")),
                column(6, colourInput("survivalhighcol", h5('"high" colour'), "#3300CC")),
                column(6, colourInput("survivallowcol", h5('"low" colour'), "#CC3300")),
                column(12,div(actionButton('survivalplotbt1','Plot', icon("palette"), class="plotbutton")), style = "display:flex; justify-content:center; align-item:center;")
              )
            ),
            column(
              8,
              column(
                12, dataTableOutput("survivaltable")
              ),
              column(
                5, plotOutput("survivalplot1")
              ),
              column(1, downloadBttn(
                outputId = "surv1dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
              column(
                5, plotOutput("survivalplot2"),
                
              ),
              column(1, downloadBttn(
                outputId = "surv2dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            )
          )
        )
      ),
      tabPanel(
        "Tutorial",
        div(style = "text-align:center;", img(src = "tumain.svg", height = "200px", width = "1000px", style = "")),
        conditionalPanel(
          condition = "input.tutorialtab == 'Web'",
          column(10, HTML('<iframe style="height:1200px; width:90%" src= "manual.pdf">This browser does not support PDFs.Please download the PDF at our github.</iframe>')),
        ),
        conditionalPanel(
          condition = "input.tutorialtab == 'Docker'",
          column(10, HTML('Coming soon')),
        ),
        conditionalPanel(
          condition = "input.tutorialtab == 'R Package'",
          column(10, HTML('Coming soon')),
        ),
        column(
          2,
          radioGroupButtons(
            inputId = "tutorialtab",
            label = "",
            choices = c("Web", 
                        "Docker", 
                        "R Package"),
            direction = "vertical"
          )
        )
        
      ),
      tabPanel(
        "FAQ",
        h2("FAQ", style="align: center;"),
        hr(style = "border-color: grey;"),
        h4("Q1: Where does the example data come from? "),
        h5("WiDr colorectal cancer cells harbouring the BRAF(V600E) mutation after treatment using vemurafenibin a time course of 0, 2, 6, 24, and 48 hour(Ressa,et al.,2018). The raw files were deposited in ProteomeXchange Consortium(PXD007740)."),
        # downloadButton("maxexampledl", "maxquant data", icon = icon("download")),
        # downloadButton("masexampledl", "firmiana data", icon = icon("download")),
        hr(),
        h4("Q2: When I encounter a bug, how do I contact the author? "),
        h5("Please click the github icon to submit issue, we will reply to you as soon as possible."),
        hr(),
        h4("Q3: If I want to pre-process a part of samples, can I change only the experimental design file instead the other data?"),
        h5("Sure."),
        hr(),
        h4("Q4: I encountered this error when uploading files: ''Error: zip error: 'Failed to set mtime on 'profiling_gene_txt//Exp***_gene.txt' while extracting 'C:\\Users\\***\\AppData\\Local\\Temp\\RtmpCa5Mdw\\62c04ab3afa3d1ce11d77f19\\0.zip'' in file 'zip.c:260'''"),
        h5("Please clean up the memory then re-upload."),
        hr(),
        h4("Q5: What is the format of the experimental design file?"),
        h5("Click on the download button below to download the template. Importantly, column 'Experiment_Code' and 'Group' are required."),
        downloadButton("designtemplate", "design file template", icon = icon("download")),
        hr(),
        h4("Q6: What is the format of the clinical data file?"),
        h5("Click on the download button below to download the template. Importantly, all columns are required."),
        downloadButton("clinicaltemplate", "clinical data file template", icon = icon("download"))
      ),
      tabPanel(
        "Download",
        h2("Download", style="align: center;"),
        hr(style = "border-color: grey;"),
        h4("1. PhosMap_datasets.zip for local version:"),
        downloadButton("dldatasets", "PhosMap_datasets.zip"),
        h4("2. 'Preprocessing' example data:"),
        downloadButton("maxexampledl", "maxquant data"),
        downloadButton("masexampledl", "firmiana data"),
        h4("3. 'Analysis' example data:"),
        downloadButton("dlanalysisexample", "analysis data"),
        h4("4. Motif-kinase relation table:"),
        downloadButton("dlmotifkinase", "motif-kinase"),
      ),
      nav_item(a(target="_blank",  href="https://github.com/liuzan-info/PhosMap", icon("github"))),
      collapsible = TRUE
    )
  )
)