extract_psites_score <- function(
    phosphorylation_exp_design_info_file_path,
    mascot_xml_dir,
    mascot_txt_dir
){
  requireNamespace('utils')
  withProgress(message = "Start extracting the confidence of Psites from mascot.xml", detail = "This may take a while...", value = 0, {
    phosphorylation_exp_design_info_file_path <- normalizePath(phosphorylation_exp_design_info_file_path)
    if (!file.exists(phosphorylation_exp_design_info_file_path)) {
      cat('\n', phosphorylation_exp_design_info_file_path, ' -> ', 'No the file.')
      stop('')
    }
    mascot_xml_dir <- normalizePath(mascot_xml_dir)
    if (!file.exists(mascot_xml_dir)) {
      cat('\n', mascot_xml_dir, ' -> ', 'No the directory.')
      stop('')
    }
    mascot_xml_dir_files <- list.files(mascot_xml_dir)
    
    mascot_txt_dir <- normalizePath(mascot_txt_dir)
    if (!file.exists(mascot_txt_dir)) {
      cat('\n', mascot_txt_dir, ' -> ', 'No the directory, create it.')
      dir.create(mascot_txt_dir)
    }
    
    command <- "python"
    path2script <- system.file("src", "XMLParser_mascot_dat.py", package = "PhosMap") # The location of python script called
    
    # path2script <- "w:/R/R-3.3.2/library/PhosMap/src/XMLParser_mascot_dat.py"
    path2script <- normalizePath(path2script, mustWork = FALSE)
    
    # Get experiments codes by reading txt files
    experiment_code <- utils::read.table(phosphorylation_exp_design_info_file_path,
                                         sep = '\t',
                                         header = TRUE)
    experiment_code <- as.vector(unlist(experiment_code$Experiment_Code))
    
    # match txt files to mascot_xml_dir
    experiment_match_index <- match(experiment_code, mascot_xml_dir_files)
    na_index <- which(is.na(experiment_match_index))
    if(length(na_index)>0){
      na_experiments <- experiment_code[na_index]
      cat('\n', 'The following experiments do not exist in', mascot_xml_dir, '\n')
      for(na_experiment in na_experiments){
        cat('\n', na_experiment, '\n')
      }
      stop('')
    }
    
    experiment_code_count <- length(experiment_code)
    if (experiment_code_count < 1) {
      cat('\n', phosphorylation_exp_design_info_file_path, '\n')
      stopifnot('No experiments')
    }
    
    cat('\n Start extracting the confidence of Psites from mascot.xml.')
    cat('\n Total ', experiment_code_count, ' experiment(s).')
    cat('\n It will take a little while.')
    
    parent_dir <- dirname(phosphorylation_exp_design_info_file_path)
    parent_dir <- normalizePath(parent_dir)
    log_dir <- normalizePath(file.path(parent_dir, 'log'), mustWork = FALSE)
    if (!file.exists(log_dir)) {
      cat('\n', log_dir, ' -> ', 'No the directory, create it.')
      dir.create(log_dir)
    }
    
    log_df <- NULL
    for(i in seq_len(experiment_code_count)){
      experiment_code_i <- experiment_code[i]
      args <- c(experiment_code_i, mascot_xml_dir, mascot_txt_dir)  # Set args to vector
      allArgs <- c(path2script, args)  # Add python script path to parameters vector
      log_out <- tryCatch(
        {
          output <- system2(command, args = allArgs, stdout = TRUE) # R call python script by pass parameters vector
          cat('\n', i, '->', experiment_code_i, '->', 'success', '\n')
          c(experiment_code_i, 'success')
        },
        
        warning = function(w){ # process warning
          cat('\n', i, '->', experiment_code_i, '->', 'warning', '\n')
          print(w)
          log_i <- c(experiment_code_i, 'warning')
          return(log_i)
        },
        
        error = function(e){ # process error
          cat('\n', i, '->', experiment_code_i, '->', 'error', '\n')
          print(e)
          log_i <- c(experiment_code_i, 'error')
          return(log_i)
        }
      )
      log_df <- rbind(log_df, log_out)
      incProgress(1/seq_len(experiment_code_count), detail = paste0('\n Completed file: ', i, '/', experiment_code_count))
    }
    
    colnames(log_df) <- c('Exp_no', 'Status')
    now_time <- Sys.time()
    now_time <- gsub(':', '-', now_time)
    log_df_file_name <- paste(now_time, 'log_of_extract_psites_score.txt')
    log_df_file_path <- normalizePath(file.path(log_dir, log_df_file_name), mustWork = FALSE)
    utils::write.table(log_df, log_df_file_path, sep = '\t', row.names = FALSE, quote = FALSE)
    
    cat('\n Program finish, please see result log to check status.', '->', log_df_file_path)
  })
}


get_file_info_from_dir <- function(specific_dir, experiment_ID){
  requireNamespace('utils')
  withProgress(message = 'Reading peptide identification files', style = "notification", detail = "processing...", value = 0,{
    # read all files from specific director and save them into a list
    all_files <- list.files(specific_dir)
    all_files_count <- length(all_files)
    if(all_files_count>0){
      file_suffix <- get_file_suffix(all_files[1])
      if(file_suffix=='txt'){
        read_file_function <- utils::read.table
        sep <- '\t'
      }else{
        read_file_function <- utils::read.csv
        sep <- ','
      }
      sep_symbol <- paste('.', file_suffix, sep = '')
      all_files_ID <- apply(data.frame(all_files), 1, function(x, sep){
        x <- strsplit(x, split = sep)[[1]][1]
        x
      }, sep=sep_symbol)
      
      all_files_ID_code <- apply(data.frame(all_files_ID), 1, function(x, sep){
        x <- strsplit(x, split = sep)[[1]][1]
        x
      }, sep='_')
      all_files_paths <- normalizePath(file.path(specific_dir, all_files))
      
      index_of_match <- match(experiment_ID, all_files_ID_code)
      matched_all_files_paths <- all_files_paths[index_of_match]
      matched_all_files_ID <- all_files_ID[index_of_match]
      
      file_data_list <- list()
      matched_all_files_count <- length(matched_all_files_paths)
      cat('\n Total file: ', matched_all_files_count)
      for(i in seq_len(matched_all_files_count)){
        # Read bach data and save to file_data_list.
        cat('\n completed: ', i, '/', matched_all_files_count)
        file_data <- as.matrix(read_file_function(matched_all_files_paths[i], header = TRUE, sep = sep))
        file_data_list[[i]] <- file_data
        incProgress(1/matched_all_files_count, detail = paste0('\n completed: ', i, '/', matched_all_files_count))
      }
      attr(file_data_list,'names') <- matched_all_files_ID
      result_list <- list(file_data_list=file_data_list, file_ID=matched_all_files_ID)
      return(result_list)
      
    }else{
      stop('The directory of ', specific_dir, ' has no files.')
    }
  })
}


