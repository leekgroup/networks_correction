grep ^\> gencode.v25.pc_transcripts.fa | grep CDS | sed 's/|/\t/g' >annotation_line
cp ../../data/etc/variable_genes_selected.csv .