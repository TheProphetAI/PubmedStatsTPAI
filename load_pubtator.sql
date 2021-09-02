drop table if exists pubtator.medic_diseases ;
create table pubtator.medic_diseases (
	DiseaseName varchar,
	DiseaseID   varchar,
	AltDiseaseIDs   varchar,
	"Definition"  varchar,
	ParentIDs   varchar,
	TreeNumbers varchar,
	ParentTreeNumbers   varchar,
	Synonyms    varchar,
	SlimMappings    varchar
);

copy pubtator.medic_diseases
from '/tmp/CTD_diseases.csv'
csv;

CREATE INDEX medic_diseases_diseaseid_idx ON pubtator.medic_diseases (diseaseid);


drop table if exists pubtator.gene2ncbi ;
create table if not exists pubtator.gene2ncbi (
	genesymbol	varchar,
	ncbi_id	varchar,
	source	varchar
);

copy pubtator.gene2ncbi
from '/tmp/Sym_NCBI_id.tab'
with delimiter E'\t';

CREATE INDEX gene2ncbi_genesymbol_idx ON pubtator.gene2ncbi (genesymbol);
CREATE INDEX gene2ncbi_ncbi_id_idx ON pubtator.gene2ncbi (ncbi_id);


drop table if exists pubtator.bioconcepts2pubtatorcentral ;
create table if not exists pubtator.bioconcepts2pubtatorcentral (
	pmid	varchar,
	"type"	varchar,
	concept_id	varchar,
	"name"	varchar,
	origin	varchar
);

copy pubtator.bioconcepts2pubtatorcentral(
	pmid,
	"type",
	concept_id,
	"name",
	origin
)
from '/tmp/bioconcepts2pubtatorcentral_edit'
with delimiter E'\t';

CREATE INDEX bioconcepts2pubtatorcentral_pmid_idx ON pubtator.bioconcepts2pubtatorcentral (pmid);
CREATE INDEX bioconcepts2pubtatorcentral_concept_id_idx ON pubtator.bioconcepts2pubtatorcentral (concept_id);
CREATE INDEX bioconcepts2pubtatorcentral_type_idx ON pubtator.bioconcepts2pubtatorcentral ("type");