get_list_with_filtered_sites <- function(peptide_id, files, files_site_score, qc, min_score, min_FDR){
  withProgress(message = 'Reading psites QC files', style = "notification", detail = "processing...", value = 0,{
    peptide_df_with_area_psm_list <- list() # data.frame(area, psm)
    ID_of_seq_gi_site_list <- list() # seq_gi_psite
    ID_DF_list <- list() # seq_gi_psite + data.frame(area, psm)
    peptide_id_len <- length(peptide_id) # File Numbers
    # ************
    # *Required column:
    # *file_peptide: Ion_Score, FDR, Area, PSMs, Sequence, Protein_Groups_Accessions, Modification
    # *file_site_score: pep_seq, pep_var_mod_conf
    cat('\n Total file: ', peptide_id_len)
    for(i in seq_len(peptide_id_len)){
      cat('\n completed: ',i,'/',peptide_id_len)
      
      file_peptide <- data.frame(files[[i]])
      # Set parameters 1：reserve peptides with ion score><-20 and FDR<0.01.
      index_of_row_filters_meet_ionscore_and_FDR <- which(as.numeric(as.vector(file_peptide$Ion.Score)) >= min_score &
                                                            as.numeric(as.vector(file_peptide$FDR)) < min_FDR)
      file_peptide <- file_peptide[index_of_row_filters_meet_ionscore_and_FDR, ]
      
      if(!qc){
        file_peptide_subset <- file_peptide
      }else{
        # Extract peptides with psites score.
        file_site_score  <-  as.data.frame(files_site_score[[i]])
        index_of_row_filters_have_site_score <- which(grepl('%', file_site_score$pep_var_mod_conf))
        file_site_score  <-  file_site_score[index_of_row_filters_have_site_score,]
        
        # Reserve peptides with psites score in file_peptide.
        index_of_peptide_with_site_score_in_file_peptide <- match(as.vector(file_site_score[,1]), as.vector(file_peptide[,1]))
        index_of_NA <- which(is.na(index_of_peptide_with_site_score_in_file_peptide))
        if(length(index_of_NA)>0){
          index_of_peptide_with_site_score_in_file_peptide <- index_of_peptide_with_site_score_in_file_peptide[-index_of_NA]
        }
        file_peptide_subset <- file_peptide[index_of_peptide_with_site_score_in_file_peptide,]
      }
      area <- as.numeric(as.vector(file_peptide_subset$Area))
      psms <- as.numeric(as.vector(file_peptide_subset$PSMs))
      
      peptide_df_with_area_psm <- data.frame(area, psms)
      peptide_df_with_area_psm_colnames <- paste(peptide_id[i], c('Area', 'PSMs'), sep = '_')
      colnames(peptide_df_with_area_psm) <- peptide_df_with_area_psm_colnames
      
      sequence_id <- as.vector(file_peptide_subset$Sequence)
      accession <- as.vector(file_peptide_subset$Protein.Groups.Accessions)
      modification <- as.vector(file_peptide_subset$Modification)
      ID_of_seq_gi_site <- paste(sequence_id, accession, modification, sep = '||')
      
      ID_DF <- data.frame(ID_of_seq_gi_site, peptide_df_with_area_psm)
      colnames(ID_DF) <- c("ID", peptide_df_with_area_psm_colnames)
      
      
      peptide_df_with_area_psm_list[[i]] <- peptide_df_with_area_psm # area, psm
      ID_of_seq_gi_site_list[[i]] <- ID_of_seq_gi_site # seq_gi_psite
      ID_DF_list[[i]] <- ID_DF # seq_gi_psite, area, psm
      
      incProgress(1/peptide_id_len, detail = paste0('\n completed: ',i,'/',peptide_id_len))
    }
    result_list <- list(
      peptide_df_with_area_psm_list = peptide_df_with_area_psm_list,
      ID_of_seq_gi_site_list = ID_of_seq_gi_site_list,
      ID_DF_list = ID_DF_list
    )
    return(result_list)
  })
}


