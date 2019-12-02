**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Convert Material do MATID
**************************************************************************

  method convert_matnr_to_matid.

    call function 'CONVERSION_EXIT_MDLPD_INPUT'
      exporting
        input  = i_matnr
      importing
        output = r_matid.

  endmethod.