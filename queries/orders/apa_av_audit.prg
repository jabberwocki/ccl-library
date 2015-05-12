select
    status_message = substring(1,200
    , rxaa.status_message)
    , Selected_IV_set = substring(1,60,mi.value)
    , Products_In_set = substring(1,40, mi1.value)

from
    rx_auto_verify_audit rxav
    , rx_product_assign_audit rxaa
    , med_identifier mi
    , med_identifier mi1

plan rxav
    where rxav.order_id = 671734019  ;enter order_id here

join rxaa
    where rxaa.catalog_group_id = rxav.catalog_group_id
join mi
    where mi.item_id = outerjoin(rxaa.set_item_id)
    and mi.med_identifier_type_cd = outerjoin(3097)
    and mi.primary_ind = outerjoin(1)
join mi1
    where mi1.item_id = outerjoin(rxaa.item_id)
    and mi1.med_product_id = outerjoin(0)
    and mi1.med_identifier_type_cd = outerjoin(3097))

with time = 30
