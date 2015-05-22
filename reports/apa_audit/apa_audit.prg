drop program apa_audit_report go
create program apa_audit_report
 
prompt
	"Output to File/Printer/MINE" = "MINE"                                            ;* Enter or select the printer or file name
	, "Date from (MM/dd/yy)" = CURDATE
	, "Date to (MM/dd/yy)" = CURDATE
	, "Patient's last name (automatically wildcarded and NOT case sensitive)" = ""
	, "Patient's first name (automatically wildcarded and NOT case sensitive)" = ""
	, "Select desired order to audit" = ""
 
with OUTDEV, dateFrom, dateTo, nameLast, nameFirst, auditOID
 
; Request HNAM sign-on when executed from CCL on host
IF (VALIDATE(IsOdbc, 0) = 0)  EXECUTE CCLSECLOGIN  ENDIF
 
if (validate(_SEPARATOR) = 0)
SET _SEPARATOR=^ ^	; applies to query execution from VisualExplorer or other apps
endif
 
SET MaxSecs = 0
IF (VALIDATE(IsOdbc, 0) = 1)  SET MaxSecs = 15  ENDIF
 
select into $OUTDEV
	rxav.order_id
	, product_assign_status_flag = evaluate (rxav.product_assign_status_flag, 0, "0 -Not set", 1, "1 -Failure", 2, "Success")
	, av_fail_reason = uar_get_code_display(rxav.auto_verify_fail_reason_cd)
	, av_flag = evaluate (rxav.discern_auto_verify_flag, 0, "0 -Not set", 1, "1 -No", 2, "2 -No w/Clinical Checking", 3,
		"3 -Yes w/Reason", 4, "3 -Yes")
	, ic_flag =evaluate (rxav.ic_auto_verify_flag, 0, "0 -Not set", 1, "1 -No", 2, "2 -No w/Clinical Checking", 3,
		"3 -Yes w/Reason", 4, "3 -Yes")
	, rxav.order_provider_id
	, order_provider_av_priv_flag = evaluate (rxav.order_provider_av_priv_flag, 0, "0 -Not set", 1, "1 -On", 2, "Off")
	, prsnl_av_priv_flag = evaluate (rxav.prsnl_auto_verify_priv_flag, 0, "0 -Not set", 1, "1 -On", 2, "Off")
	, rxav.rx_auto_verify_audit_id
 
 
from
    rx_auto_verify_audit rxav
 
where rxav.order_id = cnvtreal($auditOID)
with time = 15, NOCOUNTER, SEPARATOR=" ", FORMAT
 
end
go
 
