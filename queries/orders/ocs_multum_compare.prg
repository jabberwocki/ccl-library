/**************************************************************************
Query: Compare Order Catalog Synonyms to Multum Content
Purpose: Allow users to view the current mapping of pharmacy order catalog
synonyms and as well as compare the set OEF to the Multum Catalog Load table.
Author:: J. Aaron Britton
Date: 03/30/2015
**************************************************************************/


SELECT DISTINCT
	oc.primary_mnemonic
	, primary_cki = oc.cki
	, mnemonic_type = uar_get_code_display(ocs.mnemonic_type_cd)
	, current_syn_oef = oef.oe_format_name
	, ocs.mnemonic
	, synonym_cki = ocs.cki
	, multum_load_cki = mocl.synonym_cki
	, multum_synonym_name = mdn.drug_name
	, mltm_function_syn_match = evaluate (mdnm.function_id, 16, "Primary", 17, "Brand Name", 26, "C", 59, "M or Y", 60, 
		"N or Z", 62, "E")
	, mltm_load_syn_oef = mocl.order_entry_format

FROM
	order_catalog_synonym   ocs
	, mltm_drug_name   mdn
	, mltm_drug_name_map   mdnm
	, mltm_mmdc_name_map   mmnm
	, order_catalog   oc
	, mltm_order_catalog_load mocl
	, order_entry_format oef

plan oc
	where oc.active_ind = 1
	and oc.catalog_type_cd = 2516
	and cnvtlower(oc.primary_mnemonic) = value(cnvtlower("alpr*")) ;enter desired primary here (case insensitive)
		
join ocs 
	where oc.catalog_cd = ocs.catalog_cd	   
join mdn
    where outerjoin(ocs.cki) = concat("MUL.ORD-SYN!",trim(cnvtstring(mdn.drug_synonym_id)))
join mdnm
    where mdn.drug_synonym_id = mdnm.drug_synonym_id
join mmnm
    where mdn.drug_synonym_id = mmnm.drug_synonym_id
join mocl
	where ocs.cki = mocl.synonym_cki
join oef
	where ocs.oe_format_id = oef.oe_format_id

order by
	oc.primary_mnemonic
	, ocs.mnemonic_type_cd
	, ocs.mnemonic
	, mdn.drug_synonym_id

WITH MAXREC = 3000, timeout = 60