pre_process_filter_psites <- function(firmiana_peptide_dir, psites_score_dir,
                                      phospho_experiment_design_file_path, qc,
                                      min_score = 20, min_FDR = 0.01) {
  requireNamespace('utils')
  
  
  withProgress(message = 'Step2:QC and Merging', style = "notification", detail = "processing...", value = 0, max = 4,{
    PEPTIDE_DIR <- normalizePath(firmiana_peptide_dir, mustWork = FALSE)
    if(!file.exists(firmiana_peptide_dir)){
      cat(firmiana_peptide_dir, ' -> ', 'No the directory.')
      stop('')
    }
    
    PSITES_WITH_SCORE_DIR <- normalizePath(psites_score_dir, mustWork = FALSE)
    if(!file.exists(psites_score_dir)){
      cat(psites_score_dir, ' -> ', 'No the directory.')
      stop('')
    }
    
    phospho_experiment_design_file_path <- normalizePath(phospho_experiment_design_file_path, mustWork = FALSE)
    if(!file.exists(phospho_experiment_design_file_path)){
      cat(phospho_experiment_design_file_path, ' -> ', 'No the file')
      stop('')
    }
    
    # read experiment design file and make merged experments keep order of experiment design
    phospho_experiment_design_file <- utils::read.table(phospho_experiment_design_file_path, sep = '\t',
                                                        header = TRUE, stringsAsFactors = NA)
    phospho_experiment_ID <- as.vector(unlist(phospho_experiment_design_file$Experiment_Code))
    for(j in 1:4){
      # withProgress(message = 'please wait', style = "notification", detail = "processing...", value = 0,{
      if(j == 1){
        result_list_from_PEPTIDE_DIR <- get_file_info_from_dir(PEPTIDE_DIR, phospho_experiment_ID)
        files <- result_list_from_PEPTIDE_DIR$file_data_list
        peptide.id <- result_list_from_PEPTIDE_DIR$file_ID
      }
      
      if(j == 2){
        cat('\n The 2nd step: read psites QC files.')
        # rewrite function
        get_file_info_from_dir <- function(specific_dir, experiment_ID){
          requireNamespace('utils')
          withProgress(message = 'Reading psites QC files', style = "notification", detail = "processing...", value = 0,{
            # read all files from specific director and save them into a list
            all_files <- list.files(specific_dir)
            all_files_count <- length(all_files)
            if(all_files_count>0){
              file_suffix <- get_file_suffix(all_files[1])
              if(file_suffix=='txt'){
                read_file_function <- utils::read.table
                sep <- '\t'
              }else{
                read_file_function <- utils::read.csv
                sep <- ','
              }
              sep_symbol <- paste('.', file_suffix, sep = '')
              all_files_ID <- apply(data.frame(all_files), 1, function(x, sep){
                x <- strsplit(x, split = sep)[[1]][1]
                x
              }, sep=sep_symbol)
              
              all_files_ID_code <- apply(data.frame(all_files_ID), 1, function(x, sep){
                x <- strsplit(x, split = sep)[[1]][1]
                x
              }, sep='_')
              all_files_paths <- normalizePath(file.path(specific_dir, all_files))
              
              index_of_match <- match(experiment_ID, all_files_ID_code)
              matched_all_files_paths <- all_files_paths[index_of_match]
              matched_all_files_ID <- all_files_ID[index_of_match]
              
              file_data_list <- list()
              matched_all_files_count <- length(matched_all_files_paths)
              cat('\n Total file: ', matched_all_files_count)
              for(i in seq_len(matched_all_files_count)){
                # Read bach data and save to file_data_list.
                cat('\n completed: ', i, '/', matched_all_files_count)
                file_data <- as.matrix(read_file_function(matched_all_files_paths[i], header = TRUE, sep = sep))
                file_data_list[[i]] <- file_data
                incProgress(1/matched_all_files_count, detail = paste0('\n completed: ', i, '/', matched_all_files_count))
              }
              attr(file_data_list,'names') <- matched_all_files_ID
              result_list <- list(file_data_list=file_data_list, file_ID=matched_all_files_ID)
              return(result_list)
              
            }else{
              stop('The directory of ', specific_dir, ' has no files.')
            }
          })
          
        }
        result_list_from_PSITES_WITH_SCORE_DIR <- get_file_info_from_dir(PSITES_WITH_SCORE_DIR,
                                                                         phospho_experiment_ID)
        files_site_score <- result_list_from_PSITES_WITH_SCORE_DIR$file_data_list
        site_score.id <- result_list_from_PSITES_WITH_SCORE_DIR$file_ID
      }
      
      
      
      if(j == 3){
        cat('\n The 3rd step: filter peptides based on site quality.')
        result_list_with_filtered_sites <- get_list_with_filtered_sites(peptide.id, files,
                                                                        files_site_score, qc,
                                                                        min_score, min_FDR)
        
        
        peptide_df_with_area_psm_list <- result_list_with_filtered_sites$peptide_df_with_area_psm_list # including: area, psm
        ID_of_seq_gi_site_list <- result_list_with_filtered_sites$ID_of_seq_gi_site_list # including: seq_gi_psite
        ID_DF_list <- result_list_with_filtered_sites$ID_DF_list # including: seq_gi_psite, area, psm
      }
      
      
      if(j == 4){
        #### (4) Based on unique peptide, merge all experiments ####
        cat('\n The 4th step: merge data based on peptides (unique ID).')
        withProgress(message = 'Merging data based on peptides (unique ID)', style = "notification", detail = "processing...", value = 0,{
          for (i in 1:1) {
            merge_df_with_phospho_peptides <- get_merged_phospho_df(peptide.id,
                                                                    peptide_df_with_area_psm_list,
                                                                    ID_of_seq_gi_site_list, ID_DF_list)
            
            # delete psm column
            merge_df_with_phospho_peptides_colnames <- colnames(merge_df_with_phospho_peptides)
            index_of_PSMs <- grep('_PSMs', merge_df_with_phospho_peptides_colnames)
            merge_df_with_phospho_peptides <- merge_df_with_phospho_peptides[,-index_of_PSMs]
            
            
            
            merge_df_with_phospho_peptides_colnames <- colnames(merge_df_with_phospho_peptides)
            ID <- as.vector(merge_df_with_phospho_peptides[,1])
            Value <- merge_df_with_phospho_peptides[,-1]
            Value_colnames <- colnames(Value)
            Value_colnames_ID <- apply(data.frame(Value_colnames), 1, function(x){
              x <- strsplit(x, split = '_')[[1]][1]
              x
            })
            index_of_match <- match(phospho_experiment_ID, Value_colnames_ID)
            Value <- Value[,index_of_match]
            merge_df_with_phospho_peptides <- data.frame(ID, Value)
            colnames(merge_df_with_phospho_peptides) <- c(merge_df_with_phospho_peptides_colnames[1], phospho_experiment_ID)
            incProgress(1, detail = 'finishing...')
          }
        })
        
        return(merge_df_with_phospho_peptides)
      }
      incProgress(1, detail = '')
    }
  }) 
}


