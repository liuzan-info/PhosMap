Content: These files contain multiple IDs for the proteins of the specified species. 

Source: NCBI RefSeq, Uniprot

Format: Consists of five columns, separated by Tab. 

	GeneSymbol, GeneID, RefSeq_Protein_GI, RefSeq_Protein_Accession, Uniprot_Protein_Accession
	

Uses: For conversion between different IDs of the same protein or Mapping protein gi to gene symbol and output expression profile matrix with gene symnol.

Additional: While the "get_combined_data_frame" function is first invoked on the platform, the file will be automatically downloaded to the user's platform if the "species" and "id_type" parameters are specified correctly.

Details: ID conversion tables is for human (taxon id: 9606), mouse (taxon id: 10090) and rattus (taxon id: 10116).
