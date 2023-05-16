get_normalized_data_of_psites3 <- function(data_frame, experiment_code_file_path, nathreshold, normmethod = "global", imputemethod = "minimum/10", topN = NA, mod_types = c('S', 'T', 'Y')){
  requireNamespace('utils')
  experiment_code <- utils::read.table(experiment_code_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
  # experiment_code <- as.vector(unlist(experiment_code$Experiment_Code))
  
  nathreshold <- length(experiment_code$Experiment_Code) - nathreshold
  if(nathreshold < 0) {
    nathreshold = 0
  }
  NAnumthresig <- c()
  for (row in 1:nrow(data_frame)) {
    NAnumthresig[row] <- (sum(data_frame[row,][-c(seq(6))] == 0) <= nathreshold)
    # NAnumthresigtest[raw] <- (sum(newdata2[raw,][-c(1,2)] == 0) >= NAnumthre)
  }
  data_frame <- data_frame[NAnumthresig,]
  
  data_frame_colnames <- colnames(data_frame)
  
  cat('\n The 7th step is running.')
  summary_df_ID_Info <- data_frame[, seq_len(6)]
  summary_df_ID_Info$AA_in_protein <- toupper(summary_df_ID_Info$AA_in_protein)
  summary_df_Value <- data_frame[, -(seq_len(6))]
  
  cat('\n Filtering data only including S/T/Y modifications.')
  ptypes <- mod_types
  index_of_AA_in_protein <- apply(data.frame(summary_df_ID_Info$AA_in_protein), 1, function(x){
    if(grepl('S', x) | grepl('T', x) | grepl('Y', x)){
      return(TRUE)
    }else{
      return(FALSE)
    }
  })
  index_of_ptypes <- which(index_of_AA_in_protein)
  if(length(index_of_ptypes)>0){
    ptypes_id_df <- summary_df_ID_Info[index_of_ptypes,]
    ptypes_value <- summary_df_Value[index_of_ptypes,]
  }else{
    message('No data with modifications taking place on ', paste(mod_types, collapse = '|'))
    stop('')
  }
  
  Value_FOT5 <- ptypes_value
  Value_FOT5_col <- ncol(Value_FOT5)
  if(is.na(topN)){
    if(normmethod == "global") {
      for(i in seq_len(Value_FOT5_col)){
        x <- as.vector(unlist(ptypes_value[,i]))
        Value_FOT5[,i] <- x/sum(x)*1e5
      }
    } else if(normmethod == "median") {
      for(i in seq_len(Value_FOT5_col)){
        x <- as.vector(unlist(ptypes_value[,i]))
        Value_FOT5[,i] <- x/median(x)*1e5
      }
    }
  }else{
    if(normmethod == "global") {
      for(i in seq_len(Value_FOT5_col)){
        x <- as.vector(unlist(ptypes_value[,i]))
        x_order <- order(x, decreasing = TRUE)
        x_order_top <- x_order[seq_len(topN)]
        x[-x_order_top] <- 0
        Value_FOT5[,i] <- x/sum(x)*1e5
      }
    } else if(normmethod == "median") {
      for(i in seq_len(Value_FOT5_col)){
        x <- as.vector(unlist(ptypes_value[,i]))
        x_order <- order(x, decreasing = TRUE)
        x_order_top <- x_order[seq_len(topN)]
        x[-x_order_top] <- 0
        Value_FOT5[,i] <- x/median(x)*1e5
      }
    }
  }
  ptypes_value_FOT5 <- as.matrix(Value_FOT5)
  
  index_of_zero <- which(ptypes_value_FOT5==0)
  # if(imputemethod=="0"){
  #   ptypes_value_FOT5[index_of_zero] <- 0
  # }else if(imputemethod=="minimum"){
  #   min_value_of_non_zero <- min(ptypes_value_FOT5[-index_of_zero])
  #   ptypes_value_FOT5[index_of_zero] <- min_value_of_non_zero
  # }else if(imputemethod=="minimum/10"){
  #   min_value_of_non_zero <- min(ptypes_value_FOT5[-index_of_zero])
  #   ptypes_value_FOT5[index_of_zero] <- min_value_of_non_zero*0.1
  # }
  ptypes_value_FOT5 <- as.data.frame(ptypes_value_FOT5)
  ptypes_value_FOT5[ptypes_value_FOT5 == 0] <- NA
  fill_missing_values01 <- function(nadata, method) {
    df <- df1 <- nadata
    if (method == "none") {
      df[is.na(df)] <- 0
    } else if (method == "minimum") {
      fill_value <- min(df1, na.rm = TRUE)
      df[is.na(df)] <- fill_value
    } else if (method == "minimum/10") {
      fill_value <- min(df1, na.rm = TRUE) / 10
      df[is.na(df)] <- fill_value
    } else if (method == "bpca") {
      # take medium time
      library(pcaMethods)
      data_zero1<-pcaMethods::pca(as.matrix(df1), nPcs = ncol(df1)-1, method = "bpca", maxSteps =100)
      df<-completeObs(data_zero1)
    } else if (method == "lls") {
      # take long time 
      # library(pcaMethods)
      data_zero1<-llsImpute(t(df1), k = 10, allVariables = TRUE)
      df<-t(completeObs(data_zero1))
    } else if (method == "impseq") {
      # library(rrcovNA)
      df <- impSeq(df1)
    } else if(method=="impseqrob"){
      # library(rrcovNA)
      data_zero1 <- impSeqRob(df1, alpha=0.9)
      df<-data_zero1$x
    } else if(method=="knnmethod"){
      # library(impute)
      data_zero1<-impute.knn(as.matrix(df1),k = 10, rowmax = 1, colmax = 1)#rowmax = 0.9, colmax = 0.9
      df<-data_zero1$data
    } else if(method=="colmedian"){
      # library(e1071)
      df<-impute(df1,what ="median")
    } else if(method=="rowmedian"){
      # library(e1071)
      dfx<-impute(t(df1),what ="median")
      df<-t(dfx)
      # } else if(method=="grr"){
      #   library(DreamAI)
      #   df<-impute.RegImpute(data=as.matrix(df1), fillmethod = "row_mean", maxiter_RegImpute = 10,conv_nrmse = 1e-03)
      # } else if(method=="mle"){
      #   library(norm)
      #   xxm<-as.matrix(df1)
      #   ss <- norm::prelim.norm(xxm)
      #   thx <- norm::em.norm(ss)
      #   norm::rngseed(123)
      #   df <- norm::imp.norm(ss, thx, xxm)
    }
    return(df)
  }
  ptypes_value_FOT5 = fill_missing_values01(ptypes_value_FOT5, imputemethod)
  
  ptypes_df_list <- list(
    ptypes_area_df_with_id = data.frame(ptypes_id_df, ptypes_value),
    ptypes_fot5_df_with_id = data.frame(ptypes_id_df, ptypes_value_FOT5)
  )
  
  cat('\n The 7th step is over ^_^.')
  return(ptypes_df_list)
}
