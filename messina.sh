#!/bin/bash


###################### Walkthrough Propheta A.I. database ######################
#### Scarichiamo il database custom da HGNC, dal seguente link:
# https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_app_name&col=gd_status&col=gd_prev_sym&col=gd_aliases&col=gd_pub_acc_ids&col=gd_pub_refseq_ids&col=md_prot_id&col=gd_enz_ids&col=gd_pub_eg_id&col=gd_pub_ensembl_id&col=gd_mgd_id&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit

curl --get "https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_app_name&col=gd_status&col=gd_prev_sym&col=gd_aliases&col=gd_pub_acc_ids&col=gd_pub_refseq_ids&col=md_prot_id&col=gd_enz_ids&col=gd_pub_eg_id&col=gd_pub_ensembl_id&col=gd_mgd_id&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit" --output HGNC_custom_download.txt

#### Il contenuto della ricerca customizzata viene copiato in un file denominato HGNC_custom_database.txt
cat HGNC_custom_download.txt | awk 'BEGIN{FS=OFS="\t"}{if($4=="Approved") {print $2,$1,"gd_hgnc_id" > "Sym_HGNC.tab" ; print $2,$3,"gd_app_name" > "Sym_Name.tab" ; print $2,$4,"gd_status" > "Sym_status.tab" ; print $2,$5,"gs_prev_sym" > "Sym_PrevSym.tab" ; print $2,$6,"gd_aliases" > "Sym_SymAlias.tab" ; print $2,$7,"gd_pub_acc_ids" > "Sym_AccNumb.tab" ; print $2,$8,"gd_pub_refseq_ids" > "Sym_RefSeqId.tab" ; print $2,$9,"md_prot_id" > "Sym_UniProt.tab" ; print $2,$10,"gd_enz_ids" > "Sym_EnzID.tab" ; print $2,$11,"gd_pub_eg_id" > "Sym_NCBI_id.tab" ; print $2,$12,"gd_pub_ensembl_id" > "Sym_EnsemblID.tab"; print $2,$13,"gd_mgd_id" > "Sym_MGDB_ID.tab"} else if($3~"symbol") {split($3,a,"["); split(a[2],b,"]"); print $2,$1,b[1] > "Sym_withdrawn_PrevHGNC_NewHGNC.tab"}}'

### Editiamo i simboli con gli alias dei simboli così da avere righe multiple per Sym con alias multipli
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_SymAlias.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_SymAlias.2.tab
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_UniProt.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_UniProt.2.tab 
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_AccNumb.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_AccNumb.2.tab 
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_EnzID.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_EnzID.2.tab 
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_MGDB_ID.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_MGDB_ID.2.tab 
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_PrevSym.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_PrevSym.2.tab
awk 'BEGIN{FS=OFS="\t"}{gsub(",", "\t", $2); print $1,$3,$2}' Sym_RefSeqId.tab | awk 'BEGIN{FS=OFS="\t"}{for( i=3; i<=NF; i++) print $1,$i,$2}' | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_RefSeqID.2.tab

### Generiamo il file contenente i vecchi HGNCID corrispondenti agli attuali Sym
awk 'BEGIN{FS=OFS="\t"}{if(FILENAME=="Sym_withdrawn_PrevHGNC_NewHGNC.tab") {var[$3]=$2} else {print $1,var[$2],"withdrawn_hgnc_id"}}'  Sym_withdrawn_PrevHGNC_NewHGNC.tab Sym_HGNC.tab | awk 'BEGIN{FS=OFS="\t"}{if($2!="") print}' > Sym_withdrawn_hgncId.tab
cat Sym_HGNC.tab Sym_withdrawn_hgncId.tab | sort -k1,1 -k2,2 > Sym_HGNC_ID.all.tab

### Quindi creiamo una cartella che contenga tutti i dati derivanti da HGNC formattati come richiesto,
mkdir HGNC_sym
mv Sym_HGNC_ID.all.tab HGNC_sym/ 
mv Sym_RefSeqID.2.tab HGNC_sym/
mv Sym_UniProt.2.tab HGNC_sym/
mv Sym_AccNumb.2.tab HGNC_sym/
mv Sym_EnzID.2.tab HGNC_sym/
mv Sym_MGDB_ID.2.tab HGNC_sym/
mv Sym_EnsemblID.tab HGNC_sym/
mv Sym_Name.tab HGNC_sym/
mv Sym_NCBI_id.tab HGNC_sym/
mv Sym_status.tab HGNC_sym/
cat Sym_PrevSym.2.tab Sym_SymAlias.2.tab | sort -k1,1 -k2,2 > HGNC_sym/Sym_PrevSym_SymAlias.final.tab 

### I rimanenti dataset grezzi vengono spostati in una cartella denominata intermediate_files
mkdir intermediate_files
mv Sym_* intermediate_files/


