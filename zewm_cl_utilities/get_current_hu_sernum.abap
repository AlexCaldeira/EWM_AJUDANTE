**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Get current highest serial number (Grouped By Order)
**************************************************************************

  method get_current_hu_sernum.

    data r_serial_hutype_ewm type range of /scwm/de_hutyp.
    data v_aufnr             type aufnr.
    data v_serial            type exidv2.
    data s_huserial          type ty_hu_serial.


    v_aufnr = |{ iv_aufnr alpha = in }|.

    " Get all SAMPLE/VOLUME HUs created for Order (and saved on HU History table)
    select huident, hutype, aufnr
      into table @data(lt_hu_history)
      from zpp_t_histo_hu
     where aufnr  eq @v_aufnr
*       and hutype in @r_serial_hutype_ewm. " Only select Serial Number HUs
       and hutype eq @iv_hutype. " Only select Serial Number HUs

    if sy-subrc is not initial.
      " No HUs found for Order, no serial numbers used for Order, answer is Zero
      return.
    endif.

    " Get current highest HU serial number (EXIDV2)
    " SELECT MAX was not used because EXIDV2 is a CHAR field (value input may have been wrongly formated)
    select exidv, exidv2
      into table @data(lt_hu_serials)
      from vekp
       for all entries in @lt_hu_history
     where exidv       eq @lt_hu_history-huident.

    if sy-subrc is not initial.
      " No known HU found, answer is Zero
      return.
    endif.

    loop at lt_hu_serials into data(ls_hu_serial).

      " Convert HU serial number to Input value
      v_serial = |{ ls_hu_serial-exidv2 }|.

      " Check if serial is bigger, greater, faster than the last one
      if v_serial gt s_huserial-serial.
        s_huserial = ls_hu_serial.
      endif.

    endloop.

    es_huserial = s_huserial.

  endmethod.