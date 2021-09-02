wget http://ctdbase.org/reports/CTD_diseases.csv.gz

gunzip CTD_diseases.csv.gz
sed -i '1,29d'  

