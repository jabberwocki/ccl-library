 
DROP PROGRAM ocsyn_multum_compare GO
CREATE PROGRAM ocsyn_multum_compare
 
prompt 
	"Output to File/Printer/MINE" = "MINE"                                             ;* Enter or select the printer or file name
	, 'Please enter a complete or partial orderable and press "Tab" to search:' = ''
	, "Primary Synonym:" = 0 

with OUTDEV, orderable, primary
 
; Request HNAM sign-on when executed from CCL on host
IF (VALIDATE(IsOdbc, 0) = 0)  EXECUTE CCLSECLOGIN  ENDIF
 
if (validate(_SEPARATOR) = 0)
SET _SEPARATOR=^ ^	; applies to query execution from VisualExplorer or other apps
endif
 
SET MaxSecs = 0
IF (VALIDATE(IsOdbc, 0) = 1)  SET MaxSecs = 15  ENDIF
 
SELECT DISTINCT
	oc.primary_mnemonic
	, primary_cki = oc.cki
	, mnemonic_type = uar_get_code_display(ocs.mnemonic_type_cd)
	, ocs.mnemonic
	, synonym_cki = ocs.cki
	, multum_synonym_name = mdn.drug_name
	, mltm_function_syn_match = evaluate (mdnm.function_id, 16, "Primary", 17, "Brand Name", 26, "C", 59, "M or Y", 60,
		"N or Z", 62, "E")
	, mmnm.main_multum_drug_code
 
FROM
	order_catalog_synonym   ocs
	, mltm_drug_name   mdn
	, mltm_drug_name_map   mdnm
	, mltm_mmdc_name_map   mmnm
	, order_catalog   oc
 
plan oc
	where oc.catalog_cd=$primary
join ocs
	where oc.catalog_cd = ocs.catalog_cd
join mdn
    where outerjoin(ocs.cki) = concat("MUL.ORD-SYN!",trim(cnvtstring(mdn.drug_synonym_id)))
join mdnm
    where mdn.drug_synonym_id = mdnm.drug_synonym_id
join mmnm
    where mdn.drug_synonym_id = mmnm.drug_synonym_id
 
order by
	oc.primary_mnemonic
	, ocs.mnemonic_type_cd
	, ocs.mnemonic
	, mdn.drug_synonym_id

Head Page
	COL 17  OC.PRIMARY_MNEMONIC
	ROW + 2

Detail
	MNEMONIC1 = SUBSTRING( 1, 25, OCS.MNEMONIC ),
	OCS_MNEMONIC_TYPE_DISP1 = SUBSTRING( 1, 15, UAR_GET_CODE_DISPLAY(OCS.MNEMONIC_TYPE_CD)),
	CKI1 = SUBSTRING( 1, 20, OCS.CKI ),
	COL 13  MNEMONIC1
	COL 41  OCS_MNEMONIC_TYPE_DISP1
	COL 65  CKI1
	COL 89  MMNM.MAIN_MULTUM_DRUG_CODE
	COL 109  MDNM.FUNCTION_ID
	ROW + 1
 
WITH MAXREC = 1000, TIME =  15 

END
GO
 
