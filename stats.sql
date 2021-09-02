
-- total n of authors (group by name, surname, orcid if present)
drop materialized view if exists pubtator.metrics ;
create materialized view pubtator.metrics as
	select 
		'n_distinct_genes' as metric,
		count(distinct bp.concept_id) as value
	from pubtator.bioconcepts2pubtatorcentral bp 
	join pubtator.gene2ncbi gn on bp.concept_id = gn.ncbi_id 
	where "type" = 'Gene' 
	union
	select 
		'n_distinct_diseases' as metric,
		count(distinct bp.concept_id) as value
	from pubtator.bioconcepts2pubtatorcentral bp 
	where "type" = 'Disease' 
	union
	select 
		'total_gene_citations' as metric,
		count(distinct bp.pmid) as value
	from pubtator.bioconcepts2pubtatorcentral bp
	where bp."type" = 'Gene'
	union
	select 
		'total_disease_citations' as metric,
		count(distinct bp.pmid) as value
	from pubtator.bioconcepts2pubtatorcentral bp
	where bp."type" = 'Disease'
	union
	select 
		'total_n_authors' as metric,
		count(1) as value
	from (
		select a.forename, a.lastname, a2.value
		from public.author a
		join public.authoridentifier a2 on a.id = a2.authorid 
		group by a.forename, a.lastname, a2.value 
	) as foo
;

-- top 100 most cited genes
drop materialized view if exists pubtator.top100_most_cited_genes ;
create materialized view pubtator.top100_most_cited_genes as
	select 
		gn.genesymbol ,
		count(distinct bp.pmid) as article_count
	from pubtator.bioconcepts2pubtatorcentral bp 
	join pubtator.gene2ncbi gn on bp.concept_id = gn.ncbi_id 
	where bp."type" = 'Gene'
	group by gn.genesymbol
	order by article_count desc
	limit 100 
;

-- same with last year
drop materialized view if exists pubtator.top100_most_cited_genes_year ;
create materialized view pubtator.top100_most_cited_genes_year as
	select 
		gn.genesymbol ,
		count(distinct bp.pmid) as article_count
	from pubtator.bioconcepts2pubtatorcentral bp 
	join pubtator.gene2ncbi gn on bp.concept_id = gn.ncbi_id
	join public.article a on bp.pmid = a.pmid 
	where bp."type" = 'Gene'
		and a.pubdate > (current_date - interval '1 year')
	group by gn.genesymbol
	order by article_count desc
	limit 100 
;



	
-- top 100 most cited diseases
drop materialized view if exists pubtator.top100_most_cited_diseases ;
create materialized view pubtator.top100_most_cited_diseases as
	select 
		initcap(md.diseasename) ,
		count(distinct bp.pmid) as article_count
	from pubtator.bioconcepts2pubtatorcentral bp  
	join pubtator.medic_diseases md on bp.concept_id = md.diseaseid 
	where bp."type" = 'Disease'
	group by md.diseasename 
	order by article_count desc
	limit 100 
;


-- same with last year
drop materialized view if exists pubtator.top100_most_cited_diseases_year ;
create materialized view pubtator.top100_most_cited_diseases_year as
	select 
		md.diseasename ,
		count(distinct bp.pmid) as article_count
	from pubtator.bioconcepts2pubtatorcentral bp 
	join pubtator.medic_diseases md on bp.concept_id = md.diseaseid 	
	join public.article a on bp.pmid = a.pmid 
	where bp."type" = 'Disease'
		and a.pubdate > (current_date - interval '1 year')
	group by md.diseasename
	order by article_count desc
	limit 100 
;
	
	
	
	