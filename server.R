#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#source functions
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
  dir.create(pcaloc, recursive = TRUE)
  dir.create(tsneloc, recursive = TRUE)
  dir.create(limmaloc, recursive = TRUE)
  dir.create(samloc, recursive = TRUE)
  dir.create(tcloc, recursive = TRUE)
  dir.create(kaploc, recursive = TRUE)
  dir.create(survloc, recursive = TRUE)
  dir.create(motifloc, recursive = TRUE)
  
  ###download###
  #maxquant
  output$demomaxresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreQc.csv"), file)})
  
  output$demomaxdropproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreQc.csv"), file)})
  
  output$usermaxnoproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"), file)})
  
  output$usermaxresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"),file)})
  
  output$usermaxdropproresult1_dl <- downloadHandler(filename = function(){paste("quality_control_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreQc.csv"),file)})
  
  output$demomaxresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"), file)})
  
  output$demomaxdropproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"),file)})
  
  output$usermaxnoproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary.csv"),file)})
  
  output$usermaxresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary.csv"),file)})
  
  output$usermaxdropproresult2_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormImputeSummary.csv"),file)})
  
  output$demomaxresult3_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPreNormBasedProSummary.csv"),file)})
  
  output$demomaxresult3pro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxdemopreloc, "DemoPrePro.csv"),file)})
  
  output$usermaxresult3_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(maxuserpreloc, "PreNormBasedProSummary.csv"),file)})
  
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
  
  output$viewednorm01_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormImputeSummary.csv"),file)})
  
  output$viewednorm01droppro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormImputeSummary.csv"),file)})
  
  output$viewednorm14_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary.csv"),file)})
  
  output$viewednorm14nopro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary.csv"),file)})
  
  output$viewednorm14droppro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary.csv"),file)})
  
  output$viewednorm02_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPreNormImputeSummary.csv"),file)})
  
  output$viewednorm02pro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotdemopreloc, "DemoPrePro.csv"),file)})
  
  output$viewednorm15_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "NormImputeSummary.csv"),file)})
  
  output$viewednorm15pro_dl <- downloadHandler(filename = function(){paste("normalization_result", userID,".csv",sep="")},content = function(file){file.copy(paste0(mascotuserpreloc, "PrePro.csv"),file)})
  
  
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
        print("maxquant norm")
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
        df <- df1 <- newdata4
        method <- input$maxphosimputemethod
        if(method=="none"){
          df[is.na(df)]<-0
        }else if(method=="minimum"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)
        }else if(method=="minimum/10"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)/10
        }
        
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
        
        output$demomaxresult2 <- renderDataTable(summarydf)
        output$demomaxdropproresult2 <- renderDataTable(summarydf)
        write.csv(summarydf, paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv"))
        updateTabsetPanel(session, "demomaxresultnav", selected = "demomaxstep2val")
        updateTabsetPanel(session, "demomaxdropproresultnav", selected = "demomaxdropprostep2val")
        updateActionButton(session, "demomaxnormbt", icon = icon("rotate-right"))
        updateActionButton(session, "demomaxnormprobt", icon = icon("play"))
        if(input$maxuseprocheck1 == 1) {
          updateProgressBar(session = session, id = "demomaxpreprobar", value = 66)
        } else {
          updateProgressBar(session = session, id = "demomaxpreprobar", value = 100)
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
        filenames <- read.csv('examplefile/maxquant/phosphorylation_exp_design_info.txt',header = T,sep='\t')
        
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
                                                                                          "examplefile/maxquant/phosphorylation_exp_design_info.txt", "examplefile/maxquant/phosphorylation_exp_design_info.txt",
                                                                                          control_label = controllabel,
                                                                                          pair_flag = FALSE)
        data_frame_normalization_with_control_no_pair_for_motifanalysis <- cbind(phospho_data_topX_for_motifanalysis[c(1,2,3)], data_frame_normalization_with_control_no_pair[-1])
        
        summarydf <- data.frame(data_frame_normalization_with_control_no_pair$ID, data_frame_normalization_with_control_no_pair_for_motifanalysis)
        colnames(summarydf) <- c("Position", colnames(data_frame_normalization_with_control_no_pair_for_motifanalysis))
        rownames(summarydf) <- rownames(data_frame_normalization_with_control_no_pair)
        
        output$demomaxresult3 <- renderDataTable(summarydf)
        output$demomaxresult3pro <- renderDataTable(df2)
        
        write.csv(summarydf, paste0(maxdemopreloc, "DemoPreNormBasedProSummary.csv"), row.names = T)
        write.csv(df2, paste0(maxdemopreloc, "DemoPrePro.csv"), row.names = F)
        updateTabsetPanel(session, "demomaxresultnav", selected = "demomaxstep3val")
        updateActionButton(session, "demomaxnormprobt", icon = icon("rotate-right"))
        updateProgressBar(session = session, id = "demomaxpreprobar", value = 100)
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
  

  #mascot
  phosphorylation_exp_design_info_file_path <- 'examplefile/mascot/phosphorylation_exp_design_info.txt'
  mascot_xml_dir <- 'examplefile/mascot/mascot_xml'
  phosphorylation_peptide_dir <- 'examplefile/mascot/phosphorylation_peptide_txt'

  observeEvent(
    input$parserbt01,{
      mascot_txt_dir <- paste0(mascotdemopreloc, "demomascottxt_data")
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
      
      phospho_data_filtering_STY_and_normalization_list <- get_normalized_data_of_psites2(
        summary_df_of_unique_proteins_with_sites,
        phosphorylation_exp_design_info_file_path,
        input$masphosNAthre,
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
      
      output$viewednorm01 <- renderDataTable(summarydf)
      output$viewednorm01droppro <- renderDataTable(summarydf)
      
      write.csv(summarydf, paste0(mascotdemopreloc, 'DemoPreNormImputeSummary.csv'), row.names = T)
      
      updateTabsetPanel(session, "resultnav", selected = "demomascotstep4val")
      updateTabsetPanel(session, "resultnavdroppro", selected = "demomascotdropprostep4val")
      
      updateActionButton(session, "normalizationbt01", icon = icon("rotate-right"))
      updateActionButton(session, "normalizationbt02", icon = icon("play"))
      if(input$useprocheck1 == 1) {
        updateProgressBar(session = session, id = "preprobar", value = 80)
      } else {
        updateProgressBar(session = session, id = "preprobar", value = 100)
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
      experiment_code <- utils::read.table(profiling_exp_design_info_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
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
      
      output$viewednorm02 <- renderDataTable(summarydf)
      
      output$viewednorm02pro <- renderDataTable(profiling_data)
      
      write.csv(summarydf, paste0(mascotdemopreloc, "DemoPreNormBasedProSummary.csv"), row.names = T)
      write.csv(profiling_data, paste0(mascotdemopreloc, "DemoPrePro.csv"), row.names = F)
      
      updateTabsetPanel(session, "resultnav", selected = "demomascotstep5val")
      updateActionButton(session, "normalizationbt02", icon = icon("rotate-right"))
      updateProgressBar(session = session, id = "preprobar", value = 100)
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
              2,
              min = 0,
              max = 5,
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
        print("maxquant norm")
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
        df <- df1 <- newdata4
        method <- input$maxphosimputemethod
        if(method=="0"){
          df[is.na(df)]<-0
        }else if(method=="minimum"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)
        }else if(method=="minimum/10"){
          df[is.na(df)]<-min(df1,na.rm = TRUE)/10
        }
        
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
        
        output$usermaxresult2 <- renderDataTable(summarydf)
        output$usermaxnoproresult2 <- renderDataTable(summarydf)
        output$usermaxdropproresult2 <- renderDataTable(summarydf)
        
        write.csv(summarydf, paste0(maxuserpreloc, "PreNormImputeSummary.csv"))

        updateTabsetPanel(session, "usermaxresultnav", selected = "usermaxstep2val")
        updateTabsetPanel(session, "usermaxnoproresultnav", selected = "usermaxnoprostep2val")
        updateTabsetPanel(session, "usermaxdropproresultnav", selected = "usermaxdropprostep2val")
        updateActionButton(session, "usermaxnormbt", icon = icon("rotate-right"))
        updateActionButton(session, "usermaxnormprobt", icon = icon("play"))
        
        if(is.null(input$maxuseruseprocheck)) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
        } else if(input$maxuseruseprocheck == 1) {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 66)
        } else {
          updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
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
        
        output$usermaxresult3 <- renderDataTable(summarydf)
        output$usermaxresult3pro <- renderDataTable(df2)
        
        write.csv(summarydf, paste0(maxuserpreloc, "PreNormBasedProSummary.csv"), row.names = T)
        write.csv(df2, paste0(maxuserpreloc, "PrePro.csv"), row.names = F)
        updateTabsetPanel(session, "usermaxresultnav", selected = "usermaxstep3val")
        updateActionButton(session, "usermaxnormprobt", icon = icon("rotate-right"))
        updateProgressBar(session = session, id = "usermaxpreprobar", value = 100)
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
      
      output$viewednorm14 <- renderDataTable(summarydf)
      output$viewednorm14nopro <- renderDataTable(summarydf)
      output$viewednorm14droppro <- renderDataTable(summarydf)
      
      write.csv(summarydf, paste0(mascotuserpreloc, 'NormImputeSummary.csv'), row.names = T)
      
      updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep4val")
      updateTabsetPanel(session, "usermascotnoproresultnav", selected = "usermascotnoprostep4val")
      updateTabsetPanel(session, "usermascotdropproresultnav", selected = "usermascotdropprostep4val")
      
      updateActionButton(session, "normalizationbt11", icon = icon("rotate-right"))
      updateActionButton(session, "normalizationbt12", icon = icon("play"))
      
      if(is.null(input$useruseprocheck1)) {
        updateProgressBar(session = session, id = "userpreprobar", value = 100)
      } else if(input$useruseprocheck1 == 1) {
        updateProgressBar(session = session, id = "userpreprobar", value = 80)
      } else {
        updateProgressBar(session = session, id = "userpreprobar", value = 100)
      }
    }
  })
  
  # If the user uploads the proteome data, show the option
  proaval <- reactive(is.null(input$upprodesign) | is.null(input$upprogene))
  
  grouplabel <- reactive({
    phosphorylation_experiment_design_file = read.table(input$updesign$datapath, 
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
              bsTooltip(
                "usermasuscutoff", 
                "xxxxx",
                placement = "right", 
                options = list(container = "body")
              ),
              numericInput("usermasproNAthre", label = "minimum detection frequency: ", value = 3),
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
      experiment_code <- utils::read.table(profiling_exp_design_info_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
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
      
      output$viewednorm15 <- renderDataTable(summarydf)
      output$viewednorm15pro <- renderDataTable(profiling_data)
      
      write.csv(summarydf, paste0(mascotuserpreloc, "PreNormBasedProSummary.csv"), row.names = T)
      write.csv(profiling_data, paste0(mascotuserpreloc, "PrePro.csv"), row.names = F)
      updateTabsetPanel(session, "usermascotresultnav", selected = "usermascotstep5val")
      
      updateActionButton(session, "normalizationbt12", icon = icon("rotate-right"))
      updateProgressBar(session = session, id = "userpreprobar", value = 100)
    }
  })
  
  
  #######################################
  #######     analysis tools      #######
  #######################################
  # analysis data upload
  analysisouts <- reactive({
    output$testout <- renderText(c)
    if(input$analysisdatatype==3){
      message <- "The example data is loaded"
      designfile = "examplefile/analysistools/phosphorylation_exp_design_info.txt"
      profilingfile = "examplefile/analysistools/data_frame_normalization_with_control_no_pair.csv"
      motiffile = "examplefile/analysistools/motifanalysis.csv"
      clinicalfile = "examplefile/analysistools/Clinical_for_Demo.csv"
      # 需要修改！！！为正确的39组实验
      summarydf = "examplefile/analysistools/data_frame_normalization_with_control_no_pair.csv"
      target1 <- read.csv(designfile, sep = "\t")
      target2 <- read.csv(profilingfile, row.name=1)
      target3 <- read.csv(motiffile)
      target4 <- read.csv(clinicalfile)
      target5 <- read.csv(summarydf, row.name=1)
  
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
          output$viewedfileanalysis <- renderDataTable(target5)
        }
      )
      observeEvent(
        input$viewanalysisexamclin,{
          output$viewedfileanalysisui <- renderUI(h4("3. Clinical data file:"))
          output$viewedfileanalysis <- renderDataTable(target4)
        }
      )
    }else if(input$analysisdatatype==2 & input$loaddatatype==1 & input$softwaretype==2){ # pipe、案例数据、mascot
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
          message <- 'PhosMap detects pipeline data comes from [example data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [example data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose "load your data"'
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
            output$viewedfileanalysis <- renderDataTable(target5)
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
        target5 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
        
      }
    }
    else if(input$analysisdatatype==2 & input$loaddatatype==0 & input$softwaretype==2){ # # pipe、user、mascot
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
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else if(input$useruseprocheck1==0) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [your data]-[Firmiana/mascot]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose "load your data"'
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
            output$viewedfileanalysis <- renderDataTable(target5)
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
        target5 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==2 & input$loaddatatype==1 & input$softwaretype==1){# pipe、example、maxquant
      if(input$maxuseprocheck1==1) {
        file1 = paste0(maxdemopreloc, "DemoPreNormBasedProSummary.csv")
      } else {
        file1 = paste0(maxdemopreloc, "DemoPreNormImputeSummary.csv")
      }
      designfile = "examplefile/maxquant/phosphorylation_exp_design_info.txt"
      clinicalfile = "examplefile/analysistools/Clinical_for_Pre.csv"
      if(file.exists(file1)){
        if(input$maxuseprocheck1==1) {
          message <- 'PhosMap detects pipeline data comes from [example data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [example data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose "load your data"'
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
            output$viewedfileanalysis <- renderDataTable(target5)
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
        target5 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==2 & input$loaddatatype==0 & input$softwaretype==1){# pipe、user、maxquant
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
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else if(input$maxuseruseprocheck==0) {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]. Please make sure this is correct. Otherwise, choose "load your data"'
        } else {
          message <- 'PhosMap detects pipeline data comes from [your data]-[MaxQuant]-[Normalizing phosphoproteomics data based on proteomics data]. Please make sure this is correct. Otherwise, choose "load your data"'
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
            output$viewedfileanalysis <- renderDataTable(target5)
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
        target5 <- NULL
        output$viewedfileanalysis <- renderDataTable(NULL)
        output$viewedfileanalysisui <- renderUI(NULL)
      }
    }else if(input$analysisdatatype==1){
      message <- "Data Overview"
      target1 <- NULL
      target2 <- NULL
      target3 <- NULL
      target4 <- NULL
      target5 <- NULL
      output$viewedfileanalysisuiuser <- renderUI(NULL)
    }
    files <- list(message, target1, target2, target3, target4)
    files
  })
  
  output$htmlanalysis <- renderUI({
    wellPanel(analysisouts()[1], class = "warning")
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
      dataread <- read.csv(files$datapath, header=T, sep=",", row.names = 1)
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
      target2 <- summarydf[, c(-2, -3, -4)]
      colnames(target2)[1] <- "ID"
      target3 <- summarydf[, -1]
      
      dflist <- list(designfile_analysis(), target2, target3, clinicalfile_analysis())
      dflist
    }else{
      dflist <- list(analysisouts()[[2]], analysisouts()[[3]], analysisouts()[[4]], analysisouts()[[5]])
      dflist
    }
  })

  output$test222 <- renderDataTable({
    fileset()[[3]]
  })
  
  pca <- reactive({
    validate(
      need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
      need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
    )
    phosphorylation_experiment_design_file <- fileset()[[1]]
    data_frame_normalization_with_control_no_pair <- fileset()[[2]]
    phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
    phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
    # group information
    group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
    group_levels = paste('t', phosphorylation_groups_labels, sep = '')
    group = factor(group, levels = group_levels)
    # PCA
    expr_data_frame = data_frame_normalization_with_control_no_pair
    
    requireNamespace('stats')
    requireNamespace('graphics')
    expr_ID <- as.vector(expr_data_frame[,1])
    expr_Valule <- log2(expr_data_frame[,-1]) # have to log
    testDat <- t(expr_Valule) # row -> sample, col -> variable
    pca <- stats::prcomp(((testDat)), center = TRUE, scale = TRUE)
    list(pca, group)
  })
  
  pca_plot1 <- eventReactive(
    input$drbt,{
      PCA <- pca()[[1]]
      stats::screeplot(PCA, type="lines")
      pdf(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''))
      stats::screeplot(PCA, type="lines")
      dev.off()
      stats::screeplot(PCA, type="lines")
    })
  
  pca_plot2 <- eventReactive(
    input$drbt, {
      pca <- pca()[[1]]
      group <- pca()[[2]]
      importance <- summary(pca)$importance
      PC1 <- importance[2,1]
      PC2 <- importance[2,2]
      PC1 <- round(PC1, 4)*100
      PC2 <- round(PC2, 4)*100
      
      pca_predict <- stats::predict(pca)
      pca_predict_2d <- pca_predict[,c(1,2)]
      colors <- grDevices::rainbow(length(unique(group)))
      xlim <- c(floor(min(pca_predict_2d[,1]))-5, ceiling(max(pca_predict_2d[,1]))+5)
      ylim <- c(floor(min(pca_predict_2d[,2]))-5, ceiling(max(pca_predict_2d[,2]))+5)
      xlab <- paste("PC1 (", PC1, "%)", sep = "")
      ylab <- paste("PC2 (", PC2, "%)", sep = "")
      graphics::plot(pca_predict_2d, col=rep(colors,table(group)), pch=16, xlim = xlim, ylim = ylim, lwd = 2, xlab = xlab, ylab = ylab, main = input$pcamain)
      legend("topright",title = "Group",inset = 0.01,
             legend = unique(group),pch=16,
             col = colors,bg='white')
      
      pdf(paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep=''))
      graphics::plot(pca_predict_2d, col=rep(colors,table(group)), pch=16, xlim = xlim, ylim = ylim, lwd = 2, xlab = xlab, ylab = ylab, main = input$pcamain)
      legend("topright",title = "Group",inset = 0.01,
             legend = unique(group),pch=16,
             col = colors,bg='white')
      dev.off()
      
      pdf_combine(c(paste('tmp/',userID,'/analysis/pca/pca1.pdf',sep=''),paste('tmp/',userID,'/analysis/pca/pca2.pdf',sep='')),
                  output = paste('tmp/',userID,'/analysis/pca/joinedpca.pdf',sep=''))
    }
  )
  output$pca1 <- renderPlot(pca_plot1())
  output$pca2 <- renderPlot(pca_plot2())

  output$pcaplotdl <- downloadHandler(
    filename = function(){paste("pca_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/pca/joinedpca.pdf',sep=''),file)
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
      expr_data_frame = data_frame_normalization_with_control_no_pair
      phosphorylation_groups_labels = names(table(phosphorylation_experiment_design_file$Group))
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      group_levels = paste('t', phosphorylation_groups_labels, sep = '')
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
      
      graphics::plot(tsne$Y, col=rep(colors,table(group)), pch=16, lwd = 2, xlab = 'Dim 1', ylab = 'Dim 2', main = input$tsnemain)
      legend("topright",title = "Group",inset = 0.01,
             legend = unique(group),pch=16,
             col = colors,bg='white')
      
      pdf(paste('tmp/',userID,'/analysis/tsne/tsne.pdf',sep=''))
      graphics::plot(tsne$Y, col=rep(colors,table(group)), pch=16, lwd = 2, xlab = 'Dim 1', ylab = 'Dim 2', main = input$tsnemain)
      legend("topright",title = "Group",inset = 0.01,
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
    plot(expr_data_umap,col=rep(color_group_unique,table(expr_data_group)),pch=16,asp=1,xlab = "UMAP_1",ylab = "UMAP_2",main = main)
    abline(h=0,v=0,lty=2,col="gray")
    legend("topright",title = "Group",inset = 0.01,
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
      plot(expr_data_umap,col=rep(color_group_unique,table(expr_data_group)),pch=16,asp=1,xlab = "UMAP_1",ylab = "UMAP_2",main = main)
      abline(h=0,v=0,lty=2,col="gray")
      legend("topright",title = "Group",inset = 0.01,
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
  
  limma <- eventReactive(input$limmabt,
                         {
                           validate(
                             need(fileset()[[1]], 'Please check that the experimental design file is uploaded !'),
                             need(fileset()[[2]], 'Please check that the expression dataframe file is uploaded !')
                           )
                           
                           phosphorylation_experiment_design_file <- fileset()[[1]]
                           data_frame_normalization_with_control_no_pair <- fileset()[[2]]
                           expr_data_frame = data_frame_normalization_with_control_no_pair[,c(1,which(phosphorylation_experiment_design_file$Group==input$limmagroup1)+1,which(phosphorylation_experiment_design_file$Group==input$limmagroup2)+1)]
                           phosphorylation_experiment_design_file = phosphorylation_experiment_design_file[c(which(phosphorylation_experiment_design_file$Group==as.numeric(input$limmagroup1)),which(phosphorylation_experiment_design_file$Group==as.numeric(input$limmagroup2))),]
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
                           limmaph_df = data.frame(limma_results_df[index_of_match_pv,]$logFC, expr_data_frame[index_of_match,])
                           colnames(limmaph_df)[1] <- "logFC"
                           output$limmaresultforph <- renderDataTable(limmaph_df)
                           output$limmaresultdl2 <- downloadHandler(
                             filename = function(){paste("limma_result_forph", userID,".csv",sep="")},
                             content = function(file){
                               write.csv(limmaph_df,file,row.names = FALSE)
                             }
                           )
                           
                           group_test <- data.frame(as.character(phosphorylation_experiment_design_file[,2]), row.names = phosphorylation_experiment_design_file[,1])
                           colnames(group_test) <- "Group"
                           test_change <- ifelse(limmaph_df$logFC < 0, 'DOWN','UP')
                           rowname_test <- data.frame(test_change, row.names = limmaph_df$ID)
                           colnames(rowname_test) <- 'Change'
                           
                           test_data_plot <- data.frame(limmaph_df[,-c(1,2)])
                           rownames(test_data_plot) <- limmaph_df$ID
                           list(test_data_plot, group_test, rowname_test, limma_results_df)
                           
                           
                         })
  
  observeEvent(
    input$limmaphbt, {
      if(nrow(limma()[[1]] > 0)) {
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
      }
      output$limmaph <- renderPlot(ph)
    }
  )
  
  observeEvent(
    input$limmabt, {
      limma_results_df <- limma()[[4]]
      limma_results_df$change <- as.factor(ifelse(limma_results_df$pvalue < input$limmapvalue & abs(limma_results_df$logFC) > log2(input$limmafc),ifelse(limma_results_df$logFC > log2(input$limmafc),'UP','DOWN'),'NOT'))
      
      specifiedpoints <- input$limmalabelspec
      specifiedpoints <- strsplit(specifiedpoints, "\n")[[1]]
      limma_results_df$sign <- ifelse((limma_results_df$pvalue < input$limmalabelpvalue & abs(limma_results_df$logFC) > log2(input$limmalabelfc)) | limma_results_df$ID == specifiedpoints,limma_results_df$ID,NA)
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
    expr_data_frame = data_frame_normalization_with_control_no_pair[,c(1,which(phosphorylation_experiment_design_file$Group==input$samgroup1)+1,which(phosphorylation_experiment_design_file$Group==input$samgroup2)+1)]
    phosphorylation_experiment_design_file = phosphorylation_experiment_design_file[c(which(phosphorylation_experiment_design_file$Group==as.numeric(input$samgroup1)),which(phosphorylation_experiment_design_file$Group==as.numeric(input$samgroup2))),]
    
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
      output$samph <- renderPlot(ph)
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
    list(expr_data_frame_plot,group_test,df)
  })
  observeEvent(input$anovabt, {output$anovaresult <- renderDataTable(anova()[[3]])})
  observeEvent(
    input$anovaphbt, {
      if(nrow(anova()[[1]] > 0)) {
        ph <- pheatmap(anova()[[1]],
                     scale = input$anovaphscale,
                     cluster_rows = input$anovaphcluster,
                     cluster_cols = FALSE,
                     annotation_col = anova()[[2]],
                     show_rownames = input$anovaphrowname,
                     clustering_distance_rows = input$anovaphdistance,
                     clustering_method = input$anovaphclusmethod
                     )
        dev.off()
      } 
      output$anovaph <- renderPlot(ph)
      output$anovaphdlbt <- downloadHandler(
        filename = function(){paste("anovaph_result", userID,".pdf",sep="")},
        content = function(file){
          p <- as.ggplot(ph)
          ggsave(filename = file,plot = p,width = 9,height = 5)
        }
      )
    }
  )
  
  output$anovastatic <- renderPlot({
    anova_plot()
  })
  
  output$anovainter <- renderPlotly({
    anova_plot()
  })
  
  observeEvent(
    input$limmaphbt, {
      showModal(modalDialog(
        title = "Heatmap",
        size = "l",
        plotOutput("limmaph"),
        uiOutput('limmaphdl')
      ))
    }
  )
  output$limmaphdl <- renderUI({div(downloadButton("limmaphdlbt"), style = "display:flex; justify-content:center; align-item:center;")})
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
        dataTableOutput("limmaresultforph"),
        downloadButton("limmaresultdl2"),
        easyClose = T,
        footer = modalButton("OK")
      ))
    }
  )
  
  observeEvent(
    input$samphbt, {
      if(nrow(sam()[[3]]) > 0) {
        showModal(modalDialog(
          title = "Heatmap",
          size = "l",
          plotOutput("samph"),
          uiOutput('samphdl')
        ))
      }
    }
  )
  
  output$samphdl <- renderUI({div(downloadButton("samphdlbt"), style = "display:flex; justify-content:center; align-item:center;")})
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
  
  observeEvent(
    input$anovaphbt, {
      showModal(modalDialog(
        title = "Heatmap",
        size = "l",
        plotOutput("anovaph"),
        uiOutput('anovaphdl')
      ))
    }
  )
  output$anovaphdl <- renderUI({div(downloadButton("anovaphdlbt"), style = "display:flex; justify-content:center; align-item:center;")})
  
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
    group = paste('t', fileset()[[1]]$Group, sep = '')
    phosphorylation_groups_labels = names(table(fileset()[[1]]$Group))
    group_levels = paste('t', phosphorylation_groups_labels, sep = '')
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
    
    length(breaks)
    length(which(!duplicated(color)))
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
        filename = function(){paste("pca_result", userID,".pdf",sep="")},
        content = function(file){
          p <- as.ggplot(ph)
          ggsave(filename = file, p,width = 12,height = 12)
        }
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
      data_frame_normalization_with_control_no_pair <- fileset()[[2]]
      
      expr_data_frame = data_frame_normalization_with_control_no_pair[,c(1,which(phosphorylation_experiment_design_file$Group==input$kseagroup1)+1,which(phosphorylation_experiment_design_file$Group==input$kseagroup2)+1)]
      expr_data_frame1 = data_frame_normalization_with_control_no_pair[,which(phosphorylation_experiment_design_file$Group==input$kseagroup1)+1]
      expr_data_frame2 = data_frame_normalization_with_control_no_pair[,which(phosphorylation_experiment_design_file$Group==input$kseagroup2)+1]
      
      phosphorylation_experiment_design_file = phosphorylation_experiment_design_file[c(which(phosphorylation_experiment_design_file$Group==as.numeric(input$kseagroup1)),which(phosphorylation_experiment_design_file$Group==as.numeric(input$kseagroup2))),]
      
      phosphorylation_groups_labels = unique(phosphorylation_experiment_design_file$Group)
      phosphorylation_groups = factor(phosphorylation_experiment_design_file$Group, levels = phosphorylation_groups_labels)
      # group information
      group = paste('t', phosphorylation_experiment_design_file$Group, sep = '')
      group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group = factor(group, levels = group_levels)
      
      dfmean1 <- apply(expr_data_frame1, 1, mean)
      dfmean2 <- apply(expr_data_frame2, 1, mean)
      FC <- dfmean2/dfmean1
      kseafc <- isolate(input$kseafc)
      result <- expr_data_frame[(FC >= kseafc)|(FC <= 1/kseafc),]
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
    summary_df_list_from_ksea_cluster = get_summary_from_ksea2(ksea1()[[1]], species = input$kseaspecies, log2_label = FALSE, ratio_cutoff = 3) # species参数
    
    ksea_regulons_activity_df_cluster = summary_df_list_from_ksea_cluster$ksea_regulons_activity_df
    ksea_id_cluster = as.vector(ksea_regulons_activity_df_cluster[,1])
    ksea_value_cluster = ksea_regulons_activity_df_cluster[,-1]
    
    annotation_col = data.frame(
      group =  ksea1()[[2]]
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
    
    length(breaks)
    length(which(!duplicated(color)))
    list(ksea_value_cluster,annotation_col,breaks,color)
  })
  
  observeEvent(
    input$kseaanalysisbt2, {
      if(nrow(ksea_value_cluster) > 0) {
        ksea_value_cluster <- ksea2()[[1]]
      annotation_col <- ksea2()[[2]]
      breaks <- ksea2()[[3]]
      color <- ksea2()[[4]]
      
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
                      cellwidth = 12, cellheight = 12,
                      breaks = breaks,
                      color = color,
                      fontsize_col = 10,
                      fontsize_row = 10,
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
      output$kseastep2df <- renderDataTable(ksea_value_cluster)
      updateTabsetPanel(session, "kapresultnav", selected = "kapstep2val")
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
          selectInput("survivalsig", h5("Select a feature:"), choices = surplots()[[2]])
        )
      })
    }
  )
  
  observeEvent(
    input$survivalplotbt1, {
      if(length(surplots()[[2]] > 0)) {
        fit_km <- surplots()[[3]]
      feature <- isolate(input$survivalsig)
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
      if(input$analysisdatatype == 3 | (input$analysisdatatype == 2 & input$loaddatatype == TRUE)) {
        ask_confirmation(
          inputId = "myconfirmation",
          title = "This step will take several hours. To quickly present the case data, we used smaller background data and foreground data. Do you confirm run?"
        )
      } else {
        ask_confirmation(
          inputId = "myconfirmation",
          title = "This step will take several hours. Do you confirm run? "
        )
      }
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
        background_df = utils::read.table((paste0(motif_library_dir, fasta_type, "/", species, "/STY_background_of_", fasta_type, "_",  species, "_for_motif_enrichment.txt")), sep = '\t', header = TRUE)
        
        # construct foreground and background
        foreground = as.vector(foreground_df$aligned_seq)
        background = as.vector(background_df$Aligned_Seq)
        if(input$analysisdatatype == 3 | (input$analysisdatatype == 2 & input$loaddatatype == TRUE)) {
          foreground <- foreground[sample(length(foreground), 1000)]
          background <- background[sample(length(background), 10000)]
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
          column(12, numericInput("motifenrichrankin", h5("selected row number for plotting motif logo:"), 2, max = length(motifres1()[[2]]), min = 1, step = 1)),
        )
      })
      output$motifdfresult <- renderDataTable(datatable(rbind(motifres1()[[1]][["S"]], motifres1()[[1]][["T"]], motifres1()[[1]][["Y"]]), options = list(pageLength = 25)))
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
      result <- result[,c(1,2,3,4,6)]
      
      showModal(modalDialog(
        title = "Matched sites",
        size = "l",
        h4(paste0("Motif: "), names(motifres1()[[2]])[[id]]),
        dataTableOutput("motifsites"),
        div(downloadButton("motifsitesdl"), style = "display:flex; justify-content:center; align-item:center;"),
        
      ))
      output$motifsites <- renderDataTable(result)
      
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
      foreground_value = fileset()[[3]][,-c(seq(1,6))]
      min_seqs = input$minseqs
      index_of_motifs = which(peptides_count>=min_seqs)
      motif_group_m_ratio_df = NULL
      
      group = paste('t', fileset()[[1]]$Group, sep = '')
      phosphorylation_groups_labels = names(table(fileset()[[1]]$Group))
      group_levels = paste('t', phosphorylation_groups_labels, sep = '')
      group = factor(group, levels = group_levels)
      
      for(i in index_of_motifs){
        motif = motifs[i]
        aligned_peptides = motifres1()[[2]][[i]]
        index_of_match = match(aligned_peptides, motifres1()[[4]]$aligned_seq)
        motif_value = foreground_value[index_of_match,]
        motif_value_colsum = colSums(motif_value)
        motif_group_m = tapply(motif_value_colsum, group, mean) #group为118行的group时，下面程序跑不通
        motif_group_m_ratio = motif_group_m/motif_group_m[1]
        motif_group_m_ratio_df = rbind(motif_group_m_ratio_df, motif_group_m_ratio)
      }
      rownames(motif_group_m_ratio_df) = motifs[index_of_motifs]
      motif_group_m_ratio_df_mat = as.matrix(motif_group_m_ratio_df)
      
      if(nrow(motif_group_m_ratio_df_mat) < 15){
        ph = pheatmap(motif_group_m_ratio_df_mat, 
                      scale = input$motifscale, 
                      clustering_distance_cols = input$motifdistance,
                      clustering_method = input$motifclusmethod,
                      fontsize = 10,
                      fontsize_row = 10, 
                      show_rownames = T, 
                      cluster_rows = T,
                      fontsize_col = 12, 
                      show_colnames = T,
                      cluster_cols = F,
                      cellwidth = 15, cellheight = 15,
                      main = input$motifmain)
      } else if(nrow(motif_group_m_ratio_df_mat) < 25) {
        ph = pheatmap(motif_group_m_ratio_df_mat, 
                      scale = input$motifscale, 
                      clustering_distance_cols = input$motifdistance,
                      clustering_method = input$motifclusmethod,
                      fontsize = 8,
                      fontsize_row = 8, 
                      show_rownames = T, 
                      cluster_rows = T,
                      fontsize_col = 10, 
                      show_colnames = T,
                      cluster_cols = F,
                      cellwidth = 12, cellheight = 12,
                      main = input$motifmain)
      } else {
        ph = pheatmap(motif_group_m_ratio_df_mat, 
                      scale = input$motifscale, 
                      clustering_distance_cols = input$motifdistance,
                      clustering_method = input$motifclusmethod,
                      fontsize = 6,
                      fontsize_row = 6, 
                      show_rownames = T, 
                      cluster_rows = T,
                      fontsize_col = 8, 
                      show_colnames = T,
                      cluster_cols = F,
                      cellwidth = 8, cellheight = 8,
                      main = input$motifmain)
      }
      dev.off()
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
    }
  )
  
  output$motiflogodl <- downloadHandler(
    filename=function(){paste("motif_logo_result", userID,".pdf",sep="")},
    content = function(file){
      file.copy(paste('tmp/',userID,'/analysis/motif/logo.pdf',sep=''),file)
    })
  
  #######################################
  #######           FAQ           #######
  #######################################
  output$designtemplate <- downloadHandler(
    filename = "design_file.txt",
    content = function(file) {file.copy("examplefile/FAQ/phosphorylation_exp_design_info.txt", file)}
  )
})