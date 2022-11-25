Content: These subfiles contain ID and protein sequences for the specified species. 

Source: NCBI RefSeq

Format: Fasta. Consists of two columns(GI number and Sequences), separated by Tab. 

Uses: When PhosMap performs the following functions,

	1. Map phosphorylation sites to protein sequence and eliminate redundancy.
	2. Kinase-substrate enrichment analysis (KSEA)
	3. Motif enrichment
	
This data set will be required. 


Additional: While the "get_summary_with_unique_sites", "get_summary_from_ksea" or "get_aligned_seq_for_mea" function is first invoked on the platform, the file will be automatically downloaded to the user's platform if the "species" and "refseq_fasta" parameters are specified correctly.
