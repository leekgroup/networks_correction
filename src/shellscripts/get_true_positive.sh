mkdir ../data/genesets/
cd ../data/genesets/
wget -O kegg2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=KEGG_2016"
wget -O biocarta2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=BioCarta_2016"
wget -O reactome2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=Reactome_2016"
wget -O pid2016.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=NCI-Nature_2016"
wget -O tmp.txt "http://amp.pharm.mssm.edu/Enrichr/geneSetLibrary?mode=text&libraryName=ChEA_2016"

grep Human tmp.txt >tft.txt
rm tmp.txt

## remove 1.0s
sed -i 's/1\.0//g' tft.txt
sed -i 's/1\.0//g' kegg2016.txt
sed -i 's/1\.0//g' biocarta2016.txt
sed -i 's/1\.0//g' reactome2016.txt
sed -i 's/1\.0//g' pid2016.txt

cat *2016.txt >canonical_pathways_merged.txt
sed -i 's/,\t/,/g' canonical_pathways_merged.txt
## get list of pseudogenes
mkdir ../etc/
cd ../etc/
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.annotation.gff3.gz
gunzip gencode.v25.annotation.gff3.gz
awk '$3 == "gene" { print $0}' gencode.v25.annotation.gff3 | grep gene_type=protein_coding | cut -d";" -f1 | cut -f1,9 | sed 's/ID=//g' | sort >protein_coding.txt
