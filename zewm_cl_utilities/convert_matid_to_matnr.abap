
**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Convert Matid to Material
**************************************************************************

  method convert_matid_to_matnr.

    call function 'CONVERSION_EXIT_MDLPD_OUTPUT'
      exporting
        input  = i_matid
      importing
        output = r_matnr.

    call function 'CONVERSION_EXIT_MATN1_INPUT'
      exporting
        input  = r_matnr
      importing
        output = r_matnr.

  endmethod.