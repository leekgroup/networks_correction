source dirconfig
mkdir $datDir/genesets/
cd $datDir/genesets/
wget -O kegg2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=KEGG_2016"
wget -O biocarta2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=BioCarta_2016"
wget -O reactome2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=Reactome_2016"
wget -O pid2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=NCI-Nature_2016"
wget -O tmp.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=ChEA_2016"
wget -O gobp2017.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=GO_Biological_Process_2017b"
wget -O humanpheno.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=Human_Phenotype_Ontology"
grep Human tmp.txt >tft.txt
rm tmp.txt

## remove 1.0s
sed -i 's/1\.0//g' tft.txt
sed -i 's/1\.0//g' kegg2016.txt
sed -i 's/1\.0//g' biocarta2016.txt
sed -i 's/1\.0//g' reactome2016.txt
sed -i 's/1\.0//g' pid2016.txt
sed -i 's/1\.0//g' gobp2017.txt

cat *2016.txt >canonical_pathways_merged.txt
sed -i 's/,\t/,/g' canonical_pathways_merged.txt
sed -i 's/,\t/,/g' gobp2017.txt
sed -i 's/,\t/,/g' tft.txt
sed -i 's/,\t/,/g' kegg2016.txt
sed -i 's/,\t/,/g' biocarta2016.txt
sed -i 's/,\t/,/g' reactome2016.txt
sed -i 's/,\t/,/g' pid2016.txt
sed -i 's/\t/,/g;s/,,/\t/' humanpheno.txt
sed -i 's/,\t$//g' tft.txt 

## get list of pseudogenes
mkdir $datDir/etc/
cd $datDir/etc/
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.annotation.gff3.gz
gunzip gencode.v25.annotation.gff3.gz
awk '$3 == "gene" { print $0}' gencode.v25.annotation.gff3 | grep gene_type=protein_coding | cut -d";" -f1 | cut -f1,9 | sed 's/ID=//g' | sort >protein_coding.txt

## fasta file for computing GC content of genes
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_25/gencode.v25.pc_transcripts.fa.gz
gunzip gencode.v25.pc_transcripts.fa.gz

## get exon and utr positions by ensembl gene id --> to filter out overlapping genes
cut -f1,3,4,5,7,9 gencode.v25.annotation.gff3 | cut -d';' -f1,3,7 | grep 'UTR\|exon' | sed 's/;gene\_id\=/\t/g'| sed 's/;gene\_name\=/\t/g' | cut -f1,2,3,4,5,7,8  >gencode_exon_utr_position_bygene.txt
