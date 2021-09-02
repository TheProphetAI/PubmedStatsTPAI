#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/pub/lu/PubTatorCentral/bioconcepts2pubtatorcentral.gz

gunzip bioconcepts2pubtatorcentral.gz
sed 's/\\/ /g' bioconcepts2pubtatorcentral > bioconcepts2pubtatorcentral_edit

mv bioconcepts2pubtatorcentral_edit /tmp

source messina.sh 
cp HGNC_sym/Sym_NCBI_id.tab /tmp

source medic.sh
cp CTD_diseases.csv /tmp

psql -h localhost -p 5433 -U postgres -d pubmed -a -f load_pubtator.sql

rm bioconcepts2pubtatorcentral
rm /tmp/bioconcepts2pubtatorcentral_edit

rm HGNC_custom_download
rm -r HGNC_sym
rm -r intermediate_files
rm /tmp/Sym_NCBI_id.tab

rm CTD_diseases*
rm /tmp/CTD_diseases.csv