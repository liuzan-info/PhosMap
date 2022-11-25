get_aligned_seq_for_mea02 <- function(ID, Sequence, AA_in_protein, fixed_length, species = 'human', fasta_type = 'refseq'){
  requireNamespace('stringr')
  requireNamespace('utils')
  # require(PhosMap)
  cat('Aligned sequence based on fasta library for motif enrichment anlysis.\n')
  
  fasta_library_dir = "./PhosMap_datasets/fasta_library/"
  fasta_data <- utils::read.table((paste0(fasta_library_dir, fasta_type, "/", species, "/", species, "_", fasta_type, "_fasta.txt")), sep = '\t', header = TRUE)
  
  border_limit <- floor(fixed_length/2)
  aligned_seq <- NULL
  GI_nrow <- length(ID)
  cat('Pre-align:', GI_nrow, 'phos-pepitdes.\n')
  cat('Fixed sequence length is ', fixed_length, '.\n', sep = '')
  cat('It needs few time.\n')
  for(i in seq_len(GI_nrow)){
    gi <- ID[i]
    aa_index <- AA_in_protein[i]
    loc_index <- as.numeric(stringr::str_split(aa_index, "[STY]", n = Inf, simplify = FALSE)[[1]])[2]
    index <- which(fasta_data[,1] == gi)
    if(length(index) > 0){
      refseq <- as.vector(fasta_data[index,2])
      refseq_len <- nchar(refseq)
      
      left_limit <- loc_index - border_limit
      right_limit <- loc_index + border_limit
      
      if(left_limit>=1 & right_limit>refseq_len){
        right_limit <- refseq_len
        truncated_seq <- stringr::str_sub(refseq, left_limit, right_limit)
        truncated_seq <- stringr::str_pad(truncated_seq, fixed_length, "right", pad = '_')
      }else if(left_limit<1 & right_limit<=refseq_len){
        left_limit <- 1
        truncated_seq <- stringr::str_sub(refseq, left_limit, right_limit)
        truncated_seq <- stringr::str_pad(truncated_seq, fixed_length, "left", pad = '_')
      }else if(left_limit<1 & right_limit>refseq_len){
        left_limit <- 1
        right_limit <- refseq_len
        truncated_seq <- stringr::str_sub(refseq, left_limit, right_limit)
        truncated_seq <- stringr::str_pad(truncated_seq, fixed_length, "both", pad = '_')
      }else{
        truncated_seq <- stringr::str_sub(refseq, left_limit, right_limit)
      }
    }else{
      truncated_seq <- NA
    }
    aligned_seq <- c(aligned_seq, truncated_seq)
    if(i %% 5000 == 0){
      cat('Aligned:', i, 'phos-pepitdes.\n')
    }
    if(i == GI_nrow){
      cat('Aligned:', i, 'phos-pepitdes.\n')
      cat('Finish OK! ^_^\n')
    }
    
  }
  cat('\n')
  aligned_sequence_df_based_on_fasta_library <- data.frame(ID, Sequence, AA_in_protein, aligned_seq)
  return(aligned_sequence_df_based_on_fasta_library)
}
