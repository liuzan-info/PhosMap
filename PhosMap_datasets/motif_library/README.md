Content: These subfiles contain reference sequences for the specified species.

Source: NCBI RefSeq or Uniprot

Format: The data from RefSeq consists of three columns(GI, GeneSymbol and Aligned_Seq), separated by Tab. Uniprot's data has not been collated


Uses: The motif enrichment function in PhosMap is based on a data frame in foreground that are mapped to specific motif. At this point, the data set needs to be loaded.

Additional: While the "get_foreground_df_to_motifs" function is first invoked on the platform, the file will be automatically downloaded to the user's platform.
