/**************************************************************************
Query: New Product List 
Purpose: List new products added since the date entered on the query below 
along with the NDC, CDM, HCPCS code, and last person to update the product. 
Author:: J. Aaron Britton
Date: 05/05/2015
**************************************************************************/


select distinct
        ITEM_ID = id.item_id
        , NDC = mi.value
        , DESCRIPTION = oii.value
        , CDM = mi3.value
        , JCODE = mi2.value
        , id.create_dt_tm
        , p.name_full_formatted
 from
        item_definition id,
        med_identifier mi,
        med_identifier mi2,
        med_identifier mi3,
        object_identifier_index oii,
        person p
plan id
        where id.item_type_cd = 3122.00
        and id. active_ind = 1
        and id.create_dt_tm > CNVTDATE(10012013)   ;enter date here in mmddyyyy format 
join mi
        where mi.item_id = id.item_id 
	and mi.med_identifier_type_cd=3104 ;NDC
	and mi.active_ind = 1
join mi2
	where mi2.item_id = id.item_id 
	and mi2.med_identifier_type_cd = 615035 ;HCPCS Code 
	and mi2.active_ind = 1
join mi3
	where mi3.item_id = id.item_id 
	and mi3.med_identifier_type_cd = 3096 ;CDM 
	and mi3.active_ind = 1
join oii
        where id.item_id = oii.object_id 
	and oii.generic_object = 0.0 
	and oii.identifier_type_cd = 3097.00 ;Description
        and oii.active_ind = 1
join p
        where p.person_id = id.updt_id

order by id.create_dt_tm

with time = 60
