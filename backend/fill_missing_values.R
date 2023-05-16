fill_missing_values <- function(nadata, method) {
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
    data_zero1 <- pcaMethods::pca(as.matrix(df1), nPcs = ncol(df1)-1, method = "bpca", maxSteps =100)
    df <- completeObs(data_zero1)
  } else if (method == "lls" && anyNA(df1)) {
    # take long time 
    library(pcaMethods)
    data_zero1 <- llsImpute(t(df1), k = 10, allVariables = TRUE)
    df <- t(completeObs(data_zero1))
  } else if (method == "impseq") {
    # library(rrcovNA)
    df <- impSeq(df1)
  } else if(method == "impseqrob"){
    # library(rrcovNA)
    data_zero1 <- impSeqRob(df1, alpha = 0.9)
    df <- data_zero1$x
  } else if(method == "knnmethod"){
    # library(impute)
    data_zero1 <- impute.knn(as.matrix(df1), k = 10, rowmax = 1, colmax = 1)
    df <- data_zero1$data
  } else if(method == "colmedian"){
    # library(e1071)
    df <- impute(df1, what = "median")
  } else if(method == "rowmedian"){
    # library(e1071)
    dfx <- impute(t(df1), what = "median")
    df <- t(dfx)
  }
  return(df)
}
