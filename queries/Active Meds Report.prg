
SELECT 
   P.NAME_FULL_FORMATTED 
   , FIN = SUBSTRING (1 ,25 ,EA.ALIAS )                                                                                            
   , REG_DT = E.REG_DT_TM                                                                                                          
   , DISCH_DT = E.DISCH_DT_TM                                                                                                      
   , ENCTRSTATUS = UAR_GET_CODE_DISPLAY (E.ENCNTR_STATUS_CD )                                                                      
   , FACILITY = UAR_GET_CODE_DISPLAY (E.LOC_FACILITY_CD )                                                                          
   , E.LOC_FACILITY_CD                                                                                                             
   , E_LOC_NURSE_UNIT_DISP = UAR_GET_CODE_DISPLAY (E.LOC_NURSE_UNIT_CD )                                                           
   , ENCNTR_TYPE = UAR_GET_CODE_DISPLAY (E.ENCNTR_TYPE_CD )                                                                        
   , CKI = SUBSTRING (1 ,20 ,O.CKI )                                                                                               
   , PRIMARY = SUBSTRING (1 ,30 ,O.ORDER_MNEMONIC )                                                                                
   , ORDER_STATUS = UAR_GET_CODE_DISPLAY (O.ORDER_STATUS_CD )                                                                      
   , O.ORDER_ID                                                                                                                    
   , O.CLINICAL_DISPLAY_LINE                                                                                                       
   , O.CURRENT_START_DT_TM                                                                                                         
   , O.PROJECTED_STOP_DT_TM                                                                                                        
   , STOPTYPE = UAR_GET_CODE_DISPLAY (O.STOP_TYPE_CD )                                                                             
   , O.CATALOG_CD                                                                                                                  
   , O.ORIG_ORD_AS_FLAG                                                                                                             
   
FROM
   ORDERS O                                                                                                               
   , ENCNTR_ALIAS EA                                                                                                             
   , ENCOUNTER E                                                                                                                 
   , PERSON P
                                                                                                                     
PLAN O                                                                                                                        
   WHERE (O.ORIG_ORDER_DT_TM BETWEEN rdbbind(CNVTDATETIME (rdbbind(_$BEGDATE))) 
	AND rdbbind(                                    
   	CNVTDATETIME (rdbbind(_$ENDDATE)))) 
	AND ((O.ORDER_STATUS_CD + 0) 
		IN (2550                                                
   		, 2548                                                                                                                          
   		, 2546                                                                                                                          
   		, 2547                                                                                                                          
   		, 2552                                                                                                                          
   		, 2549 )) 
  	AND ((O.ACTIVITY_TYPE_CD + 0) = 705) 
	AND ((O.TEMPLATE_ORDER_ID + 0) = 0) 
	AND (O.ORIG_ORD_AS_FLAG != 2) 
	AND (O.CATALOG_CD IN (rdbbind(_$CATALOGCD)))                                                     
   AND E                                                                                                                         
   	WHERE (O.ENCNTR_ID = E.ENCNTR_ID)                                                                                            
   AND EA                                                                                                                        
   	WHERE (EA.ENCNTR_ID = E.ENCNTR_ID) 
		AND (EA.ENCNTR_ALIAS_TYPE_CD = 1077) 
		AND (EA.ACTIVE_IND = 1)                             
   AND P                                                                                                                         
   	WHERE (P.PERSON_ID = E.PERSON_ID ))                                                                                           
   
WITH time = 60