get_combined_data_frame02 <- function(merge_df_with_phospho_peptides, species = 'human', id_type = 'RefSeq_Protein_GI'
){
  # Read library file, map GI to Gene Symbol
  requireNamespace('utils')
  requireNamespace('stringr')
  
  cat('\n The 5th step: write the data frame with symbols mapping to genes.')
  
  withProgress(message = 'Writing the data frame with symbols mapping to genes', style = "notification", detail = "This may take a while...", value = 0,{
    id_coversion_table_dir = "./PhosMap_datasets/id_coversion_table/"
    id_coversion_table = utils::read.table((paste0(id_coversion_table_dir, species, "_ID.txt")), sep = '\t', header = TRUE)
    
    cat('\n The 5th step is running.')
    # Split a string: sequenceID, accession, modification
    seq_gi_site_vector <- as.vector(merge_df_with_phospho_peptides$ID_of_seq_gi_site)
    Sequence <- apply(data.frame(seq_gi_site_vector), 1, function(x){
      strsplit(x, split="||", fixed = TRUE)[[1]][1]
    })
    ID <- apply(data.frame(seq_gi_site_vector), 1, function(x){
      strsplit(x, split="||", fixed = TRUE)[[1]][2]
    })
    Modification <- apply(data.frame(seq_gi_site_vector), 1, function(x){
      strsplit(x, split="||", fixed = TRUE)[[1]][3]
    })
    
    
    ##########################################################################################################
    # id_types <- c('GeneID', 'RefSeq_Protein_GI', 'RefSeq_Protein_Accession', 'Uniprot_Protein_Accession')
    # GeneSymbol
    # construct dict
    # id_type <- 'RefSeq_Protein_GI'
    MappingDf <- id_coversion_table[, c('GeneSymbol', id_type)]
    invalid_index <- which(as.vector(unlist(MappingDf[,2])) == '' | as.vector(unlist(MappingDf[,2])) == '-')
    if(length(invalid_index)>0){
      MappingDf <- MappingDf[-invalid_index,]
    }
    MappingDf_row <- nrow(MappingDf)
    cat('\n', 'Construct dictionary based on GeneSymbol and specific ID.')
    mapping_dict <- NULL
    cat('\n', 'The total:', MappingDf_row)
    for(i in 1:MappingDf_row){
      x <- as.vector(MappingDf[i,1])
      y <- as.vector(unlist(MappingDf[i,2]))
      y <- strsplit(y, split = '; ')[[1]]
      x_v <- rep(x, length(y))
      names(x_v) <- y
      mapping_dict <- c(mapping_dict, x_v)
      if(i%%5000==0 | i == MappingDf_row){
        cat('\n', 'Completed:', i, '/', MappingDf_row)
        # incProgress(1/seq_len(MappingDf_row), detail = paste0('\n', 'Completed:', i, '/', MappingDf_row))
      }
      incProgress(1/MappingDf_row, detail = paste0('\n', 'Completed:', i, '/', MappingDf_row))
    }
    ##########################################################################################################
    
    GeneSymbol <- apply(data.frame(ID), 1, function(x, mapping_dict, id_type){
      gi_all <- strsplit(x, split=";", fixed = TRUE)[[1]]
      
      gi_mapping_symbol <- apply(data.frame(gi_all), 1, function(y, mapping_dict, id_type){
        if(id_type == 'RefSeq_Protein_GI'){
          y = stringr::str_replace_all(y, 'gi[|]', '')
        }
        return(mapping_dict[y])
      }, mapping_dict = mapping_dict, id_type)
      
      gi_mapping_symbol_unique <- unique(gi_mapping_symbol[which(!is.na(gi_mapping_symbol))])
      gi_mapping_symbol_unique_count <- length(gi_mapping_symbol_unique)
      
      
      if(gi_mapping_symbol_unique_count == 0){
        return(NA)
      }else if(gi_mapping_symbol_unique_count == 1){
        return(gi_mapping_symbol_unique)
      }else{
        return(paste(gi_all, collapse = ';'))
      }
    }, mapping_dict = mapping_dict, id_type = id_type)
    
    
    # sequenceID, accession, symbol, modification, quantification_value_in_experiment
    df_of_combination <- data.frame(Sequence, ID, Modification, GeneSymbol, merge_df_with_phospho_peptides[,-1]) # delete first column
    index_of_NonNA <- which(!is.na(GeneSymbol))
    df_of_combination <- df_of_combination[index_of_NonNA,]
    cat('\n The 5th step is over ^_^.')
    cat('\n The 5th step: write the data frame with symbols mapping to genes.')
    incProgress(1, detail = 'Please wait a moment')
  })
  return(df_of_combination)
}


get_summary_with_unique_sites02 <- function(combined_df_with_mapped_gene_symbol, species = 'human', fasta_type = 'refseq'
){
  requireNamespace('utils')
  requireNamespace('stringr')
  # unique phosphorylation sites
  withProgress(message = 'Constructing the data frame with unique phosphorylation site for each protein sequence', style = "notification", detail = "This may take a while...", value = 0,{
    cat('\n The 6th step: construct the data frame with unique phosphorylation site for each protein sequence.')
    
    path <- "./PhosMap_datasets/fasta_library/"
    fasta_data <- utils::read.table(paste0(path, fasta_type, "/", species, "/", species, "_", fasta_type, "_fasta.txt"), header=TRUE, sep="\t")
    
    id_data <- combined_df_with_mapped_gene_symbol
    
    # Keep peptides assigned to unique protein
    id_data_only_peptide2gi <- id_data[which(!grepl(';', as.vector(id_data$ID))),]
    
    for(j in 1:2){
      if(j == 1){
        withProgress(message = 'Getting modification index in protein sequence. ', style = "notification", detail = "This may take a while...", value = 0,{
          get_modification_index <- function(id_data_only_peptide2gi, fasta_data){
            # 1
            # Get modification index in protein sequence.
            cat('\n', 'Get modification index in protein sequence.')
            id_data_only_peptide2gi_row <- nrow(id_data_only_peptide2gi)
            modification_index_in_protein_seq_list <- list()
            for(i in seq_len(id_data_only_peptide2gi_row)){
              peptide_seq <- as.vector(id_data_only_peptide2gi$Sequence[i])
              peptide_id <- as.vector(id_data_only_peptide2gi$ID[i])
              modification_index_in_peptide_seq <- unlist(gregexpr("[a-z]", peptide_seq))
              protein_seq <- as.vector(fasta_data$Sequence[which(fasta_data$ID==peptide_id)])
              first_index_of_peptide2protein <- unlist(gregexpr(toupper(peptide_seq), protein_seq))
              modification_index_in_protein_seq <- NULL
              for(elemt in first_index_of_peptide2protein){
                tmp_modification_index_in_protein_seq <- elemt + modification_index_in_peptide_seq -1
                modification_index_in_protein_seq <- c(modification_index_in_protein_seq,
                                                       tmp_modification_index_in_protein_seq)
              }
              modification_index_in_protein_seq_list[[i]] <- modification_index_in_protein_seq
              if(i%%500==0 | i==id_data_only_peptide2gi_row ){
                cat('\n completed: ', i, '/', id_data_only_peptide2gi_row)
              }
              incProgress(1/id_data_only_peptide2gi_row, detail = paste0('\n', 'Completed:', i, '/', id_data_only_peptide2gi_row))
            }
            return(modification_index_in_protein_seq_list)
          }
          
          
          # Determine locations of the psites each peptide mapped to protein squence.
          modification_index_in_protein_seq_list <- get_modification_index(id_data_only_peptide2gi,
                                                                           fasta_data)
          
          proteins_in_id_data_only_peptide2gi <- as.vector(id_data_only_peptide2gi$ID)
          sequences_in_id_data_only_peptide2gi <- as.vector(id_data_only_peptide2gi$Sequence)
          value_in_id_data_only_peptide2gi <- id_data_only_peptide2gi[, -c(seq_len(4))]
          
          unique_proteins <- unique(proteins_in_id_data_only_peptide2gi)
          unique_protein_count <- length(unique_proteins)
        })
      }
      
      if(j == 2){
        # Show psites and modifications of one protein, merge the values with the same modification type.
        cat('\n', 'Map phosphorylation sites to protein sequence and eliminate redundancy.')
        withProgress(message = 'Mapping phosphorylation sites to protein sequence and eliminate redundancy. ', style = "notification", detail = "This may take a while...", value = 0,{
          system.time({
            summary_df_of_unique_proteins_with_sites <- c()
            for(i in seq_len(unique_protein_count)){
              
              df_with_AAs_i <- get_df_with_AAs_i(unique_proteins,
                                                 i,
                                                 id_data_only_peptide2gi,
                                                 proteins_in_id_data_only_peptide2gi,
                                                 sequences_in_id_data_only_peptide2gi,
                                                 modification_index_in_protein_seq_list)
              
              summary_df_of_unique_protein_with_sites <- get_unique_AAs_i_df(df_with_AAs_i)
              
              summary_df_of_unique_proteins_with_sites <- rbind(
                summary_df_of_unique_proteins_with_sites,
                summary_df_of_unique_protein_with_sites
              )
              
              if(i%%500==0 | i == unique_protein_count){
                cat('\n completed: ', i, '/', unique_protein_count)
              }
              incProgress(1/unique_protein_count, detail = paste0('\n', 'Completed:', i, '/', unique_protein_count))
              
              summary_df_of_unique_proteins_with_sites_rownames <- paste(as.vector(summary_df_of_unique_proteins_with_sites$ID),
                                                                         as.vector(summary_df_of_unique_proteins_with_sites$AA_in_protein),
                                                                         sep = '_')
              rownames(summary_df_of_unique_proteins_with_sites) <- summary_df_of_unique_proteins_with_sites_rownames
              summary_df_of_unique_proteins_with_sites_colnames <- colnames(summary_df_of_unique_proteins_with_sites)
              index_of_PSMs <- which(grepl('_PSMs', summary_df_of_unique_proteins_with_sites_colnames))
              if(length(index_of_PSMs)>0){
                summary_df_of_unique_proteins_with_sites <- summary_df_of_unique_proteins_with_sites[,-index_of_PSMs]
              }
              summary_df_of_unique_proteins_with_sites$GeneSymbol <- apply(data.frame(summary_df_of_unique_proteins_with_sites$GeneSymbol),
                                                                           1,
                                                                           function(x){
                                                                             if(grepl('||', x)){
                                                                               x <- as.vector(x)
                                                                               x <- strsplit(x, split = '||', fixed = TRUE)
                                                                               x[[1]][1]
                                                                             }
                                                                           })
            }
          })
        })
      }
      incProgress(1/2, detail = paste0('\n '))
    }
    cat('\n The 6th step: construct over.')
    
  })
  return(summary_df_of_unique_proteins_with_sites)
}


