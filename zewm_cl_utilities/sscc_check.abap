**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description:Check SSCC format
**************************************************************************

  method sscc_check.

    call function 'LE_SSCC_CHECK'
      exporting
        if_sscc                 = if_sscc
        if_werk                 = if_werk
        if_lgort                = if_lgort
        if_lgnum                = if_lgnum
        if_huart                = if_huart
        if_foreign_sscc         = if_foreign_sscc
        if_bapi_call            = if_bapi_call
      exceptions
        iln_not_found           = 1
        invalid_call            = 2
        invalid_customizing     = 3
        invalid_iln             = 4
        invalid_no_out_of_range = 5
        invalid_sscc            = 6
        internal_error          = 7
        error_on_number_range   = 8
        others                  = 9.

    if sy-subrc eq 1.
      raise iln_not_found.
    elseif sy-subrc eq 2.
      raise invalid_call.
    elseif sy-subrc eq 3.
      raise invalid_customizing.
    elseif sy-subrc eq 4.
      raise invalid_iln.
    elseif sy-subrc eq 5.
      raise invalid_no_out_of_range.
    elseif sy-subrc eq 6.
      raise invalid_sscc.
    elseif sy-subrc eq 7.
      raise internal_error.
    elseif sy-subrc eq 8.
      raise error_on_number_range.
    endif.

  endmethod.