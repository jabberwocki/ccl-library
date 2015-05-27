/*************************************************************************
Title: Physicians without SPIs
Author: J. Aaron Britton
Contact: jaaron.britton@gmail.com
Purpose: To show active personnel with a physician flag of "1" who do not
  have an SPI number assigned.
*************************************************************************/

select distinct
	pe.name_last_key
	, pe.name_first_key
	, pa.alias
	, alias_type_display = uar_get_code_display(pa.prsnl_alias_type_cd)
	, p.physician_ind
	, pe.person_id

from
	 person pe
	,prsnl p
	, prsnl_alias pa 

plan pe
	where pe.active_ind = 1

join p
	where pe.person_id = p.person_id
	and p.physician_ind = 1
	and p.active_ind = 1

join pa	
	where pe.person_id = pa.person_id
	and pa.prsnl_alias_type_cd = value(uar_get_code_by("MEANING", 320, "SPI"))
	and pa.alias in (" ", "", null )
	

order 
	 pe.name_last_key
	, pe.name_first_key

WITH NOCOUNTER, SEPARATOR=" ", FORMAT, time= 180