merge_profiling_file_from_Firmiana <- function(firmiana_gene_dir, US_cutoff = 1, experiment_gene_file_path){
  requireNamespace('utils')
  
  withProgress(message = 'Step5 : Normalization [Normalizing phosphoproteomics data based on proteomics data.] ', style = "notification", detail = "processing...", value = 0,{
    for (j in 1:2) {
      if(j == 1){
        DATA_DIR <- normalizePath(firmiana_gene_dir, mustWork = FALSE)
        if(!file.exists(DATA_DIR)){
          cat(DATA_DIR, ' -> ', 'No the file')
          stop('')
        }
        data_list <- list()
        file_names <- list.files(path = DATA_DIR, pattern = '.txt')
        file_names_count <- length(file_names)
        if(length(file_names_count)<1){
          stop('The directory of ', DATA_DIR, ' has no files.')
        }
        
        exp_names <- apply(data.frame(file_names), 1, function(x){
          x <- strsplit(x, split = '_')[[1]][1]
          x
        })
        
        experiment_code <- utils::read.table(experiment_gene_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
        experiment_code <- as.vector(unlist(experiment_code$Experiment_Code))
        
        index_of_match <- match(experiment_code, exp_names)
        na_index <- which(is.na(index_of_match))
        na_count <- length(na_index)
        if(na_count > 0){
          na_experiment_code <- experiment_code[na_index]
          cat(
            '\n',
            na_experiment_code,
            'not in',
            DATA_DIR
          )
          stop('')
        }
        
        exp_names <- exp_names[index_of_match]
        file_names <- file_names[index_of_match]
        file_names_count <- length(file_names)
        
        # Table headers of input data
        # "Gene.ID" "Symbol" "Annotation"  "Modification" "Description"
        # "Protein.GI" "Protein.Num" "Area" "FoT.1e.6." "iBAQ"
        # "Peptide.Num" "Unique.Peptide.Num"  "Strict.Peptide.Num"  "US.Peptide.Num"  "Identified.Proteins.Num"
        # "Unique.Proteins.Num"
        
        # New table headers of input data
        file_data_colnames <- c(
          "Gene_ID", "Symbol", "Annotation", "Modification", "Description",
          "Protein_GI",  "Protein_Num", "Area", "FoT5", "iBAQ",
          "Peptide_Num", "UPeptide_Num",  "SPeptide_Num",  "USPeptide_Num",  "Identified_Proteins_Num", "Unique_Proteins_Num"
        )
        kept_colnames <- c(
          "Symbol", "iBAQ", "USPeptide_Num"
        )
        kept_colnames_index <- match(kept_colnames, file_data_colnames)
        cat('\n Merge profiling files downloaded from Firmiana.')
        cat('\n Total files: ', file_names_count)
        for(i in seq_len(file_names_count)){
          file_name <- file_names[i]
          file_path <- normalizePath(file.path(DATA_DIR, file_name))
          file_data <- utils::read.delim(file_path, header = TRUE, stringsAsFactors = NA, sep = '\t')
          colnames(file_data) <- file_data_colnames
          file_data <- file_data[, kept_colnames_index]
          
          index_of_US <- which(file_data$USPeptide_Num >= US_cutoff)
          file_data <- file_data[index_of_US, c(1,2)]
          exp_name <- exp_names[i]
          file_data_colnames.i <- colnames(file_data)
          file_data_colnames.i <- paste(exp_name, file_data_colnames.i, sep = '_')
          file_data_colnames.i[1] <- 'Symbol'
          colnames(file_data) <- file_data_colnames.i
          data_list[[i]] <- file_data
          cat('\n Read and filter: ', i, '/', file_names_count)
          incProgress(1/seq_len(file_names_count), detail = paste0('\n Read and filter: ', i, '/', file_names_count))
        }
        attr(data_list, 'names') <- exp_names
        
        data_list_count <- length(data_list)
        merge_df <- data_list[[1]]
        merge_df_colnames <- colnames(merge_df)
      }
      
      if(j == 2){
        cat('\n merge_complete: ', 1, '/', data_list_count)
        if(data_list_count>1){
          for(i in 2:data_list_count){
            tmp_merge_df <- data_list[[i]]
            merge_df <- merge(merge_df, tmp_merge_df, by = 'Symbol', all = TRUE)
            cat('\n merge_complete: ', i, '/', data_list_count)
            incProgress(1/data_list_count, detail = paste0('\n merge_complete: ', i, '/', data_list_count))
          }
        }
        Symbol <- as.vector(merge_df[,1])
        Value <- as.matrix(merge_df[,-1])
        index_of_NA <- which(is.na(Value))
        if(length(index_of_NA)>0){
          Value[index_of_NA] <- 0
        }
        colnames(Value) <- exp_names
        merge_df_no_NA <- data.frame(Symbol, Value)
      }
    }
    incProgress(1/2, detail = '')
  })
  return(merge_df_no_NA)
}


get_normalized_data_FOT5 <- function(data_frame, experiment_code_file_path
){
  requireNamespace('utils')
  # cat('\n The 7th step: Normalize data and filter data only including phosphorylation site.')
  cat('Normalize proteomics data based on the total sum (x 1e5).')
  experiment_code <- utils::read.table(experiment_code_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
  experiment_code <- as.vector(unlist(experiment_code$Experiment_Code))
  data_frame_colnames <- colnames(data_frame)
  ID <- as.vector(data_frame[,1])
  Value_raw <- data_frame[,-1]
  Value_FOT5 <- Value_raw
  Value_FOT5_col <- ncol(Value_FOT5)
  for(i in seq_len(Value_FOT5_col)){
    x <- Value_raw[,i]
    valid_index <- which(x>0)
    valid_x <- x[valid_index]
    valid_x_sum <- sum(valid_x)
    valid_x_FOT5 <- valid_x/valid_x_sum*1e5
    Value_FOT5[valid_index,i] <- valid_x_FOT5
  }
  data_frame_normaliation <- data.frame(ID, Value_FOT5)
  data_frame_normaliation_colnames <- c(data_frame_colnames[1], experiment_code)
  colnames(data_frame_normaliation) <- data_frame_normaliation_colnames
  return(data_frame_normaliation)
}


keep_psites_with_max_in_topX2 <- function(phospho_data, percent_of_kept_sites = 3/4){
  percent_of_kept_sites_str <- paste('top', percent_of_kept_sites*100, '%', sep = '')
  cat('\n The 8th step: filter psites with row maximum in', percent_of_kept_sites_str, '.')
  # ID <- as.vector(phospho_data[,1])
  Value <- phospho_data[,-c(1,2,3)]
  Value_rowmax <- apply(Value, 1, function(x){
    x <- as.vector(unlist(x))
    max(x)
  })
  index_of_Value_rowmax_desc <- order(Value_rowmax, decreasing = TRUE)
  count_of_kept_sites <- round(nrow(Value)*percent_of_kept_sites)
  index_of_Value_rowmax_desc_kept <- index_of_Value_rowmax_desc[seq_len(count_of_kept_sites)]
  phospho_data_meet_percent <- phospho_data[index_of_Value_rowmax_desc_kept,]
  cat('\n The 8th step: filter over with ', percent_of_kept_sites_str, ' cutoff.')
  return(phospho_data_meet_percent)
}








analysis_deps_limma2 <- function(expr_data_frame, group, comparison_factor,
                                 log2_label = FALSE, adjust_method = 'BH'){
  requireNamespace('limma')
  requireNamespace('stats')
  # experiment_design_file_path <- "D:\\Phosphate-data\\Bioinfomatics\\demo_data_from_WYN\\experiment_design_noPair.txt"
  # experiment_design_file <- read.table(experiment_design_file_path, sep = '\t', header = T)
  # group <- experiment_design_file$Group[experiment_design_file$Data_Type == 'Phospho']
  # group <- paste('t', group, sep = '')
  # group <- factor(group, levels = c('t0', 't10', 't30', 't120'))
  # expr_data_frame <- data_frame_normalization_0
  
  expr_ID <- as.vector(expr_data_frame[,1])
  expr_Valule <- expr_data_frame[,-1]
  if(!log2_label){
    expr_Valule <- log2(expr_data_frame[,-1]) # have to log
  }
  expr_Valule_row_duplicated <- apply(expr_Valule, 1, function(x){
    stats::var(x)
  })
  expr_Valule_col <- ncol(expr_Valule)
  duplicated_row_index <- which(expr_Valule_row_duplicated == 0)
  if(length(duplicated_row_index)>0){
    #  Zero sample variances detected, have been offset away from zero
    expr_ID <- expr_ID[-duplicated_row_index]
    expr_Valule <- expr_Valule[-duplicated_row_index,]
  }
  # rownames(expr_Valule) <- expr_ID
  
  design <- stats::model.matrix(~ 0 + group)
  cat('\n', 'The matrix of experiment design.')
  print(design)
  colnames(design) <- levels(factor(group))
  rownames(design) <- colnames(expr_Valule)
  # comparison_statement <- c('t10-t0', 't30-t0', 't120-t0')
  # comparison_statement <- c('t10-t0')
  group_levels <- comparison_factor
  group_levels_count <- length(group_levels)
  if(group_levels_count<2){
    cat('\n', 'Do not construct pairwise comparison pattern.')
    stop('')
  }else{
    comparison_statement <- NULL
    i_end <- group_levels_count - 1
    for(i in seq_len(i_end)){
      ctrl <- group_levels[i]
      j_start <- i + 1
      for(j in j_start:group_levels_count){
        treat <- group_levels[j]
        cs <- paste(treat, '-', ctrl, sep = '')
        comparison_statement <- c(comparison_statement, cs)
      }
    }
    cat('\n', 'The combination of pairwise comparison(s).')
    cat('\n', comparison_statement, '\n')
  }
  
  
  
  contrast.matrix <- limma::makeContrasts(contrasts = comparison_statement, levels = design)
  cat('\n', 'The matrix of comparison statement, compare other groups with control.')
  print(contrast.matrix) # the matrix of comparison statement, compare other groups with control.
  
  
  # step1
  fit <- limma::lmFit(expr_Valule, design)
  
  # step2
  fit2 <- limma::contrasts.fit(fit, contrast.matrix) # An important step.
  fit2 <- limma::eBayes(fit2)  # default no trend!
  
  
  # return(fit2)
  # step3
  alls <- limma::topTable(fit2, coef = 1, adjust.method = adjust_method, p.value = 1, number = Inf) # logFC = log(a/b) = log(a) - log(b) = A - B
  # results <- decideTests(fit2, method = "global", adjust.method = adjust_method, p.value = minPvalue, lfc = minFC)
  # vennDiagram(results)
  alls <- stats::na.omit(alls)
  
  # plot
  ID <- rownames(alls)
  logFC <- alls$logFC # log2
  pvalue <- alls$adj.P.Val
  
  result_df <- data.frame(ID, logFC, pvalue)
  
  return(result_df)
}

analysis_deps_sam2 <- function(expr_data_frame, group, log2_label = FALSE,
                               nperms = 100, rand = NULL, minFDR = 0.05,
                               samr_plot = TRUE){
  requireNamespace('samr')
  requireNamespace('stats')
  expr_ID <- as.vector(expr_data_frame[,1])
  #(李佳澳)加入赋值
  expr_Valule <- expr_data_frame[,-1]
  #结束
  if(!log2_label){
    expr_Valule <- log2(expr_data_frame[,-1]) # have to log
  }
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
  
  
  if(samr_plot){
    cat('\n', 'Plot samr plot to view DEPs (or DEGs) distribution.')
    samr::samr.plot(samr_obj, delta)
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
  
  sam_result_list <- list(
    genes_up_df <- genes_up_df,
    genes_down_df <- genes_lo_df
  )
  
  return(sam_result_list)
}


get_summary_from_ksea2 <- function(
    ptypes_data,
    species = 'human',
    log2_label = TRUE,
    ratio_cutoff = 3
){
  requireNamespace('utils')
  withProgress(message = "Running KSEA", style = "notification", detail = "processing...",{
    # read relationship of kinase-substrate provided by PhosMap
    # KSRR: kinase substrate regulation relationship
    # A data frame contanning relationship of kinase-substrate that consists of "kinase", "substrate", "site", "sequence" and "predicted" columns.
    KSRR_FILE_PATH <- paste0("./PhosMap_datasets/kinase_substrate_regulation_relationship_table/", species, "/", species, "_ksrr.csv")
    kinase_substrate_regulation_relationship <- utils::read.csv(KSRR_FILE_PATH, header = TRUE, sep= ",", stringsAsFactors = NA)
    
    ID <- as.vector(ptypes_data[,1])
    ptypes_data_ratio <- ptypes_data[,-1]
    if(!log2_label){
      
      ptypes_data_ratio <- log2(ptypes_data_ratio)
    }
    ptypes_data_ratio_colnames <- colnames(ptypes_data_ratio)
    
    
    
    ksea_es_list <- list()
    ksea_pvalue_list <- list()
    ksea_regulons_list <- list()
    ksea_activity_list <- list()
    ksea_trans_list <- list()
    ptypes_data_exp_count <- ncol(ptypes_data_ratio)
    cat('\n Starting KSEA')
    for(i in seq_len(ptypes_data_exp_count)){
      cat('\n completing: ', i, '/', ptypes_data_exp_count)
      ptypes_data_ratio_in_single_exp <- as.numeric(unlist(ptypes_data_ratio[,i]))
      ksea_result_list_i <- get_ksea_result_list(
        ptypes_data_ratio_in_single_exp, ID,
        kinase_substrate_regulation_relationship,
        ksea_activity_i_pvalue = 0.05
      )
      ksea_es_list[[i]] <- ksea_result_list_i$ksea_es_i_non_NA
      ksea_pvalue_list[[i]] <- ksea_result_list_i$ksea_pvalue_i_non_NA
      ksea_regulons_list[[i]] <- ksea_result_list_i$ksea_regulons_i_non_NA
      ksea_activity_list[[i]] <- ksea_result_list_i$ksea_activity_i
      ksea_trans_list[[i]] <- ksea_result_list_i$ksea_trans_i
      cat('\n completed: ', i, '/', ptypes_data_exp_count)
      incProgress(1/ptypes_data_exp_count, detail = paste0("\n completed: ", i, "/",ptypes_data_exp_count))
    }
    cat('\n Ending KSEA')
    
    cat('\n Extracting information data frame derived from KSEA')
    cat('\n ********** Regulation direction from KSEA **********')
    cat('\n ********** Pvalue from KSEA **********')
    cat('\n ********** Activity from KSEA **********')
    cat('\n ********** Kinase_site_substrate quantification matrix after KSEA **********')
    cat('\n')
    
    ksea_regulons <- unique(unlist(ksea_regulons_list))
    ksea_regulons_count <- length(ksea_regulons)
    # enrichment score from ksea
    # pvalue from ksea
    # regulons (kinase) from ksea
    # kinase activity based on pvalue and enrichment score computed by ksea
    # regulation direction: 1 = activate, 0 = no work, -1 = supress
    ksea_regulons_regulation_direction_df <- get_ksea_regulons_info(ksea_regulons, ksea_trans_list, ksea_trans_list,
                                                                    ptypes_data_ratio_colnames)
    ksea_regulons_pvalue_df <- get_ksea_regulons_info(ksea_regulons, ksea_trans_list, ksea_pvalue_list,
                                                      ptypes_data_ratio_colnames)
    ksea_regulons_activity_df <- get_ksea_regulons_info(ksea_regulons, ksea_trans_list, ksea_activity_list,
                                                        ptypes_data_ratio_colnames)
    
    ksea_kinase_site_substrate_original_ratio_df <- get_substrate_expr_df(ID,
                                                                          kinase_substrate_regulation_relationship,
                                                                          ksea_regulons,
                                                                          ptypes_data_ratio,
                                                                          ratio_cutoff)
    summary_df_list_from_ksea <- list(
      ksea_regulons_regulation_direction_df = ksea_regulons_regulation_direction_df, # regulation direction: 1 = activate, 0 = no work, -1 = supress
      ksea_regulons_pvalue_df = ksea_regulons_pvalue_df, # pvalue from ksea
      ksea_regulons_activity_df = ksea_regulons_activity_df, # kinase activity based on pvalue and enrichment score computed by ksea
      ksea_kinase_site_substrate_original_ratio_df = ksea_kinase_site_substrate_original_ratio_df #
    )
    
    cat('\n KSEA OK! ^_^')
    
    return(summary_df_list_from_ksea)
  })
}


mea_based_on_background <- function(foreground, AA_in_protein, background, motifx_pvalue){
  # foreground <- as.vector(foreground)
  # background <- as.vector(background$Aligned_Seq)
  center_vector_candidate <- c('S', 'T', 'Y')
  center_vector_candidate_len <- length(center_vector_candidate)
  center_vector <- NULL
  for(i in seq_len(center_vector_candidate_len)){
    cat(i)
    center <- center_vector_candidate[i]
    if(length(grep(center, AA_in_protein)) > 0){
      center_vector <- c(center_vector, center)
    }
  }
  cat('Start executing motifx and find motif pattern. \n')
  cat('Foreground sequences: ', length(foreground), '.\n', sep = '')
  cat('Background sequences: ', length(background), '.\n', sep = '')
  cat('Phosphorylation: [', center_vector, '] exists in foreground.\n', sep = '')
  cat('Motifx pvalue cutoff: ', motifx_pvalue, '.\n', sep = '')
  motifs_list <- get_motifs_list(foreground, background, center_vector, motifx_pvalue)
  cat('Motifx analysis OK! ^_^', '\n')
  print(motifs_list)
  cat('\n')
  return(motifs_list)
}


get_motifs_list <- function(foreground, background, center_vector, motifx_pvalue){
  motifs_list <- list()
  motifs_list_names <- NULL
  motifs_list_index <- 0
  center_vector_len <- length(center_vector)
  cat("进入get_motifs_list 循环")
  for(i in seq_len(center_vector_len)){
    cat(center_vector_len)
    cat(i)
    center <- center_vector[i]
    motifs <- get_motif_analysis_summary(foreground, background, center = center, min_sequence_count = 1, min_pvalue = motifx_pvalue)
    if(!is.null(motifs)){
      motifs_list_index <- motifs_list_index + 1
      motifs_list[[motifs_list_index]] <- motifs
      motifs_list_names <- c(motifs_list_names, center)
    }
  }
  if(motifs_list_index > 0){
    names(motifs_list) <- motifs_list_names
    return(motifs_list)
  }else{
    return(NULL)
  }
}


get_motif_analysis_summary <- function(
    foreground,
    background,
    center='S',
    min_sequence_count = 1,
    min_pvalue = 0.01
){
  check_result_list <- check_mea_input(foreground, background, center)
  loop_foreground <- check_result_list$foreground
  loop_background <- check_result_list$background
  motif_result_list <- list()
  motif_result_list_index <- 0
  while(length(loop_foreground) >= min_sequence_count){
    cat('\n')
    cat(length(loop_foreground))
    cat('\n')
    cat(min_sequence_count)
    cat("一轮")
    motif_result_loop_i <- seach_motif_pattern(
      loop_foreground,
      loop_background,
      min_sequence_count = min_sequence_count,
      min_pvalue = min_pvalue,
      center = center,
      width = check_result_list$width
    )
    if(is.null(motif_result_loop_i)){
      break
    }
    motif_result_list_index <- motif_result_list_index + 1
    motif_result_list[[motif_result_list_index]] <- motif_result_loop_i
    loop_foreground <- loop_foreground[!grepl(motif_result_loop_i$motif_pattern, loop_foreground)]
    loop_background <- loop_background[!grepl(motif_result_loop_i$motif_pattern, loop_background)]
  }
  
  summry_list <- data.frame(
    motif = vapply(motif_result_list, function(x){x$motif_pattern},c('character')),
    score = vapply(motif_result_list, function(x){x$motif_pattern_score}, c(1)),
    foreground_matches = vapply(motif_result_list, function(x){x$foreground_matches}, 1),
    foreground_size = vapply(motif_result_list, function(x){x$foreground_size}, 1),
    background_matches = vapply(motif_result_list, function(x){x$background_matches}, 1),
    background_size = vapply(motif_result_list, function(x){x$background_size}, 1)
  )
  
  foreground_fold_increase <- summry_list$foreground_matches/summry_list$foreground_size
  background_fold_increase <- summry_list$background_matches/summry_list$background_size
  summry_list$fold_increase <- foreground_fold_increase/background_fold_increase
  
  if(nrow(summry_list) == 0){
    return(NULL)
  }
  return(summry_list)
}


get_normalized_data_of_psites2 <- function(data_frame, experiment_code_file_path, nathreshold, normmethod = "global", imputemethod = "minimum/10", topN = NA, mod_types = c('S', 'T', 'Y')){
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
  if(imputemethod=="0"){
    ptypes_value_FOT5[index_of_zero] <- 0
  }else if(imputemethod=="minimum"){
    min_value_of_non_zero <- min(ptypes_value_FOT5[-index_of_zero])
    ptypes_value_FOT5[index_of_zero] <- min_value_of_non_zero
  }else if(imputemethod=="minimum/10"){
    min_value_of_non_zero <- min(ptypes_value_FOT5[-index_of_zero])
    ptypes_value_FOT5[index_of_zero] <- min_value_of_non_zero*0.1
  }
  
  ptypes_df_list <- list(
    ptypes_area_df_with_id = data.frame(ptypes_id_df, ptypes_value),
    ptypes_fot5_df_with_id = data.frame(ptypes_id_df, ptypes_value_FOT5)
  )
  
  cat('\n The 7th step is over ^_^.')
  return(ptypes_df_list)
}


get_normalized_data_FOT52 <- function(data_frame, experiment_code_file_path, normmethod = "global", imputemethod = "minimum/10"){
  requireNamespace('utils')
  cat('\n The 7th step: Normalize data and filter data only including phosphorylation site.')
  experiment_code <- utils::read.table(experiment_code_file_path, header = TRUE, sep = '\t', stringsAsFactors = NA)
  experiment_code <- as.vector(unlist(experiment_code$Experiment_Code))
  data_frame_colnames <- colnames(data_frame)
  ID <- as.vector(data_frame[,1])
  Value_raw <- data_frame[,-1]
  Value_FOT5 <- Value_raw
  Value_FOT5_col <- ncol(Value_FOT5)
  if(normmethod == "global") {
    for(i in seq_len(Value_FOT5_col)){
      x <- Value_raw[,i]
      valid_index <- which(x>0)
      valid_x <- x[valid_index]
      valid_x_sum <- sum(valid_x)
      valid_x_FOT5 <- valid_x/valid_x_sum*1e5
      Value_FOT5[valid_index,i] <- valid_x_FOT5
    }
  } else if(normmethod == "median") {
    for(i in seq_len(Value_FOT5_col)){
      x <- Value_raw[,i]
      valid_index <- which(x>0)
      valid_x <- x[valid_index]
      valid_x_median <- median(valid_x)
      valid_x_FOT5 <- valid_x/valid_x_median*1e5
      Value_FOT5[valid_index,i] <- valid_x_FOT5
    }
  }
  Value_FOT5 <- as.matrix(Value_FOT5)
  
  index_of_zero <- which(Value_FOT5==0)
  if(imputemethod=="0"){
    Value_FOT5[index_of_zero] <- 0
  }else if(imputemethod=="minimum"){
    min_value_of_non_zero <- min(Value_FOT5[-index_of_zero])
    Value_FOT5[index_of_zero] <- min_value_of_non_zero
  }else if(imputemethod=="minimum/10"){
    min_value_of_non_zero <- min(Value_FOT5[-index_of_zero])
    Value_FOT5[index_of_zero] <- min_value_of_non_zero*0.1
  }
  
  data_frame_normaliation <- data.frame(ID, Value_FOT5)
  data_frame_normaliation_colnames <- c(data_frame_colnames[1], experiment_code)
  colnames(data_frame_normaliation) <- data_frame_normaliation_colnames
  return(data_frame_normaliation)
}

