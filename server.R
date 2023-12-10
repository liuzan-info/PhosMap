online = F

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#

# Source functions
path1 = "./appearance/"
sapply(list.files(path1), function(x){source(paste0(path1, x))})
path2 = "./backend/"
sapply(list.files(path2), function(x){source(paste0(path2, x))})

server<-shinyServer(function(input, output, session){
  options(shiny.maxRequestSize=1000*1024^2)
  userID <- "_phosmap"
  maxdemopreloc <- paste0("tmp/", userID, "/maxquant/demo/")
  maxuserpreloc <- paste0("tmp/", userID, "/maxquant/user/")
  mascotdemopreloc <- paste0("tmp/", userID, "/mascot/demo/")
  mascotuserpreloc <- paste0("tmp/", userID, "/mascot/user/")
  maxtmtdemopreloc <- paste0("tmp/", userID, "/tmt/demo/")
  maxtmtuserpreloc <- paste0("tmp/", userID, "/tmt/user/")
  dianndemopreloc <- paste0("tmp/", userID, "/diann/demo/")
  diannuserpreloc <- paste0("tmp/", userID, "/diann/user/")
  sndemopreloc <- paste0("tmp/", userID, "/sn/demo/")
  snuserpreloc <- paste0("tmp/", userID, "/sn/user/")
  
  pcaloc <- paste0("tmp/", userID, "/analysis/pca")
  tsneloc <- paste0("tmp/", userID, "/analysis/tsne")
  limmaloc <- paste0("tmp/", userID, "/analysis/limma")
  samloc <- paste0("tmp/", userID, "/analysis/sam")
  tcloc <- paste0("tmp/", userID, "/analysis/tc")
  kaploc <- paste0("tmp/", userID, "/analysis/kap")
  survloc <- paste0("tmp/", userID, "/analysis/surv")
  motifloc <- paste0("tmp/", userID, "/analysis/motif")
  
  if (dir.exists("tmp/")) {
    unlink("tmp/", recursive = TRUE)
  }
  dir.create(maxdemopreloc, recursive = TRUE)
  dir.create(maxuserpreloc, recursive = TRUE)
  dir.create(mascotdemopreloc, recursive = TRUE)
  dir.create(mascotuserpreloc, recursive = TRUE)
  dir.create(maxtmtdemopreloc, recursive = TRUE)
  dir.create(maxtmtuserpreloc, recursive = TRUE)
  dir.create(dianndemopreloc, recursive = TRUE)
  dir.create(diannuserpreloc, recursive = TRUE)
  dir.create(sndemopreloc, recursive = TRUE)
  dir.create(snuserpreloc, recursive = TRUE)
  
  dir.create(pcaloc, recursive = TRUE)
  dir.create(tsneloc, recursive = TRUE)
  dir.create(limmaloc, recursive = TRUE)
  dir.create(samloc, recursive = TRUE)
  dir.create(tcloc, recursive = TRUE)
  dir.create(kaploc, recursive = TRUE)
  dir.create(survloc, recursive = TRUE)
  dir.create(motifloc, recursive = TRUE)
  
  observeEvent(
    input$viewinstall,{
      showModal(modalDialog(
        title = "Tutorial video",
        size = "l",
        h5("If the following video fails to play, you can choose to open these links instead."),
        tags$ol(
          tags$li(
            style = "display: flex; align-items: center;",
            tags$a(
              href = "https://youtu.be/2ZlMqMJjNU8",
              target = "_blank",
              "https://youtu.be/2ZlMqMJjNU8"
            ),
            tags$span(
              style = "color: red; margin-left: 5px;",
              "recommended"
            )
          ),
          tags$li(
            style = "display: flex; align-items: center;",
            tags$a(
              href = "https://www.bilibili.com/video/BV1tj411z7Fe/",
              target = "_blank",
              "https://www.bilibili.com/video/BV1tj411z7Fe/"
            ),
            tags$span(
              style = "color: red; margin-left: 5px;",
              "recommended"
            )
          ),
          tags$li(
            style = "display: flex; align-items: center;",
            tags$a(
              href = "https://bio-inf.shinyapps.io/phosmap_video/",
              target = "_blank",
              "https://bio-inf.shinyapps.io/phosmap_video/"
            )
          )
        ),
        tags$iframe(width="850", height="700", src="https://bio-inf.shinyapps.io/phosmap_video/", frameborder="0", allow="accelerometer; encrypted-media; gyroscope; picture-in-picture", allowfullscreen=NA),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  #######################################
  #######     import data ex      #######
  #######################################
  #1.phosphoproteomics experimental design file
  output$html <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
  output$viewedfile <- renderDataTable({
    dataread <- read.csv("examplefile/maxquant/phosphorylation_exp_design_info.txt",header=T,sep='\t')
    datatable(dataread,options = list(ordering=F))
  })
  
  #actionbutton for viewing data
  observeEvent(
    input$viewbt1,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/maxquant/phosphorylation_exp_design_info.txt",header=T,sep='\t')
        # dataread
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$mascotdemoxmlid,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("2. Mascot xml file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv(paste0("examplefile/root/mascot/mascot_xml/", substr(input$mascotdemoxmlid, 1, 9), "/", input$mascotdemoxmlid, ".txt"), sep = "\t", header=FALSE)
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$mascotdemopeptidefileid,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("3. Phosphoproteomics peptide file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv(paste0("examplefile/mascot/phosphorylation_peptide_txt/", input$mascotdemopeptidefileid, ".txt"), sep = "\t", header=T)
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$viewbt5,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("4.1 Proteomics experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/mascot/profiling_exp_design_info.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$mascotdemoproid,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("4.2 Profiling file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv(paste0("examplefile/mascot/profiling_gene_txt/", input$mascotdemoproid, ".txt"), sep = "\t", header=TRUE)
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$loaddatatype,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/maxquant/phosphorylation_exp_design_info.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$viewdemomaxphosbt,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/maxquant/Phospho (STY)Sites.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$viewdemomaxprodesignbt,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("3.1 Proteomics experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/maxquant/profiling_exp_design_info.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$viewdemomaxprobt,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("3.2 proteinGroups.txt:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/maxquant/proteinGroups.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  # maxquant tmt demo
  observeEvent(
    input$viedemomaxtmtphosbt1,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/tmt/phosphorylation_exp_design_info.txt",header=T,sep='\t')
        # dataread
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$viewdemomaxtmtphosbt2,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/tmt/Phospho (STY)Sites.txt",header=T,sep='\t')
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  # diann demo
  observeEvent(
    input$dianndemoviewbt1,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile <- renderDataTable({
        dataread <- read.csv("examplefile/diann/phosphorylation_exp_design_info.txt",header=T,sep='\t')
        # dataread
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  observeEvent(
    input$dianndemoviewbt2,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("2. report.tsv:")))
      output$viewedfile <- renderDataTable({
        dataread <- as.data.frame(fread("examplefile/diann/report_mini.tsv", stringsAsFactors = FALSE))
        datatable(dataread,options = list(ordering=F))
      })
    }
  )
  
  # sn demo
  observeEvent(
    input$sndemoviewbt2,{
      output$html <- renderUI(div(class = "loadfiledescription", HTML("2. Report.xls:")))
      output$viewedfile <- renderDataTable({
        file.rename("examplefile/SN/20231122_1_Report.xls", "examplefile/SN/20231122_1_Report.csv")
        sn_df <- read.csv("examplefile/SN/20231122_1_Report.csv", sep = '\t', check.names=F)
        file.rename("examplefile/SN/20231122_1_Report.csv", "examplefile/SN/20231122_1_Report.xls")
        datatable(sn_df,options = list(ordering=F))
      })
    }
  )
  
  #######################################
  #######     import data user    #######
  #######################################
  designfile <- reactive({
    files = input$updesign
    if (is.null(files)){
      
    }else{
      dataread <- read.csv(files$datapath, header=T, sep="\t")
    }
  })
  
  # display file by dataframe in main
  observeEvent(
    input$updesign,{
      shinyjs::show(id = "hiddenview1", anim = FALSE)
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile2 <- renderDataTable({
        datatable(designfile(), options = list(pageLength = 10))
      })
    }
  )

  # when pressing viewbt4, display designfile by dataframe in main
  observeEvent(
    input$viewbt4,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("1. Experimental design file:")))
      output$viewedfile2 <- renderDataTable({
        datatable(designfile(), options = list(pageLength = 10))
      })
    }
  )
  
  # maxquant
  usermaxphos <- reactive({
    files = input$upusermaxphos
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header = T, sep = "\t")
    }
  })
  
  observeEvent(
    input$upusermaxphos,{
      shinyjs::show(id = "hidviewusermaxphosbt", anim = FALSE)
      data <- usermaxphos()
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(data,options = list(ordering=F))})
      if(!('Gene.names' %in% colnames(data))){
        sendSweetAlert(
          session = session,
          title = "Error...",
          text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
          type = "error",
          btn_labels = "I will rerun MaxQuant"
        )
        shinyjs::show(id = "hidviewusermaxphosbtwarning", anim = FALSE)
      } else {
        shinyjs::hide(id = "hidviewusermaxphosbtwarning", anim = FALSE)
      }
    }
  )
  
  observeEvent(
    input$viewusermaxphosbtwarning, {
      sendSweetAlert(
        session = session,
        title = "Error...",
        text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
        type = "error",
        btn_labels = "I will rerun MaxQuant"
      )
    }
  )

  observeEvent(
    input$viewusermaxphosbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(usermaxphos(),options = list(ordering=F))})
    }
  )
  
  usermaxprodesign <- reactive({
    files = input$upusermaxprodesign
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header = T, sep = "\t")
    }
    datatable(dataread,options = list(ordering=F))
  })
  
  observeEvent(
    input$upusermaxprodesign,{
      shinyjs::show(id = "hidviewusermaxprodesignbt", anim = FALSE)
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("3.1 Proteomics experimental design file:")))
      output$viewedfile2 <- renderDataTable({usermaxprodesign()})
    }
  )
  
  observeEvent(
    input$viewusermaxprodesignbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("3.1 Proteomics experimental design file:")))
      output$viewedfile2 <- renderDataTable({usermaxprodesign()})
    }
  )
  
  usermaxpro <- reactive({
    files = input$upusermaxpro
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header = T, sep = "\t")
    }
  })
  
  observeEvent(
    input$upusermaxpro,{
      shinyjs::show(id = "hidviewusermaxprobt", anim = FALSE)
      data <- usermaxpro()
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("3.2 proteinGroups.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(data,options = list(ordering=F))})
      if(!('Gene.names' %in% colnames(data))){
        sendSweetAlert(
          session = session,
          title = "Error...",
          text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
          type = "error",
          btn_labels = "I will rerun MaxQuant"
        )
        shinyjs::show(id = "hidviewusermaxprobtwarning", anim = FALSE)
      } else {
        shinyjs::hide(id = "hidviewusermaxprobtwarning", anim = FALSE)
      }
    }
  )
  
  observeEvent(
    input$viewusermaxprobtwarning, {
      sendSweetAlert(
        session = session,
        title = "Error...",
        text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
        type = "error",
        btn_labels = "I will rerun MaxQuant"
      )
    }
  )

  observeEvent(
    input$viewusermaxprobt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("3.2 proteinGroups.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(usermaxpro(),options = list(ordering=F))})
    }
  )
  
  
  # mascot
  # extract the file and obtain the storage path
  mascotfilepath <- reactive({
    # check file format
    validate(need(tools::file_ext(input$upmascot) == "zip", "File extension should be '.zip'"))
    path <- get_file_path(input$upmascot, paste0(mascotuserpreloc, "mascotxml_data"))
    path
  })
  
  # Get a list of file names without suffixes based on the path
  mascottargetnames <- reactive({
    names <- get_target_name(mascotfilepath(), 2)
    names
  })
  
  # Get the full file path and change the suffix to.txt for reading fastly
  mascottargetpath <- reactive({
    file1 = normalizePath(list.files(mascotfilepath(), full.names = T))
    file2 = list.files(file1, full.names = T)
    for (f in file2){
      tmpname <- substring(f, 0, nchar(f)-4)
      newname <- sub("$", ".txt", tmpname)
      file.rename(f, newname)
    }
    list.files(file1, full.names = T)
  })
  
  # view button only shows after mascotfile is uploaded
  observeEvent(input$upmascot,{
    output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Mascot xml file:")))
    output$masui <- renderUI({
      return(
        selectInput(
          "upmascotfileid", 
          NULL, 
          choices = mascottargetnames()
        )
      )
    })
  })
  
  observeEvent(
    input$upmascotfileid,{
      output$viewedfile2 <- renderDataTable({
        library(data.table)
        upmascotfile <- reactive({
          id = input$upmascotfileid
          index = which(mascottargetnames() == id)
          path = mascottargetpath()[index]
          dataread <- read.csv(path, header=FALSE, sep="\t")
          datatable(dataread,options = list(ordering=F))
        })
        upmascotfile()
      })
    }
  )
  
  # extract the file and obtain the storage path
  pepfilepath <- reactive({
    # check file format
    validate(need(tools::file_ext(input$uppeptide) == "zip", "File extension should be '.zip'"))
    path <- get_file_path(input$uppeptide, paste0(mascotuserpreloc, "peptide_data"))
    path
  })
  
  # Get a list of file names without suffixes based on the path
  peptargetnames <- reactive({
    names <- get_target_name(pepfilepath(), 1)
    names
  })
  
  # Get the full file path 
  peptargetpath <- reactive({
    file = normalizePath(list.files(pepfilepath(), full.names = T))
    file
  })
  
  # view button only shows after peptidefile is uploaded
  observeEvent(input$uppeptide,{
    output$html2 <- renderUI(div(class = "loadfiledescription", HTML("3. Phosphoproteomics peptide file:")))
    output$pepui <- renderUI({
      return(
        selectInput(
          "uppepfileid", 
          NULL, 
          choices = peptargetnames()
        )
      )
    })
  })
  
  observeEvent(
    input$uppepfileid,{
      output$viewedfile2 <- renderDataTable({
        library(data.table)
        uppepfileid <- reactive({
          id = input$uppepfileid
          # Determine the file path based on the relative index position
          index = which(peptargetnames() == id)
          path = peptargetpath()[index]
          dataread <- read.csv(path, header=T, sep="\t")
          datatable(dataread,options = list(ordering=F))
        })
        uppepfileid()
      })
    }
  )

  # Proteomics experimental design file
  prodesignfile <- reactive({
    files = input$upprodesign
    if (is.null(files)){
      
    }else{
      dataread <- read.csv(files$datapath, header=T, sep="\t")
      datatable(dataread,options = list(ordering=F))
    }
  })
  
  # Display file by dataframe in main
  observeEvent(
    input$upprodesign,{
      shinyjs::show(id = "prohiddenview", anim = FALSE)
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("4.1 Proteomics experimental design file:")))
      output$viewedfile2 <- renderDataTable({
        prodesignfile()
      })
    }
  )

  # When pressing proviewbt, display designfile by dataframe in main
  observeEvent(
    input$proviewbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("4.1 Proteomics experimental design file:")))
      output$viewedfile2 <- renderDataTable({
        # datatable(prodesignfile(), options = list(pageLength = 10))
        prodesignfile()
      })
    }
  )
  
  # extract the file and obtain the storage path
  propath <- reactive({
    # check file format
    validate(need(tools::file_ext(input$upprogene) == "zip", "File extension should be '.zip'"))
    path <- get_file_path(input$upprogene, paste0(mascotuserpreloc, "proteomics_data"))
    path
  })
  
  # Get a list of file names without suffixes based on the path
  protargetnames <- reactive({
    names <- get_target_name(propath(), 1)
    names
  })
  
  # Get the full file path 
  protargetpath <- reactive({
    file = normalizePath(list.files(propath(), full.names = T))
    file
  })
  
  # view button only shows after peptidefile is uploaded
  observeEvent(input$upprogene,{
    output$html2 <- renderUI(div(class = "loadfiledescription", HTML("4.2 Profiling file:")))
    output$progeneui <- renderUI({
      return(
        selectInput(
          "upproid", 
          NULL, 
          choices = protargetnames()
        )
      )
    })
  })
  
  observeEvent(
    input$upproid,{
      output$viewedfile2 <- renderDataTable({
        upproid_ <- reactive({
          id = input$upproid
          # Determine the file path based on the relative index position
          index = which(protargetnames() == id)
          path = protargetpath()[index]
          dataread <- read.csv(path, header=T, sep="\t")
          datatable(dataread,options = list(ordering=F))
        })
        upproid_()
      })
    }
  )
  
  output$userdesigndl <- downloadHandler(
    filename = "experimental_design_template.txt",
    content = function(file) {file.copy("examplefile/maxquant/phosphorylation_exp_design_info.txt", file)}
  )
  
  instruction_design <- HTML("In this file, the <strong>'Experiment_Code'</strong> column and 
               the <strong>'Group'</strong> column are required, and the column 
               names cannot be changed. </br> </br>
                 1. Each item in the <strong>'Experiment_Code'
               </strong> column can be of any type, but must be unique, and is 
               considered as the unique identifier for the sample.</br> </br>
                 2. Each item in the <strong>'Group'</strong> column can be of 
               any type, and the 
               same value indicates that the samples belong to the same group. 
               In the case data, the numbers represent the processing time.</br> </br>
               
               The <strong>'Description'</strong> column is optional, and its 
               content can be anything you enter, such as the original mass 
               spectrum file name used in the case data.</br> </br>
               
               The <strong>'Pair'</strong> column is optional.If there is no pair 
               information, you can either fill the 'Pair' column with 0, or leave
               it blank. Otherwise, 'Pair' numbers of paired 
               samples should be the same. Click the button to download the 
               template with 'Pair' information.")
  # maxqunt
  observeEvent(
    input$userdesigninstruction,{
      showModal(modalDialog(
        title = "Experimental design file",
        size = "l",
        tags$p(instruction_design),
        downloadBttn(
          outputId = "pairedtemplatedl",
          label = "",
          style = "material-flat",
          color = "default",
          size = "sm"
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$pairedtemplatedl <- downloadHandler(
    filename = "design_file_with_Pair.txt",
    content = function(file) {file.copy("examplefile/analysistools/case2/phosphorylation_exp_design_info_with_pair.txt", file)}
  )
  
  output$userphosmaxdl <- downloadHandler(
    filename = "Phospho (STY)Sites.txt",
    content = function(file) {file.copy("examplefile/maxquant/Phospho (STY)Sites.txt", file)}
  )
  output$userpromaxdl <- downloadHandler(
    filename = "proteinGroups.txt",
    content = function(file) {file.copy("examplefile/maxquant/proteinGroups.txt", file)}
  )
  
  observeEvent(
    input$userphosmaxinstruction,{
      showModal(modalDialog(
        title = "Phospho (STY)Sites.txt",
        size = "l",
        tags$p(
          HTML("This file comes directly from the identically-named result file of MaxQuant.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$userprodesigndl <- downloadHandler(
    filename = "proteomics_design_template.txt",
    content = function(file) {file.copy("examplefile/maxquant/profiling_exp_design_info.txt", file)}
  )
  
  observeEvent(
    input$userprodesigninstruction,{
      showModal(modalDialog(
        title = "Proteomics experimental design file",
        size = "l",
        tags$p(instruction_design),
        downloadBttn(
          outputId = "pairedtemplatedl2",
          label = "",
          style = "material-flat",
          color = "default",
          size = "sm"
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$pairedtemplatedl2 <- downloadHandler(
    filename = "design_file_with_Pair.txt",
    content = function(file) {file.copy("examplefile/analysistools/case2/phosphorylation_exp_design_info_with_pair.txt", file)}
  )
  
  observeEvent(
    input$userpromaxinstruction,{
      showModal(modalDialog(
        title = "proteinGroups.txt",
        size = "l",
        tags$p(
          HTML("This file comes directly from the identically-named result file of MaxQuant.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  # mascot
  observeEvent(
    input$usermascotxmlinstruction,{
      showModal(modalDialog(
        title = "Mascot xml file",
        size = "l",
        tags$p(
          HTML("This compressed file is obtained by compressing the corresponding
               output of Mascot. For specific details, please refer to the manual
               in the Tutorial module.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  observeEvent(
    input$usermascotpepinstruction,{
      showModal(modalDialog(
        title = "Phosphoproteomics peptide file",
        size = "l",
        tags$p(
          HTML("This compressed file is obtained by compressing the corresponding
               output of Firmiana. For specific details, please refer to the manual
               in the Tutorial module.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$userpromascotdesigndl <- downloadHandler(
    filename = "proteomics_design_template.txt",
    content = function(file) {file.copy("examplefile/maxquant/profiling_exp_design_info.txt", file)}
  )
  
  observeEvent(
    input$userpromascotdesigninstruction,{
      showModal(modalDialog(
        title = "Proteomics experimental design file",
        size = "l",
        tags$p(instruction_design),
        downloadBttn(
          outputId = "pairedtemplatedl3",
          label = "",
          style = "material-flat",
          color = "default",
          size = "sm"
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$pairedtemplatedl3 <- downloadHandler(
    filename = "design_file_with_Pair.txt",
    content = function(file) {file.copy("examplefile/analysistools/case2/phosphorylation_exp_design_info_with_pair.txt", file)}
  )

  observeEvent(
    input$usermascotprofilinginstruction,{
      showModal(modalDialog(
        title = "Profiling file",
        size = "l",
        tags$p(
          HTML("This compressed file is obtained by compressing the corresponding
               output of Firmiana. For specific details, please refer to the manual
               in the Tutorial module.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$usermascotxmldl <- downloadHandler(
    filename = "mascot_xml.zip",
    content = function(file) {file.copy("examplefile/download/mascot_xml.zip", file)}
  )
  output$usermascotpepdl <- downloadHandler(
    filename = "phosphorylation_peptide_txt.zip",
    content = function(file) {file.copy("examplefile/download/phosphorylation_peptide_txt.zip", file)}
  )
  output$usermascotprodl <- downloadHandler(
    filename = "profiling_gene_txt.zip",
    content = function(file) {file.copy("examplefile/download/profiling_gene_txt.zip", file)}
  )
  
  
  # max tmt
  output$userphosmaxtmtdl <- downloadHandler(
    filename = "Phospho (STY)Sites.txt",
    content = function(file) {file.copy("examplefile/tmt/Phospho (STY)Sites.txt", file)}
  )
  observeEvent(
    input$userphosmaxtmtinstruction,{
      showModal(modalDialog(
        title = "Phospho (STY)Sites.txt",
        size = "l",
        tags$p(
          HTML("This file comes directly from the identically-named result file of MaxQuant.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  usermaxtmtphos <- reactive({
    files = input$upusermaxtmtphos
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header = T, sep = "\t")
    }
  })
  observeEvent(
    input$upusermaxtmtphos,{
      shinyjs::show(id = "hidviewusermaxtmtphosbt", anim = FALSE)
      data <- usermaxtmtphos()
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(data,options = list(ordering=F))})
      if(!('Gene.names' %in% colnames(data))){
        sendSweetAlert(
          session = session,
          title = "Error...",
          text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
          type = "error",
          btn_labels = "I will rerun MaxQuant"
        )
        shinyjs::show(id = "hidviewusermaxtmtphosbtwarning", anim = FALSE)
      } else {
        shinyjs::hide(id = "hidviewusermaxtmtphosbtwarning", anim = FALSE)
      }
    }
  )
  observeEvent(
    input$viewusermaxtmtphosbtwarning, {
      sendSweetAlert(
        session = session,
        title = "Error...",
        text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
        type = "error",
        btn_labels = "I will rerun MaxQuant"
      )
    }
  )
  
  observeEvent(
    input$viewusermaxtmtphosbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Phospho (STY)Sites.txt:")))
      output$viewedfile2 <- renderDataTable({datatable(usermaxtmtphos(),options = list(ordering=F))})
    }
  )
  
  # sn
  output$userphossndl <- downloadHandler(
    filename = "20231122_1_Report.xls",
    content = function(file) {file.copy("examplefile/SN/20231122_1_Report.xls", file)}
  )
  observeEvent(
    input$userphossninstruction,{
      showModal(modalDialog(
        title = "Report.xls",
        size = "l",
        tags$p(
          HTML("This file comes directly from the identically-named result file of Spectronaut. Please make sure to export 'PEP.MS2Quantity' information in Spectronaut.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  usersnphos <- reactive({
    files = input$upusersnphos
    if(is.null(files)){
      dataread <- NULL
    }else{
      old_filename <- files$datapath
      new_filename <- sub(".xls$", ".csv", old_filename)
      file.rename(old_filename, new_filename)
      sn_df <- read.csv(new_filename, sep = '\t', check.names=F)
      file.rename(new_filename, old_filename)
      sn_df
    }
  })
  observeEvent(
    input$upusersnphos,{
      shinyjs::show(id = "hidviewusersnphosbt", anim = FALSE)
      data <- usersnphos()
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Report.xls:")))
      output$viewedfile2 <- renderDataTable({datatable(data,options = list(ordering=F))})
      if(!(any(grepl("PEP.MS2Quantity$", colnames(data))))){
        sendSweetAlert(
          session = session,
          title = "Error...",
          text = "The data format is wrong because you did not export 'PEP.MS2Quantity' information in Spectronaut",
          type = "error",
          btn_labels = "I will rerun Spectronaut"
        )
        shinyjs::show(id = "hidviewusersnphosbtwarning", anim = FALSE)
      } else {
        shinyjs::hide(id = "hidviewusersnphosbtwarning", anim = FALSE)
      }
    }
  )
  observeEvent(
    input$viewusersnphosbtwarning, {
      sendSweetAlert(
        session = session,
        title = "Error...",
        text = "The data format is wrong because you did not export 'PEP.MS2Quantity' information in Spectronaut",
        type = "error",
        btn_labels = "I will rerun Spectronaut"
      )
    }
  )
  
  observeEvent(
    input$viewusersnphosbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. Report.xls:")))
      output$viewedfile2 <- renderDataTable({datatable(usersnphos(),options = list(ordering=F))})
    }
  )
  
  # diann
  output$userphosdianndl <- downloadHandler(
    filename = "report.tsv",
    content = function(file) {file.copy("examplefile/diann/report_mini.tsv", file)}
  )
  observeEvent(
    input$userphosdianninstruction,{
      showModal(modalDialog(
        title = "report.tsv",
        size = "l",
        tags$p(
          HTML("This file comes directly from the identically-named result file of DiaNN.")
        ),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  userdiannphos <- reactive({
    files = input$upuserdiannphos
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- as.data.frame(fread(files$datapath, stringsAsFactors = FALSE))
    }
  })
  observeEvent(
    input$upuserdiannphos,{
      shinyjs::show(id = "hidviewuserdiannphosbt", anim = FALSE)
      data <- userdiannphos()
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. report.tsv:")))
      output$viewedfile2 <- renderDataTable({datatable(data,options = list(ordering=F))})
      # if(!('Gene.names' %in% colnames(data))){
      #   sendSweetAlert(
      #     session = session,
      #     title = "Error...",
      #     text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
      #     type = "error",
      #     btn_labels = "I will rerun MaxQuant"
      #   )
      #   shinyjs::show(id = "hidviewuserdiannphosbtwarning", anim = FALSE)
      # } else {
      #   shinyjs::hide(id = "hidviewuserdiannphosbtwarning", anim = FALSE)
      # }
    }
  )
  # observeEvent(
  #   input$viewuserdiannphosbtwarning, {
  #     sendSweetAlert(
  #       session = session,
  #       title = "Error...",
  #       text = "The data format is wrong because you did not select the correct 'identifier rule' for the fasta file on maxquant software",
  #       type = "error",
  #       btn_labels = "I will rerun MaxQuant"
  #     )
  #   }
  # )
  observeEvent(
    input$viewuserdiannphosbt,{
      output$html2 <- renderUI(div(class = "loadfiledescription", HTML("2. report.tsv:")))
      output$viewedfile2 <- renderDataTable({datatable(userdiannphos(),options = list(ordering=F))})
    }
  )
  
  # sample quality control
  observeEvent(
    input$samplequalityinspector, {
      output$samplequalityinspectorplot <- renderPlot({
        # if(input$loaddatatype == T) {}
        if(input$mstech == 1 & input$softwaretype == 1) {  # max label-free
          if(input$loaddatatype == T) {
            filenames <- read.csv('examplefile/maxquant/phosphorylation_exp_design_info.txt',header = T,sep='\t')
            rawdata <- read.csv('examplefile/maxquant/Phospho (STY)Sites.txt', sep = "\t")
          } else {
            if(is.null(input$upusermaxphos)|is.null(input$updesign)) {
              filenames <- NULL
            } else {
              rawdata <- read.csv(input$upusermaxphos$datapath,header=T,sep='\t')
              filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
            }
          }
          
          if(!is.null(filenames)) {
            rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
            rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
            rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
            varnames <- c()
            for(i in 1:nrow(filenames)){
              varnames[i] <- paste('Intensity',filenames$Experiment_Code[i],sep = '.')
            }
          }
        }
        if(input$mstech == 1 & input$softwaretype == 2) {  # mascot
          filenames <- NULL
        }
        if(input$mstech == 2 & input$lddasoftwaretype == 1) {  # max tmt
          if(input$loaddatatype == T) {
            filenames <- read.csv('examplefile/tmt/phosphorylation_exp_design_info.txt',header = T,sep='\t')
            rawdata <- read.csv('examplefile/tmt/Phospho (STY)Sites.txt', sep = "\t")
          } else {
            if(is.null(input$upusermaxtmtphos)|is.null(input$updesign)) {
              filenames <- NULL
            } else {
              rawdata <- read.csv(input$upusermaxtmtphos$datapath,header=T,sep='\t')
              filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
            }
          }
          
          if(!is.null(filenames)) {
            rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
            rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
            rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
            varnames <- c()
            for(i in 1:nrow(filenames)){
              varnames[i] <- paste0('Reporter.intensity.corrected.',filenames$Experiment_Code[i],'___1')
            }
          }
        }
        if(input$mstech == 3 & input$diasoftwaretype == 2) {  # diann
          if(input$loaddatatype == T) {
            filenames <- read.csv('examplefile/diann/phosphorylation_exp_design_info.txt',header = T,sep='\t')
            diann_df <- as.data.frame(fread('examplefile/diann/report_mini.tsv', stringsAsFactors = FALSE))
          } else {
            if(is.null(input$upuserdiannphos)|is.null(input$updesign)) {
              filenames <- NULL
            } else {
              diann_df <- as.data.frame(fread(input$upuserdiannphos$datapath, stringsAsFactors = FALSE))
              filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
            }
          }
          
          if(!is.null(filenames)) {
            diann_df <- diann_df %>% filter(Run %in% filenames$Experiment_Code)
            
            fasta_file = 'PhosMap_datasets/fasta_library/uniprot/human/human_uniprot_fasta.txt'
            PHOSPHATE_LIB_FASTA_DATA = utils::read.table(file=fasta_file, header=TRUE, sep="\t")
            
            diann_df_var <- c("Run", "Protein.Group", "Genes", "PG.MaxLFQ", "Modified.Sequence", "Stripped.Sequence", "PTM.Q.Value")
            diann_df <- diann_df[diann_df_var]
            
            # Dont filter in module 'sample check'
            # diann_df <- diann_df[which(diann_df$PTM.Q.Value <= input$diannptmqvalue),]
            
            for (i in 1:nrow(diann_df)) {
              if(!(i %% 5000)) {
                showNotification(
                  paste0("Processing, please wait. Currently completed processing ", i, " out of ", nrow(diann_df), " rows of data."),
                  duration = 3  # second
                )
              }
              diann_df_modified_seq <- diann_df[i, "Modified.Sequence"]
              # Check Phospho
              match_result <- regexpr("\\(UniMod:21\\)", diann_df_modified_seq)
              if(match_result != -1) {
                substring <- substr(diann_df_modified_seq, 1, match_result - 1)
                updated_string <- gsub("\\([^()]+\\)", "", substring)
                index_pep <- nchar(updated_string)
                site_type <- substr(updated_string, index_pep, index_pep)
              } else {
                index_pep <- -1
                site_type <- 'non-phos'
              }
              if(index_pep != -1) {
                # Find peptide in whole protein
                diann_df_seq <- diann_df[i, "Stripped.Sequence"]
                source_seq <- PHOSPHATE_LIB_FASTA_DATA[PHOSPHATE_LIB_FASTA_DATA$ID == diann_df[i, "Protein.Group"],]$Sequence
                matches <- gregexpr(diann_df_seq, source_seq)
                if (length(matches) > 0 && any(matches[[1]] != -1)) {  # some protein not in fasta file
                  start_positions <- matches[[1]]
                  notfound <- 0  # found
                } else {
                  start_positions <- -1
                  notfound <- 1  # dont find pep in protein, maybe need update fasta file.
                }
                if(length(start_positions) == 1) {
                  if(start_positions != -1) {
                    # Get index in protein
                    index <- start_positions[1] + index_pep - 1
                    phospho_site <- paste0(site_type, index)
                    upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
                  } else {
                    index <- -1
                    phospho_site <- paste0(site_type, index)
                    upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
                  }
                } else {
                  index <- -2
                  phospho_site <- paste0(site_type, index)
                  upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
                }
              } else {
                index <- -3
                notfound <- -1
                phospho_site <- paste0(site_type, index)
                upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
              }
              # Modify p-site to lower case
              if(notfound == 0 & index != -2) {
                part1 <- substr(diann_df_seq, 1, index_pep - 1)
                part2 <- tolower(substr(diann_df_seq, index_pep, index_pep))
                part3 <- substr(diann_df_seq, index_pep + 1, nchar(diann_df_seq))
                diann_df_seq <- paste0(part1, part2, part3)
              } else {
                diann_df_seq <- -1
              }
              diann_df[i, "upsID"] <- upsID
              diann_df[i, "Sequence"] <- diann_df_seq
              diann_df[i, "index"] <- index  # the index of phospho-site in corresponding protein. -1: not found,equal 'not found=1'; -2: multi phospho-site; -3: no phospho-site,equal 'not found=-1'
              diann_df[i, "notfound"] <- notfound  # 0: found; 1: not found; -1: no phospho-site
            }
            
            # Following information maybe useful in future.
            diann_df_notfound = diann_df[which(diann_df$notfound == 1),]
            diann_df_other_modify = diann_df[which(diann_df$notfound == -1),]
            diann_df_phos = diann_df[which(diann_df$notfound == 0),]
            diann_df_phos_multi = diann_df_phos[which(diann_df_phos$index == -2),]
            diann_df_phos_single = diann_df_phos[which(diann_df_phos$index != -2),]
            
            final_diann_df_phos_single = diann_df_phos_single[c("upsID", "Sequence", "PG.MaxLFQ", "Run")]
            
            grouped_df <- final_diann_df_phos_single %>%
              group_by(upsID, Run) %>%
              summarise(Sequence = first(Sequence), PG.MaxLFQ = sum(PG.MaxLFQ))
            
            grouped_df <- grouped_df %>%
              group_by(upsID) %>%
              mutate(Sequence = first(Sequence))
            
            rawdata <- grouped_df %>%
              pivot_wider(names_from = Run, values_from = PG.MaxLFQ, values_fill = 0)
            
            varnames <- filenames$Experiment_Code
          }
        }
        if(input$mstech == 3 & input$diasoftwaretype == 1) {  # sn
          if(input$loaddatatype == T) {
            filenames <- read.csv('examplefile/diann/phosphorylation_exp_design_info.txt',header = T,sep='\t')
            data_summary_path <- 'examplefile/SN/20231122_1_Report.xls'
            new_filename <- sub(".xls$", ".csv", data_summary_path)
            file.rename(data_summary_path, new_filename)
            rawdata <- read.csv(new_filename, sep = '\t', check.names=F)
            file.rename(new_filename, data_summary_path)
          } else {
            if(is.null(input$upusersnphos)|is.null(input$updesign)) {
              filenames <- NULL
            } else {
              filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
              old_filename <- input$upusersnphos$datapath
              new_filename <- sub(".xls$", ".csv", old_filename)
              file.rename(old_filename, new_filename)
              rawdata <- read.csv(new_filename, sep = '\t', check.names=F)
              file.rename(new_filename, old_filename)
            }
          }
          
          if(!is.null(filenames)) {
            colnames(rawdata) <- sub("\\[\\d+\\] (.*)\\.raw\\.PEP\\.MS2Quantity", "\\1", colnames(rawdata))
            rawdata <- rawdata[-which(rawdata$PG.ProteinAccessions == "" | rawdata$PG.Genes == "" | rawdata$EG.ProteinPTMLocations == "" | rawdata$EG.ModifiedSequence == ""),]
            varnames <- filenames$Experiment_Code
          }
        }
        
        if(is.null(filenames)) {
          plot.new()
          text(x = 0.5, y = 0.5, labels = "Please check after uploading the file. \nThis feature is not supported by Firmiana Data at the moment.", cex = 2)
        } else {
          newdata <- rawdata[varnames]
          colnames(newdata) <- filenames$Experiment_Code
          zero_counts <- apply(newdata, 2, function(x) sum(x == 0 | is.na(x)))
          nonzero_counts <- apply(newdata, 2, function(x) sum(x != 0 & !is.na(x)))
          
          data <- data.frame(column = colnames(newdata), Missing = zero_counts, Detection = nonzero_counts)
          
          data_long <- gather(data, key = "class", value = "value", Detection, Missing)
          
          p <- ggplot(data_long) +
            geom_bar(aes(x = column, y = value, fill = class), stat = "identity", position = position_stack(reverse = TRUE)) +
            scale_fill_manual(values = c("#fec44f", "grey")) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10),
                  axis.text.y = element_text(size = 10),
                  axis.title.x = element_text(size = 12),
                  axis.title.y = element_text(size = 12)) +
            labs(x = "Sample", y = "The Number of p-site")
          ggsave(paste('tmp/',userID,'/sample_quality.pdf',sep=''), p, height = 5, width = 6) 
        }
        
        p
      })
      
      showModal(modalDialog(
        title = "Sample Quality Control",
        size = "l",
        tags$p(
          HTML("The detection status of each sample, with a low detection count indicating poor data quality. 
               You can remove low-quality samples in the design file without the need to manipulate other files. PhosMap will automatically handle the remaining tasks for you.")
        ),
        plotOutput("samplequalityinspectorplot"),
        div(downloadButton("samplequalinspecplotdl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = F,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$samplequalinspecplotdl <- downloadHandler(
    filename = function(){paste("sample_quality", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/sample_quality.pdf',sep=''),file)
    }
  )
  #######################################
  #######     preprocessing       #######
  #######################################
  
  # example
  # maxquant
  observeEvent(
    input$demomaxqcbt, {
      rawdata <- read.csv("examplefile/maxquant/Phospho (STY)Sites.txt",header=T,sep='\t')
      filenames <- read.csv('examplefile/maxquant/phosphorylation_exp_design_info.txt',header = T,sep='\t')
      rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
      rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
      rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
      
      varnames <- c()
      for(i in 1:nrow(filenames)){
        varnames[i] <- paste('Intensity',filenames$Experiment_Code[i],sep = '.')
      }
      varnames <- gsub('-','.',varnames)
      myvar <- c('Localization.prob','Score', 'Leading.proteins','Gene.names','Amino.acid', 'Positions', 'Phospho..STY..Probabilities', 'Position.in.peptide', varnames)
      newdata <- rawdata[myvar]
      
      Genenames <- apply(data.frame(newdata$Gene.names), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      Positions <- apply(data.frame(newdata$Positions), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      Leadingproteins <- apply(data.frame(newdata$Leading.proteins), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      newdata$Gene.names <- Genenames
      newdata$Positions <- Positions
      newdata$Leading.proteins <- Leadingproteins
      
      newdata2 <- newdata[which(newdata$Localization.prob >= input$minqclocalizationprob & newdata$Score >= input$minqcscore),]
      
      NAnumthre <- length(filenames$Experiment_Code) - input$maxphosNAthre
      if(NAnumthre < 0) {NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(newdata2)) {
        NAnumthresig[row] <- (sum(newdata2[row,][-c(seq(8))] == 0) <= NAnumthre)
      }
      newdata3 <- newdata2[NAnumthresig,]
      
      aminoposition <- paste0(newdata3$Amino.acid, newdata3$Positions)
      ID <- paste(newdata3$Gene.names, aminoposition, sep = '_')
      rowname <- paste(newdata3$Leading.proteins, ID, sep = '_')
      
      sequence <- gsub("\\(.*?\\)","",newdata3$Phospho..STY..Probabilities)
      Sequence <- c()
      for (i in seq(length(sequence))) {
        tmp <- unlist(str_split(sequence[i], pattern = ""))
        index <- newdata3$Position.in.peptide[i]
        tmp[index] <- tolower(tmp[index])
        
        Sequence[i] <- paste(tmp, collapse = "")
      }
      
      newdata3out <- newdata3[-c(seq(8))]  
      rownames(newdata3out) <- rowname
      
      newdata3motif <- data.frame(aminoposition, Sequence, newdata3$Leading.proteins, newdata3out)
      colnames(newdata3motif) <- c("AA_in_protein", "Sequence", "ID", filenames$Experiment_Code)
      newdata3out <- data.frame(ID, newdata3out)
      colnames(newdata3out) <- c("ID", filenames$Experiment_Code)
      
      newdata3motif <- newdata3motif[!duplicated(newdata3out$ID),]
      newdata3out <- newdata3out[!duplicated(newdata3out$ID),]
      
      write.csv(newdata3out, paste0(maxdemopreloc, "DemoPreQc.csv"), row.names = T)
      write.csv(newdata3motif, paste0(maxdemopreloc, "DemoPreQcForMotifAnalysis.csv"), row.names = F)
      output$demomaxresult1 <- renderDataTable({
        datatable(newdata3out, options = list(pageLength = 10))
      })
      output$demomaxdropproresult1 <- renderDataTable({
        datatable(newdata3out, options = list(pageLength = 10))
      })

      updateTabsetPanel(session, "demomaxresultnav", selected = "demomaxstep1val")
      updateTabsetPanel(session, "demomaxdropproresultnav", selected = "demomaxdropprostep1val")
      updateActionButton(session, "demomaxqcbt", icon = icon("rotate-right"))
      updateActionButton(session, "demomaxnormbt", icon = icon("play"))
      updateActionButton(session, "demomaxnormprobt", icon = icon("play"))
      
      if(input$maxuseprocheck1 == 1) {
        updateProgressBar(session = session, id = "demomaxpreprobar", value = 33)
      } else {
        updateProgressBar(session = session, id = "demomaxpreprobar", value = 50)
      }
    }
  )

  observeEvent(
    input$demomaxnormbt, {
      if(!file.exists(
        paste0(maxdemopreloc, "DemoPreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv("examplefile/maxquant/phosphorylation_exp_design_info.txt",header=T,sep = '\t')
        newdata3out <- read.csv(paste0(maxdemopreloc, "DemoPreQc.csv"), row.names = 1)
        newdata3motif <- read.csv(paste0(maxdemopreloc, "DemoPreQcForMotifAnalysis.csv"))
        normmethod <- "global" # median  
        if(input$maxphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-1],2,apply(newdata3out[-1],2,sum,na.rm=T),FUN="/")
        }
        if(input$maxphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-1],2,apply(newdata3out[-1],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$maxdemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$maxphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$maxphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
        
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
        
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$maxphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
        
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          } 
          
        }
        
        if (!any(errorlabel_values)) {
        dfmotif <- data.frame(newdata3motif$AA_in_protein, newdata3motif$Sequence, newdata3motif$ID, df)
        colnames(dfmotif) <- colnames(newdata3motif)
        rownames(dfmotif) <- seq(nrow(dfmotif))
        df <- data.frame(newdata3out$ID, df)
        colnames(df) <- colnames(newdata3out)
        
        phospho_data_topX = keep_psites_with_max_in_topX(df, percent_of_kept_sites = input$maxtop/100)
        phospho_data_topX_for_motifanalysis = keep_psites_with_max_in_topX2(dfmotif, percent_of_kept_sites = input$maxtop/100)
        
        
        summarydf <- data.frame(phospho_data_topX$ID, phospho_data_topX_for_motifanalysis)
        colnames(summarydf) <- c("Position", colnames(phospho_data_topX_for_motifanalysis))
        rownames(summarydf) <- rownames(phospho_data_topX)
        
        summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
        summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
        row.names(summarydf_view) <- NULL
        
        output$demomaxresult2 <- renderDataTable(summarydf_view)
        write.csv(summarydf_view, paste0(maxdemopreloc, "DemoPreNormImputeSummary_v.csv"), row.names = FALSE)
        output$demomaxdropproresult2 <- renderDataTable(summarydf_view)
        write.csv(summarydf, paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"))
        updateTabsetPanel(session, "demomaxresultnav", selected = "demomaxstep2val")
        updateTabsetPanel(session, "demomaxdropproresultnav", selected = "demomaxdropprostep2val")
        updateActionButton(session, "demomaxnormbt", icon = icon("rotate-right"))
        updateActionButton(session, "demomaxnormprobt", icon = icon("play"))
        if(input$maxuseprocheck1 == 1) {
          updateProgressBar(session = session, id = "demomaxpreprobar", value = 66)
        } else {
          updateProgressBar(session = session, id = "demomaxpreprobar", value = 100)
            sendSweetAlert(
              session = session,
              title = "All Done",
              text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
              type = "success",
              btn_labels = "OK"
            )
            sendSweetAlert(
              session = session,
              title = "All Done",
              text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
              type = "success",
              btn_labels = "OK"
            )
        }
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
        
        
      }
    }
  )

  observeEvent(
    input$demomaxnormprobt, {
      if(!file.exists(paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"))) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        rawdata <- read.csv('examplefile/maxquant/proteinGroups.txt',header=T,sep='\t') 
        filenames <- read.csv('examplefile/maxquant/profiling_exp_design_info.txt',header = T,sep='\t')
        
        rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
        rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
        rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
        
        Genenames <- apply(data.frame(rawdata$Gene.names), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        
        intensitytype <- input$maxintensitylist 
        varnames <- c()
        for(i in 1:nrow(filenames)){
          varnames[i] <- paste(intensitytype,filenames$Experiment_Code[i],sep = '.')
        }
        
        newdata <- rawdata[c('Unique.peptides', varnames)]
        newdata <- data.frame(Genenames, newdata)
        
        uniquepeptide <- input$maxuniquepeptide
        newdata2 <- newdata[which(newdata$Unique.peptides > uniquepeptide),]
        NAnumthre <- length(filenames$Experiment_Code) - input$maxproNAthre
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()

        for (raw in 1:nrow(newdata2)) {
          NAnumthresig[raw] <- (sum(newdata2[raw,][-c(1,2)] == 0) <= NAnumthre)
        }
        newdata3 <- newdata2[NAnumthresig,]
        
        normmethod <- input$maxnormmethod
        if(normmethod == "global") {
          newdata4 <- sweep(newdata3[c(-1,-2)],2,apply(newdata3[c(-1,-2)],2,sum,na.rm=T),FUN="/")
        }
        if(normmethod == "median") {
          newdata4 <- sweep(newdata3[c(-1,-2)],2,apply(newdata3[c(-1,-2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 * 1e5
        
        newdata4[newdata4==0]<-NA
        df <- df1 <- newdata4
        
        method <- input$maximputemethod
        if(method=="0"){
          df[is.na(df)]<-0
        }else if(method=="minimum"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)
        }else if(method=="minimum/10"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)/10
        }
        df2 <- data.frame(newdata3$Genenames, df)
        colnames(df2) <- c("Symbol", filenames$Experiment_Code)
        
        summarydf <- read.csv(paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"), row.names = 1)
        phospho_data_topX <- summarydf[, c(-2, -3, -4)]
        colnames(phospho_data_topX)[1] <- "ID"
        phospho_data_topX_for_motifanalysis <- summarydf[, -1]
        
        controllabel = input$maxcontrol
        if(controllabel == "no control") {
          controllabel = NA
        }
        data_frame_normalization_with_control_no_pair = normalize_phos_data_to_profiling(phospho_data_topX, df2,
                                                                                          "examplefile/maxquant/phosphorylation_exp_design_info.txt", "examplefile/maxquant/profiling_exp_design_info.txt",
                                                                                          control_label = controllabel,
                                                                                          pair_flag = FALSE)
        data_frame_normalization_with_control_no_pair_for_motifanalysis <- cbind(phospho_data_topX_for_motifanalysis[c(1,2,3)], data_frame_normalization_with_control_no_pair[-1])
        
        summarydf <- data.frame(data_frame_normalization_with_control_no_pair$ID, data_frame_normalization_with_control_no_pair_for_motifanalysis)
        colnames(summarydf) <- c("Position", colnames(data_frame_normalization_with_control_no_pair_for_motifanalysis))
        rownames(summarydf) <- rownames(data_frame_normalization_with_control_no_pair)
        
        summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
        summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
        row.names(summarydf_view) <- NULL
        
        output$demomaxresult3 <- renderDataTable(summarydf_view)
        output$demomaxresult3pro <- renderDataTable(df2)
        
        write.csv(summarydf_view, paste0(maxdemopreloc, "DemoPreNormBasedProSummary_v.csv"), row.names = FALSE)
        write.csv(summarydf, paste0(maxdemopreloc, "DemoPreNormBasedProSummary.csv"), row.names = T)
        write.csv(df2, paste0(maxdemopreloc, "DemoPrePro.csv"), row.names = F)
        updateTabsetPanel(session, "demomaxresultnav", selected = "demomaxstep3val")
        updateActionButton(session, "demomaxnormprobt", icon = icon("rotate-right"))
        updateProgressBar(session = session, id = "demomaxpreprobar", value = 100)
        sendSweetAlert(
          session = session,
          title = "All Done",
          text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
          type = "success",
          btn_labels = "OK"
        )
      }
    }
  )
  
  observeEvent(
    input$maxpre2analysis, {
      updateTabsetPanel(
        session,
        "navbarpage",
        selected = "UPLOAD DATA [ prerequisite ]"
      )
      updateRadioGroupButtons(
        session = session, inputId = "analysisdatatype",
        selected = 1
      )
      updateRadioGroupButtons(
        session = session, inputId = "analysisdatatype",
        selected = 2
      )
    }
  )
  
  observeEvent(
    input$qualityinspector,{
      output$qualityinspectorplot <- renderPlot({
        if(input$loaddatatype == T) {  # demo
          if(input$mstech == 1 & input$softwaretype == 1) {
            design_file_path = "examplefile/maxquant/phosphorylation_exp_design_info.txt"  # max demo
            if(input$maxuseprocheck1 == T) {
              expr_df_path = paste0(maxdemopreloc, "DemoPreNormBasedProSummary_v.csv")  # max demo with proteomics
            } else {
              expr_df_path = paste0(maxdemopreloc, "DemoPreNormImputeSummary_v.csv")  # max demo without proteomics
            }
          }
          if(input$mstech == 1 & input$softwaretype == 2) {
            design_file_path = "examplefile/mascot/phosphorylation_exp_design_info.txt"  # mascot demo
            if(input$useprocheck1 == T) {
              expr_df_path = paste0(mascotdemopreloc, "DemoPreNormBasedProSummary_v.csv")  # mascot demo with proteomics
            } else {
              expr_df_path = paste0(mascotdemopreloc, "DemoPreNormImputeSummary_v.csv")  # mascot demo without proteomics
            }
          }
          if(input$mstech == 2 & input$lddasoftwaretype == 1) {
            design_file_path = "examplefile/tmt/phosphorylation_exp_design_info.txt"  # maxtmt demo
            expr_df_path = paste0(maxtmtdemopreloc, "DemoPreNormImputeSummary.csv")
          }
          if(input$mstech == 3 & input$diasoftwaretype == 2) {
            design_file_path = "examplefile/diann/phosphorylation_exp_design_info.txt"  # diann demo
            expr_df_path = paste0(dianndemopreloc, "DemoPreNormImputeSummary.csv")
          }
          if(input$mstech == 3 & input$diasoftwaretype == 1) {
            design_file_path = "examplefile/diann/phosphorylation_exp_design_info.txt"  # sn demo
            expr_df_path = paste0(sndemopreloc, "DemoPreNormImputeSummary.csv")
          }
        } else {  # user
          if(input$mstech == 1 & input$softwaretype == 1) {
            design_file_path = input$updesign$datapath  # max user
            if(is.null(input$maxuseruseprocheck)) {
              expr_df_path = paste0(maxuserpreloc, "PreNormImputeSummary_v.csv")
            } else if(input$maxuseruseprocheck==0) {
              expr_df_path = paste0(maxuserpreloc, "PreNormImputeSummary_v.csv")
            } else {
              expr_df_path = paste0(maxuserpreloc, "PreNormBasedProSummary_v.csv")
            }
          }
          if(input$mstech == 1 & input$softwaretype == 2) {
            design_file_path = input$updesign$datapath  # mascot user
            if(is.null(input$useruseprocheck1)) {
              expr_df_path = paste0(mascotuserpreloc, "NormImputeSummary_v.csv")
            } else if(input$useruseprocheck1==0) {
              expr_df_path = paste0(mascotuserpreloc, "NormImputeSummary_v.csv")
            } else {
              expr_df_path = paste0(mascotuserpreloc, "PreNormBasedProSummary_v.csv")
            }
          }
          if(input$mstech == 2 & input$lddasoftwaretype == 1) {
            design_file_path = input$updesign$datapath  # maxtmt user
            expr_df_path = paste0(maxtmtuserpreloc, "PreNormImputeSummary.csv")
          }
          if(input$mstech == 3 & input$diasoftwaretype == 2) {
            design_file_path = input$updesign$datapath  # diann user
            expr_df_path = paste0(diannuserpreloc, "PreNormImputeSummary.csv")
          }
          if(input$mstech == 3 & input$diasoftwaretype == 1) {
            design_file_path = input$updesign$datapath  # sn user
            expr_df_path = paste0(snuserpreloc, "PreNormImputeSummary.csv")
          }
        }
        
        if(!file.exists(expr_df_path) | !file.exists(design_file_path)){
          plot.new()
          text(x = 0.5, y = 0.5, labels = "Please click this button after completing all the steps!", cex = 2)
        } else {
          df_design = read.csv(design_file_path, sep = '\t')
          df = read.csv(expr_df_path, check.names=F)[,-c(1,2)]
          dist_matrix <- stats::hclust(stats::dist(t(df)))
          label_grps <- df_design$Group[stats::order.dendrogram(as.dendrogram(dist_matrix))]
          
          nGrps = length(table(label_grps))
          label_colors = grDevices::rainbow(nGrps)[factor(label_grps)]
          p <- ggdendro::ggdendrogram(dist_matrix) +
            ggplot2::ggtitle("Sample hierarchical clustering") +
            ggplot2::theme(
              axis.text.x = ggtext::element_markdown(color = label_colors),
              axis.text = ggplot2::element_text(size = 12)
            )
          ggsave(paste('tmp/',userID,'/quality_inspector.pdf',sep=''), p, height = 6, width = 5) 
          p
        }
      })
      
      showModal(modalDialog(
        title = "Quality Inspector",
        size = "l",
        tags$p(
          HTML("When performing unsupervised hierarchical clustering on appropriately
               preprocessed data, samples from the same group should cluster together.
               If not, please adjust the parameters accordingly.")
        ),
        plotOutput("qualityinspectorplot"),
        div(downloadButton("qualinspecplotdl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$qualinspecplotdl <- downloadHandler(
    filename = function(){paste("quality_inspector", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/quality_inspector.pdf',sep=''),file)
    }
  )

  #mascot
  phosphorylation_exp_design_info_file_path <- 'examplefile/mascot/phosphorylation_exp_design_info.txt'
  # mascot_xml_dir <- 'examplefile/mascot/mascot_xml'
  mascot_xml_dir <- 'examplefile/root/mascot/mascot_xml'
  phosphorylation_peptide_dir <- 'examplefile/mascot/phosphorylation_peptide_txt'

  observeEvent(
    input$parserbt01,{
      mascot_txt_dir <- paste0(mascotdemopreloc, "demomascottxt_data")
      # Convert the suffix, convert again after extraction for reading
      file1 = normalizePath(list.files(mascot_xml_dir, full.names = T))
      file2 = list.files(file1, full.names = T)
      for (f in file2){
        tmpname <- substring(f, 0, nchar(f)-4)
        newname <- sub("$", ".xml", tmpname)
        file.rename(f, newname)
      }
      if(dir.exists(mascot_txt_dir)){
        unlink(mascot_txt_dir, recursive = T)
      }
      dir.create(mascot_txt_dir)
      
      withProgress(message = 'Step1:Paser', style = "notification", detail = "processing...",
                   value = 0,max = 2,{
                     for(i in 1:2){
                       if(i == 1){
                         extract_psites_score(phosphorylation_exp_design_info_file_path, mascot_xml_dir, mascot_txt_dir)
                         
                         file1 = normalizePath(list.files(mascot_xml_dir, full.names = T))
                         file2 = list.files(file1, full.names = T)
                         for (f in file2){
                           tmpname <- substring(f, 0, nchar(f)-4)
                           newname <- sub("$", ".txt", tmpname)
                           file.rename(f, newname)
                         }
                       }
                       if(i == 2){
                         withProgress(message = "Generating CSV files of phosphorylation sites with confidence score", style = "notification", detail = "This may take a while...", value = 0, {
                           BASE_DIR <- getwd()
                           psites_score_dir <- paste0(mascotdemopreloc, "psites_score_csv")
                           if(dir.exists(psites_score_dir)){
                             unlink(psites_score_dir, recursive = T)
                           }
                           dir.create(psites_score_dir)
                           firmiana_peptide_dir <- phosphorylation_peptide_dir
                           mascot_txt_dir_paths <- list.dirs(mascot_txt_dir)
                           mascot_txt_dir_paths <- mascot_txt_dir_paths[-1]
                           mascot_txt_dir_paths_expNames <- list.files(mascot_txt_dir)
                           
                           firmiana_txt_file_names <- list.files(firmiana_peptide_dir)
                           firmiana_txt_file_names_expNames <- apply(data.frame(firmiana_txt_file_names), 1, function(x){
                             x <- strsplit(x, split = '_')[[1]]
                             x[1]
                           })
                           
                           mascot_txt_dir_paths_len <- length(mascot_txt_dir_paths)
                           cat('\n Total file: ', mascot_txt_dir_paths_len)
                           cat('\n It will take a little while.')
                           for(i in seq_len(mascot_txt_dir_paths_len)){
                             mascot_txt_dir_path <- mascot_txt_dir_paths[i]
                             mascot_txt_dir_path_expName <- mascot_txt_dir_paths_expNames[i]
                             mascot_txt_dir_path_expName_path <- list.files(mascot_txt_dir_path)
                             mascot_txt_dir_path_expName_path <- normalizePath(
                               file.path(mascot_txt_dir_path, mascot_txt_dir_path_expName_path)
                             )
                             
                             match_index <- match(mascot_txt_dir_path_expName, firmiana_txt_file_names_expNames)
                             firmiana_txt_file_name <- firmiana_txt_file_names[match_index]
                             firmiana_peptide_dir_path_expName_path <- normalizePath(
                               file.path(firmiana_peptide_dir, firmiana_txt_file_name)
                             )
                             
                             outputName <- normalizePath(
                               file.path(psites_score_dir, paste(mascot_txt_dir_path_expName, '_psites_score.csv', sep = '')),
                               mustWork = FALSE
                             )
                             expName <- mascot_txt_dir_path_expName
                             write_csv_pep_seq_conf(expName, outputName, mascot_txt_dir_path_expName_path, firmiana_peptide_dir_path_expName_path)
                             
                             cat('\n Completed file: ', i, '/', mascot_txt_dir_paths_len)
                             incProgress(1/seq_len(mascot_txt_dir_paths_len), detail = paste0('\n Completed file: ', i, '/', mascot_txt_dir_paths_len))
                           }
                         })
                         
                         
                         
                         output$demomascotparserui <- renderUI({
                           tagList(
                             selectInput(
                               "demomascotparserresultid",
                               NULL,
                               choices = get_target_name(psites_score_dir, 1)
                             ),
                             dataTableOutput("demomascotparserresultdt")
                           )
                         })
                         output$demomascotdropproparserui <- renderUI({
                           tagList(
                             selectInput(
                               "demomascotdropproparserresultid",
                               NULL,
                               choices = get_target_name(psites_score_dir, 1)
                             ),
                             dataTableOutput("demomascotdropproparserresultdt")
                           )
                         })
                       }
                       incProgress(1, detail = "")
                     }
                   })
      updateTabsetPanel(session, "resultnav", selected = "demomascotstep1val")
      updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep1val")
      
      observeEvent(
        input$demomascotparserresultid,{
          output$demomascotparserresultdt <- renderDataTable({
            id <- input$demomascotparserresultid
            psites_score_dir <- paste0(mascotdemopreloc, "psites_score_csv")
            # Determine the file path based on the relative index position
            index = which(get_target_name(psites_score_dir, 1) == id)
            path <- list.files(psites_score_dir, full.names = T)[index]
            dataread <- read.csv(path, header = T)
          })
        }
      )
      observeEvent(
        input$demomascotdropproparserresultid,{
          output$demomascotdropproparserresultdt <- renderDataTable({
            id <- input$demomascotdropproparserresultid
            psites_score_dir <- paste0(mascotdemopreloc, "psites_score_csv")
            # Determine the file path based on the relative index position
            index = which(get_target_name(psites_score_dir, 1) == id)
            path <- list.files(psites_score_dir, full.names = T)[index]
            dataread <- read.csv(path, header = T)
          })
        }
      )
      updateActionButton(session, "parserbt01", icon = icon("rotate-right"))
      updateActionButton(session, "mergingbt0", icon = icon("play"))
      updateActionButton(session, "mappingbt01", icon = icon("play"))
      updateActionButton(session, "normalizationbt01", icon = icon("play"))
      updateActionButton(session, "normalizationbt02", icon = icon("play"))
      if(input$useprocheck1 == 1) {
        updateProgressBar(session = session, id = "preprobar", value = 20)
      } else {
        updateProgressBar(session = session, id = "preprobar", value = 25)
      }
    }
  )
  
  #qc and merging 
  observeEvent(input$mergingbt0,{
    if(!(dir.exists(paste0(mascotdemopreloc, "psites_score_csv")))) {
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      psites_score_dir <- paste0(mascotdemopreloc, "psites_score_csv")
      merge_df_with_phospho_peptides <- pre_process_filter_psites( 
        phosphorylation_peptide_dir,
        psites_score_dir,
        phosphorylation_exp_design_info_file_path,
        qc = TRUE,
        min_score = input$qcscore,
        min_FDR = input$qcfdr
      )
      # write.csv
      shinyjs::show(id = "hiddenmerging", anim = FALSE)
      shinyjs::show(id = "hiddenmergingdroppro", anim = FALSE)
      write.csv(merge_df_with_phospho_peptides, paste0(mascotdemopreloc, "merge_df_with_phospho_peptides.csv"), row.names = F)
      output$viewedmerging <- renderDataTable(merge_df_with_phospho_peptides)
      output$viewedmergingdroppro <- renderDataTable(merge_df_with_phospho_peptides)
      updateTabsetPanel(session, "resultnav", selected = "demomascotstep2val")
      updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep2val")
      updateActionButton(session, "mergingbt0", icon = icon("rotate-right"))
      updateActionButton(session, "mappingbt01", icon = icon("play"))
      updateActionButton(session, "normalizationbt01", icon = icon("play"))
      updateActionButton(session, "normalizationbt02", icon = icon("play"))
      if(input$useprocheck1 == 1) {
        updateProgressBar(session = session, id = "preprobar", value = 40)
      } else {
        updateProgressBar(session = session, id = "preprobar", value = 50)
      }
    }
  })
  
  
  # mapping
  observeEvent(input$mappingbt01, {
    if(!file.exists(paste0(mascotdemopreloc,'merge_df_with_phospho_peptides.csv'))) {
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      withProgress(message = 'Step3:Mapping', style = "notification", detail = "processing...",
                   value = 0,max = 2,{
                     for(ii in 1:2){
                       if(ii == 1){
                         merge_df_with_phospho_peptides <- read.csv(paste0(mascotdemopreloc, "merge_df_with_phospho_peptides.csv"))
                         combined_df_with_mapped_gene_symbol = get_combined_data_frame02(
                           merge_df_with_phospho_peptides, species = input$species, id_type = input$idtype
                         )
                         write.csv(combined_df_with_mapped_gene_symbol, paste0(mascotdemopreloc, "combined_df_with_mapped_gene_symbol.csv"), row.names = F)
                       }
                       if(ii == 2){
                         combined_df_with_mapped_gene_symbol <- read.csv(paste0(mascotdemopreloc, "combined_df_with_mapped_gene_symbol.csv"))
                         summary_df_of_unique_proteins_with_sites = get_summary_with_unique_sites02(
                           combined_df_with_mapped_gene_symbol, species = input$species, fasta_type = input$fastatype
                         )
                         shinyjs::show(id = "hiddenmapping02", anim = FALSE)
                         shinyjs::show(id = "hiddenmapping02droppro", anim = FALSE)
                         write.csv(summary_df_of_unique_proteins_with_sites, paste0(mascotdemopreloc, "summary_df_of_unique_proteins_with_sites.csv"), row.names = T)
                         output$viewedmapping02 <- renderDataTable(summary_df_of_unique_proteins_with_sites)
                         output$viewedmapping02droppro <- renderDataTable(summary_df_of_unique_proteins_with_sites)
                         updateTabsetPanel(session, "resultnav", selected = "demomascotstep3val")
                         updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep3val")
                       }
                       incProgress(1, detail = "")
                     }
                   })
      updateActionButton(session, "mappingbt01", icon = icon("rotate-right"))
      updateActionButton(session, "normalizationbt01", icon = icon("play"))
      updateActionButton(session, "normalizationbt02", icon = icon("play"))
      if(input$useprocheck1 == 1) {
        updateProgressBar(session = session, id = "preprobar", value = 60)
      } else {
        updateProgressBar(session = session, id = "preprobar", value = 75)
      }
    }
  })

  observeEvent(input$viewexamnormmotif, {
    showModal(modalDialog(
      title = "Result file for motif enrichment analysis",
      size = "l",
      dataTableOutput("examnormmotif"),
      div(downloadButton("examnormmotifdl"), style = "display:flex; justify-content:center; align-item:center;"),
      easyClose = T,
      footer = modalButton("OK")
    ))
  })

  observeEvent(input$normalizationbt01, {
    if(!file.exists(paste0(mascotdemopreloc,'summary_df_of_unique_proteins_with_sites.csv'))) {
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      summary_df_of_unique_proteins_with_sites <- read.csv(paste0(mascotdemopreloc, "summary_df_of_unique_proteins_with_sites.csv"), row.names = 1)
      design_file <- read.csv("examplefile/mascot/phosphorylation_exp_design_info.txt",header=T,sep = '\t')
      if (input$democountbygroup == FALSE) {
        phospho_data_filtering_STY_and_normalization_list <- get_normalized_data_of_psites3(
        summary_df_of_unique_proteins_with_sites,
        phosphorylation_exp_design_info_file_path,
        input$masphosNAthre,
        normmethod = input$mascotnormmethod,
        imputemethod = input$mascotimputemethod,
        topN = NA, mod_types = c('S', 'T', 'Y'),
        design_file = design_file,
        bygroup = FALSE
        )

        phospho_data_filtering_STY_and_normalization <-
          phospho_data_filtering_STY_and_normalization_list$ptypes_fot5_df_with_id
        
        ID <- paste(phospho_data_filtering_STY_and_normalization$GeneSymbol,
                    phospho_data_filtering_STY_and_normalization$AA_in_protein,
                    sep = '_')
        Value <- phospho_data_filtering_STY_and_normalization[,-seq(1,6)]
        phospho_data <- data.frame(ID, Value)
        phospho_data_rownames <- paste(phospho_data_filtering_STY_and_normalization$ID,
                                       phospho_data_filtering_STY_and_normalization$GeneSymbol,
                                       phospho_data_filtering_STY_and_normalization$AA_in_protein,
                                       sep = '_')
        rownames(phospho_data) <- phospho_data_rownames
        
        phospho_data_for_motifanalysis <- cbind(phospho_data_filtering_STY_and_normalization$AA_in_protein, phospho_data_filtering_STY_and_normalization$Sequence, phospho_data_filtering_STY_and_normalization$ID, phospho_data[-1])
        # Further filter phosphoproteomics data..
        phospho_data_topX = keep_psites_with_max_in_topX(phospho_data, percent_of_kept_sites = input$top/100)
        phospho_data_for_motifanalysis2 = keep_psites_with_max_in_topX2(phospho_data_for_motifanalysis, percent_of_kept_sites = input$top/100)
        colnames(phospho_data_for_motifanalysis2) <- c("AA_in_protein", "Sequence", "ID", colnames(phospho_data_for_motifanalysis2)[-c(1,2,3)])
        
        summarydf <- data.frame(phospho_data_topX$ID, phospho_data_for_motifanalysis2)
        colnames(summarydf) <- c("Position", colnames(phospho_data_for_motifanalysis2))
        rownames(summarydf) <- rownames(phospho_data_topX)
        
        summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
        summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
        row.names(summarydf_view) <- NULL
        
        output$viewednorm01 <- renderDataTable(summarydf_view)
        output$viewednorm01droppro <- renderDataTable(summarydf_view)
        
        write.csv(summarydf_view, paste0(mascotdemopreloc, 'DemoPreNormImputeSummary_v.csv'), row.names = F)
        write.csv(summarydf, paste0(mascotdemopreloc, 'DemoPreNormImputeSummary.csv'), row.names = T)
        
        updateTabsetPanel(session, "resultnav", selected = "demomascotstep4val")
        updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep4val")
        
        updateActionButton(session, "normalizationbt01", icon = icon("rotate-right"))
        updateActionButton(session, "normalizationbt02", icon = icon("play"))
        if(input$useprocheck1 == 1) {
          updateProgressBar(session = session, id = "preprobar", value = 80)
        } else {
          updateProgressBar(session = session, id = "preprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        }
      } else {
        
        phospho_data_filtering_STY_and_normalization_list <- get_normalized_data_of_psites3(
          summary_df_of_unique_proteins_with_sites,
          phosphorylation_exp_design_info_file_path,
          input$masphosNAthre,
          normmethod = input$mascotnormmethod,
          imputemethod = input$mascotimputemethod,
          topN = NA, mod_types = c('S', 'T', 'Y'),
          design_file = design_file,
          bygroup = TRUE
        )
        
        if (identical(phospho_data_filtering_STY_and_normalization_list, list())) {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        } else {
          phospho_data_filtering_STY_and_normalization <-
            phospho_data_filtering_STY_and_normalization_list$ptypes_fot5_df_with_id

          ID <- paste(phospho_data_filtering_STY_and_normalization$GeneSymbol,
                      phospho_data_filtering_STY_and_normalization$AA_in_protein,
                      sep = '_')
          Value <- phospho_data_filtering_STY_and_normalization[,-seq(1,6)]
          phospho_data <- data.frame(ID, Value)
          phospho_data_rownames <- paste(phospho_data_filtering_STY_and_normalization$ID,
                                         phospho_data_filtering_STY_and_normalization$GeneSymbol,
                                         phospho_data_filtering_STY_and_normalization$AA_in_protein,
                                         sep = '_')
          rownames(phospho_data) <- phospho_data_rownames

          phospho_data_for_motifanalysis <- cbind(phospho_data_filtering_STY_and_normalization$AA_in_protein, phospho_data_filtering_STY_and_normalization$Sequence, phospho_data_filtering_STY_and_normalization$ID, phospho_data[-1])
          # Further filter phosphoproteomics data..
          phospho_data_topX = keep_psites_with_max_in_topX(phospho_data, percent_of_kept_sites = input$top/100)
          phospho_data_for_motifanalysis2 = keep_psites_with_max_in_topX2(phospho_data_for_motifanalysis, percent_of_kept_sites = input$top/100)
          colnames(phospho_data_for_motifanalysis2) <- c("AA_in_protein", "Sequence", "ID", colnames(phospho_data_for_motifanalysis2)[-c(1,2,3)])

          summarydf <- data.frame(phospho_data_topX$ID, phospho_data_for_motifanalysis2)
          colnames(summarydf) <- c("Position", colnames(phospho_data_for_motifanalysis2))
          rownames(summarydf) <- rownames(phospho_data_topX)
          
          summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
          summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
          row.names(summarydf_view) <- NULL
          
          output$viewednorm01 <- renderDataTable(summarydf_view)
          output$viewednorm01droppro <- renderDataTable(summarydf_view)
          
          write.csv(summarydf_view, paste0(mascotdemopreloc, 'DemoPreNormImputeSummary_v.csv'), row.names = F)
          write.csv(summarydf, paste0(mascotdemopreloc, 'DemoPreNormImputeSummary.csv'), row.names = T)

          updateTabsetPanel(session, "resultnav", selected = "demomascotstep4val")
          updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep4val")

          updateActionButton(session, "normalizationbt01", icon = icon("rotate-right"))
          updateActionButton(session, "normalizationbt02", icon = icon("play"))
          if(input$useprocheck1 == 1) {
            updateProgressBar(session = session, id = "preprobar", value = 80)
          } else {
            updateProgressBar(session = session, id = "preprobar", value = 100)
            sendSweetAlert(
              session = session,
              title = "All Done",
              text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
              type = "success",
              btn_labels = "OK"
            )
          }
        }
      }
      
      
    }
  })
  
  observeEvent(input$normalizationbt02, {
    if(!file.exists(paste0(mascotdemopreloc, 'DemoPreNormImputeSummary.csv'))){
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      summarydf <- read.csv(paste0(mascotdemopreloc, 'DemoPreNormImputeSummary.csv'), row.names = 1)
      phospho_data_topX <- summarydf[, c(-2, -3, -4)]
      colnames(phospho_data_topX)[1] <- "ID"
      
      phospho_data_for_motifanalysis2 <- summarydf[, -1]
      profiling_gene_dir <- "examplefile/mascot/profiling_gene_txt"
      profiling_exp_design_info_file_path <- 'examplefile/mascot/profiling_exp_design_info.txt'
      
      profiling_data = merge_profiling_file_from_Firmiana(profiling_gene_dir, US_cutoff = input$masuscutoff, profiling_exp_design_info_file_path)
      experiment_code <- utils::read.csv(profiling_exp_design_info_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
      NAnumthre <- length(experiment_code$Experiment_Code) - input$masproNAthre
      if(NAnumthre < 0) { NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(profiling_data)) {
        NAnumthresig[row] <- (sum(profiling_data[row,][-1] == 0) <= NAnumthre)
      }
      profiling_data <- profiling_data[NAnumthresig,]
      
      profiling_data = get_normalized_data_FOT52(profiling_data, profiling_exp_design_info_file_path, normmethod = input$mascotpronormmethod, imputemethod = input$mascotproimputemethod)
      
      controllabel = input$mascotcontrol
      if(controllabel == "no control") {
        controllabel = NA
      }
      data_frame_normalization_with_control_no_pair = normalize_phos_data_to_profiling(phospho_data_topX, profiling_data,
                                                                                        phosphorylation_exp_design_info_file_path, profiling_exp_design_info_file_path,
                                                                                        control_label = controllabel,
                                                                                        pair_flag = FALSE)
      data_frame_normalization_with_control_no_pair_for_motifanalysis <- cbind(phospho_data_for_motifanalysis2[c(1,2,3)], data_frame_normalization_with_control_no_pair[-1])
      
      summarydf <- data.frame(data_frame_normalization_with_control_no_pair$ID, data_frame_normalization_with_control_no_pair_for_motifanalysis)
      colnames(summarydf) <- c("Position", colnames(data_frame_normalization_with_control_no_pair_for_motifanalysis))
      rownames(summarydf) <- rownames(data_frame_normalization_with_control_no_pair)
      
      summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
      summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
      row.names(summarydf_view) <- NULL
      
      output$viewednorm02 <- renderDataTable(summarydf_view)
      
      output$viewednorm02pro <- renderDataTable(profiling_data)
      
      write.csv(summarydf_view, paste0(mascotdemopreloc, "DemoPreNormBasedProSummary_v.csv"), row.names = F)
      write.csv(summarydf, paste0(mascotdemopreloc, "DemoPreNormBasedProSummary.csv"), row.names = T)
      write.csv(profiling_data, paste0(mascotdemopreloc, "DemoPrePro.csv"), row.names = F)
      
      updateTabsetPanel(session, "resultnav", selected = "demomascotstep5val")
      updateActionButton(session, "normalizationbt02", icon = icon("rotate-right"))
      updateProgressBar(session = session, id = "preprobar", value = 100)
      sendSweetAlert(
        session = session,
        title = "All Done",
        text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
        type = "success",
        btn_labels = "OK"
      )
    }
  })
  
  observeEvent(
    input$pre2analysis, {
      updateTabsetPanel(
        session,
        "navbarpage",
        selected = "UPLOAD DATA [ prerequisite ]"
      )
      updateRadioGroupButtons(
        session = session, inputId = "analysisdatatype",
        selected = 1
      )
      updateRadioGroupButtons(
        session = session, inputId = "analysisdatatype",
        selected = 2
      )
    }
  )
  # maxtmt demo
  observeEvent(
    input$demomaxtmtqcbt, {
      tmt_df <- read.csv("examplefile/tmt/Phospho (STY)Sites.txt",header=T,sep='\t')
      filenames <- read.csv('examplefile/tmt/phosphorylation_exp_design_info.txt',header = T,sep='\t')
      
      # Filter reverse and contaminant
      tmt_df <- tmt_df[-which(tmt_df$Reverse=="+"),]
      tmt_df <- tmt_df[-which(tmt_df$Potential.contaminant=="+"),]
      tmt_df <- tmt_df[-which(tmt_df$Protein == "" | tmt_df$Gene.names == ""),]
      
      varnames <- c()
      for(i in 1:nrow(filenames)){
        varnames[i] <- paste0('Reporter.intensity.corrected.',filenames$Experiment_Code[i],'___1')
      }
      
      myvar <- c('Proteins', 'Positions.within.proteins', 'Protein','Gene.names','Amino.acid', 
                 'Localization.prob','Score', 'Phospho..STY..Probabilities', 
                 'Position.in.peptide', varnames)
      tmt_df <- tmt_df[myvar]
      
      # Filter by qc config
      tmt_df <- tmt_df[which(tmt_df$Localization.prob >= input$maxtmtminqclocalizationprob & tmt_df$Score >= input$maxtmtminqcscore),]
      
      Protein <- apply(data.frame(tmt_df$Protein), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      Gene.names <- apply(data.frame(tmt_df$Gene.names), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      tmt_df$Protein <- Protein
      tmt_df$Gene.names <- Gene.names
      
      get_combined <- function(protein, proteins, positions, Gene.names, psite) {
        protein_index <- which(strsplit(proteins, ";")[[1]] == protein)
        if (length(protein_index) > 0) {
          positions <- strsplit(positions, ";")[[1]]
          combined <- paste(protein, Gene.names, paste0(psite, positions[protein_index]), sep = "_")
        } else {
          combined <- NA
        }
        return(combined)
      }
      
      # Retrive upsID
      tmt_df$upsID <- mapply(get_combined, tmt_df$Protein, tmt_df$Proteins, 
                             tmt_df$Positions.within.proteins, tmt_df$Gene.names, tmt_df$Amino.acid)
      
      # Retrive sequence
      sequence <- gsub("\\(.*?\\)","",tmt_df$Phospho..STY..Probabilities)
      Sequence <- c()
      for (i in seq(length(sequence))) {
        tmp <- unlist(str_split(sequence[i], pattern = ""))
        index <- tmt_df$Position.in.peptide[i]
        tmp[index] <- tolower(tmp[index])
        
        Sequence[i] <- paste(tmp, collapse = "")
      }
      
      tmt_df$Sequence <- Sequence
      
      tmt_df <- tmt_df[c('upsID', 'Sequence', varnames)]
      
      # Filter by the number of NA
      NAnumthre <- length(filenames$Experiment_Code) - input$maxtmtphosNAthre  # NA threshold
      if(NAnumthre < 0) {NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(tmt_df)) {
        NAnumthresig[row] <- (sum(tmt_df[row,][-c(1, 2)] == 0) <= NAnumthre)
      }
      tmt_df_filter <- tmt_df[NAnumthresig,]
      
      # Change column names to match the design file
      colnames(tmt_df_filter) <- sub("^Reporter\\.intensity\\.corrected\\.(.*)___1$", "\\1", colnames(tmt_df_filter), perl = TRUE)
      
      write.csv(tmt_df_filter, paste0(maxtmtdemopreloc, "DemoPreQc.csv"), row.names = F)
      output$demomaxtmtresult1 <- renderDataTable(({datatable(tmt_df_filter)}))
      updateTabsetPanel(session, "demomaxtmtresultnav", selected = "demomaxtmtstep1val")
      updateActionButton(session, "demomaxtmtqcbt", icon = icon("rotate-right"))
      updateActionButton(session, "demomaxtmtnormbt", icon = icon("play"))
      updateProgressBar(session = session, id = "demomaxtmtpreprobar", value = 50)
    }
  )
  
  observeEvent(
    input$demomaxtmtnormbt, {
      if(!file.exists(
        paste0(maxtmtdemopreloc, "DemoPreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv("examplefile/tmt/phosphorylation_exp_design_info.txt",header=T,sep = '\t')
        newdata3out <- read.csv(paste0(maxtmtdemopreloc, "DemoPreQc.csv"), check.names=F)
        normmethod <- "global" # median
        if(input$maxtmtphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,sum,na.rm=T),FUN="/")
        }
        if(input$maxtmtphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$maxtmtdemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$maxtmtphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$maxtmtphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
              
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$maxtmtphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
            
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }
          
        }
        
        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$maxtmttop/100)
          output$demomaxtmtresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(maxtmtdemopreloc, "DemoPreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "demomaxtmtresultnav", selected = "demomaxtmtstep2val")
          updateActionButton(session, "demomaxtmtnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "demomaxtmtpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  # diann demo
  observeEvent(
    input$demodiannqcbt, {
      diann_df <- as.data.frame(fread("examplefile/diann/report_mini.tsv", stringsAsFactors = FALSE))
      # diann_df <- read.csv("PhosMap_datasets/diann/mini_diann_report_modified.csv")
      filenames <- read.csv('examplefile/diann/phosphorylation_exp_design_info.txt',header = T,sep='\t')
      
      # Filter by filenames
      diann_df <- diann_df %>% filter(Run %in% filenames$Experiment_Code)
      
      fasta_file = 'PhosMap_datasets/fasta_library/uniprot/human/human_uniprot_fasta.txt'
      PHOSPHATE_LIB_FASTA_DATA = utils::read.table(file=fasta_file, header=TRUE, sep="\t")
      
      diann_df_var <- c("Run", "Protein.Group", "Genes", "PG.MaxLFQ", "Modified.Sequence", "Stripped.Sequence", "PTM.Q.Value")
      diann_df <- diann_df[diann_df_var]
      
      diann_df <- diann_df[which(diann_df$PTM.Q.Value <= input$diannptmqvalue),]
      
      for (i in 1:nrow(diann_df)) {
        if(!(i %% 5000)) {
          showNotification(
            paste0("Processing, please wait. Currently completed processing ", i, " out of ", nrow(diann_df), " rows of data."),
            duration = 3  # second
          )
        }
        diann_df_modified_seq <- diann_df[i, "Modified.Sequence"]
        # Check Phospho
        match_result <- regexpr("\\(UniMod:21\\)", diann_df_modified_seq)
        if(match_result != -1) {
          substring <- substr(diann_df_modified_seq, 1, match_result - 1)
          updated_string <- gsub("\\([^()]+\\)", "", substring)
          index_pep <- nchar(updated_string)
          site_type <- substr(updated_string, index_pep, index_pep)
        } else {
          index_pep <- -1
          site_type <- 'non-phos'
        }
        if(index_pep != -1) {
          # Find peptide in whole protein
          diann_df_seq <- diann_df[i, "Stripped.Sequence"]
          source_seq <- PHOSPHATE_LIB_FASTA_DATA[PHOSPHATE_LIB_FASTA_DATA$ID == diann_df[i, "Protein.Group"],]$Sequence
          matches <- gregexpr(diann_df_seq, source_seq)
          if (length(matches) > 0 && any(matches[[1]] != -1)) {  # some protein not in fasta file
            start_positions <- matches[[1]]
            notfound <- 0  # found
          } else {
            start_positions <- -1
            notfound <- 1  # dont find pep in protein, maybe need update fasta file.
          }
          if(length(start_positions) == 1) {
            if(start_positions != -1) {
              # Get index in protein
              index <- start_positions[1] + index_pep - 1
              phospho_site <- paste0(site_type, index)
              upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
            } else {
              index <- -1
              phospho_site <- paste0(site_type, index)
              upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
            }
          } else {
            index <- -2
            phospho_site <- paste0(site_type, index)
            upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
          }
        } else {
          index <- -3
          notfound <- -1
          phospho_site <- paste0(site_type, index)
          upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
        }
        # Modify p-site to lower case
        if(notfound == 0 & index != -2) {
          part1 <- substr(diann_df_seq, 1, index_pep - 1)
          part2 <- tolower(substr(diann_df_seq, index_pep, index_pep))
          part3 <- substr(diann_df_seq, index_pep + 1, nchar(diann_df_seq))
          diann_df_seq <- paste0(part1, part2, part3)
        } else {
          diann_df_seq <- -1
        }
        diann_df[i, "upsID"] <- upsID
        diann_df[i, "Sequence"] <- diann_df_seq
        diann_df[i, "index"] <- index  # the index of phospho-site in corresponding protein. -1: not found,equal 'not found=1'; -2: multi phospho-site; -3: no phospho-site,equal 'not found=-1'
        diann_df[i, "notfound"] <- notfound  # 0: found; 1: not found; -1: no phospho-site
      }
      
      # Following information maybe useful in future.
      diann_df_notfound = diann_df[which(diann_df$notfound == 1),]
      diann_df_other_modify = diann_df[which(diann_df$notfound == -1),]
      diann_df_phos = diann_df[which(diann_df$notfound == 0),]
      diann_df_phos_multi = diann_df_phos[which(diann_df_phos$index == -2),]
      diann_df_phos_single = diann_df_phos[which(diann_df_phos$index != -2),]
      
      final_diann_df_phos_single = diann_df_phos_single[c("upsID", "Sequence", "PG.MaxLFQ", "Run")]
      
      grouped_df <- final_diann_df_phos_single %>%
        group_by(upsID, Run) %>%
        summarise(Sequence = first(Sequence), PG.MaxLFQ = sum(PG.MaxLFQ))
      
      grouped_df <- grouped_df %>%
        group_by(upsID) %>%
        mutate(Sequence = first(Sequence))
      
      final_df <- grouped_df %>%
        pivot_wider(names_from = Run, values_from = PG.MaxLFQ, values_fill = 0)
      final_df$upsID <- as.character(final_df$upsID)
      
      # Filter by the number of NA
      NAnumthre <- length(filenames$Experiment_Code) - input$diannphosNAthre
      if(NAnumthre < 0) {NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(final_df)) {
        NAnumthresig[row] <- (sum(final_df[row,][-c(1:2)] == 0) <= NAnumthre)
      }
      final_df <- final_df[NAnumthresig,]
      final_df <- final_df[c("upsID", "Sequence", filenames$Experiment_Code)]
      
      write.csv(final_df, paste0(dianndemopreloc, "DemoPreQc.csv"), row.names = F)
      output$demodiannresult1 <- renderDataTable(({datatable(final_df)}))
      updateTabsetPanel(session, "demodiannresultnav", selected = "demodiannstep1val")
      updateActionButton(session, "demodiannqcbt", icon = icon("rotate-right"))
      updateActionButton(session, "demodiannnormbt", icon = icon("play"))
      updateProgressBar(session = session, id = "demodiannpreprobar", value = 50)
    }
  )
  
  observeEvent(
    input$demodiannnormbt, {
      if(!file.exists(
        paste0(dianndemopreloc, "DemoPreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv("examplefile/diann/phosphorylation_exp_design_info.txt",header=T,sep = '\t')
        newdata3out <- read.csv(paste0(dianndemopreloc, "DemoPreQc.csv"), check.names=F)
        normmethod <- "global" # median
        if(input$diannphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,sum,na.rm=T),FUN="/")
        }
        if(input$diannphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()

        if (input$dianndemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$diannphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$diannphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]

              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]

              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$diannphosimputemethod)

              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }

            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }

        }

        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$dianntop/100)
          output$demodiannresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(dianndemopreloc, "DemoPreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "demodiannresultnav", selected = "demodiannstep2val")
          updateActionButton(session, "demodiannnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "demodiannpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  # SN demo
  observeEvent(
    input$demosnqcbt, {
      file.rename("examplefile/SN/20231122_1_Report.xls", "examplefile/SN/20231122_1_Report.csv")
      sn_df <- read.csv("examplefile/SN/20231122_1_Report.csv", sep = '\t', check.names=F)
      file.rename("examplefile/SN/20231122_1_Report.csv", "examplefile/SN/20231122_1_Report.xls")
      filenames <- read.csv('examplefile/diann/phosphorylation_exp_design_info.txt',header = T,sep='\t')
      
      varnames <- c()
      for(i in 1:nrow(filenames)){
        varnames[i] <- paste0('[',i,']',' ', filenames$Experiment_Code[i],'.raw.PEP.MS2Quantity')
      }
      
      myvar <- c('PG.ProteinAccessions', 'PG.Genes', 'EG.ProteinPTMLocations', 'EG.ModifiedSequence', varnames)
      sn_df <- sn_df[myvar]
      
      sn_df <- sn_df[-which(sn_df$PG.ProteinAccessions == "" | sn_df$PG.Genes == "" | sn_df$EG.ProteinPTMLocations == "" | sn_df$EG.ModifiedSequence == ""),]
      
      PG.ProteinAccessions <- apply(data.frame(sn_df$PG.ProteinAccessions), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      
      PG.Genes <- apply(data.frame(sn_df$PG.Genes), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      
      EG.ProteinPTMLocations <- apply(data.frame(sn_df$EG.ProteinPTMLocations), 1, function(x){
        x <- strsplit(x, split = ';')[[1]]
        x[1]
      })
      
      sn_df$PG.ProteinAccessions <- PG.ProteinAccessions
      sn_df$PG.Genes <- PG.Genes
      sn_df$EG.ProteinPTMLocations <- EG.ProteinPTMLocations
      
      process_locations <- function(locations) {
        
        # Remove multiple bracket
        if (grepl("\\(.*\\).*\\(.*\\)", locations)) {
          return(NA)
        }
        # Remove bracket
        locations <- gsub("[()]", "", locations)
        
        elements <- strsplit(locations, ",")[[1]]
        
        # S\T\Y
        s_elements <- grep("S", elements, value = TRUE)
        t_elements <- grep("T", elements, value = TRUE)
        y_elements <- grep("Y", elements, value = TRUE)
        
        # Count
        countS <- length(s_elements)
        countT <- length(t_elements)
        countY <- length(y_elements)
        
        if (countS + countT + countY == 1) {
          if (countS == 1) {
            locations <- gsub(".*?(S\\d+).*", "\\1", s_elements)
          } else if (countT == 1) {
            locations <- gsub(".*?(T\\d+).*", "\\1", t_elements)
          } else {
            locations <- gsub(".*?(Y\\d+).*", "\\1", y_elements)
          }
        } else {
          # Remove multiple sites
          locations <- NA
        }
        
        return(locations)
      }
      
      sn_df$test_EG.ProteinPTMLocations <- sapply(sn_df$EG.ProteinPTMLocations, process_locations)
      sn_df <- sn_df[-which(is.na(sn_df$test_EG.ProteinPTMLocations)),]
      
      process_sequence <- function(sequence) {
        # Remove _
        sequence <- str_remove_all(sequence, "^_|_$")
        
        match <- str_locate(sequence, "\\[Phospho \\(STY\\)\\]")
        
        if (!is.na(match[1])) {
          start <- match[1]
          end <- match[2]
          left <- tolower(str_sub(sequence, start - 1, start - 1))
          sequence <- paste0(str_sub(sequence, 1, start - 2), left, str_sub(sequence, start, end), str_sub(sequence, end + 1))
        }
        sequence <- str_remove_all(sequence, "\\[.*?\\]")
        return(sequence)
      }
      
      sn_df$Sequence <- sapply(sn_df$EG.ModifiedSequence, process_sequence)
      sn_df$upsID <- paste(sn_df$PG.ProteinAccessions, sn_df$PG.Genes, sn_df$test_EG.ProteinPTMLocations, sep = "_")
      sn_df <- sn_df[c("upsID", "Sequence", varnames)]
      
      colnames(sn_df) <- sub("\\[\\d+\\] (.*)\\.raw\\.PEP\\.MS2Quantity", "\\1", colnames(sn_df))
      
      # Filter by the number of NA
      NAnumthre <- length(filenames$Experiment_Code) - input$snphosNAthre  # NA threshold
      if(NAnumthre < 0) {NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(sn_df)) {
        NAnumthresig[row] <- (sum(is.na(sn_df[row,][-c(1, 2)])) <= NAnumthre)
      }
      sn_df_filter <- sn_df[NAnumthresig,]
      
      write.csv(sn_df_filter, paste0(sndemopreloc, "DemoPreQc.csv"), row.names = F)
      output$demosnresult1 <- renderDataTable(({datatable(sn_df_filter)}))
      updateTabsetPanel(session, "demosnresultnav", selected = "demosnstep1val")
      updateActionButton(session, "demosnqcbt", icon = icon("rotate-right"))
      updateActionButton(session, "demosnnormbt", icon = icon("play"))
      updateProgressBar(session = session, id = "demosnpreprobar", value = 50)
    }
  )
  
  observeEvent(
    input$demosnnormbt, {
      if(!file.exists(
        paste0(sndemopreloc, "DemoPreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv("examplefile/diann/phosphorylation_exp_design_info.txt",header=T,sep = '\t')
        newdata3out <- read.csv(paste0(sndemopreloc, "DemoPreQc.csv"))
        
        newdata4 = newdata3out[-c(1,2)]
        
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$sndemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$snphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$snphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
              
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$snphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
            
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }
          
        }
        
        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          
          value_cols <- names(df)[3:ncol(df)]
          
          df <- df %>%
            group_by(upsID) %>%
            summarize(Sequence = first(Sequence), across(all_of(value_cols), sum))
          
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$sntop/100)
          output$demosnresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(sndemopreloc, "DemoPreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "demosnresultnav", selected = "demosnstep2val")
          updateActionButton(session, "demosnnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "demosnpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  
  # user maxquant
  # If the user uploads the proteome data, show the option
  maxuserproaval <- reactive(is.null(input$upusermaxprodesign) | is.null(input$upusermaxpro))
  output$maxuserusepro <- renderUI({
    if(maxuserproaval()) {
      h5("You can use the module only after uploading proteomics data.")
    }else {
      tagList(
        prettyToggle(
          inputId = "maxuseruseprocheck",
          label_on = "Use proteomics data", 
          icon_on = icon("check"),
          status_on = "info",
          status_off = "warning", 
          label_off = "Donot use proteomics data",
          icon_off = icon("xmark"),
          value = TRUE
        ),
        conditionalPanel(
          condition = "input.maxuseruseprocheck == 1",
          wellPanel(
            h5("Proteomics data preprocessing parameters", style = "color: grey;"),
            selectInput("maxuserintensitylist", "intensity type: ", choices = maxuserintensitylistreactive()[[1]], selected = maxuserintensitylistreactive()[[2]]),
            numericInput(
              "maxuseruniquepeptide",
              "minimum unique peptide:",
              1,
              min = 0,
              step = 1
            ),
            numericInput(
              "maxuserproNAthre",
              "minimum detection frequency:",
              1,
              min = 0,
              # max = 5,
              step = 1
            ),
            bsTooltip(
              "maxuserproNAthre",
              "minimum detection frequency for per protein, equivalents to the number of samples minus the number of ‘0’ value",
              placement = "right",
              options = list(container = "body")
            ),
            selectInput("maxusernormmethod", "normalization method:", choices = c("global", "median")),
            selectInput("maxuserimputemethod", "imputation method:", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10")
          ),
          selectInput("usermaxcontrol", label = "control label: ", choices = c(grouplabel(), "no control")),
          div(
            class = "runbuttondiv",
            actionButton(
              "usermaxnormprobt",
              "",
              icon("play"),
              class = "runbutton"
            )
          )
        ),
        conditionalPanel(
          condition = "input.maxuseruseprocheck == 0",
          wellPanel(
            h5("After 'Step1-Step2' have been run, you can click 'Go to analysis tools'", style = "color: grey;")
          )
        )
      )
    }
  })
  
  maxuserintensitylistreactive <- reactive({
    flag1 <- 'iBAQ' %in% colnames(usermaxpro())
    flag2 <- any(grepl("LFQ.intensity", colnames(usermaxpro())))
    if(flag1 & flag2) {
      list(c("Intensity", "iBAQ", "LFQ.intensity"), "iBAQ")
    } else if(!flag1 & flag2) {
      list(c("Intensity", "LFQ.intensity"), "LFQ.intensity")
    } else if(flag1 & !flag2) {
      list(c("Intensity", "iBAQ"), "iBAQ")
    } else {
      list(c("Intensity"), "Intensity")
    }
  })
  
  output$maxuserresultpanelui <- renderUI({
    if(maxuserproaval()) {
      tagList(
        navbarPage(
          title = "Result",
          id = "usermaxnoproresultnav",
          
          tabPanel(
            "Step 1",
            value = "usermaxnoprostep1val",
            h4("QC result: "),
            column(11,dataTableOutput('usermaxnoproresult1')),
            column(1,downloadBttn(
              outputId = "usermaxnoproresult1_dl",
              label = "",
              style = "material-flat",
              color = "default",
              size = "sm"
            ))
            
          ),
          tabPanel(
            "Step 2",
            value = "usermaxnoprostep2val",
            h4("Phosphorylation data frame: "),
            dataTableOutput("usermaxnoproresult2motif"),
            column(11,dataTableOutput("usermaxnoproresult2")),
            column(1,downloadBttn(
              outputId = "usermaxnoproresult2_dl",
              label = "",
              style = "material-flat",
              color = "default",
              size = "sm"
            ))
          )
        )
      )
    }else {
      tagList(
        conditionalPanel(
          condition = "input.maxuseruseprocheck == 1",
          navbarPage(
            title = "Result",
            id = "usermaxresultnav",
            tabPanel(
              "Step 1",
              value = "usermaxstep1val",
              h4("QC result: "),
              column(11,dataTableOutput('usermaxresult1')),
              column(1,downloadBttn(
                outputId = "usermaxresult1_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 2",
              value = "usermaxstep2val",
              h4("Phosphorylation data frame: "),
              column(11,dataTableOutput("usermaxresult2")),
              column(1,downloadBttn(
                outputId = "usermaxresult2_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 3",
              value = "usermaxstep3val",
              h4("Phosphorylation data frame: "),
              column(11,dataTableOutput("usermaxresult3")),
              column(1,downloadBttn(
                outputId = "usermaxresult3_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
              br(),
              h4("Proteomics data frame:"),
              column(11,dataTableOutput("usermaxresult3pro")),
              column(1,downloadBttn(
                outputId = "usermaxresult3pro_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            )
          )
        ),
        conditionalPanel(
          condition = "input.maxuseruseprocheck == 0",
          navbarPage(
            title = "Result",
            id = "usermaxdropproresultnav",
            tabPanel(
              "Step 1",
              value = "usermaxdropprostep1val",
              h4("QC result: "),
              column(11,dataTableOutput('usermaxdropproresult1')),
              column(1,downloadBttn(
                outputId = "usermaxdropproresult1_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
              
            ),
            tabPanel(
              "Step 2",
              value = "usermaxdropprostep2val",
              h4("Phosphorylation data frame: "),
              column(11,dataTableOutput("usermaxdropproresult2")),
              column(1,downloadBttn(
                outputId = "usermaxdropproresult2_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            )
          )
        )
      )
    }
  })
  
  output$maxuserprouploaded <- reactive({
    maxuserproaval()
  })
  outputOptions(output, 'maxuserprouploaded', suspendWhenHidden=FALSE)
  
  observeEvent(
    input$usermaxqcbt, {
      if(is.null(input$upusermaxphos)|is.null(input$updesign)) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please upload data",
          type = "info"
        )
      } else {
        rawdata <- read.csv(input$upusermaxphos$datapath,header=T,sep='\t')
        filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
        rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
        rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
        rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
        
        varnames <- c()
        for(i in 1:nrow(filenames)){
          varnames[i] <- paste('Intensity',filenames$Experiment_Code[i],sep = '.')
        }
        varnames <- gsub('-','.',varnames)
        myvar <- c('Localization.prob','Score', 'Leading.proteins','Gene.names','Amino.acid', 'Positions', 'Phospho..STY..Probabilities', 'Position.in.peptide', varnames)
        newdata <- rawdata[myvar]
        
        Genenames <- apply(data.frame(newdata$Gene.names), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        Positions <- apply(data.frame(newdata$Positions), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        Leadingproteins <- apply(data.frame(newdata$Leading.proteins), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        newdata$Gene.names <- Genenames
        newdata$Positions <- Positions
        newdata$Leading.proteins <- Leadingproteins
        
        newdata2 <- newdata[which(newdata$Localization.prob >= input$minqclocalizationprob & newdata$Score >= input$minqcscore),]
        
        NAnumthre <- length(filenames$Experiment_Code) - input$maxphosNAthre
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()
        for (row in 1:nrow(newdata2)) {
          NAnumthresig[row] <- (sum(newdata2[row,][-c(seq(8))] == 0) <= NAnumthre)
        }
        newdata3 <- newdata2[NAnumthresig,]
        
        aminoposition <- paste0(newdata3$Amino.acid, newdata3$Positions)
        ID <- paste(newdata3$Gene.names, aminoposition, sep = '_')
        rowname <- paste(newdata3$Leading.proteins, ID, sep = '_')
        
        sequence <- gsub("\\(.*?\\)","",newdata3$Phospho..STY..Probabilities)
        Sequence <- c()
        for (i in seq(length(sequence))) {
          tmp <- unlist(str_split(sequence[i], pattern = ""))
          index <- newdata3$Position.in.peptide[i]
          tmp[index] <- tolower(tmp[index])
          
          Sequence[i] <- paste(tmp, collapse = "")
        }
        
        newdata3out <- newdata3[-c(seq(8))]  
        rownames(newdata3out) <- rowname
        
        newdata3motif <- data.frame(aminoposition, Sequence, newdata3$Leading.proteins, newdata3out)
        colnames(newdata3motif) <- c("AA_in_protein", "Sequence", "ID", filenames$Experiment_Code)
        newdata3out <- data.frame(ID, newdata3out)
        colnames(newdata3out) <- c("ID", filenames$Experiment_Code)
        
        newdata3motif <- newdata3motif[!duplicated(newdata3out$ID),]
        newdata3out <- newdata3out[!duplicated(newdata3out$ID),]
        
        write.csv(newdata3out, paste0(maxuserpreloc, "PreQc.csv"), row.names = T)
        write.csv(newdata3motif, paste0(maxuserpreloc, "PreQcForMotifAnalysis.csv"), row.names = F)
        
        output$usermaxresult1 <- renderDataTable({
          datatable(newdata3out, options = list(pageLength = 10))
        })
        output$usermaxnoproresult1 <- renderDataTable({
          datatable(newdata3out, options = list(pageLength = 10))
        })
        output$usermaxdropproresult1 <- renderDataTable({
          datatable(newdata3out, options = list(pageLength = 10))
        })
        updateTabsetPanel(session, "usermaxresultnav", selected = "usermaxstep1val")
        updateTabsetPanel(session, "usermaxnoproresultnav", selected = "usermaxnoprostep1val")
        updateTabsetPanel(session, "usermaxdropproresultnav", selected = "usermaxdropprostep1val")
        updateActionButton(session, "usermaxqcbt", icon = icon("rotate-right"))
        updateActionButton(session, "usermaxnormbt", icon = icon("play"))
        updateActionButton(session, "usermaxnormprobt", icon = icon("play"))
        
        if(is.null(input$maxuseruseprocheck)) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 50)
        } else if(input$maxuseruseprocheck == 1) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 33)
        } else {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 50)
        }
      }
    }
  )

  observeEvent(
    input$usermaxnormbt, {
      if(!file.exists(paste0(maxuserpreloc, "PreQc.csv"))) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      } else {
        design_file <- read.csv(input$updesign$datapath,header = T,sep = '\t')
        newdata3out <- read.csv(paste0(maxuserpreloc, "PreQc.csv"), row.names = 1)
        newdata3motif <- read.csv(paste0(maxuserpreloc, "PreQcForMotifAnalysis.csv"))
        if(input$maxphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-1],2,apply(newdata3out[-1],2,sum,na.rm=T),FUN="/")
        }
        if(input$maxphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-1],2,apply(newdata3out[-1],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        if (input$maxdemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$maxphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$maxphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
        }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
        
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$maxphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
        
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
        }
        
        }
        # df <- df1 <- newdata4
        # method <- input$maxphosimputemethod
        # if(method=="0"){
        #   df[is.na(df)]<-0
        # }else if(method=="minimum"){
        #   df[is.na(df)]<-min(df1,na.rm = TRUE)
        # }else if(method=="minimum/10"){
        #   df[is.na(df)]<-min(df1,na.rm = TRUE)/10
        # }
        if (!any(errorlabel_values)) {
        dfmotif <- data.frame(newdata3motif$AA_in_protein, newdata3motif$Sequence, newdata3motif$ID, df)
        colnames(dfmotif) <- colnames(newdata3motif)
        rownames(dfmotif) <- seq(nrow(dfmotif))
        df <- data.frame(newdata3out$ID, df)
        colnames(df) <- colnames(newdata3out)
        
        phospho_data_topX = keep_psites_with_max_in_topX(df, percent_of_kept_sites = input$maxtop/100)
        phospho_data_topX_for_motifanalysis = keep_psites_with_max_in_topX2(dfmotif, percent_of_kept_sites = input$maxtop/100)
        
        summarydf <- data.frame(phospho_data_topX$ID, phospho_data_topX_for_motifanalysis)
        colnames(summarydf) <- c("Position", colnames(phospho_data_topX_for_motifanalysis))
        rownames(summarydf) <- rownames(phospho_data_topX)
        
        summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
        summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
        row.names(summarydf_view) <- NULL
        
        output$usermaxresult2 <- renderDataTable(summarydf_view)
        output$usermaxnoproresult2 <- renderDataTable(summarydf_view)
        output$usermaxdropproresult2 <- renderDataTable(summarydf_view)
        
        write.csv(summarydf_view, paste0(maxuserpreloc, "PreNormImputeSummary.csv"), row.names = F)
        write.csv(summarydf, paste0(maxuserpreloc, "PreNormImputeSummary.csv"))

        updateTabsetPanel(session, "usermaxresultnav", selected = "usermaxstep2val")
        updateTabsetPanel(session, "usermaxnoproresultnav", selected = "usermaxnoprostep2val")
        updateTabsetPanel(session, "usermaxdropproresultnav", selected = "usermaxdropprostep2val")
        updateActionButton(session, "usermaxnormbt", icon = icon("rotate-right"))
        updateActionButton(session, "usermaxnormprobt", icon = icon("play"))
        
        if(is.null(input$maxuseruseprocheck)) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else if(input$maxuseruseprocheck == 1) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 66)
        } else {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        }
        } else {
          
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
          
        }
        
        
      }
    }
  )
  
  observeEvent(
    input$usermaxnormprobt, {
      if(!file.exists(paste0(maxuserpreloc, "PreNormImputeSummary.csv"))) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }else{
        rawdata <- read.csv(input$upusermaxpro$datapath,header=T,sep='\t')
        filenames <- read.csv(input$upusermaxprodesign$datapath,header = T,sep='\t')
        
        rawdata <- rawdata[-which(rawdata$Reverse=="+"),]
        rawdata <- rawdata[-which(rawdata$Potential.contaminant=="+"),]
        rawdata <- rawdata[-which(rawdata$Protein.names == "" | rawdata$Gene.names == ""),]
        
        Genenames <- apply(data.frame(rawdata$Gene.names), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        
        intensitytype <- input$maxuserintensitylist
        varnames <- c()
        for(i in 1:nrow(filenames)){
          varnames[i] <- paste(intensitytype,filenames$Experiment_Code[i],sep = '.')
        }
        newdata <- rawdata[c('Unique.peptides', varnames)]
        newdata <- data.frame(Genenames, newdata)
        
        uniquepeptide <- input$maxuseruniquepeptide
        newdata2 <- newdata[which(newdata$Unique.peptides > uniquepeptide),]
        NAnumthre <- length(filenames$Experiment_Code) - input$maxuserproNAthre
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()
        
        for (raw in 1:nrow(newdata2)) {
          NAnumthresig[raw] <- (sum(newdata2[raw,][-c(1,2)] == 0) <= NAnumthre)
        }
        newdata3 <- newdata2[NAnumthresig,]
        
        normmethod <- input$maxusernormmethod
        if(normmethod == "global") {
          newdata4 <- sweep(newdata3[c(-1,-2)],2,apply(newdata3[c(-1,-2)],2,sum,na.rm=T),FUN="/")
        }
        if(normmethod == "median") {
          newdata4 <- sweep(newdata3[c(-1,-2)],2,apply(newdata3[c(-1,-2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 * 1e5

        newdata4[newdata4==0]<-NA
        df <- df1 <- newdata4
        
        method <- input$maxuserimputemethod
        if(method=="0"){
          df[is.na(df)]<-0
        }else if(method=="minimum"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)
        }else if(method=="minimum/10"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)/10
        }
        df2 <- data.frame(newdata3$Genenames, df)
        colnames(df2) <- c("Symbol", filenames$Experiment_Code)
        
        summarydf <- read.csv(paste0(maxuserpreloc, "PreNormImputeSummary.csv"), row.names = 1)
        phospho_data_topX <- summarydf[, c(-2, -3, -4)]
        colnames(phospho_data_topX)[1] <- "ID"

        phospho_data_topX_for_motifanalysis <- summarydf[, -1]

        controllabel = input$usermaxcontrol
        if(controllabel == "no control") {
          controllabel = NA
        }
        data_frame_normalization_with_control_no_pair = normalize_phos_data_to_profiling(phospho_data_topX, df2,
                                                                                          input$updesign$datapath, input$upusermaxprodesign$datapath,
                                                                                          control_label = controllabel,
                                                                                          pair_flag = FALSE)

        data_frame_normalization_with_control_no_pair_for_motifanalysis <- cbind(phospho_data_topX_for_motifanalysis[c(1,2,3)], data_frame_normalization_with_control_no_pair[-1])
        
        summarydf <- data.frame(data_frame_normalization_with_control_no_pair$ID, data_frame_normalization_with_control_no_pair_for_motifanalysis)
        colnames(summarydf) <- c("Position", colnames(data_frame_normalization_with_control_no_pair_for_motifanalysis))
        rownames(summarydf) <- rownames(data_frame_normalization_with_control_no_pair)
        
        summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
        summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
        row.names(summarydf_view) <- NULL
        
        output$usermaxresult3 <- renderDataTable(summarydf_view)
        output$usermaxresult3pro <- renderDataTable(df2)
        
        write.csv(summarydf_view, paste0(maxuserpreloc, "PreNormBasedProSummary_v.csv"), row.names = F)
        write.csv(summarydf, paste0(maxuserpreloc, "PreNormBasedProSummary.csv"), row.names = T)
        write.csv(df2, paste0(maxuserpreloc, "PrePro.csv"), row.names = F)
        updateTabsetPanel(session, "usermaxresultnav", selected = "usermaxstep3val")
        updateActionButton(session, "usermaxnormprobt", icon = icon("rotate-right"))
        updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
        sendSweetAlert(
          session = session,
          title = "All Done",
          text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
          type = "success",
          btn_labels = "OK"
        )
      }
    }
  )

  # parser
  observeEvent(
    input$parserbt11,{
      if(is.null(input$upmascot)|is.null(input$updesign)|is.null(input$uppeptide)) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please upload data",
          type = "info"
        )}
      
      else{
        
        phosphorylation_exp_design_info_file_path <- input$updesign$datapath
        # Convert the suffix, convert again after extraction for reading
        mascot_xml_dir <- mascotfilepath()
        mascot_txt_dir <- paste0(mascotuserpreloc, "mascottxt_data")
        file1 = normalizePath(list.files(mascot_xml_dir, full.names = T))
        file2 = list.files(file1, full.names = T)
        for (f in file2){
          tmpname <- substring(f, 0, nchar(f)-4)
          newname <- sub("$", ".xml", tmpname)
          file.rename(f, newname)
        }
        if(dir.exists(mascot_txt_dir)){
          unlink(mascot_txt_dir, recursive = T)
        }
        dir.create(mascot_txt_dir)
        
        withProgress(message = 'Step1:Paser', style = "notification", detail = "processing...",
                     value = 0,max = 2,{
                       for(i in 1:2){
                         if(i == 1){
                           extract_psites_score(phosphorylation_exp_design_info_file_path, mascot_xml_dir, mascot_txt_dir)
                           
                           file1 = normalizePath(list.files(mascot_xml_dir, full.names = T))
                           file2 = list.files(file1, full.names = T)
                           for (f in file2){
                             tmpname <- substring(f, 0, nchar(f)-4)
                             newname <- sub("$", ".txt", tmpname)
                             file.rename(f, newname)
                           }
                         }
                         if(i == 2){
                           withProgress(message = "Generating CSV files of phosphorylation sites with confidence score", style = "notification", detail = "This may take a while...", value = 0, {
                             BASE_DIR <- getwd()
                             mascot_txt_dir <- normalizePath(file.path(BASE_DIR, paste0(mascotuserpreloc, "mascottxt_data")))
                             phosphorylation_peptide_dir <- pepfilepath()
                             psites_score_dir <- paste0(mascotuserpreloc, "psites_score_csv")
                             if(dir.exists(psites_score_dir)){
                               unlink(psites_score_dir, recursive = T)
                             }
                             dir.create(psites_score_dir)
                             psites_score_dir <- normalizePath(file.path(BASE_DIR, psites_score_dir))
                             firmiana_peptide_dir <- phosphorylation_peptide_dir
                             mascot_txt_dir_paths <- list.dirs(mascot_txt_dir)
                             mascot_txt_dir_paths <- mascot_txt_dir_paths[-1]
                             mascot_txt_dir_paths_expNames <- list.files(mascot_txt_dir)
                             
                             firmiana_txt_file_names <- list.files(firmiana_peptide_dir)
                             firmiana_txt_file_names_expNames <- apply(data.frame(firmiana_txt_file_names), 1, function(x){
                               x <- strsplit(x, split = '_')[[1]]
                               x[1]
                             })
                             
                             mascot_txt_dir_paths_len <- length(mascot_txt_dir_paths)
                             cat('\n Total file: ', mascot_txt_dir_paths_len)
                             cat('\n It will take a little while.')
                             for(i in seq_len(mascot_txt_dir_paths_len)){
                               mascot_txt_dir_path <- mascot_txt_dir_paths[i]
                               mascot_txt_dir_path_expName <- mascot_txt_dir_paths_expNames[i]
                               mascot_txt_dir_path_expName_path <- list.files(mascot_txt_dir_path)
                               mascot_txt_dir_path_expName_path <- normalizePath(
                                 file.path(mascot_txt_dir_path, mascot_txt_dir_path_expName_path)
                               )
                               
                               match_index <- match(mascot_txt_dir_path_expName, firmiana_txt_file_names_expNames)
                               firmiana_txt_file_name <- firmiana_txt_file_names[match_index]
                               firmiana_peptide_dir_path_expName_path <- normalizePath(
                                 file.path(firmiana_peptide_dir, firmiana_txt_file_name)
                               )
                               
                               outputName <- normalizePath(
                                 file.path(psites_score_dir, paste(mascot_txt_dir_path_expName, '_psites_score.csv', sep = '')),
                                 mustWork = FALSE
                               )
                               expName <- mascot_txt_dir_path_expName
                               write_csv_pep_seq_conf(expName, outputName, mascot_txt_dir_path_expName_path, firmiana_peptide_dir_path_expName_path)
                               
                               cat('\n Completed file: ', i, '/', mascot_txt_dir_paths_len)
                               incProgress(1/mascot_txt_dir_paths_len, detail = paste0('\n Completed file: ', i, '/', mascot_txt_dir_paths_len))
                             }
                           })
                           
                           
                           output$parserresult12 <- renderUI({
                             tagList(
                               selectInput(
                                 "parserresult12id",
                                 NULL,
                                 choices = get_target_name(psites_score_dir, 1)
                               ),
                               dataTableOutput("parserresultdt2")
                             )
                           })
                           output$parserresult12nopro <- renderUI({
                             tagList(
                               selectInput(
                                 "parserresult12idnopro",
                                 NULL,
                                 choices = get_target_name(psites_score_dir, 1)
                               ),
                               dataTableOutput("parserresultdt2nopro")
                             )
                           })
                           output$parserresult12droppro <- renderUI({
                             tagList(
                               selectInput(
                                 "parserresult12iddroppro",
                                 NULL,
                                 choices = get_target_name(psites_score_dir, 1)
                               ),
                               dataTableOutput("parserresultdt2droppro")
                             )
                           })
                         }
                         incProgress(1, detail = "")
                       }
                     })
        
        updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep1val")
        updateTabsetPanel(session, "usermascotnoproresultnav", selected = "usermascotnoprostep1val")
        updateTabsetPanel(session, "usermascotdropproresultnav", selected = "usermascotdropprostep1val")
        
        updateActionButton(session, "parserbt11", icon = icon("rotate-right"))
        updateActionButton(session, "mergingbt1", icon = icon("play"))
        updateActionButton(session, "mappingbt11", icon = icon("play"))
        updateActionButton(session, "normalizationbt11", icon = icon("play"))
        updateActionButton(session, "normalizationbt12", icon = icon("play"))
        
        if(is.null(input$useruseprocheck1)) {
          updateProgressBar(session = session, id = "userpreprobar", value = 25)
        } else if(input$useruseprocheck1 == 1) {
          updateProgressBar(session = session, id = "userpreprobar", value = 20)
        } else {
          updateProgressBar(session = session, id = "userpreprobar", value = 25)
        }
        
      }
    }
  )
  
  observeEvent(
    input$parserresult12id,{
      output$parserresultdt2 <- renderDataTable({
        id <- input$parserresult12id
        psites_score_dir <- paste0(mascotuserpreloc, "psites_score_csv")
        # Determine the file path based on the relative index position
        index = which(get_target_name(psites_score_dir, 1) == id)
        path <- list.files(psites_score_dir, full.names = T)[index]
        dataread <- read.csv(path, header = T)
        dataread
      })
    }
  )
  observeEvent(
    input$parserresult12idnopro,{
      output$parserresultdt2nopro <- renderDataTable({
        id <- input$parserresult12idnopro
        psites_score_dir <- paste0(mascotuserpreloc, "psites_score_csv")
        # Determine the file path based on the relative index position
        index = which(get_target_name(psites_score_dir, 1) == id)
        path <- list.files(psites_score_dir, full.names = T)[index]
        dataread <- read.csv(path, header = T)
        dataread
      })
    }
  )
  observeEvent(
    input$parserresult12iddroppro,{
      output$parserresultdt2droppro <- renderDataTable({
        id <- input$parserresult12iddroppro
        psites_score_dir <- paste0(mascotuserpreloc, "psites_score_csv")
        # Determine the file path based on the relative index position
        index = which(get_target_name(psites_score_dir, 1) == id)
        path <- list.files(psites_score_dir, full.names = T)[index]
        dataread <- read.csv(path, header = T)
        dataread
      })
    }
  )
  
  # qc and merging
  observeEvent(
    input$mergingbt1,{
      if(!(dir.exists(paste0(mascotuserpreloc, "psites_score_csv")))) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        psites_score_dir <- paste0(mascotuserpreloc, "psites_score_csv")
        phosphorylation_exp_design_info_file_path <- input$updesign$datapath
        phosphorylation_peptide_dir <- pepfilepath()
        merge_df_with_phospho_peptides <- pre_process_filter_psites( 
          phosphorylation_peptide_dir,
          psites_score_dir,
          phosphorylation_exp_design_info_file_path,
          qc = TRUE,
          min_score = input$qcscore,
          min_FDR = input$qcfdr
        )
        write.csv(merge_df_with_phospho_peptides, paste0(mascotuserpreloc, "merge_df_with_phospho_peptides.csv"), row.names = F)
        output$viewedmerging1 <- renderDataTable(merge_df_with_phospho_peptides)
        output$viewedmerging1nopro <- renderDataTable(merge_df_with_phospho_peptides)
        output$viewedmerging1droppro <- renderDataTable(merge_df_with_phospho_peptides)
        updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep2val")
        updateTabsetPanel(session, "usermascotnoproresultnav", selected = "usermascotnoprostep2val")
        updateTabsetPanel(session, "usermascotdropproresultnav", selected = "usermascotdropprostep2val")
        
        updateActionButton(session, "mergingbt1", icon = icon("rotate-right"))
        updateActionButton(session, "mappingbt11", icon = icon("play"))
        updateActionButton(session, "normalizationbt11", icon = icon("play"))
        updateActionButton(session, "normalizationbt12", icon = icon("play"))
        
        if(is.null(input$useruseprocheck1)) {
          updateProgressBar(session = session, id = "userpreprobar", value = 50)
        } else if(input$useruseprocheck1 == 1) {
          updateProgressBar(session = session, id = "userpreprobar", value = 40)
        } else {
          updateProgressBar(session = session, id = "userpreprobar", value = 50)
        }
      }
    }
  )
  
  # mapping
  observeEvent(
    input$mappingbt11,{
      if(!file.exists(paste0(mascotuserpreloc,'merge_df_with_phospho_peptides.csv'))) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        withProgress(message = 'Step3:Mapping', style = "notification", detail = "processing...",
                     value = 0,max = 2,{
                       for(ii in 1:2){
                         if(ii == 1){
                           merge_df_with_phospho_peptides <- read.csv(paste0(mascotuserpreloc, "merge_df_with_phospho_peptides.csv"))
                           
                           combined_df_with_mapped_gene_symbol = get_combined_data_frame02(
                             merge_df_with_phospho_peptides, species = input$species, id_type = input$idtype
                           )
                           write.csv(combined_df_with_mapped_gene_symbol, paste0(mascotuserpreloc, "combined_df_with_mapped_gene_symbol.csv"), row.names = F)
                         }
                         if(ii == 2){
                           combined_df_with_mapped_gene_symbol <- read.csv(paste0(mascotuserpreloc, "combined_df_with_mapped_gene_symbol.csv"))
                           
                           summary_df_of_unique_proteins_with_sites = get_summary_with_unique_sites02(
                             combined_df_with_mapped_gene_symbol, species = input$species, fasta_type = input$fastatype
                           )
                           write.csv(summary_df_of_unique_proteins_with_sites, paste0(mascotuserpreloc, "summary_df_of_unique_proteins_with_sites.csv"), row.names = T)
                           output$viewedmapping12 <- renderDataTable(summary_df_of_unique_proteins_with_sites)
                           output$viewedmapping12nopro <- renderDataTable(summary_df_of_unique_proteins_with_sites)
                           output$viewedmapping12droppro <- renderDataTable(summary_df_of_unique_proteins_with_sites)
                           updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep3val")
                           updateTabsetPanel(session, "usermascotnoproresultnav", selected = "usermascotnoprostep3val")
                           updateTabsetPanel(session, "usermascotdropproresultnav", selected = "usermascotdropprostep3val")
                           
                           updateActionButton(session, "mappingbt11", icon = icon("rotate-right"))
                           updateActionButton(session, "normalizationbt11", icon = icon("play"))
                           updateActionButton(session, "normalizationbt12", icon = icon("play"))
                           
                           if(is.null(input$useruseprocheck1)) {
                             updateProgressBar(session = session, id = "userpreprobar", value = 75)
                           } else if(input$useruseprocheck1 == 1) {
                             updateProgressBar(session = session, id = "userpreprobar", value = 60)
                           } else {
                             updateProgressBar(session = session, id = "userpreprobar", value = 75)
                           }
                         }
                         incProgress(1, detail = "")
                       }
                     })
      }
    }
  )
  
  
  observeEvent(input$normalizationbt11, {
    if(!file.exists(paste0(mascotuserpreloc, 'summary_df_of_unique_proteins_with_sites.csv'))) {
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      summary_df_of_unique_proteins_with_sites <- read.csv(paste0(mascotuserpreloc, "summary_df_of_unique_proteins_with_sites.csv"), row.names = 1)
      phosphorylation_exp_design_info_file_path <- input$updesign$datapath
      phospho_data_filtering_STY_and_normalization_list <- get_normalized_data_of_psites2(
        summary_df_of_unique_proteins_with_sites,
        phosphorylation_exp_design_info_file_path,
        input$usermasphosNAthre,
        normmethod = input$mascotnormmethod,
        imputemethod = input$mascotimputemethod,
        topN = NA, mod_types = c('S', 'T', 'Y')
      )

      phospho_data_filtering_STY_and_normalization <-
        phospho_data_filtering_STY_and_normalization_list$ptypes_fot5_df_with_id
      
      ID <- paste(phospho_data_filtering_STY_and_normalization$GeneSymbol,
                  phospho_data_filtering_STY_and_normalization$AA_in_protein,
                  sep = '_')
      Value <- phospho_data_filtering_STY_and_normalization[,-seq(1,6)]
      phospho_data <- data.frame(ID, Value)
      phospho_data_rownames <- paste(phospho_data_filtering_STY_and_normalization$ID,
                                     phospho_data_filtering_STY_and_normalization$GeneSymbol,
                                     phospho_data_filtering_STY_and_normalization$AA_in_protein,
                                     sep = '_')
      rownames(phospho_data) <- phospho_data_rownames
      
      phospho_data_for_motifanalysis <- cbind(phospho_data_filtering_STY_and_normalization$AA_in_protein, phospho_data_filtering_STY_and_normalization$Sequence, phospho_data_filtering_STY_and_normalization$ID, phospho_data[-1])
      # Further filter phosphoproteomics data..
      phospho_data_topX = keep_psites_with_max_in_topX(phospho_data, percent_of_kept_sites = input$top/100)
      phospho_data_for_motifanalysis2 = keep_psites_with_max_in_topX2(phospho_data_for_motifanalysis, percent_of_kept_sites = input$top/100)
      colnames(phospho_data_for_motifanalysis2) <- c("AA_in_protein", "Sequence", "ID", colnames(phospho_data_for_motifanalysis2)[-c(1,2,3)])
      
      summarydf <- data.frame(phospho_data_topX$ID, phospho_data_for_motifanalysis2)
      colnames(summarydf) <- c("Position", colnames(phospho_data_for_motifanalysis2))
      rownames(summarydf) <- rownames(phospho_data_topX)
      
      summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
      summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
      row.names(summarydf_view) <- NULL
      
      output$viewednorm14 <- renderDataTable(summarydf_view)
      output$viewednorm14nopro <- renderDataTable(summarydf_view)
      output$viewednorm14droppro <- renderDataTable(summarydf_view)
      
      write.csv(summarydf_view, paste0(mascotuserpreloc, 'NormImputeSummary_v.csv'), row.names = F)
      write.csv(summarydf, paste0(mascotuserpreloc, 'NormImputeSummary.csv'), row.names = T)
      
      updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep4val")
      updateTabsetPanel(session, "usermascotnoproresultnav", selected = "usermascotnoprostep4val")
      updateTabsetPanel(session, "usermascotdropproresultnav", selected = "usermascotdropprostep4val")
      
      updateActionButton(session, "normalizationbt11", icon = icon("rotate-right"))
      updateActionButton(session, "normalizationbt12", icon = icon("play"))
      
      if(is.null(input$useruseprocheck1)) {
        updateProgressBar(session = session, id = "userpreprobar", value = 100)
        sendSweetAlert(
          session = session,
          title = "All Done",
          text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
          type = "success",
          btn_labels = "OK"
        )
      } else if(input$useruseprocheck1 == 1) {
        updateProgressBar(session = session, id = "userpreprobar", value = 80)
      } else {
        updateProgressBar(session = session, id = "userpreprobar", value = 100)
        sendSweetAlert(
          session = session,
          title = "All Done",
          text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
          type = "success",
          btn_labels = "OK"
        )
      }
    }
  })
  
  # If the user uploads the proteome data, show the option
  proaval <- reactive(is.null(input$upprodesign) | is.null(input$upprogene))
  
  grouplabel <- reactive({
    phosphorylation_experiment_design_file = read.csv(input$updesign$datapath, 
                                                        header = T, sep = '\t', stringsAsFactors = NA)
    unique(phosphorylation_experiment_design_file$Group)
  })
  
  output$userusepro <- renderUI({
    if(proaval()) {
      NULL
    }else {
      tagList(
        
        panel(
          heading = "Step5: Normalization based on proteomics data",
          status = "success",
          prettyToggle(
            inputId = "useruseprocheck1",
            label_on = "Use proteomics data", 
            icon_on = icon("check"),
            status_on = "info",
            status_off = "warning", 
            label_off = "Donot use proteomics data",
            icon_off = icon("xmark"),
            value = TRUE
          ),
          conditionalPanel(
            condition = "input.useruseprocheck1 == 1",
            wellPanel(
              h5("Proteomics data preprocessing parameters", style = "color: grey;"),
              numericInput("usermasuscutoff", label = "US cutoff: ", value = 1),
              numericInput("usermasproNAthre", label = "minimum detection frequency: ", value = 1, min = 0),
              bsTooltip(
                "usermasproNAthre",
                "minimum detection frequency for per locus, equivalents to the number of samples minus the number of ‘0’ value",
                placement = "right",
                options = list(container = "body")
              ),
              selectInput("usermascotpronormmethod", label = "normalization method: ", choices = c("global", "median")),
              selectInput("usermascotproimputemethod", label = "imputation method: ", choices = c("0", "minimum", "minimum/10"), selected = "minimum/10"),
            ),
            selectInput("usermascotcontrol", label = "control label: ", choices = c(grouplabel(), "no control")),
            div(
              class = "runbuttondiv",
              actionButton(
                "normalizationbt12",
                "",
                icon("play"),
                class = "runbutton"
              )
            )
          ),
          conditionalPanel(
            condition = "input.useruseprocheck1 == 0",
            wellPanel(
              h5("After 'Step1-Step2-Step3-Step4' have been run, you can click 'Go to analysis tools'", style = "color: grey;")
            )
          )
        )
      )
    }
  })
  
  output$userresultpanelui <- renderUI({
    if(proaval()) {
      tagList(
        navbarPage(
          title = "Result",
          id = "usermascotnoproresultnav",
          tabPanel(
            "Step 1",
            value = "usermascotnoprostep1val",
            h4("Peptide identification files with psites scores:"),
            uiOutput("parserresult12nopro")
          ),
          tabPanel(#quality control and merging 
            "Step 2",
            value = "usermascotnoprostep2val",
            h4("Peptide data frame through phosphorylation sites quality control:"),
            column(11,dataTableOutput("viewedmerging1nopro")),
            column(1,downloadBttn(
              outputId = "viewedmerging1nopro_dl",
              label = "",
              style = "material-flat",
              color = "default",
              size = "sm"
            ))
          ),
          tabPanel(
            "Step 3",
            value = "usermascotnoprostep3val",
            h4("Data frame mapped ID to Gene Symbol:"),
            column(11,dataTableOutput("viewedmapping12nopro")),
            column(1,downloadBttn(
              outputId = "viewedmapping12nopro_dl",
              label = "",
              style = "material-flat",
              color = "default",
              size = "sm"
            ))
          ),
          tabPanel(
            "Step 4",#normalization1
            value = "usermascotnoprostep4val",
            h4("Phosphorylation data frame:"),
            column(11,dataTableOutput("viewednorm14nopro")),
            column(1,downloadBttn(
              outputId = "viewednorm14nopro_dl",
              label = "",
              style = "material-flat",
              color = "default",
              size = "sm"
            ))
          )
        )
      )
    } else {
      tagList(
        conditionalPanel(
          condition = "input.useruseprocheck1 == 1",
          navbarPage(
            title = "Result",
            id = "usermascotresultnav",
            tabPanel(
              "Step 1",
              value = "usermascotstep1val",
              h4("Peptide identification files with psites scores:"),
              uiOutput("parserresult12")
            ),
            tabPanel(
              "Step 2",
              value = "usermascotstep2val",
              h4("Peptide data frame through phosphorylation sites quality control:"),
              column(11,dataTableOutput("viewedmerging1")),
              column(1,downloadBttn(
                outputId = "viewedmerging1_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 3",
              value = "usermascotstep3val",
              h4("Data frame mapped ID to Gene Symbol:"),
              column(11,dataTableOutput("viewedmapping12")),
              column(1,downloadBttn(
                outputId = "viewedmapping12_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 4",
              value = "usermascotstep4val",
              h4("Phosphorylation data frame:"),
              column(11,dataTableOutput("viewednorm14")),
              column(1,downloadBttn(
                outputId = "viewednorm14_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 5",
              value = "usermascotstep5val",
              h4("Phosphorylation data frame:"),
              column(11,dataTableOutput("viewednorm15")),
              column(1,downloadBttn(
                outputId = "viewednorm15_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              )),
              br(),
              h4("Proteomics data frame:"),
              column(11,dataTableOutput("viewednorm15pro")),
              column(1,downloadBttn(
                outputId = "viewednorm15pro_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            )
          )
        ),
        conditionalPanel(
          condition = "input.useruseprocheck1 == 0",
          navbarPage(
            title = "Result",
            id = "usermascotdropproresultnav",
            tabPanel(
              "Step 1",
              value = "usermascotdropprostep1val",
              h4("Peptide identification files with psites scores:"),
              uiOutput("parserresult12droppro")
            ),
            tabPanel(
              "Step 2",#qc and merging
              value = "usermascotdropprostep2val",
              h4("Peptide data frame through phosphorylation sites quality control:"),
              column(11,dataTableOutput("viewedmerging1droppro")),
              column(1,downloadBttn(
                outputId = "viewedmerging1droppro_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(
              "Step 3",#mapping
              value = "usermascotdropprostep3val",
              h4("Data frame mapped ID to Gene Symbol:"),
              column(11,dataTableOutput("viewedmapping12droppro")),
              column(1,downloadBttn(
                outputId = "viewedmapping12droppro_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            ),
            tabPanel(#normalization 1
              "Step 4",
              value = "usermascotdropprostep4val",
              h4("Phosphorylation data frame:"),
              column(11,dataTableOutput("viewednorm14droppro")),
              column(1,downloadBttn(
                outputId = "viewednorm14droppro_dl",
                label = "",
                style = "material-flat",
                color = "default",
                size = "sm"
              ))
            )
          )
        )
      )
    }
  })
  
  observeEvent(input$normalizationbt12, {
    if(!file.exists(paste0(mascotuserpreloc, 'NormImputeSummary.csv'))) {
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = "Please click the buttons in order",
        type = "info"
      )
    }
    else{
      summarydf <- read.csv(paste0(mascotuserpreloc, 'NormImputeSummary.csv'), row.names = 1)
      phospho_data_topX <- summarydf[, c(-2, -3, -4)]
      colnames(phospho_data_topX)[1] <- "ID"
      
      phospho_data_for_motifanalysis2 <- summarydf[, -1]
      
      profiling_gene_dir <- list.files(paste0(mascotuserpreloc, 'proteomics_data'), full.names = T)
      profiling_exp_design_info_file_path <- input$upprodesign$datapath
      profiling_data = merge_profiling_file_from_Firmiana(profiling_gene_dir, US_cutoff = input$usermasuscutoff, profiling_exp_design_info_file_path)
      experiment_code <- utils::read.csv(profiling_exp_design_info_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
      NAnumthre <- length(experiment_code$Experiment_Code) - input$usermasproNAthre
      if(NAnumthre < 0) {NAnumthre = 0}
      NAnumthresig <- c()
      for (row in 1:nrow(profiling_data)) {
        NAnumthresig[row] <- (sum(profiling_data[row,][-1] == 0) <= NAnumthre)
      }
      profiling_data <- profiling_data[NAnumthresig,]
      
      profiling_data = get_normalized_data_FOT52(profiling_data, profiling_exp_design_info_file_path, normmethod = input$usermascotpronormmethod, imputemethod = input$usermascotproimputemethod)
      
      phosphorylation_exp_design_info_file_path <- input$updesign$datapath
      controllabel = input$usermascotcontrol
      if(controllabel == "no control") {
        controllabel = NA
      }
      data_frame_normalization_with_control_no_pair = normalize_phos_data_to_profiling(phospho_data_topX, profiling_data,
                                                                                        phosphorylation_exp_design_info_file_path, profiling_exp_design_info_file_path,
                                                                                        control_label = controllabel,
                                                                                        pair_flag = FALSE)
      data_frame_normalization_with_control_no_pair_for_motifanalysis <- cbind(phospho_data_for_motifanalysis2[c(1,2,3)], data_frame_normalization_with_control_no_pair[-1])
      
      summarydf <- data.frame(data_frame_normalization_with_control_no_pair$ID, data_frame_normalization_with_control_no_pair_for_motifanalysis)
      colnames(summarydf) <- c("Position", colnames(data_frame_normalization_with_control_no_pair_for_motifanalysis))
      rownames(summarydf) <- rownames(data_frame_normalization_with_control_no_pair)
      
      summarydf_view <- subset(summarydf, select = -c(Position, AA_in_protein, ID))
      summarydf_view <- cbind(upsID = row.names(summarydf_view), summarydf_view)
      row.names(summarydf_view) <- NULL
      
      output$viewednorm15 <- renderDataTable(summarydf_view)
      output$viewednorm15pro <- renderDataTable(profiling_data)
      
      write.csv(summarydf_view, paste0(mascotuserpreloc, "PreNormBasedProSummary_v.csv"), row.names = F)
      write.csv(summarydf, paste0(mascotuserpreloc, "PreNormBasedProSummary.csv"), row.names = T)
      write.csv(profiling_data, paste0(mascotuserpreloc, "PrePro.csv"), row.names = F)
      updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep5val")
      
      updateActionButton(session, "normalizationbt12", icon = icon("rotate-right"))
      updateProgressBar(session = session, id = "userpreprobar", value = 100)
      sendSweetAlert(
        session = session,
        title = "All Done",
        text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
        type = "success",
        btn_labels = "OK"
      )
    }
  })
  
  # user max tmt
  observeEvent(
    input$usermaxtmtqcbt, {
      if(is.null(input$upusermaxtmtphos)|is.null(input$updesign)) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please upload data",
          type = "info"
        )
      } else {
        tmt_df <- read.csv(input$upusermaxtmtphos$datapath,header=T,sep='\t')
        filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
        
        # Filter reverse and contaminant
        tmt_df <- tmt_df[-which(tmt_df$Reverse=="+"),]
        tmt_df <- tmt_df[-which(tmt_df$Potential.contaminant=="+"),]
        tmt_df <- tmt_df[-which(tmt_df$Protein == "" | tmt_df$Gene.names == ""),]
        
        varnames <- c()
        for(i in 1:nrow(filenames)){
          varnames[i] <- paste0('Reporter.intensity.corrected.',filenames$Experiment_Code[i],'___1')
        }
        
        myvar <- c('Proteins', 'Positions.within.proteins', 'Protein','Gene.names','Amino.acid', 
                   'Localization.prob','Score', 'Phospho..STY..Probabilities', 
                   'Position.in.peptide', varnames)
        tmt_df <- tmt_df[myvar]
        
        # Filter by qc config
        tmt_df <- tmt_df[which(tmt_df$Localization.prob >= input$maxtmtminqclocalizationprob & tmt_df$Score >= input$maxtmtminqcscore),]
        
        Protein <- apply(data.frame(tmt_df$Protein), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        Gene.names <- apply(data.frame(tmt_df$Gene.names), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        tmt_df$Protein <- Protein
        tmt_df$Gene.names <- Gene.names
        
        get_combined <- function(protein, proteins, positions, Gene.names, psite) {
          protein_index <- which(strsplit(proteins, ";")[[1]] == protein)
          if (length(protein_index) > 0) {
            positions <- strsplit(positions, ";")[[1]]
            combined <- paste(protein, Gene.names, paste0(psite, positions[protein_index]), sep = "_")
          } else {
            combined <- NA
          }
          return(combined)
        }
        
        # Retrive upsID
        tmt_df$upsID <- mapply(get_combined, tmt_df$Protein, tmt_df$Proteins, 
                               tmt_df$Positions.within.proteins, tmt_df$Gene.names, tmt_df$Amino.acid)
        
        # Retrive sequence
        sequence <- gsub("\\(.*?\\)","",tmt_df$Phospho..STY..Probabilities)
        Sequence <- c()
        for (i in seq(length(sequence))) {
          tmp <- unlist(str_split(sequence[i], pattern = ""))
          index <- tmt_df$Position.in.peptide[i]
          tmp[index] <- tolower(tmp[index])
          
          Sequence[i] <- paste(tmp, collapse = "")
        }
        
        tmt_df$Sequence <- Sequence
        
        tmt_df <- tmt_df[c('upsID', 'Sequence', varnames)]
        
        # Filter by the number of NA
        NAnumthre <- length(filenames$Experiment_Code) - input$maxtmtphosNAthre  # NA threshold
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()
        for (row in 1:nrow(tmt_df)) {
          NAnumthresig[row] <- (sum(tmt_df[row,][-c(1, 2)] == 0) <= NAnumthre)
        }
        tmt_df_filter <- tmt_df[NAnumthresig,]
        
        # Change column names to match the design file
        colnames(tmt_df_filter) <- sub("^Reporter\\.intensity\\.corrected\\.(.*)___1$", "\\1", colnames(tmt_df_filter), perl = TRUE)
        
        write.csv(tmt_df_filter, paste0(maxtmtuserpreloc, "PreQc.csv"), row.names = F)
        output$usermaxtmtresult1 <- renderDataTable(({datatable(tmt_df_filter)}))
        updateTabsetPanel(session, "usermaxtmtresultnav", selected = "usermaxtmtstep1val")
        updateActionButton(session, "usermaxtmtqcbt", icon = icon("rotate-right"))
        updateActionButton(session, "usermaxtmtnormbt", icon = icon("play"))
        updateProgressBar(session = session, id = "usermaxtmtpreprobar", value = 50)
      }
    }
  )
  
  observeEvent(
    input$usermaxtmtnormbt, {
      if(!file.exists(
        paste0(maxtmtuserpreloc, "PreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv(input$updesign$datapath,header=T,sep = '\t')
        newdata3out <- read.csv(paste0(maxtmtuserpreloc, "PreQc.csv"), check.names=F)
        normmethod <- "global" # median
        if(input$maxtmtphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,sum,na.rm=T),FUN="/")
        }
        if(input$maxtmtphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$maxtmtdemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$maxtmtphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$maxtmtphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
              
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$maxtmtphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
            
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }
          
        }
        
        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$maxtmttop/100)
          output$usermaxtmtresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(maxtmtuserpreloc, "PreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "usermaxtmtresultnav", selected = "usermaxtmtstep2val")
          updateActionButton(session, "usermaxtmtnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "usermaxtmtpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  # user sn
  observeEvent(
    input$usersnqcbt, {
      if(is.null(input$upusersnphos)|is.null(input$updesign)) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please upload data",
          type = "info"
        )
      } else {
        old_filename <- input$upusersnphos$datapath
        new_filename <- sub(".xls$", ".csv", old_filename)
        file.rename(old_filename, new_filename)
        sn_df <- read.csv(new_filename, sep = '\t', check.names=F)
        file.rename(new_filename, old_filename)
        
        filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
        
        colnames(sn_df) <- sub("\\[\\d+\\] (.*)\\.raw\\.PEP\\.MS2Quantity", "\\1", colnames(sn_df))
        # varnames <- c()
        # for(i in 1:nrow(filenames)){
        #   varnames[i] <- paste0('[',i,']',' ', filenames$Experiment_Code[i],'.raw.PEP.MS2Quantity')
        # }
        # 
        myvar <- c('PG.ProteinAccessions', 'PG.Genes', 'EG.ProteinPTMLocations', 'EG.ModifiedSequence', filenames$Experiment_Code)
        sn_df <- sn_df[myvar]
        
        sn_df <- sn_df[-which(sn_df$PG.ProteinAccessions == "" | sn_df$PG.Genes == "" | sn_df$EG.ProteinPTMLocations == "" | sn_df$EG.ModifiedSequence == ""),]
        
        PG.ProteinAccessions <- apply(data.frame(sn_df$PG.ProteinAccessions), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        
        PG.Genes <- apply(data.frame(sn_df$PG.Genes), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        
        EG.ProteinPTMLocations <- apply(data.frame(sn_df$EG.ProteinPTMLocations), 1, function(x){
          x <- strsplit(x, split = ';')[[1]]
          x[1]
        })
        
        sn_df$PG.ProteinAccessions <- PG.ProteinAccessions
        sn_df$PG.Genes <- PG.Genes
        sn_df$EG.ProteinPTMLocations <- EG.ProteinPTMLocations
        
        process_locations <- function(locations) {
          
          # Remove multiple bracket
          if (grepl("\\(.*\\).*\\(.*\\)", locations)) {
            return(NA)
          }
          # Remove bracket
          locations <- gsub("[()]", "", locations)
          
          elements <- strsplit(locations, ",")[[1]]
          
          # S\T\Y
          s_elements <- grep("S", elements, value = TRUE)
          t_elements <- grep("T", elements, value = TRUE)
          y_elements <- grep("Y", elements, value = TRUE)
          
          # Count
          countS <- length(s_elements)
          countT <- length(t_elements)
          countY <- length(y_elements)
          
          if (countS + countT + countY == 1) {
            if (countS == 1) {
              locations <- gsub(".*?(S\\d+).*", "\\1", s_elements)
            } else if (countT == 1) {
              locations <- gsub(".*?(T\\d+).*", "\\1", t_elements)
            } else {
              locations <- gsub(".*?(Y\\d+).*", "\\1", y_elements)
            }
          } else {
            # Remove multiple sites
            locations <- NA
          }
          
          return(locations)
        }
        
        sn_df$test_EG.ProteinPTMLocations <- sapply(sn_df$EG.ProteinPTMLocations, process_locations)
        sn_df <- sn_df[-which(is.na(sn_df$test_EG.ProteinPTMLocations)),]
        
        process_sequence <- function(sequence) {
          # Remove _
          sequence <- str_remove_all(sequence, "^_|_$")
          
          match <- str_locate(sequence, "\\[Phospho \\(STY\\)\\]")
          
          if (!is.na(match[1])) {
            start <- match[1]
            end <- match[2]
            left <- tolower(str_sub(sequence, start - 1, start - 1))
            sequence <- paste0(str_sub(sequence, 1, start - 2), left, str_sub(sequence, start, end), str_sub(sequence, end + 1))
          }
          sequence <- str_remove_all(sequence, "\\[.*?\\]")
          return(sequence)
        }
        
        sn_df$Sequence <- sapply(sn_df$EG.ModifiedSequence, process_sequence)
        sn_df$upsID <- paste(sn_df$PG.ProteinAccessions, sn_df$PG.Genes, sn_df$test_EG.ProteinPTMLocations, sep = "_")
        sn_df <- sn_df[c("upsID", "Sequence", filenames$Experiment_Code)]
        
        # colnames(sn_df) <- sub("\\[\\d+\\] (.*)\\.raw\\.PEP\\.MS2Quantity", "\\1", colnames(sn_df))
        
        # Filter by the number of NA
        NAnumthre <- length(filenames$Experiment_Code) - input$snphosNAthre  # NA threshold
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()
        for (row in 1:nrow(sn_df)) {
          NAnumthresig[row] <- (sum(is.na(sn_df[row,][-c(1, 2)])) <= NAnumthre)
        }
        sn_df_filter <- sn_df[NAnumthresig,]
        
        write.csv(sn_df_filter, paste0(snuserpreloc, "PreQc.csv"), row.names = F)
        output$usersnresult1 <- renderDataTable(({datatable(sn_df_filter)}))
        updateTabsetPanel(session, "usersnresultnav", selected = "usersnstep1val")
        updateActionButton(session, "usersnqcbt", icon = icon("rotate-right"))
        updateActionButton(session, "usersnnormbt", icon = icon("play"))
        updateProgressBar(session = session, id = "usersnpreprobar", value = 50)
      }
    }
  )
  
  observeEvent(
    input$usersnnormbt, {
      if(!file.exists(
        paste0(snuserpreloc, "PreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv(input$updesign$datapath,header=T,sep = '\t')
        newdata3out <- read.csv(paste0(snuserpreloc, "PreQc.csv"))
        
        newdata4 = newdata3out[-c(1,2)]
        
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$sndemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$snphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$snphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
              
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$snphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
            
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }
          
        }
        
        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          
          value_cols <- names(df)[3:ncol(df)]
          
          df <- df %>%
            group_by(upsID) %>%
            summarize(Sequence = first(Sequence), across(all_of(value_cols), sum))
          
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$sntop/100)
          output$usersnresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(snuserpreloc, "PreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "usersnresultnav", selected = "usersnstep2val")
          updateActionButton(session, "usersnnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "usersnpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  # user diann
  observeEvent(
    input$userdiannqcbt, {
      if(is.null(input$upuserdiannphos)|is.null(input$updesign)) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please upload data",
          type = "info"
        )
      } else {
        diann_df <- as.data.frame(fread(input$upuserdiannphos$datapath, stringsAsFactors = FALSE))
        # diann_df <- read.csv("PhosMap_datasets/diann/mini_diann_report_modified.csv")
        filenames <- read.csv(input$updesign$datapath,header = T,sep='\t')
        
        # Filter by filenames
        diann_df <- diann_df %>% filter(Run %in% filenames$Experiment_Code)

        fasta_file = paste0('PhosMap_datasets/fasta_library/uniprot/', input$diannspecies, '/', input$diannspecies, '_uniprot_fasta.txt')
        PHOSPHATE_LIB_FASTA_DATA = utils::read.table(file=fasta_file, header=TRUE, sep="\t")
        
        diann_df_var <- c("Run", "Protein.Group", "Genes", "PG.MaxLFQ", "Modified.Sequence", "Stripped.Sequence", "PTM.Q.Value")
        diann_df <- diann_df[diann_df_var]
        
        diann_df <- diann_df[which(diann_df$PTM.Q.Value <= input$diannptmqvalue),]
        
        for (i in 1:nrow(diann_df)) {
          if(!(i %% 5000)) {
            showNotification(
              paste0("Processing, please wait. Currently completed processing ", i, " out of ", nrow(diann_df), " rows of data."),
              duration = 3  # second
            )
          }
          diann_df_modified_seq <- diann_df[i, "Modified.Sequence"]
          # Check Phospho
          match_result <- regexpr("\\(UniMod:21\\)", diann_df_modified_seq)
          if(match_result != -1) {
            substring <- substr(diann_df_modified_seq, 1, match_result - 1)
            updated_string <- gsub("\\([^()]+\\)", "", substring)
            index_pep <- nchar(updated_string)
            site_type <- substr(updated_string, index_pep, index_pep)
          } else {
            index_pep <- -1
            site_type <- 'non-phos'
          }
          if(index_pep != -1) {
            # Find peptide in whole protein
            diann_df_seq <- diann_df[i, "Stripped.Sequence"]
            source_seq <- PHOSPHATE_LIB_FASTA_DATA[PHOSPHATE_LIB_FASTA_DATA$ID == diann_df[i, "Protein.Group"],]$Sequence
            matches <- gregexpr(diann_df_seq, source_seq)
            if (length(matches) > 0 && any(matches[[1]] != -1)) {  # some protein not in fasta file
              start_positions <- matches[[1]]
              notfound <- 0  # found
            } else {
              start_positions <- -1
              notfound <- 1  # dont find pep in protein, maybe need update fasta file.
            }
            if(length(start_positions) == 1) {
              if(start_positions != -1) {
                # Get index in protein
                index <- start_positions[1] + index_pep - 1
                phospho_site <- paste0(site_type, index)
                upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
              } else {
                index <- -1
                phospho_site <- paste0(site_type, index)
                upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
              }
            } else {
              index <- -2
              phospho_site <- paste0(site_type, index)
              upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
            }
          } else {
            index <- -3
            notfound <- -1
            phospho_site <- paste0(site_type, index)
            upsID <- paste(diann_df[i, "Protein.Group"], diann_df[i, "Genes"], phospho_site, sep = "_")
          }
          # Modify p-site to lower case
          if(notfound == 0 & index != -2) {
            part1 <- substr(diann_df_seq, 1, index_pep - 1)
            part2 <- tolower(substr(diann_df_seq, index_pep, index_pep))
            part3 <- substr(diann_df_seq, index_pep + 1, nchar(diann_df_seq))
            diann_df_seq <- paste0(part1, part2, part3)
          } else {
            diann_df_seq <- -1
          }
          diann_df[i, "upsID"] <- upsID
          diann_df[i, "Sequence"] <- diann_df_seq
          diann_df[i, "index"] <- index  # the index of phospho-site in corresponding protein. -1: not found,equal 'not found=1'; -2: multi phospho-site; -3: no phospho-site,equal 'not found=-1'
          diann_df[i, "notfound"] <- notfound  # 0: found; 1: not found; -1: no phospho-site
        }
        # Following information maybe useful in future.
        diann_df_notfound = diann_df[which(diann_df$notfound == 1),]
        diann_df_other_modify = diann_df[which(diann_df$notfound == -1),]
        diann_df_phos = diann_df[which(diann_df$notfound == 0),]
        diann_df_phos_multi = diann_df_phos[which(diann_df_phos$index == -2),]
        diann_df_phos_single = diann_df_phos[which(diann_df_phos$index != -2),]
        final_diann_df_phos_single = diann_df_phos_single[c("upsID", "Sequence", "PG.MaxLFQ", "Run")]
        grouped_df <- final_diann_df_phos_single %>%
          group_by(upsID, Run) %>%
          summarise(Sequence = first(Sequence), PG.MaxLFQ = sum(PG.MaxLFQ))
        grouped_df <- grouped_df %>%
          group_by(upsID) %>%
          mutate(Sequence = first(Sequence))
        final_df <- grouped_df %>%
          pivot_wider(names_from = Run, values_from = PG.MaxLFQ, values_fill = 0)
        final_df$upsID <- as.character(final_df$upsID)
        # Filter by the number of NA
        NAnumthre <- length(filenames$Experiment_Code) - input$diannphosNAthre
        if(NAnumthre < 0) {NAnumthre = 0}
        NAnumthresig <- c()
        for (row in 1:nrow(final_df)) {
          NAnumthresig[row] <- (sum(final_df[row,][-c(1:2)] == 0) <= NAnumthre)
        }
        final_df <- final_df[NAnumthresig,]
        final_df <- final_df[c("upsID", "Sequence", filenames$Experiment_Code)]
        
        write.csv(final_df, paste0(diannuserpreloc, "PreQc.csv"), row.names = F)
        output$userdiannresult1 <- renderDataTable(({datatable(final_df)}))
        updateTabsetPanel(session, "userdiannresultnav", selected = "userdiannstep1val")
        updateActionButton(session, "userdiannqcbt", icon = icon("rotate-right"))
        updateActionButton(session, "userdiannnormbt", icon = icon("play"))
        updateProgressBar(session = session, id = "userdiannpreprobar", value = 50)
      }
    }
  )
  
  observeEvent(
    input$userdiannnormbt, {
      if(!file.exists(
        paste0(diannuserpreloc, "PreQc.csv")
      )) {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the buttons in order",
          type = "info"
        )
      }
      else{
        design_file <- read.csv(input$updesign$datapath,header=T,sep = '\t')
        newdata3out <- read.csv(paste0(diannuserpreloc, "PreQc.csv"), check.names=F)
        normmethod <- "global" # median
        if(input$diannphosnormmethod == "global") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,sum,na.rm=T),FUN="/")
        }
        if(input$diannphosnormmethod == "median") {
          newdata4 <- sweep(newdata3out[-c(1:2)],2,apply(newdata3out[-c(1:2)],2,median,na.rm=T),FUN="/")
        }
        newdata4 <- newdata4 *1e5
        newdata4[newdata4==0]<-NA
        # added by lja
        errorlabel = FALSE
        errorlabel_values <- c()
        
        if (input$dianndemocountbygroup == FALSE) {
          df <- fill_missing_values(nadata = newdata4, method = input$diannphosimputemethod)
        } else {
          # 遍历每个分组
          if (input$diannphosimputemethod %in% c('bpca', 'rowmedian', 'lls', 'knnmethod')) {
            for (group in unique(design_file$Group)) {
              samples <- design_file[design_file$Group == group,1]
              group_data <- newdata4[, samples]
              # Check if any row in group_data has missing values
              if (any(rowSums(is.na(group_data)) > 0)) {
                errorlabel <- TRUE
              } else {
                errorlabel <- FALSE
              }
              errorlabel_values <- c(errorlabel_values, errorlabel)
            }
          }
          if (!any(errorlabel_values)) {
            for (group in unique(design_file$Group)) {
              # 选择该分组下的所有样本
              # samples <- design_file$Experiment_code[design_file$Group == group]
              samples <- design_file[design_file$Group == group,1]
              
              # 从原始数据框中提取该分组下的所有样本数据
              group_data <- newdata4[, samples]
              
              # 对该分组下的样本进行缺失值填充
              filled_group_data <- fill_missing_values(group_data, method = input$diannphosimputemethod)
              
              # 将填充后的数据框添加到结果列表中
              if (exists('result_list')) {
                result_list <- c(result_list, list(filled_group_data))
              } else {
                result_list <- list(filled_group_data)
              }
            }
            
            # 将所有填充后的数据框合并为一个数据框
            df <- Reduce(cbind, result_list)
          }
          
        }
        
        if (!any(errorlabel_values)) {
          df <- data.frame(newdata3out$upsID, newdata3out$Sequence, df)
          colnames(df) <- colnames(newdata3out)
          phospho_data_topX <- keep_psites_with_max_in_topX3(df, percent_of_kept_sites = input$dianntop/100)
          output$userdiannresult2 <- renderDataTable(phospho_data_topX)
          write.csv(phospho_data_topX, paste0(diannuserpreloc, "PreNormImputeSummary.csv"), row.names = FALSE)
          
          updateTabsetPanel(session, "userdiannresultnav", selected = "userdiannstep2val")
          updateActionButton(session, "userdiannnormbt", icon = icon("rotate-right"))
          updateProgressBar(session = session, id = "userdiannpreprobar", value = 100)
          sendSweetAlert(
            session = session,
            title = "All Done",
            text = "You can now download the ‘Phosphorylation data frame’ for further analysis.",
            type = "success",
            btn_labels = "OK"
          )
        } else {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "Selecting ‘count by each group’ as TRUE may result in rows with all missing values for some groups, causing errors with certain imputation methods. Please consider choosing another imputation method, increasing the missing value filter threshold, or deselecting ‘count by each group’ to avoid this issue.",
            type = "error",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  #######################################
  #######     analysis tools      #######
  #######################################
  
  output$clinicaldl <- downloadHandler(
    filename = "clinical_file_template.csv",
    content = function(file) {file.copy("examplefile/analysistools/Clinical_for_Demo.csv", file)}
  )
  
  observeEvent(
    input$clinicalinstruction,{
      showModal(modalDialog(
        title = "Clinical data file",
        size = "l",
        tags$p(HTML("In this file, the <strong>'PatientID'</strong> column, the 
        <strong>'status'</strong> column and the <strong>'time'</strong> column
        are required, and the column names cannot be changed. </br> </br>
        1. <strong>PatientID</strong> corresponds to the 'Experiment_Code' in the 'Experimental 
        design file'.</br> </br>
        2. <strong>time</strong> refers to the length of time until a specific event occurs, such 
        as death or disease recurrence.</br> </br>
        3. <strong>status</strong> refers to whether or not the event of interest has occurred 
        for each individual in the study, with a value of 1 indicating that the 
        event has occurred and a value of 0 indicating that it has not.")),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  # Config some tools for case2
  observeEvent(c(input$analysisdatatype, input$analysisdemodata),{
    if((input$analysisdatatype == 3) & (input$analysisdemodata == 'case2')) {
      disable("tcanalysis")
      disable("kapanalysisbt1")
      disable("motifanalysisbt")
      disable("motifseqdownload")
      sendSweetAlert(
        session = session,
        title = "Tip",
        text = HTML("Due to the fact that there are only <u>two sample groups</u> in the data 
        and the 'Phosphorylation data frame' does <u>not contain sequence information</u>, 
        <br><span style='color:red'>some of the tools have been disabled</span>."),
        type = "info",
        html = TRUE
      )
    } else {
      enable("tcanalysis")
      enable("kapanalysisbt1")
      enable("motifanalysisbt")
      enable("motifseqdownload")
    }
  })
  
  # Config some tools for max tmt demo
  observeEvent(input$analysisdatatype, {
    if((input$analysisdatatype == 2) & (input$mstech == 2) & (input$lddasoftwaretype == 1) & (input$loaddatatype == TRUE)) {
      disable("sambt")
      disable("tcanalysis")
      disable("kapanalysisbt1")
      updateNumericInput(session, "kseafc", value = 1.5)
      updateNumericInput(session, "tsneperplexity", value = 1)
      updateNumericInput(session, "umapneighbors", value = 2)
      disable("motifanalysisbt")
    } else {
      enable("sambt")
      enable("tcanalysis")
      enable("kapanalysisbt1")
      updateNumericInput(session, "kseafc", value = 2)
      updateNumericInput(session, "tsneperplexity", value = 2)
      updateNumericInput(session, "umapneighbors", value = 5)
      enable("motifanalysisbt")
    }
  })
  
  # Config some tools for sn demo
  observeEvent(input$analysisdatatype, {
    if((input$analysisdatatype == 2) & (input$mstech == 3) & (input$diasoftwaretype == 1) & (input$loaddatatype == TRUE)) {
      updateNumericInput(session, "tcpvalue", value = 1)
      updateNumericInput(session, "kappvalue", value = 1)
    } else {
      updateNumericInput(session, "tcpvalue", value = 0.1)
      updateNumericInput(session, "kappvalue", value = 0.1)
    }
  })
  
  # Config some tools for mascot demo
  observeEvent(input$analysisdatatype, { 
    if((input$analysisdatatype == 2) & (input$mstech == 1) & (input$softwaretype == 2) & (input$loaddatatype == TRUE)) {
      updateSelectInput(session, "motiffastatype", selected = "refseq")
    } else {
      updateSelectInput(session, "motiffastatype", selected = "uniprot")
    }
  })
  
  
  # Analysis data upload
  analysisouts <- reactive({
    if(input$analysisdatatype==3){
      message <- "The example data is loaded"
      if(input$analysisdemodata == 'case1'){
        designfile = "examplefile/analysistools/phosphorylation_exp_design_info.txt"
        clinicalfile = "examplefile/analysistools/Clinical_for_Demo.csv"
        summarydf = "examplefile/analysistools/PreNormBasedProSummary.csv"
      } else {
        designfile = "examplefile/analysistools/case2/phosphorylation_exp_design_info_with_pair.txt"
        clinicalfile = "examplefile/analysistools/case2/clinical.csv"
        summarydf = "examplefile/analysistools/case2/phosphorylation.csv"
      }
      # Extract information from summarydf
      summarydf <- read.csv(summarydf)
      target_summarydf <- summarydf
      upsID_parts <- as.data.frame(do.call(rbind, strsplit(as.character(target_summarydf$upsID), "_")))
      colnames(upsID_parts) <- c("ID", "Position", "AA_in_protein")
      upsID_parts$Position <- paste(upsID_parts[,2], upsID_parts[,3], sep = '_')
      rownames(target_summarydf) <- target_summarydf$upsID
      target_summarydf <- subset(target_summarydf, select = -upsID)
      target_summarydf <- cbind(upsID_parts[,c(2,3)],target_summarydf$Sequence, upsID_parts[,1],target_summarydf[,2:ncol(target_summarydf)])
      colnames(target_summarydf)[1:4] <- c("Position", "AA_in_protein", "Sequence", "ID")
      
      target1 <- read.csv(designfile, sep = "\t")
      target4 <- read.csv(clinicalfile)
      target2 <- target_summarydf[, c(-2, -3, -4)]
      colnames(target2)[1] <- "ID"
      target3 <- target_summarydf[, -1]
  
      output$viewedfileanalysisui <- renderUI(h4("1. Experimental design file:"))
      output$viewedfileanalysis <- renderDataTable(target1)

      observeEvent(
        input$viewanalysisexamdesign,{
          output$viewedfileanalysisui <- renderUI(h4("1. Experimental design file:"))
          output$viewedfileanalysis <- renderDataTable(target1)
        }
      )
      observeEvent(
        input$viewanalysisexamdf,{
          output$viewedfileanalysisui <- renderUI(h4("2. Phosphorylation data frame:"))
          output$viewedfileanalysis <- renderDataTable(summarydf)
        }
      )
      observeEvent(
        input$viewanalysisexamclin,{
          output$viewedfileanalysisui <- renderUI(h4("3. Clinical data file:"))
          output$viewedfileanalysis <- renderDataTable(target4)
        }
      )
    }else if(input$analysisdatatype==2 & input$loaddatatype==1 & input$softwaretype==2 & input$mstech==1){ # pipe、demo、mascot
      if(input$useprocheck1==1) {
        file1 = paste0(mascotdemopreloc, "DemoPreNormBasedProSummary.csv")
      } else {
        file1 = paste0(mascotdemopreloc, "DemoPreNormImputeSummary.csv")
      }
      designfile = "examplefile/mascot/phosphorylation_exp_design_info.txt"
      
      clinicalfile = "examplefile/analysistools/Clinical_for_Pre.csv"
      target1 <- read.csv(designfile, sep = "\t")
      target4 <- read.csv(clinicalfile)
      if(file.exists(file1)){
        if(input$useprocheck1==1) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [example data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        
        target5 <- read.csv(file1, row.name=1)
        target2 <- target5[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID"
        target3 <- target5[, -1]
        output$viewedfileanalysis <- renderDataTable(target1)
        output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
        
        observeEvent(
          input$viewanalysispipedesign, {
            output$viewedfileanalysis <- renderDataTable(target1)
            output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
          }
        )
        observeEvent(
          input$viewanalysispipedf, {
            if(input$useprocheck1==1) {
              file1_v = paste0(mascotdemopreloc, "DemoPreNormBasedProSummary_v.csv")
            } else {
              file1_v = paste0(mascotdemopreloc, "DemoPreNormImputeSummary_v.csv")
            }
            output$viewedfileanalysis <- renderDataTable(df <- read.csv(file1_v))
            output$viewedfileanalysisui <- renderUI({h4("2. Phosphorylation data frame:")})
          }
        )
        observeEvent(
          input$viewanalysispipeclin, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3.Clinical data file:")})
          }
        )
      }else {
        if(input$useprocheck1==1) {
          message <- "PhosMap does not detect pipeline data comes from [example data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]."
        } else {
          message <- "PhosMap does not detect pipeline data comes from [example data]-[Firmiana/mascot]."
        }
        target1 <- NULL
        target4 <- NULL
        target2 <- NULL
        target3 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
        
      }
    }
    else if(input$analysisdatatype==2 & input$loaddatatype==0 & input$softwaretype==2 & input$mstech==1){ # # pipe、user、mascot
      if(is.null(input$useruseprocheck1)) {
        file1 = paste0(mascotuserpreloc, "NormImputeSummary.csv")
      } else if(input$useruseprocheck1==0) {
        file1 = paste0(mascotuserpreloc, "NormImputeSummary.csv")
      } else {
        file1 = paste0(mascotuserpreloc, "PreNormBasedProSummary.csv")
      }
      designfile = input$updesign
      clinicalfile = input$annalysisupload24
      
      if(file.exists(file1) & !(is.null(designfile))){
        if(is.null(input$useruseprocheck1)) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$useruseprocheck1==0) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        
        target1 <- read.csv(designfile$datapath, sep = "\t")
        target5 <- read.csv(file1, row.name=1)
        target2 <- target5[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID"
        target3 <- target5[, -1]
        if(is.null(clinicalfile)){
          target4 <- NULL
        }else {
          target4 <- read.csv(clinicalfile$datapath)
        }
        output$viewedfileanalysis <- renderDataTable(target1)
        output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
        
        observeEvent(
          input$viewanalysispipedesign, {
            output$viewedfileanalysis <- renderDataTable(target1)
            output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
          }
        )
        observeEvent(
          input$viewanalysispipedf, {
            if(is.null(input$useruseprocheck1)) {
              file1_v = paste0(mascotuserpreloc, "NormImputeSummary_v.csv")
            } else if(input$useruseprocheck1==0) {
              file1_v = paste0(mascotuserpreloc, "NormImputeSummary_v.csv")
            } else {
              file1_v = paste0(mascotuserpreloc, "PreNormBasedProSummary_v.csv")
            }
            output$viewedfileanalysis <- renderDataTable(df <- read.csv(file1_v))
            output$viewedfileanalysisui <- renderUI({h4("2. Phosphorylation data frame:")})
          }
        )
        
        observeEvent(
          input$annalysisupload24, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
            output$viewanalysispipeclinui <- renderUI({actionButton("viewanalysispipeclinuibt", "view")})
          }
        )
        
        observeEvent(
          input$viewanalysispipeclinuibt, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
          }
        )
      }else{
        if(is.null(input$useruseprocheck1)) {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[Firmiana/mascot]."
        } else if(input$useruseprocheck1==0) {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[Firmiana/mascot]."
        } else {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]."
        }
        target1 <- NULL
        target2 <- NULL
        target3 <- NULL
        target4 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==2 & input$loaddatatype==1 & input$softwaretype==1 & input$mstech==1){# pipe、demo、maxquant
      if(input$maxuseprocheck1==1) {
        file1 = paste0(maxdemopreloc, "DemoPreNormBasedProSummary.csv")
      } else {
        file1 = paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv")
      }
      designfile = "examplefile/maxquant/phosphorylation_exp_design_info.txt"
      clinicalfile = "examplefile/analysistools/Clinical_for_Pre.csv"
      if(file.exists(file1)){
        if(input$maxuseprocheck1==1) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [example data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        target1 <- read.csv(designfile, sep = "\t")
        target4 <- read.csv(clinicalfile)
        target5 <- read.csv(file1, row.name=1)
        target2 <- target5[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID" 
        target3 <- target5[, -1]
        
        output$viewedfileanalysis <- renderDataTable(target1)
        output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
        
        observeEvent(
          input$viewanalysispipedesign, {
            output$viewedfileanalysis <- renderDataTable(target1)
            output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
          }
        )
        observeEvent(
          input$viewanalysispipedf, {
            if(input$maxuseprocheck1==1) {
              file1_v = paste0(maxdemopreloc, "DemoPreNormBasedProSummary_v.csv")
            } else {
              file1_v = paste0(maxdemopreloc, "DemoPreNormImputeSummary_v.csv")
            }
            output$viewedfileanalysis <- renderDataTable(df <- read.csv(file1_v))
            output$viewedfileanalysisui <- renderUI({h4("2. Phosphorylation data frame:")})
          }
        )
        observeEvent(
          input$viewanalysispipeclin, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
          }
        )
      }else{
        if(input$maxuseprocheck1==1) {
          message <- "PhosMap does not detect pipeline data comes from [example data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]."
        } else {
          message <- "PhosMap does not detect pipeline data comes from [example data]-[MaxQuant]."
        }
        target1 <- NULL
        target2 <- NULL
        target3 <- NULL
        target4 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==2 & input$loaddatatype==0 & input$softwaretype==1 & input$mstech==1){# pipe、user、maxquant
      if(is.null(input$maxuseruseprocheck)) {
        file1 = paste0(maxuserpreloc, "PreNormImputeSummary.csv")
      } else if(input$maxuseruseprocheck==0) {
        file1 = paste0(maxuserpreloc, "PreNormImputeSummary.csv")
      } else {
        file1 = paste0(maxuserpreloc, "PreNormBasedProSummary.csv")
      }
      designfile = input$updesign
      if(file.exists(file1) & !(is.null(designfile))){
        if(is.null(input$maxuseruseprocheck)) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$maxuseruseprocheck==0) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        target1 <- read.csv(designfile$datapath, sep = "\t")
        # target4 <- read.csv(clinicalfile, row.name=1)
        target5 <- read.csv(file1, row.name=1)
        target2 <- target5[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID"
        target3 <- target5[, -1]
        clinicalfile = input$annalysisupload24
        
        if(is.null(clinicalfile)){
          target4 <- NULL
        }else {
          target4 <- read.csv(clinicalfile$datapath)
        }
        
        output$viewedfileanalysis <- renderDataTable(target1)
        output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
        
        observeEvent(
          input$viewanalysispipedesign, {
            output$viewedfileanalysis <- renderDataTable(target1)
            output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
          }
        )
        observeEvent(
          input$viewanalysispipedf, {
            if(is.null(input$maxuseruseprocheck)) {
              file1_v = paste0(maxuserpreloc, "PreNormImputeSummary_v.csv")
            } else if(input$maxuseruseprocheck==0) {
              file1_v = paste0(maxuserpreloc, "PreNormImputeSummary_v.csv")
            } else {
              file1_v = paste0(maxuserpreloc, "PreNormBasedProSummary_v.csv")
            }
            output$viewedfileanalysis <- renderDataTable(df <- read.csv(file1_v))
            output$viewedfileanalysisui <- renderUI({h4("2. Phosphorylation data frame:")})
          }
        )
        observeEvent(
          input$annalysisupload24, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
            output$viewanalysispipeclinui <- renderUI({actionButton("viewanalysispipeclinuibt2", "view")})
          }
        )
        observeEvent(
          input$viewanalysispipeclinuibt2, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
          }
        )
        
      }else{
        if(is.null(input$maxuseruseprocheck)) {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[MaxQuant]."
        } else if(input$maxuseruseprocheck==0) {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[MaxQuant]."
        } else {
          message <- "PhosMap does not detect pipeline data comes from [your data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]."
        }
        target1 <- NULL
        target2 <- NULL
        target3 <- NULL
        target4 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if((input$analysisdatatype==2 & input$lddasoftwaretype==1 & input$mstech==2) |  # max tmt
             (input$analysisdatatype==2 & input$diasoftwaretype==1 & input$mstech==3) |  # sn
             (input$analysisdatatype==2 & input$diasoftwaretype==2 & input$mstech==3)){  # diann
      if(input$loaddatatype==0){  # user
        designfile <- input$updesign
        if(input$lddasoftwaretype==1 & input$mstech==2) {file1 <- paste0(maxtmtuserpreloc, "PreNormImputeSummary.csv")}
        if(input$diasoftwaretype==1 & input$mstech==3) {file1 <- paste0(snuserpreloc, "PreNormImputeSummary.csv")}
        if(input$diasoftwaretype==2 & input$mstech==3) {file1 <- paste0(diannuserpreloc, "PreNormImputeSummary.csv")}
      } else {  # demo
        if(input$lddasoftwaretype==1 & input$mstech==2) {
          designfile <- "examplefile/tmt/phosphorylation_exp_design_info.txt"
          file1 <- paste0(maxtmtdemopreloc, "DemoPreNormImputeSummary.csv")
        }
        if(input$diasoftwaretype==1 & input$mstech==3) {
          designfile <- "examplefile/diann/phosphorylation_exp_design_info.txt"
          file1 <- paste0(sndemopreloc, "DemoPreNormImputeSummary.csv")
        }
        if(input$diasoftwaretype==2 & input$mstech==3) {
          designfile <- "examplefile/diann/phosphorylation_exp_design_info.txt"
          file1 <- paste0(dianndemopreloc, "DemoPreNormImputeSummary.csv")
        }
      }
      
      if((input$loaddatatype==0 & file.exists(file1) & !(is.null(designfile))) | (input$loaddatatype==1 & file.exists(file1))){
        if(input$loaddatatype==0 & input$lddasoftwaretype==1 & input$mstech==2) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant-tmt]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$lddasoftwaretype==1 & input$mstech==2) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[MaxQuant-tmt]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$loaddatatype==0 & input$diasoftwaretype==1 & input$mstech==3) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Spectronaut-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$diasoftwaretype==1 & input$mstech==3) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[Spectronaut-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$loaddatatype==0 & input$diasoftwaretype==2 & input$mstech==3) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[DiaNN-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$diasoftwaretype==2 & input$mstech==3) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[DiaNN-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        summarydf <- read.csv(file1, check.names=F)
        summarydf_v <- summarydf
        
        if(input$loaddatatype==0) {
          target1 <- read.csv(designfile$datapath, header=T, sep="\t")
        } else {
          target1 <- read.csv(designfile, header=T, sep="\t")
        }
        
        upsID_parts <- as.data.frame(do.call(rbind, strsplit(as.character(summarydf$upsID), "_")))
        colnames(upsID_parts) <- c("ID", "Position", "AA_in_protein")
        upsID_parts$Position <- paste(upsID_parts[,2], upsID_parts[,3], sep = '_')
        rownames(summarydf) <- summarydf$upsID
        summarydf <- subset(summarydf, select = -upsID)
        summarydf <- cbind(upsID_parts[,c(2,3)],summarydf$Sequence, upsID_parts[,1],summarydf[,2:ncol(summarydf)])
        colnames(summarydf)[1:4] <- c("Position", "AA_in_protein", "Sequence", "ID")
        
        target2 <- summarydf[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID"
        target3 <- summarydf[, -1]
        # avoid isoform
        target2 <- target2[!duplicated(target2$ID), ]
        clinicalfile = input$annalysisupload24
        
        if(is.null(clinicalfile)){
          target4 <- NULL
        }else {
          target4 <- read.csv(clinicalfile$datapath)
        }
        
        output$viewedfileanalysis <- renderDataTable(target1)
        output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
        
        observeEvent(
          input$viewanalysispipedesign, {
            output$viewedfileanalysis <- renderDataTable(target1)
            output$viewedfileanalysisui <- renderUI({h4("1. Experimental design file:")})
          }
        )
        observeEvent(
          input$viewanalysispipedf, {
            output$viewedfileanalysis <- renderDataTable(summarydf_v)
            output$viewedfileanalysisui <- renderUI({h4("2. Phosphorylation data frame:")})
          }
        )
        observeEvent(
          input$annalysisupload24, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
            output$viewanalysispipeclinui <- renderUI({actionButton("viewanalysispipeclinuibt2", "view")})
          }
        )
        observeEvent(
          input$viewanalysispipeclinuibt2, {
            output$viewedfileanalysis <- renderDataTable(target4)
            output$viewedfileanalysisui <- renderUI({h4("3. Clinical data file:")})
          }
        )
      } else {
        if(input$loaddatatype==0 & input$lddasoftwaretype==1 & input$mstech==2) {
          message <- 'PhosMap does not detect pipeline data comes from [your data]-[MaxQuant-tmt]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$lddasoftwaretype==1 & input$mstech==2) {
          message <- 'PhosMap does not detect pipeline data comes from [example data]-[MaxQuant-tmt]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$loaddatatype==0 & input$diasoftwaretype==1 & input$mstech==3) {
          message <- 'PhosMap does not detect pipeline data comes from [your data]-[Spectronaut-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$diasoftwaretype==1 & input$mstech==3) {
          message <- 'PhosMap does not detect pipeline data comes from [example data]-[Spectronaut-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if(input$loaddatatype==0 & input$diasoftwaretype==2 & input$mstech==3) {
          message <- 'PhosMap does not detect pipeline data comes from [your data]-[DiaNN-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        } else if (input$loaddatatype==1 & input$diasoftwaretype==2 & input$mstech==3) {
          message <- 'PhosMap does not detect pipeline data comes from [example data]-[DiaNN-DIA]. Please make sure this is correct. Otherwise, choose to upload "your data"'
        }
        target1 <- NULL
        target2 <- NULL
        target3 <- NULL
        target4 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==2 & input$diasoftwaretype==1 & input$mstech==3){  # sn
      
    }else if(input$analysisdatatype==2 & input$diasoftwaretype==2 & input$mstech==3){  # diann
      
    }else if(input$analysisdatatype==1){
      message <- "Data Overview"
      target1 <- NULL
      target2 <- NULL
      target3 <- NULL
      target4 <- NULL
      output$viewedfileanalysisuiuser <- renderUI(NULL)
    }
    files <- list(message, target1, target2, target3, target4)
    files
  })
  
  output$htmlanalysis <- renderUI({
    string  <- analysisouts()[[1]]
    matches <- gregexpr("(?<=\\[)[^\\[\\]]+(?=\\])", string, perl = TRUE)
    result <- regmatches(string, matches)
    for (i in seq_along(result[[1]])) {
      html <- paste0("<span style='color:red'>", result[[1]][i], "</span>")
      string <- gsub(result[[1]][i], html, string)
    }
    wellPanel(HTML(string), class = "warning")
  })
  
  # display uploadded designfile
  designfile_analysis <- reactive({
    files = input$analysisupload11
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header=T, sep="\t")
    }
    dataread
  })
  
  observeEvent(
    input$analysisupload11,{
      output$viewedfileanalysisuiuser <- renderUI(h4("1. Experimental design file :"))
      output$viewanalysisyourdesign <- renderUI({actionButton("viewanalysisyourdesignbt", "view")})
      output$viewedfileanalysisuser <- renderDataTable({designfile_analysis()})
      if(online) {
        data <- designfile_analysis()
        if(nrow(data)>39){
          sendSweetAlert(
            session = session,
            title = "Attention...",
            text = "The sample size is too large. It is recommended to use the local version.",
            type = "info",
            btn_labels = "OK"
          )
        }
      }
    }
  )
  
  observeEvent(
    input$viewanalysisyourdesignbt, {
      output$viewedfileanalysisuiuser <- renderUI(h4("1. Experimental design file :"))
      output$viewedfileanalysisuser <- renderDataTable({designfile_analysis()})
    }
  )
  
  # display uploadded profilingfile
  profilingfile_analysis <- reactive({
    files = input$analysisupload12
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, check.names=F)
    }
    dataread
  })
  
  # display profilingfile by dataframe in main
  observeEvent(
    input$analysisupload12,{
      output$viewedfileanalysisuiuser <- renderUI(h4("2. Phosphorylation data frame:"))
      output$viewanalysisyourexpre <- renderUI({actionButton("viewanalysisyourdfbt", "view")})
      output$viewedfileanalysisuser <- renderDataTable({profilingfile_analysis()})
    }
  )
  
  observeEvent(
    input$viewanalysisyourdfbt, {
      output$viewedfileanalysisuiuser <- renderUI(h4("2. Phosphorylation data frame:"))
      output$viewedfileanalysisuser <- renderDataTable({profilingfile_analysis()})
    }
  )
  
  # display uploader clinicalfile
  clinicalfile_analysis <- reactive({
    files = input$analysisupload14
    if(is.null(files)){
      dataread <- NULL
    }else{
      dataread <- read.csv(files$datapath, header = T, sep = ",")
    }
    dataread
  })
  
  # display clinicalfile by df in main
  observeEvent(
    input$analysisupload14,{
      output$viewedfileanalysisuiuser <- renderUI(h4("4. Clinical data file :"),)
      output$viewanalysisyourclin <- renderUI({actionButton("viewanalysisyourclinbt", "view")})
      output$viewedfileanalysisuser <- renderDataTable({clinicalfile_analysis()})
    }
  )
  
  observeEvent(
    input$viewanalysisyourclinbt, {
      output$viewedfileanalysisuiuser <- renderUI( h4("4. Clinical data file :"))
      output$viewedfileanalysisuser <- renderDataTable({clinicalfile_analysis()})
    }
  )
  
  fileset <- reactive({
    if(input$analysisdatatype == 1){
      summarydf <- profilingfile_analysis()
      if(!is.null(summarydf)) {
        upsID_parts <- as.data.frame(do.call(rbind, strsplit(as.character(summarydf$upsID), "_")))
        colnames(upsID_parts) <- c("ID", "Position", "AA_in_protein")
        upsID_parts$Position <- paste(upsID_parts[,2], upsID_parts[,3], sep = '_')
        rownames(summarydf) <- summarydf$upsID
        summarydf <- subset(summarydf, select = -upsID)
        summarydf <- cbind(upsID_parts[,c(2,3)],summarydf$Sequence, upsID_parts[,1],summarydf[,2:ncol(summarydf)])
        colnames(summarydf)[1:4] <- c("Position", "AA_in_protein", "Sequence", "ID")
        
        target2 <- summarydf[, c(-2, -3, -4)]
        colnames(target2)[1] <- "ID"
        target3 <- summarydf[, -1]
        # avoid isoform
        target2 <- target2[!duplicated(target2$ID), ]
      } else {
        target2 <- NULL
        target3 <- NULL
      }
      dflist <- list(designfile_analysis(), target2, target3, clinicalfile_analysis())
      dflist
    }else{
      target2 <- analysisouts()[[3]]
      # avoid isoform
      target2 <- target2[!duplicated(target2$ID), ]
      dflist <- list(analysisouts()[[2]], target2, analysisouts()[[4]], analysisouts()[[5]])
      dflist
    }
  })
  
  output$dimensionproteinui <- renderUI({
    if (!is.null(fileset()[[2]])) {
      multiInput(
        inputId = "dimensionproteinselect",
        label = NULL, 
        choices = fileset()[[2]]$ID
      )
    } else {
      p("Please check that the expression dataframe file is uploaded !")
    }
  })
  
  output$selected_values <- renderPrint({
    input$dimensionproteinselect
  })
  
  pca <- eventReactive(input$drbt,{
    validate(
      need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
      need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
    )
    phosphorylation_experiment_design_file <- fileset()[[1]]
    data_frame_normalization_with_control_no_pair <- fileset()[[2]]
    if(input$proteinselectionornot) {
      validate(
        need(length(input$dimensionproteinselect) > 1, 'Please check to ensure that at least 2 p-sites are selected !')
      )
      data_frame_normalization_with_control_no_pair <- data_frame_normalization_with_control_no_pair[data_frame_normalization_with_control_no_pair$ID %in% input$dimensionproteinselect, ]
    }
    phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
    phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
    # group information
    # group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
    group = phosphorylation_experiment_design_file$Group
    # group_levels = paste('t', phosphorylation_groups_labels, sep = '')
    group_levels = phosphorylation_groups_labels
    group = factor(group, levels = group_levels)
    
    if(input$pcamean == TRUE) {
      # PCA
      validate(need(length(unique(phosphorylation_experiment_design_file$Group)) > 2, "The number of groups is at least 3"))
      expr_data_frame = data_frame_normalization_with_control_no_pair
      phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      group = phosphorylation_experiment_design_file$Group
      group_levels = phosphorylation_groups_labels
      group = factor(group, levels = group_levels)
      data_test <- expr_data_frame[, -1]
      data_test_mean = NULL 
      for(i in 1:nrow(data_test)){
        x = as.vector(unlist(data_test[i,]))
        x_m = tapply(x, group, mean)
        data_test_mean = rbind(data_test_mean, x_m)
      }
      rownames(data_test_mean) <- rownames(data_test)
      # pca_result <- prcomp(t(data_test_mean), scale. = TRUE)
      # sample_coordinates <- data.frame(pca_result$x[, 1:2])
      # sample_coordinates$Sample <- rownames(sample_coordinates)
      # merged_data = sample_coordinates
      
      data_test_t <- t(data_test_mean)
      res.pca <- PCA(data_test_t, graph = FALSE, scale.unit = FALSE)
      # pca <- list(pca_result, merged_data)
      pca <- list(res.pca, unique(phosphorylation_experiment_design_file$Group))
    } else {
      # PCA
      expr_data_frame = data_frame_normalization_with_control_no_pair
      data_test <- expr_data_frame[, -1]
      data_test <- log2(data_test)
      
      # pca_result <- prcomp(t(data_test), scale. = TRUE)
      # sample_coordinates <- data.frame(pca_result$x[, 1:2])
      # sample_coordinates$Sample <- rownames(sample_coordinates)
      # exp_design <- data.frame(Sample = phosphorylation_experiment_design_file$Experiment_Code, Group = phosphorylation_experiment_design_file$Group)
      # merged_data <- merge(exp_design, sample_coordinates, by = "Sample")
      # merged_data$Group = factor(merged_data$Group)
      
      data_test_t <- t(data_test)
      res.pca <- PCA(data_test_t, graph = FALSE, scale.unit = FALSE)
      # pca <- list(pca_result, merged_data)
      pca <- list(res.pca, phosphorylation_experiment_design_file$Group)
    }
  })
  
  pca_plot1 <- eventReactive(
    input$drbt,{
      # PCA <- pca()[[1]]
      # stats::screeplot(PCA, type="lines")
      # pdf(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''))
      # stats::screeplot(PCA, type="lines")
      # dev.off()
      # stats::screeplot(PCA, type="lines")
      p <- fviz_pca_var(pca()[[1]], col.var = "cos2",
                   gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                   repel = TRUE # Avoid text overlapping
      ) +
        theme(plot.title = element_text(hjust = 0.5, margin = margin(b = 20)))
      ggsave(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''), p, height = 7, width = 7)
      p
    })
  
  pca_plot2 <- eventReactive(
    input$drbt, {
      # PCA <- pca()[[1]]
      # merged_data <- pca()[[2]]
      # importance <- summary(PCA)$importance
      # PC1 <- importance[2,1]
      # PC2 <- importance[2,2]
      # PC1 <- round(PC1, 4)*100
      # PC2 <- round(PC2, 4)*100
      # 
      # pca_predict <- stats::predict(PCA)
      # pca_predict_2d <- pca_predict[,c(1,2)]
      # xlim <- c(floor(min(pca_predict_2d[,1]))-5, ceiling(max(pca_predict_2d[,1]))+5)
      # ylim <- c(floor(min(pca_predict_2d[,2]))-5, ceiling(max(pca_predict_2d[,2]))+5)
      # xlab <- paste("PC1 (", PC1, "%)", sep = "")
      # ylab <- paste("PC2 (", PC2, "%)", sep = "")
      # if(input$pcamean == TRUE) {
      #   group_colors <- grDevices::rainbow(length(merged_data$Sample))
      #   color = "Sample"
      # } else {
      #   group_levels <- levels(factor(merged_data$Group))
      #   group_colors <- grDevices::rainbow(length(group_levels))
      #   color = "Group"
      # }
      # p <- ggplot(merged_data, aes_string(x = "PC1", y = "PC2", color = color)) +
      #   geom_point(size = 1, alpha = 0.8) +
      #   scale_color_manual(values = group_colors) +
      #   theme_bw() +
      #   theme(panel.grid = element_blank(),
      #         legend.box.background = element_rect(colour = "black"),
      #         plot.title = element_text(hjust = 0.5, face = "bold")) +
      #   labs(title = input$pcamain,
      #        x = xlab,
      #        y = ylab,
      #        color = input$pcalegend)
      # ggsave(paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep=''), p, height = 7, width = 7) 
      # 
      # pdf_combine(c(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''),paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep='')),
      #             output = paste('tmp/',userID,'/analysis/pca/joinedpca.pdf',sep=''))
      # p
      p <- fviz_pca_ind(pca()[[1]],
                   # show points only (nbut not "text") 只显示点而不显示文本，默认都显示
                   geom.ind = "point",
                   # config group
                   col.ind = as.factor(pca()[[2]]),
                   pointshape  = 16, 
                   # config color
                   palette = "aaas",
                   # palette = grDevices::rainbow(length(pca()[[2]])),
                   # Concentration ellipses
                   addEllipses = FALSE,
                   legend.title = input$pcalegend,
      )+
        ggtitle("PCA") +
        theme(plot.title = element_text(hjust = 0.5, margin = margin(b = 20)))
      ggsave(paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep=''), p, height = 7, width = 7) 
      p
    }
  )
  output$pca1 <- renderPlot(pca_plot1())
  output$pca2 <- renderPlot(pca_plot2())
  output$pcaplustable <- renderDataTable(get_pca_var((pca()[[1]]))$contrib[, 1:2, drop = FALSE])
  
  output$pcaplotdl <- downloadHandler(
    filename = function(){paste("pca_result", userID,".pdf",sep="")},
    content = function(file){
      pdf_combine(c(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''),paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep='')),
                  output = paste('tmp/',userID,'/analysis/pca/joinedpca.pdf',sep=''))
      file.copy(paste('tmp/',userID,'/analysis/pca/joinedpca.pdf',sep=''),file)
    }
  )
  
  observeEvent(
    input$viewpcaresult, {
      showModal(modalDialog(
        title = "Score matrix",
        size = "l",
        dataTableOutput("pcascore"),
        div(downloadButton("pcascoredl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  tsne <- eventReactive(
    input$drbt, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
      )
      
      phosphorylation_experiment_design_file <- fileset()[[1]]
      data_frame_normalization_with_control_no_pair <- fileset()[[2]]
      if(input$proteinselectionornot) {
        validate(
          need(length(input$dimensionproteinselect) > 1, 'Please check to ensure that at least 2 p-sites are selected !')
        )
        data_frame_normalization_with_control_no_pair <- data_frame_normalization_with_control_no_pair[data_frame_normalization_with_control_no_pair$ID %in% input$dimensionproteinselect, ]
      }
      expr_data_frame = data_frame_normalization_with_control_no_pair
      phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      # group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      group = phosphorylation_experiment_design_file$Group
      # group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group_levels = phosphorylation_groups_labels
      group = factor(group, levels = group_levels)
      set.seed(input$tsneseed)
      main = input$tsnemain
      perplexity = input$tsneperplexity
      requireNamespace("Rtsne")
      requireNamespace("grDevices")
      requireNamespace("graphics")
      expr_ID <- as.vector(expr_data_frame[, 1])
      expr_Valule <- log2(expr_data_frame[, -1])
      rtsne_df <- data.frame(group, t(expr_Valule))
      rtsne_df_unique <- unique(rtsne_df)
      colors <- grDevices::rainbow(length(unique(group)))
      names(colors) <- unique(group)
      system.time({
        tsne <- Rtsne::Rtsne(rtsne_df_unique[, -1], dims = 2, 
                             perplexity = perplexity, verbose = TRUE, max_iter = 500)
      })
      list(expr_data_frame, group,tsne,main,colors)
    }
  )
  
  tsne_plot <- eventReactive(
    input$drbt, {
      tsne <- tsne()[[3]]
      colors <- tsne()[[5]]
      group <- tsne()[[2]]
      main <- tsne()[[4]]
      par(xpd = TRUE, mar = c(5, 5, 5, 5.5))
      graphics::plot(tsne$Y, col=rep(colors,table(group)), pch=16, lwd = 2, xlab = 'Dim 1', ylab = 'Dim 2', main = input$tsnemain)
      usr <- par("usr")
      x_rel <- 1.05 * (usr[2] - usr[1]) + usr[1]
      y_rel <- 0.95 * (usr[4] - usr[3]) + usr[3]
      legend(x = x_rel, y = y_rel,title = input$tsnelegend,inset = 0.01,
             legend = unique(group),pch=16,
             col = colors,bg='white')
      
      pdf(paste('tmp/',userID,'/analysis/tsne/tsne.pdf',sep=''))
      par(xpd = TRUE, mar = c(5, 5, 5, 5.5))
      graphics::plot(tsne$Y, col=rep(colors,table(group)), pch=16, lwd = 2, xlab = 'Dim 1', ylab = 'Dim 2', main = input$tsnemain)
      usr <- par("usr")
      x_rel <- 1.05 * (usr[2] - usr[1]) + usr[1]
      y_rel <- 0.95 * (usr[4] - usr[3]) + usr[3]
      legend(x = x_rel, y = y_rel,title = input$tsnelegend,inset = 0.01,
             legend = unique(group),pch=16,
             col = colors,bg='white')
      dev.off()
    }
  )
  
  output$tsne <- renderPlot(tsne_plot())

  output$tsneplotdl <- downloadHandler(
    filename = function(){paste("tsne_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/tsne/tsne.pdf',sep=''),file)
    }
  )
  
  umap <- eventReactive(input$drbt,{
    
    validate(
      need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
      need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
    )
    phosphorylation_experiment_design_file <- fileset()[[1]]
    data_frame_normalization_with_control_no_pair <- fileset()[[2]]
    if(input$proteinselectionornot) {
      validate(
        need(length(input$dimensionproteinselect) > 1, 'Please check to ensure that at least 2 p-sites are selected !')
      )
      data_frame_normalization_with_control_no_pair <- data_frame_normalization_with_control_no_pair[data_frame_normalization_with_control_no_pair$ID %in% input$dimensionproteinselect, ]
    }
    expr_data_frame = data_frame_normalization_with_control_no_pair
    expr_data_frame_2=t(expr_data_frame[,-1])
    expr_data_frame_2 <- as.data.frame(expr_data_frame_2)
    expr_data_group <- NULL
    for (i in c(1:length(row.names(expr_data_frame_2))))
    {expr_data_group[i]=phosphorylation_experiment_design_file[which(phosphorylation_experiment_design_file$Experiment_Code==row.names(expr_data_frame_2)[i]),2]}
    requireNamespace('uwot')
    requireNamespace('grDevices')
    main = input$umapmain
    neighbors = input$umapneighbors
    expr_data_umap <- uwot::umap(expr_data_frame_2,n_neighbors = neighbors)
    color_group_unique <- grDevices::rainbow(length(unique(expr_data_group)))
    list(expr_data_umap,color_group_unique,main,expr_data_group)
  })
  umap_plot <- eventReactive(input$drbt,{
    expr_data_umap <- umap()[[1]]
    color_group_unique <- umap()[[2]]
    main <- umap()[[3]]
    expr_data_group <- umap()[[4]]
    par(xpd = TRUE, mar = c(5, 5, 5, 5.5))
    plot(expr_data_umap,col=rep(color_group_unique,table(expr_data_group)),pch=16,asp=1,xlab = "UMAP_1",ylab = "UMAP_2",main = main)
    usr <- par("usr")
    x_rel <- 1.05 * (usr[2] - usr[1]) + usr[1]
    y_rel <- 0.95 * (usr[4] - usr[3]) + usr[3]
    # abline(h=0,v=0,lty=2,col="gray")
    legend(x = x_rel, y = y_rel,title = input$umaplegend,inset = 0.01,
           legend = unique(expr_data_group),pch=16,
           col = color_group_unique,
           bg='white'
    )
  })
  
  output$umap <- renderPlot(umap_plot())
  output$umapplotdl <- downloadHandler(
    filename = function(){paste("umap_result", userID,".pdf",sep="")},
    content = function(file){
      pdf(file=file)
      expr_data_umap <- umap()[[1]]
      color_group_unique <- umap()[[2]]
      main <- umap()[[3]]
      expr_data_group <- umap()[[4]]
      par(xpd = TRUE, mar = c(5, 5, 5, 5.5))
      plot(expr_data_umap,col=rep(color_group_unique,table(expr_data_group)),pch=16,asp=1,xlab = "UMAP_1",ylab = "UMAP_2",main = main)
      usr <- par("usr")
      x_rel <- 1.05 * (usr[2] - usr[1]) + usr[1]
      y_rel <- 0.95 * (usr[4] - usr[3]) + usr[3]
      # abline(h=0,v=0,lty=2,col="gray")
      legend(x = x_rel, y = y_rel,title = input$umaplegend,inset = 0.01,
             legend = unique(expr_data_group),pch=16,
             col = color_group_unique,
             bg='white'
      )
      dev.off()
    }
  )
  
  # Differential Expression Analysis
  output$limmaselect1 <- renderUI({
    return(
      selectInput(
        'limmagroup1',
        h5('control:'),
        choices = unique((fileset()[[1]])[,2])
      )
    )
  })
  output$limmaselect2 <- renderUI({
    return(
      selectInput(
        'limmagroup2',
        h5('experiment:'),
        choices = setdiff(unique((fileset()[[1]])[,2]), input$limmagroup1)
      )
    )
  })
  
  click_counter <- reactiveValues(limma_count = 0, sam_count = 0, anova_count = 0)
  limma <- eventReactive(input$limmabt,
                         {
                           validate(
                             need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
                             need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
                           )
                           
                           phosphorylation_experiment_design_file <- fileset()[[1]]
                           data_frame_normalization_with_control_no_pair <- fileset()[[2]]
                           
                           group_T_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$limmagroup2]
                           group_P_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$limmagroup1]
                           
                           expr_data_frame = data_frame_normalization_with_control_no_pair[c("ID", group_P_codes, group_T_codes)]
                           # expr_data_frame = data_frame_normalization_with_control_no_pair[,c(1,which(phosphorylation_experiment_design_file$Group==input$limmagroup1)+1,which(phosphorylation_experiment_design_file$Group==input$limmagroup2)+1)]
                           
                           phosphorylation_experiment_design_file = phosphorylation_experiment_design_file[c(which(phosphorylation_experiment_design_file$Group==input$limmagroup1),which(phosphorylation_experiment_design_file$Group==input$limmagroup2)),]
                           # select phosphorylation sites with greater variation
                           expr_data_frame_var = apply(expr_data_frame, 1, function(x){
                             var(x[-1])
                           })
                           index_of_kept = which(expr_data_frame_var>1)
                           expr_data_frame = expr_data_frame[index_of_kept,]
                           
                           phosphorylation_groups_labels = unique(phosphorylation_experiment_design_file$Group)
                           phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
                           # group information
                           group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
                           group_levels = paste('t', phosphorylation_groups_labels, sep = '')
                           group = factor(group, levels = group_levels)
                           
                           limma_results_df = analysis_deps_limma2(expr_data_frame, group, group_levels, log2_label = FALSE, adjust_method = input$limmaadjust)
                           limma_results_df$ID = apply(limma_results_df, 1, function(x){
                             x = strsplit(x, '_')[[1]]
                             paste(x[2], x[3], sep = '_')
                           })
                           output$limmaresult <- renderDataTable({limma_results_df[,1:3]})
                           output$limmaresultdl<-downloadHandler(
                             filename = function(){paste("limma_result", userID,".csv",sep="")},
                             content = function(file){
                               write.csv(limma_results_df[,1:3],file,row.names = FALSE)
                             }
                           )
                           index_of_deps = which(limma_results_df[,1:3]$pvalue < input$limmapvalue & (abs(limma_results_df[,1:3]$logFC)>log2(input$limmafc)))
                           symbol_of_deps = as.vector(limma_results_df[,1:3]$ID[index_of_deps])
                           index_of_match = match(symbol_of_deps, expr_data_frame$ID)
                           index_of_match_pv = match(symbol_of_deps, limma_results_df$ID)
                           
                           # check.names = F, to ensure not x
                           limmaph_df = data.frame(limma_results_df[index_of_match_pv,]$logFC, expr_data_frame[index_of_match,], check.names = F)
                           
                           colnames(limmaph_df)[1] <- "logFC"
                           
                           group_test <- data.frame(as.character(phosphorylation_experiment_design_file[,2]), row.names = phosphorylation_experiment_design_file[,1], check.names = F)
                           colnames(group_test) <- "Group"
                           test_change <- ifelse(limmaph_df$logFC < 0, 'DOWN','UP')
                           rowname_test <- data.frame(test_change, row.names = limmaph_df$ID, check.names = F)
                           colnames(rowname_test) <- 'Change'
                           
                           test_data_plot <- data.frame(limmaph_df[,-c(1,2)], check.names = F)
                           
                           rownames(test_data_plot) <- limmaph_df$ID
                           click_counter$limma_count = 1
                           list(test_data_plot, group_test, rowname_test, limma_results_df)
                           
                           
                         })
  
  observeEvent(
    input$limmaphbt, {
      if(click_counter$limma_count) {
        if(nrow(limma()[[1]]) > 1){
          limma_for_ph <- isolate(limma()[[1]])

          ph <- pheatmap(limma_for_ph,
                         scale = input$limmaphscale,
                         cluster_rows = input$limmaphcluster,
                         cluster_cols = FALSE,
                         annotation_col = limma()[[2]],
                         annotation_row = limma()[[3]],
                         show_rownames = input$limmaphrowname,
                         clustering_distance_rows = input$limmaphdistance,
                         clustering_method = input$limmaphclusmethod
          )
          dev.off()
          output$limmaph <- renderPlot(ph)
          if((nrow(limma_for_ph) > 500) & online) {
            output$limmainterph <- renderPlotly({
              p <- plot_ly() %>%
                add_annotations(
                  text = "Differential phosphorylation sites exceed 500.
                Please use the local version to view the interactive heatmap.",
                  xref = "paper", yref = "paper",
                  x = 0.5, y = 0.1,
                  showarrow = FALSE,
                  font = list(size = 20)
                )
            })
          } else {
            output$limmainterph <- renderPlotly(
              heatmaply(
                limma_for_ph,
                scale = input$limmaphscale,
                scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(
                  low = "blue",
                  high = "red"
                ),
                Rowv = input$limmaphcluster,
                Colv = FALSE,
                hclust_method = input$limmaphclusmethod,
                distance_method = input$limmaphdistance
              )
            )
          }
        }
        else {
          sendSweetAlert(
            session = session,
            title = "Tip",
            text = "At least two p-sites are required to plot a heatmap.",
            type = "info"
          )
        }
      } else {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the 'Analysis' button first.",
          type = "info"
        )
      }
    }
  )
  
  observeEvent(
    input$limmabt, {
      limma_results_df <- limma()[[4]]
      limma_results_df$change <- as.factor(ifelse(limma_results_df$pvalue < input$limmapvalue & abs(limma_results_df$logFC) > log2(input$limmafc),ifelse(limma_results_df$logFC > log2(input$limmafc),'UP','DOWN'),'NOT'))
      
      specifiedpoints <- input$limmalabelspec
      specifiedpoints <- strsplit(specifiedpoints, "\n")[[1]]
      if(identical(specifiedpoints, character(0))){specifiedpoints <- "abcdefghij"}
      limma_results_df$sign <- ifelse((limma_results_df$pvalue < input$limmalabelpvalue & abs(limma_results_df$logFC) > log2(input$limmalabelfc)) | limma_results_df$ID %in% specifiedpoints,limma_results_df$ID,NA)
      p <- ggplot(data = limma_results_df, aes(x = logFC, y = -log10(pvalue), text = paste("ID:", ID))) +
        geom_point(aes(color = change), alpha=0.6, size=2) +
        theme_bw(base_size = 15) +
        theme(panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
              plot.title=element_text(size=18,
                                      hjust=0.5,
                                      vjust=0.5)) +
        geom_hline(yintercept = -log10(input$limmapvalue), linetype = 4) +
        geom_vline(xintercept = c(-log2(input$limmafc), log2(input$limmafc)), linetype = 4) +
        scale_color_manual(name = "", values = c(input$limmaupcolor, input$limmadowncolor, input$limmanotcolor), limits = c("UP", "DOWN", "NOT")) +
        geom_label_repel(aes(label = sign), size = 3.8, fontface="bold", color="grey50", box.padding=unit(0.35, "lines"), point.padding=unit(0.5, "lines"), segment.colour = "grey50") +
        labs(title = input$limmamain, x = input$limmaxaxis, y = input$limmayaxis)
      ggsave(paste('tmp/',userID,'/analysis/limma/limma.pdf',sep=''),width = 10,height = 7)
      output$limmastatic <- renderPlot(p)
      output$limmainter <- renderPlotly(p)
    }
  )

  #download
  output$limmaplotdl <- downloadHandler(
    filename = function(){paste("limma_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/limma/limma.pdf',sep=''),file)
    }
  )

  # sam
  output$samselect1 <- renderUI({
    return(
      selectInput(
        'samgroup1',
        h5('control:'),
        choices = unique((fileset()[[1]])[,2])
      )
    )
  })
  
  output$samselect2 <- renderUI({
    return(
      selectInput(
        'samgroup2',
        h5('experiment:'),
        choices = setdiff(unique((fileset()[[1]])[,2]), input$samgroup1)
      )
    )
  })
  
  sam <- eventReactive(input$sambt,{
    validate(
      need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
      need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
    )
    phosphorylation_experiment_design_file <- fileset()[[1]]
    data_frame_normalization_with_control_no_pair <- fileset()[[2]]
    
    group_T_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$samgroup2]
    group_P_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$samgroup1]
    
    expr_data_frame = data_frame_normalization_with_control_no_pair[c("ID", group_P_codes, group_T_codes)]
    
    # expr_data_frame = data_frame_normalization_with_control_no_pair[,c(1,which(phosphorylation_experiment_design_file$Group==input$samgroup1)+1,which(phosphorylation_experiment_design_file$Group==input$samgroup2)+1)]
    phosphorylation_experiment_design_file = phosphorylation_experiment_design_file[c(which(phosphorylation_experiment_design_file$Group==input$samgroup1),which(phosphorylation_experiment_design_file$Group==input$samgroup2)),]
    
    expr_data_frame_var = apply(expr_data_frame, 1, function(x){
      var(x[-1])
    })
    index_of_kept = which(expr_data_frame_var>1)
    expr_data_frame = expr_data_frame[index_of_kept,]
    
    phosphorylation_groups_labels = unique(phosphorylation_experiment_design_file$Group)
    phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
    # group information
    group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
    group_levels = paste('t', phosphorylation_groups_labels, sep = '')
    group = factor(group, levels = group_levels)
    nperms = input$samnperms
    rand = NULL
    minFDR = input$samfdr
    samr_plot = T
    requireNamespace('samr')
    requireNamespace('stats')
    expr_ID <- as.vector(expr_data_frame[,1])
    expr_Valule <- expr_data_frame[,-1]
    expr_Valule <- log2(expr_data_frame[,-1])
    expr_Valule_row_duplicated <- apply(expr_Valule, 1, function(x){
      stats::var(x)
    })
    expr_Valule_col <- ncol(expr_Valule)
    duplicated_row_index <- which(expr_Valule_row_duplicated == 0)
    if(length(duplicated_row_index)>0){
      expr_ID <- expr_ID[-duplicated_row_index]
      expr_Valule <- expr_Valule[-duplicated_row_index,]
    }
    
    # construct the samr data
    sam_data <- list(x = as.matrix(expr_Valule), y = as.numeric(as.factor(group)),
                     geneid = expr_ID, genenames = expr_ID, logged2=TRUE)
    
    group_nlevels <- nlevels(group)
    if(group_nlevels < 2){
      cat('\n', 'Groups are less than one.', '\n')
      stop('')
    }
    
    if(group_nlevels == 2){
      resp_type <- "Two class unpaired"
    }else{
      resp_type <- "Multiclass"
    }
    cat('\n', resp_type, '\n')
    samr_obj <- samr::samr(sam_data, resp.type = resp_type, nperms = nperms, random.seed = rand)
    
    # Compute the delta values
    delta_table <- samr::samr.compute.delta.table(samr_obj)
    
    # Determine a FDR cut-off
    index_less_than_min_FDR <- which(delta_table[,5] < minFDR)
    if(length(index_less_than_min_FDR) < 1){
      cat('\n', 'Not found appropiate cutoff less than specific minimum FDR.')
      stop('')
    }else{
      delta_index <- index_less_than_min_FDR[1]
      delta <- delta_table[delta_index,1]
    }
    
    
    # Extract significant genes at the cut-off delta
    siggenes_table <- samr::samr.compute.siggenes.table(samr_obj, delta, sam_data, delta_table, all.genes = FALSE)
    genes_up_n <- siggenes_table$ngenes.up
    if(genes_up_n > 0){
      genes_up_df <- data.frame(siggenes_table$genes.up)
      genes_up_df_col <- ncol(genes_up_df)
      genes_up_df <- genes_up_df[,c(3,7:genes_up_df_col)]
      genes_up_df_col <- ncol(genes_up_df)
      genes_up_df[,genes_up_df_col] <- as.numeric(genes_up_df[,genes_up_df_col])/100
      genes_up_df_colnames <- colnames(genes_up_df)
      colnames(genes_up_df) <- c('ID', genes_up_df_colnames[-c(1,genes_up_df_col)], 'qvalue')
      
    }else{
      genes_up_df <- NULL
    }
    
    genes_lo_n <- siggenes_table$ngenes.lo
    if(genes_lo_n > 0){
      genes_lo_df <- data.frame(siggenes_table$genes.lo)
      genes_lo_df_col <- ncol(genes_lo_df)
      genes_lo_df <- genes_lo_df[,c(3,7:genes_lo_df_col)]
      genes_lo_df_col <- ncol(genes_lo_df)
      genes_lo_df[,genes_lo_df_col] <- as.numeric(genes_lo_df[,genes_lo_df_col])/100
      genes_lo_df_colnames <- colnames(genes_lo_df)
      colnames(genes_lo_df) <- c('ID', genes_lo_df_colnames[-c(1,genes_lo_df_col)], 'qvalue')
    }else{
      genes_lo_df <- NULL
    }
    
    sam_results_list <- list(
      genes_up_df <- genes_up_df,
      genes_down_df <- genes_lo_df
    )
    
    sam_results_list[[1]]$Fold.Change = as.numeric(sam_results_list[[1]]$Fold.Change)
    sam_results_list[[2]]$Fold.Change = as.numeric(sam_results_list[[2]]$Fold.Change)
    sam_results = rbind(sam_results_list[[1]], sam_results_list[[2]])
    output$samresult <- renderDataTable(sam_results)
    output$samresultdl<-downloadHandler(
      filename = function(){paste("sam_result", userID,".csv",sep="")},
      content = function(file){
        write.csv(sam_results,file,row.names = FALSE)
      }
    )
    
    index_of_match = match(sam_results$ID, expr_data_frame$ID)
    expr_data_frame_match = expr_data_frame[index_of_match,]
    expr_data_frame_plot = expr_data_frame_match[,-1]
    rownames(expr_data_frame_plot) = expr_data_frame_match$ID
    
    group_test <- data.frame(as.character(phosphorylation_experiment_design_file[,2]), row.names = phosphorylation_experiment_design_file[,1])
    colnames(group_test) <- "Group"
    test_change <- ifelse(sam_results$Fold.Change < 1, 'DOWN','UP')
    rowname_test <- data.frame(test_change, row.names = sam_results$ID)
    colnames(rowname_test) <- 'Change'
    click_counter$sam_count = 1
    list(samr_obj, delta, expr_data_frame_plot, group_test, rowname_test)
    
  })
  
  sam_plot <- eventReactive(
    input$sambt, {
      samr::samr.plot(sam()[[1]], sam()[[2]])
      pdf(file = paste('tmp/',userID,'/analysis/sam/sam.pdf',sep=''))
      samr::samr.plot(sam()[[1]], sam()[[2]])
      dev.off()
    }
  )

  # download
  output$samplotdl <- downloadHandler(
    filename = function(){paste("sam_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/sam/sam.pdf',sep=''),file)
    }
  )
  
  observeEvent(
    input$samphbt, {
      if(click_counter$sam_count) {
        isolate(
          if(nrow(sam()[[3]]) > 1){
            sam_for_ph <- isolate(sam()[[3]])
            ph <- pheatmap(sam_for_ph,
                           scale = input$samphscale,
                           cluster_rows = input$samphcluster,
                           cluster_cols = FALSE,
                           annotation_col = sam()[[4]],
                           annotation_row = sam()[[5]],
                           show_rownames = input$samphrowname,
                           clustering_distance_rows = input$samphdistance,
                           clustering_method = input$samphclusmethod
            )
            dev.off()
            output$samph <- renderPlot(ph)
            if((nrow(sam()[[3]]) > 500) & online ) {
              output$samphinter <- renderPlotly({
                p <- plot_ly() %>%
                  add_annotations(
                    text = "Differential phosphorylation sites exceed 500. 
                Please use the local version to view the interactive heatmap.",
                    xref = "paper", yref = "paper",
                    x = 0.5, y = 0.1,
                    showarrow = FALSE,
                    font = list(size = 20)
                  )
              })
            } else {
              output$samphinter <- renderPlotly(
                heatmaply(
                  sam_for_ph,
                  scale = input$samphscale,
                  scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(
                    low = "blue",
                    high = "red"
                  ),
                  Rowv = input$samphcluster,
                  Colv = FALSE,
                  hclust_method = input$samphclusmethod,
                  distance_method = input$samphdistance
                )
              )
            }
          } else {
            sendSweetAlert(
              session = session,
              title = "Tip",
              text = "At least two p-sites are required to plot a heatmap.",
              type = "info"
            )
          }
        )
      } else {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the 'Analysis' button first.",
          type = "info"
        )
      }
    }
  )
  
  observeEvent(
    input$sambt, {
      output$samstatic <- renderPlot(sam_plot())
    }
  )

  # anova
  anova <- eventReactive(input$anovabt,{
    validate(
      need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
      need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
    )
    phosphorylation_experiment_design_file <- fileset()[[1]]
    expr_data_frame <- fileset()[[2]]
    
    phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
    phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
    # group information
    group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
    group_levels = paste('t', phosphorylation_groups_labels, sep = '')
    group = factor(group, levels = group_levels)
    
    anova_result_df = analysis_deps_anova(expr_data_frame, group, log2_label = FALSE, return_padjust = TRUE, adjust_method = input$anovaadjust)
    df <- anova_result_df[anova_result_df$logFC > log2(input$anovafc) & anova_result_df$pvalue < input$anovapvalue,]
    
    index_of_match = match(df$ID, expr_data_frame$ID)
    expr_data_frame_match = expr_data_frame[index_of_match,]
    expr_data_frame_plot = expr_data_frame_match[,-1]
    rownames(expr_data_frame_plot) = expr_data_frame_match$ID
    
    group_test <- data.frame(as.character(phosphorylation_experiment_design_file[,2]), row.names = phosphorylation_experiment_design_file[,1])
    colnames(group_test) <- "Group"
    click_counter$anova_count = 1
    list(expr_data_frame_plot,group_test,df)
  })
  observeEvent(input$anovabt, {output$anovaresult <- renderDataTable(anova()[[3]])})
  observeEvent(
    input$anovaphbt, {
      if(click_counter$anova_count) {
        if(nrow(anova()[[1]]) > 1) {
          anova_for_ph <- isolate(anova()[[1]])
          ph <- pheatmap(anova_for_ph,
                         scale = input$anovaphscale,
                         cluster_rows = input$anovaphcluster,
                         cluster_cols = FALSE,
                         annotation_col = anova()[[2]],
                         show_rownames = input$anovaphrowname,
                         clustering_distance_rows = input$anovaphdistance,
                         clustering_method = input$anovaphclusmethod
          )
          dev.off()
          output$anovaph <- renderPlot(ph)
          output$anovaphdlbt <- downloadHandler(
            filename = function(){paste("anovaph_result", userID,".pdf",sep="")},
            content = function(file){
              p <- as.ggplot(ph)
              ggsave(filename = file,plot = p,width = 9,height = 5)
            }
          )
          if((nrow(anova_for_ph) > 500) & online) {
            output$anovainterph <- renderPlotly({
              p <- plot_ly() %>%
                add_annotations(
                  text = "Differential phosphorylation sites exceed 500. 
                Please use the local version to view the interactive heatmap.",
                  xref = "paper", yref = "paper",
                  x = 0.5, y = 0.1,
                  showarrow = FALSE,
                  font = list(size = 20)
                )
            })
          } else {
            output$anovainterph <- renderPlotly(
              heatmaply(
                anova_for_ph,
                scale = input$anovaphscale,
                scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(
                  low = "blue",
                  high = "red"
                ),
                Rowv = input$anovaphcluster,
                Colv = FALSE,
                hclust_method = input$anovaphclusmethod,
                distance_method = input$anovaphdistance,
              )
            )
          }
        } else {
          sendSweetAlert(
            session = session,
            title = "Tip",
            text = "At least two p-sites are required to plot a heatmap.",
            type = "info"
          )
        }
      } else {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "Please click the 'Analysis' button first.",
          type = "info"
        )
      }
    }
  )
  
  output$anovastatic <- renderPlot({
    anova_plot()
  })
  
  output$anovainter <- renderPlotly({
    anova_plot()
  })
  
  output$limmaphdlbt <- downloadHandler(
    filename = function(){paste("limmaph_result", userID,".pdf",sep="")},
    content = function(file){
      ph <- pheatmap(limma()[[1]],
                     scale = input$limmaphscale,
                     cluster_rows = input$limmaphcluster,
                     cluster_cols = FALSE,
                     annotation_col = limma()[[2]],
                     annotation_row = limma()[[3]],
                     show_rownames = input$limmaphrowname,
                     clustering_distance_rows = input$limmaphdistance,
                     clustering_method = input$limmaphclusmethod
      )
      dev.off()
      ggsave(p, filename = file,width = 9,height = 5)
    }
  )
  observeEvent(
    input$viewlimmafile,{
      showModal(modalDialog(
        title = "Result file",
        size = "l",
        dataTableOutput("limmaresult"),
        div(downloadButton("limmaresultdl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$samphdlbt <- downloadHandler(
    
    filename = function(){paste("samph_result", userID,".pdf",sep="")},
    content = function(file){
      ph <- pheatmap(sam()[[3]],
                     scale = input$samphscale,
                     cluster_rows = input$samphcluster,
                     cluster_cols = FALSE,
                     annotation_col = sam()[[4]],
                     annotation_row = sam()[[5]],
                     show_rownames = input$samphrowname,
                     clustering_distance_rows = input$samphdistance,
                     clustering_method = input$samphclusmethod
      )
      dev.off()
      p <- as.ggplot(ph)
      ggsave(filename = file,plot = p,width = 9,height = 5)
    }
    
  )
  observeEvent(
    input$viewsamfile,{
      showModal(modalDialog(
        title = "Result file",
        size = "l",
        dataTableOutput("samresult"),
        div(downloadButton("samresultdl"), style = "display:flex; justify-content:center; align-item:center;"),
        dataTableOutput("samresultforph"),
        downloadButton("samresultdl2"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  # Time course
  tc <- eventReactive(
    input$tcanalysis, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
      )
      phosphorylation_experiment_design_file <- fileset()[[1]]
      data_frame_normalization_with_control_no_pair <- fileset()[[2]]
      expr_data_frame = data_frame_normalization_with_control_no_pair
      # read group information
      phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group = factor(group, levels = group_levels)
      # annova for deps
      anova_result_df = analysis_deps_anova(expr_data_frame, group, log2_label = FALSE, return_padjust = TRUE, adjust_method = input$tcadjust)
      index_of_deps = which(anova_result_df$pvalue < input$tcpvalue & (abs(anova_result_df$logFC)>log2(input$tcfc)))
      symbol_of_deps = as.vector(anova_result_df$ID[index_of_deps])
      # DEPs for time course analysis
      index_of_match = match(symbol_of_deps, expr_data_frame$ID)
      fuzzy_input_df = expr_data_frame[index_of_match,]
      # fuzzy c-means clustering
      set.seed(1000)
      n1 = ceiling(sqrt(input$tckcluster))
      n2 = ceiling(input$tckcluster/n1)
      input_data <- fuzzy_input_df
      group <- group
      group_levels <- group_levels
      k_cluster <- input$tckcluster
      iteration = input$tciteration
      mfrow = c(n1,n2)
      min_mem = input$tcminmem
      
      requireNamespace('e1071')
      requireNamespace('ClueR')
      deps_ID <- as.vector(input_data[,1])
      deps_value <- input_data[,-1]
      deps_value_row <- nrow(deps_value)
      deps_value_group_mean <- NULL
      for(i in seq_len(deps_value_row)){
        x <- as.vector(unlist(deps_value[i,]))
        x_g_m <- tapply(x, group, mean)
        deps_value_group_mean <- rbind(deps_value_group_mean, x_g_m)
      }
      colnames(deps_value_group_mean) <- group_levels
      rownames(deps_value_group_mean) <- deps_ID
      deps_value_scale <- t(scale(t(deps_value_group_mean)))
      clustObj <- e1071::cmeans(deps_value_scale, centers = k_cluster, iter.max=100, m=1.5)
      fuzzy_clustObj=clustObj
      list(deps_value_scale,clustObj,min_mem,mfrow)
    }
  )
  
  tc_plot <- eventReactive(input$tcanalysis,{
    deps_value_scale <- tc()[[1]]
    clustObj <- tc()[[2]]
    min_mem <- tc()[[3]]
    mfrow <- tc()[[4]]
    ClueR::fuzzPlot(deps_value_scale, clustObj, llwd = 2, min.mem = min_mem, mfrow = mfrow)
    pdf(file=paste('tmp/',userID,'/analysis/tc/tc.pdf',sep=''))
    ClueR::fuzzPlot(deps_value_scale, clustObj, llwd = 2, min.mem = min_mem, mfrow = mfrow)
    dev.off()
    
  })
  output$timecourse <- renderPlot({
    tc_plot()
  })
  clusterdf <- reactive({
    fuzzy_clustObj <- tc()[[2]]
    clusterS_info =  fuzzy_clustObj$cluster
    clusterS_names = names(clusterS_info)
    clusters_df = data.frame(clusterS_names, clusterS_info)
    clusters_df
  })
  output$timecoursedf <- renderDataTable(clusterdf())
  output$tcresultdl<-downloadHandler(
    filename = function(){paste("timecourse_result", userID,".csv",sep="")},
    content = function(file){
      write.csv(clusterdf(),file,row.names = FALSE)
    }
  )
  
  output$tcplotdl <- downloadHandler(
    filename = function(){paste("timecourse_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/tc/tc.pdf',sep=''),file)
    }
  )
  
  observeEvent(
    input$viewtcfile,{
      showModal(modalDialog(
        title = "Result file",
        size = "l",
        dataTableOutput("timecoursedf"),
        div(downloadButton("tcresultdl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  # Kinase-substrate enrichment analysis (KSEA)
  kap1 <- eventReactive(
    input$kapanalysisbt1, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
      )
      phosphorylation_experiment_design_file <- fileset()[[1]]
      data_frame_normalization_with_control_no_pair <- fileset()[[2]]
      expr_data_frame = data_frame_normalization_with_control_no_pair
      # read group information
      phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group = factor(group, levels = group_levels)
      # annova for deps
      anova_result_df = analysis_deps_anova(expr_data_frame, group, log2_label = FALSE, return_padjust = TRUE, adjust_method = input$kapadjust)
      index_of_deps = which(anova_result_df$pvalue < input$kappvalue & (abs(anova_result_df$logFC)>log2(input$kapfc)))
      symbol_of_deps = as.vector(anova_result_df$ID[index_of_deps])
      # DEPs for time course analysis
      index_of_match = match(symbol_of_deps, expr_data_frame$ID)
      fuzzy_input_df = expr_data_frame[index_of_match,]
      # fuzzy c-means clustering
      set.seed(1000)
      n1 = ceiling(sqrt(input$kapkcluster))
      n2 = ceiling(input$kapkcluster/n1)
      
      input_data <- fuzzy_input_df
      group <- group
      group_levels <- group_levels
      k_cluster=input$kapkcluster
      iteration = input$kapiteration
      min_mem = input$kapminmem
      mfrow = c(n1,n2)
      requireNamespace('e1071')
      requireNamespace('ClueR')
      deps_ID <- as.vector(input_data[,1])
      deps_value <- input_data[,-1]
      deps_value_row <- nrow(deps_value)
      deps_value_group_mean <- NULL
      for(i in seq_len(deps_value_row)){
        x <- as.vector(unlist(deps_value[i,]))
        x_g_m <- tapply(x, group, mean)
        deps_value_group_mean <- rbind(deps_value_group_mean, x_g_m)
      }
      colnames(deps_value_group_mean) <- group_levels
      rownames(deps_value_group_mean) <- deps_ID
      deps_value_scale <- t(scale(t(deps_value_group_mean)))
      clustObj <- e1071::cmeans(deps_value_scale, centers = k_cluster, iter.max=100, m=1.5)
      list(deps_value_scale,clustObj,min_mem,mfrow)
    }
  )
  
  kap_plot1 <- eventReactive(input$kapanalysisbt1,{
    deps_value_scale <- kap1()[[1]]
    clustObj <- kap1()[[2]]
    min_mem <- kap1()[[3]]
    mfrow <- kap1()[[4]]
    
    ClueR::fuzzPlot(deps_value_scale, clustObj, llwd = 2, min.mem = min_mem, mfrow = mfrow)
    
    pdf(paste('tmp/',userID,'/analysis/kap/kap1.pdf',sep=''))
    ClueR::fuzzPlot(deps_value_scale, clustObj, llwd = 2, min.mem = min_mem, mfrow = mfrow)
    dev.off()
  })
  
  output$kapstep2cluster <- renderUI(selectInput("kapstep2cluster", h5("select a cluster:"), choices = seq(1, input$kapkcluster)))
  output$kapmainui <- renderUI(textAreaInput("kapmain", h5("title:"), value = paste0("Kinase-Substrate Enrichment Analysis of Cluster ", input$kapstep2cluster)))
  
  kaptcclusterdf <- reactive({
    fuzzy_clustObj <- kap1()[[2]]
    clusterS_info =  fuzzy_clustObj$cluster
    clusterS_names = names(clusterS_info)
    clusters_df = data.frame(clusterS_names, clusterS_info)
    clusters_df
  })
  
  observeEvent(
    input$kapanalysisbt1,{
      output$kaptimecoursedf <- renderDataTable(kaptcclusterdf())
      output$kaptimecourseplot <- renderPlot({
        kap_plot1()
      })
      updateTabsetPanel(session, "kapresultnav", selected = "kapstep1val")
    }
  )
  
  output$kaptcplotdl <- downloadHandler(
    filename = function(){paste("kinase_activity_pred_timecourse_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/kap/kap1.pdf',sep=''),file)
    }
  )
  
  observeEvent(
    input$viewkaptimecoursefile,{
      showModal(modalDialog(
        title = "Result file",
        size = "l",
        dataTableOutput("kaptimecoursedf"),
        div(downloadButton("kaptcresultdl"), style = "display:flex; justify-content:center; align-item:center;"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  output$kaptcresultdl<-downloadHandler(
    filename = function(){paste("kinase_activity_pred_timecourse_result", userID,".csv",sep="")},
    content = function(file){
      write.csv(kaptcclusterdf(),file,row.names = FALSE)
    }
  )
  
  kap2 <- eventReactive(input$kapanalysisbt2,{
    phosphorylation_experiment_design_file <- fileset()[[1]]
    data_frame_normalization_with_control_no_pair <- fileset()[[2]]
    expr_data_frame = data_frame_normalization_with_control_no_pair
    
    cluster_symbol = kaptcclusterdf()[,1][kaptcclusterdf()[,2]==input$kapstep2cluster] 
    index_of_cluster = match(cluster_symbol, expr_data_frame$ID)
    cluster_df = expr_data_frame[index_of_cluster,]
    summary_df_list_from_ksea_cluster = get_summary_from_ksea2(cluster_df, species = input$kapspecies, log2_label = FALSE, ratio_cutoff = 3)
    
    ksea_regulons_activity_df_cluster = summary_df_list_from_ksea_cluster$ksea_regulons_activity_df
    ksea_id_cluster = as.vector(ksea_regulons_activity_df_cluster[,1])
    ksea_value_cluster = ksea_regulons_activity_df_cluster[,-1]
    
    # annotation setting
    # group = paste('t', fileset()[[1]]$Group, sep = '')
    group = fileset()[[1]]$Group
    phosphorylation_groups_labels = names(table(fileset()[[1]]$Group))
    # group_levels = paste('t', phosphorylation_groups_labels, sep = '')
    group_levels = phosphorylation_groups_labels
    group = factor(group, levels = group_levels)
    annotation_col = data.frame(
      group = group
    )
    rownames(annotation_col) = colnames(ksea_value_cluster)
    
    # breaks and colors setting
    breaks_1 = seq(-4, -2, 0.2) 
    colors_1 = colorRampPalette(c('#11264f', '#145b7d'))(length(breaks_1)-1) 
    
    breaks_2 = seq(-2, -1, 0.2)
    colors_2 = colorRampPalette(c('#145b7d', '#009ad6'))(length(breaks_2))
    
    breaks_3 = seq(-1, 1, 0.2)
    colors_3 = colorRampPalette(c('#009ad6', 'white', '#FF6600'))(length(breaks_3))
    
    breaks_4 = seq(1, 2, 0.2)
    colors_4 = colorRampPalette(c('#FF6600', 'red'))(length(breaks_4))
    
    breaks_5 = seq(2, 4, 0.2)
    colors_5 = colorRampPalette(c('red', 'firebrick'))(length(breaks_5))
    
    breaks = c(breaks_1, breaks_2, breaks_3, breaks_4, breaks_5)
    breaks = breaks[which(!duplicated(breaks))]
    color = c(colors_1, colors_2, colors_3, colors_4, colors_5)
    color = color[which(!duplicated(color))]
    
    # length(breaks)
    # length(which(!duplicated(color)))
    list(ksea_value_cluster,annotation_col,breaks,color)
  })
  observeEvent(
    input$kapanalysisbt2, {
      ksea_value_cluster <- kap2()[[1]]
      annotation_col <- kap2()[[2]]
      breaks <- kap2()[[3]]
      color <- kap2()[[4]]
      ph = pheatmap(ksea_value_cluster, scale = input$kapscale,
                    annotation_col = annotation_col,
                    clustering_distance_rows = input$kapdistance,
                    clustering_method = input$kapclusmethod,
                    show_rownames = T,
                    cluster_cols = F,
                    border_color = 'black',
                    cellwidth = 12, cellheight = 12,
                    breaks = breaks,
                    color = color,
                    legend_breaks = c(-4, -2, -1, 0, 1, 2, 4),
                    legend_labels = c(-4, -2, -1, 0, 1, 2, 4),
                    main = input$kapmain)
      dev.off()
      output$kapstep2plot <- renderPlot(ph)
      output$kapplotdl <- downloadHandler(
        filename = function(){paste("kinase_activity_pred", userID,".pdf",sep="")},
        content = function(file){
          p <- as.ggplot(ph)
          ggsave(filename = file, p,width = 12,height = 12)
        }
      )
      output$kapstep2plotinter <- renderPlotly(
        heatmaply(
          ksea_value_cluster,
          main = input$kapmain,
          scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(
            low = "blue", 
            high = "red", 
            limits = c(-4, 4)
          ),
          scale = input$kapscale,
          # row_dendrogram = TRUE,  
          Colv = FALSE, 
          hclust_method = input$kapclusmethod, 
          distance_method = input$kapdistance
        )
      )
      output$kapstep2df <- renderDataTable(ksea_value_cluster)
      updateTabsetPanel(session, "kapresultnav", selected = "kapstep2val")
    }
  )
  
  output$kseaselect1 <- renderUI({
    return(
      selectInput(
        'kseagroup1',
        h5('control:'),
        choices = unique((fileset()[[1]])[,2])
      )
    )
  })
  output$kseaselect2 <- renderUI({
    return(
      selectInput(
        'kseagroup2',
        h5('experiment:'),
        choices = setdiff(unique((fileset()[[1]])[,2]), input$kseagroup1)
      )
    )
  })
  
  ksea1 <- eventReactive(
    input$kseaanalysisbt1, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
      )
      phosphorylation_experiment_design_file <- fileset()[[1]]
      expr_data_frame <- fileset()[[2]]
      
      group_T_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$kseagroup2]
      expr_data_frame2 <- expr_data_frame[c("ID", group_T_codes)]
      
      group_P_codes <- phosphorylation_experiment_design_file$Experiment_Code[phosphorylation_experiment_design_file$Group == input$kseagroup1]
      expr_data_frame1 <- expr_data_frame[c("ID", group_P_codes)]
      
      phosphorylation_groups_labels = unique(phosphorylation_experiment_design_file$Group)
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      # group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      # group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group = phosphorylation_experiment_design_file$Group
      group_levels = phosphorylation_groups_labels
      group = factor(group, levels = group_levels)
      
      if(input$kseapair == TRUE) {
        if (!("Pair" %in% names(fileset()[[1]])) || all(is.na(fileset()[[1]]$Pair) | fileset()[[1]]$Pair == "") || all(fileset()[[1]]$Pair == 0)) {
          sendSweetAlert(
            session = session,
            title = "Error...",
            text = "No 'Pair' information available.",
            type = "error",
            btn_labels = "OK"
          )
          result <- NULL
        } else {
          result = expr_data_frame2
          for(sample in colnames(result)){
            pair = phosphorylation_experiment_design_file[phosphorylation_experiment_design_file$Experiment_Code == sample,]$Pair
            target_sample = phosphorylation_experiment_design_file[phosphorylation_experiment_design_file$Pair == pair &
                                                                     phosphorylation_experiment_design_file$Group == input$kseagroup1,]$Experiment_Code
            
            result[, sample] = expr_data_frame[, sample] / expr_data_frame[, target_sample]
          }
          result$ID = expr_data_frame$ID
          df_without_id <- result[, -ncol(result)]
          id_col <- result[, ncol(result)]
          result <- data.frame(ID = id_col, df_without_id)
        }
      } else {
        dfmean1 <- apply(expr_data_frame1, 1, mean)
        dfmean2 <- apply(expr_data_frame2, 1, mean)
        FC <- dfmean2/dfmean1
        kseafc <- isolate(input$kseafc)
        result <- expr_data_frame[(FC >= kseafc)|(FC <= 1/kseafc),]
      }
      list(result, group)
    }
  )

  observeEvent(
    input$kseaanalysisbt1, {
      output$kseastep1df <- renderDataTable(ksea1()[[1]])
      updateTabsetPanel(session, "kapresultnav", selected = "kapstep1val")
    }
  )
  
  ksea2 <- eventReactive(input$kseaanalysisbt2,{
    if(online & (input$kseamode == 'Two groups') & (input$analysisdatatype == 3) & (input$analysisdemodata == 'case2')) {
      sendSweetAlert(
        session = session,
        title = "Attention...",
        text = "Due to limited hardware resources, please use the local version.",
        type = "info",
        btn_labels = "OK"
      )
    } else {
      
      if(!is.null(ksea1()[[1]])) {
        summary_df_list_from_ksea_cluster = get_summary_from_ksea2(ksea1()[[1]], species = input$kseaspecies, log2_label = FALSE, ratio_cutoff = 3)
        ksea_regulons_activity_df_cluster = summary_df_list_from_ksea_cluster$ksea_regulons_activity_df
        med <- apply(abs(ksea_regulons_activity_df_cluster[, 2:ncol(ksea_regulons_activity_df_cluster)]), 1, median) # 增加排序方式选项
        ksea_regulons_activity_df_cluster$median <- med
        
        ksea_regulons_activity_df_cluster_sorted <- ksea_regulons_activity_df_cluster[order(-ksea_regulons_activity_df_cluster$median),]
        ksea_regulons_activity_df_cluster_sorted <- head(ksea_regulons_activity_df_cluster_sorted, 50)
        ksea_regulons_activity_df_cluster_sorted$median <- NULL
        
        ksea_id_cluster = as.vector(ksea_regulons_activity_df_cluster_sorted[,1])
        ksea_value_cluster = ksea_regulons_activity_df_cluster_sorted[,-1]
        
        if(input$kseapair == FALSE) {
          annotation_col = data.frame(
            group =  ksea1()[[2]]
          )
          rownames(annotation_col) = colnames(ksea_value_cluster)
        } else {
          annotation_col = NULL
        }
        # breaks and colors setting
        breaks_1 = seq(-4, -2, 0.2) 
        colors_1 = colorRampPalette(c('#11264f', '#145b7d'))(length(breaks_1)-1) 
        
        breaks_2 = seq(-2, -1, 0.2)
        colors_2 = colorRampPalette(c('#145b7d', '#009ad6'))(length(breaks_2))
        
        breaks_3 = seq(-1, 1, 0.2)
        colors_3 = colorRampPalette(c('#009ad6', 'white', '#FF6600'))(length(breaks_3))
        
        breaks_4 = seq(1, 2, 0.2)
        colors_4 = colorRampPalette(c('#FF6600', 'red'))(length(breaks_4))
        
        breaks_5 = seq(2, 4, 0.2)
        colors_5 = colorRampPalette(c('red', 'firebrick'))(length(breaks_5))
        
        breaks = c(breaks_1, breaks_2, breaks_3, breaks_4, breaks_5)
        breaks = breaks[which(!duplicated(breaks))]
        color = c(colors_1, colors_2, colors_3, colors_4, colors_5)
        color = color[which(!duplicated(color))]
        
        length(breaks)
        length(which(!duplicated(color)))
        list(ksea_value_cluster,annotation_col,breaks,color)
      }
      
    }
  })
  
  observeEvent(
    input$kseaanalysisbt2, {
      if(online & (input$kseamode == 'Two groups') & (input$analysisdatatype == 3) & (input$analysisdemodata == 'case2')) {
        sendSweetAlert(
          session = session,
          title = "Attention...",
          text = "Due to limited hardware resources, please use the local version.",
          type = "info",
          btn_labels = "OK"
        )
      } else {
        if(!is.null(ksea1()[[1]])) {
          ksea_value_cluster <- ksea2()[[1]]
          if(nrow(ksea_value_cluster) > 0) {
            annotation_col <- ksea2()[[2]]
            breaks <- ksea2()[[3]]
            color <- ksea2()[[4]]
            
            output$kapstep2plottwogroupinter <- renderPlotly(
              heatmaply(
                ksea_value_cluster,
                main = input$kseamain,
                scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(
                  low = "blue", 
                  high = "red", 
                  limits = c(-4, 4)
                ),
                scale = input$kseascale,
                # row_dendrogram = TRUE,  
                Colv = FALSE, 
                hclust_method = input$kseaclusmethod, 
                distance_method = input$kseadistance,
              )
            )
            
            if(nrow(ksea_value_cluster) < 37) {
              output$kseastep2plotui <- renderUI({plotOutput("kseastep2plot")})
              ph = pheatmap(ksea_value_cluster, scale = input$kseascale,
                            annotation_col = annotation_col,
                            clustering_distance_rows = input$kseadistance,
                            clustering_method = input$kseaclusmethod,
                            show_rownames = T,
                            cluster_cols = F,
                            border_color = 'black',
                            cellwidth = 15, cellheight = 15,
                            breaks = breaks,
                            color = color,
                            fontsize_col = 10,
                            fontsize_row = 10,
                            legend_breaks = c(-4, -2, -1, 0, 1, 2, 4),
                            legend_labels = c(-4, -2, -1, 0, 1, 2, 4),
                            main = input$kseamain)
              dev.off()
              output$kseastep2plot <- renderPlot(ph)
            } else if(nrow(ksea_value_cluster) < 70) {
              output$kseastep2plotui <- renderUI({plotOutput("kseastep2plotmid")})
              ph = pheatmap(ksea_value_cluster, scale = input$kseascale,
                            annotation_col = annotation_col,
                            clustering_distance_rows = input$kseadistance,
                            clustering_method = input$kseaclusmethod,
                            show_rownames = T,
                            cluster_cols = F,
                            border_color = 'black',
                            # cellwidth = 12, cellheight = 12,
                            cellwidth = 3, cellheight = 3,
                            breaks = breaks,
                            color = color,
                            # fontsize_col = 10,
                            # fontsize_row = 10,
                            fontsize_col = 2,
                            fontsize_row = 2,
                            legend_breaks = c(-4, -2, -1, 0, 1, 2, 4),
                            legend_labels = c(-4, -2, -1, 0, 1, 2, 4),
                            main = input$kseamain)
              dev.off()
              output$kseastep2plotmid <- renderPlot(ph)
            } else if(nrow(ksea_value_cluster) < 100) {
              output$kseastep2plotui <- renderUI({plotOutput("kseastep2plotmini")})
              ph = pheatmap(ksea_value_cluster, scale = input$kseascale,
                            annotation_col = annotation_col,
                            clustering_distance_rows = input$kseadistance,
                            clustering_method = input$kseaclusmethod,
                            show_rownames = T,
                            cluster_cols = F,
                            border_color = 'black',
                            cellwidth = 12, cellheight = 12,
                            breaks = breaks,
                            color = color,
                            fontsize_col = 10,
                            fontsize_row = 10,
                            
                            legend_breaks = c(-4, -2, -1, 0, 1, 2, 4),
                            legend_labels = c(-4, -2, -1, 0, 1, 2, 4),
                            main = input$kseamain)
              dev.off()
              output$kseastep2plotmini <- renderPlot(ph)
            } else {
              output$kseastep2plotui <- renderUI({plotOutput("kseastep2plotxs")})
              ph = pheatmap(ksea_value_cluster, scale = input$kseascale,
                            annotation_col = annotation_col,
                            clustering_distance_rows = input$kseadistance,
                            clustering_method = input$kseaclusmethod,
                            show_rownames = T,
                            cluster_cols = F,
                            border_color = 'black',
                            cellwidth = 12, cellheight = 12,
                            breaks = breaks,
                            color = color,
                            fontsize_col = 10,
                            fontsize_row = 10,
                            
                            legend_breaks = c(-4, -2, -1, 0, 1, 2, 4),
                            legend_labels = c(-4, -2, -1, 0, 1, 2, 4),
                            main = input$kseamain)
              dev.off()
              output$kseastep2plotxs <- renderPlot(ph)
            }
            output$kaptwogroupplotdl <- downloadHandler(
              filename = function(){paste("kinase_activity_pred", userID,".pdf",sep="")},
              content = function(file){
                p <- as.ggplot(ph)
                ggsave(filename = file, p,width = 12,height = 12)
              }
            )
            output$kseastep2df <- renderDataTable(ksea_value_cluster)
            updateTabsetPanel(session, "kapresultnav", selected = "kapstep2val")
          }
        }
      }
    }
  )
  
  # Survival analysis
  surplots <- eventReactive(
    input$survivalanalysis, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !'),
        need(fileset()[[4]],'Please check that the clinical data file is uploaded !')
      )
      Clinical <- fileset()[[4]]
      phosphorylation <- fileset()[[2]]
      
      # Clinical
      clinical <- Clinical[, 2:ncol(Clinical)]
      rownames(clinical) <- Clinical[, 1]
      clinical <- na.omit(clinical)
      
      exp <- phosphorylation
      exp <- exp[, -1]
      
      samples <- intersect(rownames(clinical), colnames(exp))
      
      if (length(samples) == 0) {
        print("The sample name was different between expreesion and Clinical files!", "\n")
        return(NULL)
      }
      
      exp <- exp[, samples]
      clinical <- clinical[samples, ]
      
      cox_result <- as.data.frame(matrix(data = NA, ncol = 5, nrow = nrow(exp)))
      colnames(cox_result) <- c("Feature", "HR", "lower_95", "upper_95", "pvalue")
      
      for (i in 1:nrow(exp)) {
        fit_df <- clinical
        variable_names <- rownames(exp)[i]
        fit_df["variable"] <- as.numeric(exp[variable_names, ])
        dim(fit_df)
        
        res.cox <- coxph(Surv(fit_df[, 2], fit_df[, 1]) ~ fit_df[, 3], data = fit_df)
        sum <- summary(res.cox)
        
        cox_result[i, ] <- c(variable_names, round(c(sum$conf.int[, 1], sum$conf.int[, 3], sum$conf.int[, 4], sum$waldtest[3]), 4))
      }
      
      cox_result["adj_pvalue"] <- p.adjust(cox_result$pvalue, method = input$survivalpajust)
      cox_result <- cox_result[cox_result$HR != 1, ]
      rownames(cox_result) <- 1:nrow(cox_result)
      
      q_cutoff <- input$survivalpthreshold
      cox_result2 <- cox_result[which(cox_result$adj_pvalue <= q_cutoff), ]
      
      features <- cox_result2$Feature
      
      list(cox_result, features, clinical, exp)
    }
  )
  
  observeEvent(
    input$survivalanalysis, {
      output$survivaltable <- renderDataTable({
        surplots()[[1]]
      })
      output$survivalui <- renderUI({
        tagList(
          selectInput("survivalsig", h5("Select a statistically significant Psite:"), choices = surplots()[[2]])
        )
      })
    }
  )
  
  observeEvent(
    input$survivalplotbt1, {
      if ((input$sa_text_input %in% surplots()[[1]]$Feature) | (length(surplots()[[2]] > 0))){
        if (input$sa_text_input %in% surplots()[[1]]$Feature) {
          feature <- isolate(input$sa_text_input)
        } else {
          feature <- isolate(input$survivalsig)
        }
        fit_km <- surplots()[[3]]
        fit_km[feature] <- as.numeric(surplots()[[4]][feature, ])
      
        res.cut <- surv_cutpoint(fit_km,
                                 time = colnames(fit_km)[2], event = colnames(fit_km)[1],
                                 variables = feature
        )
        
        res.cat <- surv_categorize(res.cut)
        res.cat[, 3] <- ifelse(fit_km[feature] > res.cut$cutpoint$cutpoint, "high", "low")
        colnames(res.cat) <- c("time", "status", "Group")
        
        lowcol <- isolate(input$survivallowcol)
        highcol <- isolate(input$survivalhighcol)
        pdf(file = paste('tmp/',userID,'/analysis/surv/suv1.pdf',sep=''))#survivalplot1
        print(plot(res.cut, feature, palette = c(lowcol, highcol)),newpage=F)
        dev.off()
        pdf(file = paste('tmp/',userID,'/analysis/surv/suv2.pdf',sep=''))#survivalplot1
        print(ggsurvplot(do.call(survfit, list(Surv(res.cat[, 1], res.cat[, 2]) ~ Group, data = res.cat)),
                         linetype = c("solid", "solid"),
                         surv.median.line = "hv", surv.scale = "percent",
                         pval = T, risk.table = T,
                         conf.int = T, conf.int.alpha = 0.1, conf.int.style = "ribbon",
                         risk.table.y.text = T,
                         palette = c(lowcol, highcol),
                         xlab = "Survival time"
        ),newpage=F)
        dev.off()
  
        output$survivalplot1 <- renderPlot({
          plot(res.cut, feature, palette = c(lowcol, highcol))
          
        })
        
        output$survivalplot2 <- renderPlot({ggsurvplot(do.call(survfit, list(Surv(res.cat[, 1], res.cat[, 2]) ~ Group, data = res.cat)),
                                                       linetype = c("solid", "solid"),
                                                       surv.median.line = "hv", surv.scale = "percent",
                                                       pval = T, risk.table = T,
                                                       conf.int = T, conf.int.alpha = 0.1, conf.int.style = "ribbon",
                                                       risk.table.y.text = T,
                                                       palette = c(lowcol, highcol),
                                                       xlab = "Survival time"
        )})
      } else {
        sendSweetAlert(
          session = session,
          title = "Error...",
          text = "Please select an item from the feature column in the right table to input.",
          type = "error",
          btn_labels = "OK"
        )
      }
      
    }
  )
  
  output$surv1dl <- downloadHandler(
    filename = function(){paste("suvival_result1", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/surv/suv1.pdf',sep=''),file)
    }
  )

  output$surv2dl <- downloadHandler(
    filename = function(){paste("suvival_result2", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/surv/suv2.pdf',sep=''),file)
    }
  )
  
  
  # Motif enrichment analysis

  observeEvent(
    input$motifanalysisbt, {
      validate(
        need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
        need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !'),
        need(fileset()[[3]],'Please check that the motif analysis file is uploaded !')
      )
      if(input$analysisdatatype == 3 | ((input$analysisdatatype == 2) & (input$loaddatatype == TRUE))) {
        if(input$analysisdatatype == 3) {
          updateSelectInput(session, "motiffastatype", selected = "refseq")
        } else if(input$softwaretype == 1) {
          updateSelectInput(session, "motiffastatype", selected = "uniprot")
        } else if(input$softwaretype == 2) {
          updateSelectInput(session, "motiffastatype", selected = "refseq")
        }
        ask_confirmation(
          inputId = "myconfirmation",
          title = "Attention...",
          text = HTML(sprintf("The value of the parameter <u>'fasta type'</u> is set to <span style='color:red'>%s</span>. Please make sure this value is correct, otherwise the program will report an error. 
                         <br>To quickly present the case data, we sampled the original data to obtain smaller background data and foreground data. <br>Do you confirm run?", input$motiffastatype)),
          html = TRUE
        )
      } else {
        if(online) {
          sendSweetAlert(
            session = session,
            title = "Attention...",
            text = "Due to limited hardware resources, please use the local version.",
            type = "info",
            btn_labels = "OK"
          )
        } else {
          ask_confirmation(
            inputId = "myconfirmation",
            title = HTML(sprintf("The value of the parameter <u>'fasta type'</u> is set to <span style='color:red'>%s</span>. Please make sure this value is correct, otherwise the program will report an error.
                            <br>This step will take several hours.", input$motiffastatype)),
            text = "Do you confirm run? "
          )
        }
      }
    }
  )
  
  output$motifseqdownload <- downloadHandler(
    filename = function(){paste("sequence_for_motif", userID,".csv",sep="")},
    content = function(file){
      foreground_data <- fileset()[[3]]
      
      ID = as.vector(foreground_data$ID)
      Sequence = as.vector(foreground_data$Sequence)
      AA_in_protein = as.vector(foreground_data$AA_in_protein)
      
      # *** required parameters ***
      fixed_length = 15
      species = input$motifspecies
      fasta_type = input$motiffastatype
      
      # get foreground data frame
      foreground_df = get_aligned_seq_for_mea02(ID, Sequence, AA_in_protein, fixed_length, species = species, fasta_type = fasta_type)
      
      write.csv(foreground_df, file, row.names = FALSE)
    }
  )
  
  motifres1 <- eventReactive(
    input$myconfirmation, {
      if (isTRUE(input$myconfirmation)) {
        foreground_data <- fileset()[[3]]
        
        ID = as.vector(foreground_data$ID)
        Sequence = as.vector(foreground_data$Sequence)
        AA_in_protein = as.vector(foreground_data$AA_in_protein)
        
        # *** required parameters ***
        fixed_length = 15
        species = input$motifspecies
        motifx_pvalue = input$motifpvalue
        fasta_type = input$motiffastatype
        
        # get foreground data frame
        foreground_df = get_aligned_seq_for_mea02(ID, Sequence, AA_in_protein, fixed_length, species = species, fasta_type = fasta_type)
        
        # get background data frame
        motif_library_dir = "./PhosMap_datasets/motif_library/"
        background_df = utils::read.csv((paste0(motif_library_dir, fasta_type, "/", species, "/STY_background_of_", fasta_type, "_",  species, "_for_motif_enrichment.txt")), sep = '\t', header = TRUE)
        
        # construct foreground and background
        foreground = as.vector(foreground_df$aligned_seq)
        background = as.vector(background_df$Aligned_Seq)
        if(input$analysisdatatype == 3 | (input$analysisdatatype == 2 & input$loaddatatype == TRUE)) {
          foreground <- tail(foreground, 300)
          background <- tail(background, 800)
        }
        motifs_list = mea_based_on_background(foreground, AA_in_protein, background, motifx_pvalue)
        # Find sequences in foreground that are mapped to specific motif
        foreground_sequences_mapped_to_motifs = get_foreground_seq_to_motifs(motifs_list, foreground)
        # Find data frame in foreground that are mapped to specific motif
        foreground_df_mapped_to_motifs = get_foreground_df_to_motifs(foreground_sequences_mapped_to_motifs, foreground, foreground_df)
        # the data can be used for ploting logo of sepcific motif
        # foreground_sequences_mapped_to_motifs
        # ploting logo: Q......S.......
        
        # display--plot/quanti--unknown--quanti
        shinyjs::show(id = "motifenrichhidden1", anim = FALSE)
        list(motifs_list, foreground_sequences_mapped_to_motifs, foreground_df_mapped_to_motifs, foreground_df)
      } else {
        list(NULL, NULL, NULL, NULL)
      }
    },ignoreNULL = TRUE
  )
  
  observeEvent(
    input$motifanalysisbt, {
      output$motifenrichrank <- renderUI({
        tagList(
          column(12, numericInput("motifenrichrankin", h5("selected row number for plotting motif logo:"), 1, max = length(motifres1()[[2]]), min = 1, step = 1)),
        )
      })
      output$motifdfresult <- renderDataTable(datatable(rbind(motifres1()[[1]][["S"]], motifres1()[[1]][["T"]], motifres1()[[1]][["Y"]]), options = list(pageLength = 25)))
      output$motifenrichdl <- downloadHandler(
        filename = function(){paste("mearesult", userID,".csv",sep="")},
        content = function(file){
          write.csv(rbind(motifres1()[[1]][["S"]], motifres1()[[1]][["T"]], motifres1()[[1]][["Y"]]),file,row.names = FALSE)
        }
      )
    }
  )
  
  observeEvent(
    input$motifplotbt, {
      output$motifenrich1 <- renderPlot({
        # the data can be used for ploting logo of sepcific motif
        # foreground_sequences_mapped_to_motifs
        # 15 '.......SP.K....' CDK
        id <- isolate(input$motifenrichrankin)
        p <- ggseqlogo(motifres1()[[2]][[id]])
        ggsave(paste('tmp/',userID,'/analysis/motif/logo.pdf',sep=''),p)
        p
      })
      showModal(modalDialog(
        title = "Motif logo",
        size = "l",
        plotOutput("motifenrich1"),
        div(downloadButton("motiflogodl"), style = "display:flex; justify-content:center; align-item:center;")
      ))
    }
  )
  
  observeEvent(
    input$motifviewbt, {
      id <- isolate(input$motifenrichrankin)
      aligned_peptides = motifres1()[[2]][[id]]
      index_of_match = match(aligned_peptides, motifres1()[[4]]$aligned_seq)
      result <- fileset()[[3]][index_of_match,]
      # result <- result[,c(1,2,3,4,6)]
      result <- result[,c(1,2)]
      
      showModal(modalDialog(
        title = "Matched sites",
        size = "l",
        h4(paste0("Motif: "), names(motifres1()[[2]])[[id]]),
        dataTableOutput("motifsites"),
        div(downloadButton("motifsitesdl"), style = "display:flex; justify-content:center; align-item:center;"),
        
      ))
      output$motifsites <- renderDataTable(result)
      output$motifsitesdl <- downloadHandler(
        filename = function(){paste("motif_matched_sites", userID,".csv",sep="")},
        content = function(file){
          write.csv(result,file,row.names = FALSE)
        }
      )
    }
  )
  
  observeEvent(
    input$motifplotbt2, {
      foreground_sequences_mapped_to_motifs_count = length(motifres1()[[2]])
      motifs = names(motifres1()[[2]])
      peptides_count = NULL
      for(i in 1:foreground_sequences_mapped_to_motifs_count){
        l_i = motifres1()[[2]][[i]]
        peptides_count = c(peptides_count, length(l_i))
      }
      
      # Select motifs at least having 50 peptides
      # Assign quantitative values of peptides to their motif
      foreground_value = fileset()[[3]][,-c(seq(1,3))]
      min_seqs = input$minseqs
      index_of_motifs = which(peptides_count>=min_seqs)
      if(length(index_of_motifs) > 0) {
        motif_group_m_ratio_df = NULL
      
        # group = paste('t', fileset()[[1]]$Group, sep = '')
        group = fileset()[[1]]$Group
        phosphorylation_groups_labels = names(table(fileset()[[1]]$Group))
        # group_levels = paste('t', phosphorylation_groups_labels, sep = '')
        group_levels = phosphorylation_groups_labels
        group = factor(group, levels = group_levels)
        
        for(i in index_of_motifs){
          motif = motifs[i]
          aligned_peptides = motifres1()[[2]][[i]]
          index_of_match = match(aligned_peptides, motifres1()[[4]]$aligned_seq)
          motif_value = foreground_value[index_of_match,]
          motif_value_colsum = colSums(motif_value)
          motif_group_m = tapply(motif_value_colsum, group, mean)
          motif_group_m_ratio = motif_group_m/motif_group_m[1]
          motif_group_m_ratio_df = rbind(motif_group_m_ratio_df, motif_group_m_ratio)
        }
        rownames(motif_group_m_ratio_df) = motifs[index_of_motifs]
        motif_group_m_ratio_df_mat = as.matrix(motif_group_m_ratio_df)
        
        # 更改
        breaks_1 <- seq(0, 0.5, 0.1)
        colors_1 <- colorRampPalette(c('green', 'blue'))(length(breaks_1)-1)
        
        breaks_3 <- seq(0.5, 1.5, 0.1)
        colors_3 <- colorRampPalette(c('blue', 'white', '#FFBFBF'))(length(breaks_3))
        
        breaks_4 <- seq(1.5, 2, 0.1)
        colors_4 <- colorRampPalette(c('#FFBFBF', 'red'))(length(breaks_4))
        
        breaks_5 <- seq(2, 4, 0.1)
        colors_5 <- colorRampPalette(c('red','firebrick'))(length(breaks_5))
        
        breaks <- c(breaks_1, breaks_3, breaks_4, breaks_5)
        breaks <- breaks[which(!duplicated(breaks))]
        colors <- c(colors_1, colors_3, colors_4, colors_5)
        colors <- colors[which(!duplicated(colors))]
        
        length(breaks)
        length(which(!duplicated(colors)))
        ph <- pheatmap(
          motif_group_m_ratio_df_mat, 
          scale = 'none', 
          # annotation_col = annotation_col, 
          clustering_distance_cols = 'euclidean',
          clustering_method = input$motifclusmethod,
          fontsize_row = 6, cutree_rows = 1, show_rownames = TRUE, cluster_rows = TRUE,
          fontsize_col = 6, cutree_cols = 1, show_colnames = TRUE, cluster_cols = FALSE,
          border_color = 'black', 
          # color = colors, 
          cellwidth = 12, cellheight = 12,
          breaks = breaks,
          color = colors,
          legend_breaks = c(0, 0.5, 1, 1.5, 2, 4),
          legend_labels = c(0, 0.5, 1, 1.5, 2, 4),
          main = 'Motif enrichment analysis'
        )
        showModal(modalDialog(
          title = "Heatmap",
          size = "l",
          plotOutput("motifenrich2"),
          div(downloadButton("motifphdl"), style = "display:flex; justify-content:center; align-item:center;"),
          
        ))
        output$motifenrich2 <- renderPlot(ph)
        output$motifphdl <- downloadHandler(
          filename=function(){paste("motif_heatmap_result", userID,".pdf",sep="")},
          content = function(file){
            ggsave(ph, filename = file,width = 9,height = 9)
          })
        # if(nrow(motif_group_m_ratio_df_mat) > 0) {
        #   if(nrow(motif_group_m_ratio_df_mat) < 15){
        #   ph = pheatmap(motif_group_m_ratio_df_mat, 
        #                 scale = input$motifscale, 
        #                 clustering_distance_cols = input$motifdistance,
        #                 clustering_method = input$motifclusmethod,
        #                 fontsize = 10,
        #                 fontsize_row = 10, 
        #                 show_rownames = T, 
        #                 cluster_rows = T,
        #                 fontsize_col = 12, 
        #                 show_colnames = T,
        #                 cluster_cols = F,
        #                 cellwidth = 15, cellheight = 15,
        #                 main = input$motifmain)
        #   } else if(nrow(motif_group_m_ratio_df_mat) < 25) {
        #     ph = pheatmap(motif_group_m_ratio_df_mat, 
        #                   scale = input$motifscale, 
        #                   clustering_distance_cols = input$motifdistance,
        #                   clustering_method = input$motifclusmethod,
        #                   fontsize = 8,
        #                   fontsize_row = 8, 
        #                   show_rownames = T, 
        #                   cluster_rows = T,
        #                   fontsize_col = 10, 
        #                   show_colnames = T,
        #                   cluster_cols = F,
        #                   cellwidth = 12, cellheight = 12,
        #                   main = input$motifmain)
        #   } else {
        #     ph = pheatmap(motif_group_m_ratio_df_mat, 
        #                   scale = input$motifscale, 
        #                   clustering_distance_cols = input$motifdistance,
        #                   clustering_method = input$motifclusmethod,
        #                   fontsize = 6,
        #                   fontsize_row = 6, 
        #                   show_rownames = T, 
        #                   cluster_rows = T,
        #                   fontsize_col = 8, 
        #                   show_colnames = T,
        #                   cluster_cols = F,
        #                   cellwidth = 8, cellheight = 8,
        #                   main = input$motifmain)
        #   }
        #   dev.off()
        #   showModal(modalDialog(
        #     title = "Heatmap",
        #     size = "l",
        #     plotOutput("motifenrich2"),
        #     div(downloadButton("motifphdl"), style = "display:flex; justify-content:center; align-item:center;"),
        #     
        #   ))
        #   output$motifenrich2 <- renderPlot(ph)
        #   output$motifphdl <- downloadHandler(
        #     filename=function(){paste("motif_heatmap_result", userID,".pdf",sep="")},
        #     content = function(file){
        #       ggsave(ph, filename = file,width = 9,height = 9)
        #   })
        # } 
      } else {
        sendSweetAlert(
          session = session,
          title = "Tip",
          text = "No motif meets the criteria, please reduce the 'matched seqs threshold' parameter.",
          type = "info"
        )
      }
    }
  )
  
  output$motiflogodl <- downloadHandler(
    filename=function(){paste("motif_logo_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/motif/logo.pdf',sep=''),file)
    })
  
  #######################################
  #######        Tutorial         #######
  #######################################
  # output$dockermanual <- renderUI({
  #   readme <- readLines("README.md")
  #   md_start <- grep("^### 1\\. Docker-based installation", readme)
  #   md_end <- grep("^### 2\\. R-based installation", readme)
  #   md_section <- paste(readme[(md_start + 1) : (md_end - 1)], collapse = "\n")
  #   markdown(md_section)
  # })
  
  #######################################
  #######    FAQ and Download     #######
  #######################################
  output$designtemplate <- downloadHandler(
    filename = "design_file_template.txt",
    content = function(file) {file.copy("examplefile/analysistools/phosphorylation_exp_design_info.txt", file)}
  )
  output$clinicaltemplate <- downloadHandler(
    filename = "clinical_file_template.csv",
    content = function(file) {file.copy("examplefile/analysistools/Clinical_for_Demo.csv", file)}
  )

  output$dlphosdesign <- downloadHandler(
    filename = "experimental_design.txt",
    content = function(file) {file.copy("examplefile/maxquant/phosphorylation_exp_design_info.txt", file)}
  )
  output$dlprodesign <- downloadHandler(
    filename = "proteomics_design.txt",
    content = function(file) {file.copy("examplefile/maxquant/profiling_exp_design_info.txt", file)}
  )

  output$maxexampledl1 <- downloadHandler(
    filename = "Phospho (STY)Sites.txt",
    content = function(file) {file.copy("examplefile/maxquant/Phospho (STY)Sites.txt", file)}
  )
  output$maxexampledl2 <- downloadHandler(
    filename = "proteinGroups.txt",
    content = function(file) {file.copy("examplefile/maxquant/proteinGroups.txt", file)}
  )

  output$masexampledl1 <- downloadHandler(
    filename = "mascot_xml.zip",
    content = function(file) {file.copy("examplefile/download/mascot_xml.zip", file)}
  )
  output$masexampledl2 <- downloadHandler(
    filename = "phosphorylation_peptide_txt.zip",
    content = function(file) {file.copy("examplefile/download/phosphorylation_peptide_txt.zip", file)}
  )
  output$masexampledl3 <- downloadHandler(
    filename = "profiling_gene_txt.zip",
    content = function(file) {file.copy("examplefile/download/profiling_gene_txt.zip", file)}
  )

  output$dlanalysisexample <- downloadHandler(
    filename = "anaysis_demo.zip",
    content = function(file) {file.copy("examplefile/download/anaysis_demo.zip", file)}
  )
  # output$dlanalysisexamplefirmiana <- downloadHandler(
  #   filename = "firmiana_mascot_39sample.zip",
  #   content = function(file) {file.copy("mascot_39sample.zip", file)}
  # )
  output$dlmotifkinase <- downloadHandler(
    filename = "motif_kinase_relation.xlsx",
    content = function(file) {file.copy("examplefile/download/motif_kinase_relation.xlsx", file)}
  )
  
  ###download###
  #maxquant label-free
  output$demomaxresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreQc.csv"), file)})
  
  output$demomaxdropproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreQc.csv"), file)})
  
  output$usermaxnoproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"), file)})
  
  output$usermaxresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"),file)})
  
  output$usermaxdropproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"),file)})
  
  output$demomaxresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormImputeSummary_v.csv"), file)})
  
  output$demomaxdropproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormImputeSummary_v.csv"),file)})
  
  output$usermaxnoproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary_v.csv"),file)})
  
  output$usermaxresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary_v.csv"),file)})
  
  output$usermaxdropproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary_v.csv"),file)})
  
  output$demomaxresult3_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormBasedProSummary_v.csv"),file)})
  
  output$demomaxresult3pro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPrePro.csv"),file)})
  
  output$usermaxresult3_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormBasedProSummary_v.csv"),file)})
  
  output$usermaxresult3pro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PrePro.csv"),file)})
  
  # mascot
  output$viewedmerging_dl <- downloadHandler(filename = function(){paste("merge_df_with_phospho_peptides", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "merge_df_with_phospho_peptides.csv"),file)})
  
  output$viewedmergingdroppro_dl <- downloadHandler(filename = function(){paste("merge_df_with_phospho_peptides", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "merge_df_with_phospho_peptides.csv"),file)})
  
  output$viewedmerging1nopro_dl <- downloadHandler(filename = function(){paste("merge_df_with_phospho_peptides", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "merge_df_with_phospho_peptides.csv"),file)})
  
  output$viewedmerging1_dl <- downloadHandler(filename = function(){paste("merge_df_with_phospho_peptides", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "merge_df_with_phospho_peptides.csv"),file)})
  
  output$viewedmerging1droppro_dl <- downloadHandler(filename = function(){paste("merge_df_with_phospho_peptides", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "merge_df_with_phospho_peptides.csv"),file)})
  
  output$viewedmapping02_dl <- downloadHandler(filename = function(){paste("summary_df_of_unique_proteins_with_sites", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "summary_df_of_unique_proteins_with_sites.csv"),file)})
  
  output$viewedmapping02droppro_dl <- downloadHandler(filename = function(){paste("summary_df_of_unique_proteins_with_sites", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "summary_df_of_unique_proteins_with_sites.csv"),file)})
  
  output$viewedmapping12nopro_dl <- downloadHandler(filename = function(){paste("summary_df_of_unique_proteins_with_sites", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "summary_df_of_unique_proteins_with_sites.csv"),file)})
  
  output$viewedmapping12_dl <- downloadHandler(filename = function(){paste("summary_df_of_unique_proteins_with_sites", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "summary_df_of_unique_proteins_with_sites.csv"),file)})
  
  output$viewedmapping12droppro_dl <- downloadHandler(filename = function(){paste("summary_df_of_unique_proteins_with_sites", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "summary_df_of_unique_proteins_with_sites.csv"),file)})
  
  output$viewednorm01_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormImputeSummary_v.csv"),file)})
  
  output$viewednorm01droppro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormImputeSummary_v.csv"),file)})
  
  output$viewednorm14_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary_v.csv"),file)})
  
  output$viewednorm14nopro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary_v.csv"),file)})
  
  output$viewednorm14droppro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary_v.csv"),file)})
  
  output$viewednorm02_dl <- downloadHandler(filename = function(){paste("norm_based_pro", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormBasedProSummary_v.csv"),file)})
  
  output$viewednorm02pro_dl <- downloadHandler(filename = function(){paste("pro_normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPrePro.csv"),file)})
  
  output$viewednorm15_dl <- downloadHandler(filename = function(){paste("PreNormBasedProSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "PreNormBasedProSummary_v.csv"),file)})
  
  output$viewednorm15pro_dl <- downloadHandler(filename = function(){paste("PrePro", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "PrePro.csv"),file)})
  
  # maxquant tmt
  output$demomaxtmtresult1_dl <- downloadHandler(filename = function(){paste("DemoPreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxtmtdemopreloc, "DemoPreQc.csv"),file)})

  output$demomaxtmtresult2_dl <- downloadHandler(filename = function(){paste("DemoPreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxtmtdemopreloc, "DemoPreNormImputeSummary.csv"),file)})

  output$usermaxtmtresult1_dl <- downloadHandler(filename = function(){paste("PreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxtmtuserpreloc, "PreQc.csv"),file)})

  output$usermaxtmtresult2_dl <- downloadHandler(filename = function(){paste("PreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxtmtuserpreloc, "PreNormImputeSummary.csv"),file)})

  # diann dia
  output$demodiannresult1_dl <- downloadHandler(filename = function(){paste("DemoPreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(dianndemopreloc, "DemoPreQc.csv"),file)})

  output$demodiannresult2_dl <- downloadHandler(filename = function(){paste("DemoPreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(dianndemopreloc, "DemoPreNormImputeSummary.csv"),file)})

  output$userdiannresult1_dl <- downloadHandler(filename = function(){paste("PreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(diannuserpreloc, "PreQc.csv"),file)})

  output$userdiannresult2_dl <- downloadHandler(filename = function(){paste("PreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(diannuserpreloc, "PreNormImputeSummary.csv"),file)})

  # sn dia
  output$demosnresult1_dl <- downloadHandler(filename = function(){paste("DemoPreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(sndemopreloc, "DemoPreQc.csv"),file)})

  output$demosnresult2_dl <- downloadHandler(filename = function(){paste("DemoPreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(sndemopreloc, "DemoPreNormImputeSummary.csv"),file)})

  output$usersnresult1_dl <- downloadHandler(filename = function(){paste("PreQc", userID,".csv",sep="")},content = function(file){file.copy(paste0(snuserpreloc, "PreQc.csv"),file)})

  output$usersnresult2_dl <- downloadHandler(filename = function(){paste("PreNormImputeSummary", userID,".csv",sep="")},content = function(file){file.copy(paste0(snuserpreloc, "PreNormImputeSummary.csv"),file)})


})