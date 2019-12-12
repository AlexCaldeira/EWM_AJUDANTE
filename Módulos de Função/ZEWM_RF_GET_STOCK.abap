FUNCTION zewm_rf_get_stock.
*"----------------------------------------------------------------------
*"*"Interface local:
*" IMPORTING
*" REFERENCE(I_LGNUM) TYPE /SCWM/LGNUM
*" REFERENCE(I_BARCODE) TYPE BARCODE
*" REFERENCE(I_CHECK_STOCK) TYPE FLAG OPTIONAL
*" EXPORTING
*" REFERENCE(T_MESSAGES) TYPE TAB_BDCMSGCOLL
*" TABLES
*" T_AQUA STRUCTURE /SCWM/AQUA
*" CHANGING
*" REFERENCE(LGPLA) TYPE /SCWM/LGPLA OPTIONAL
*" REFERENCE(HUIDENT) TYPE /SCWM/HUIDENT OPTIONAL
*"----------------------------------------------------------------------

* Global data declarations

*Descrição: Devolve stock para os parametros indicados

  DATA: ls_ewm_lagp TYPE /scwm/lagp,
        lv_lgpla    TYPE /scwm/lgpla,
        lv_hu       TYPE /scwm/huident.

  DATA: lt_huhdr    TYPE /scwm/tt_huhdr_int,
        lt_huitm    TYPE /scwm/tt_huitm_int,
        ls_huhdr    LIKE LINE OF lt_huhdr,
        lt_messages TYPE tab_bdcmsgcoll,
        ls_message  TYPE bdcmsgcoll.


*Valida se barcode é posição
  lv_lgpla = i_barcode.
  CONDENSE lv_lgpla.

  SELECT * FROM /scwm/lagp UP TO 1 ROWS
     INTO ls_ewm_lagp
                WHERE lgnum = i_lgnum AND
                      lgpla = lv_lgpla.
  ENDSELECT.



  IF ls_ewm_lagp IS INITIAL.
*Valida se HU
    lv_hu = i_barcode.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_hu
      IMPORTING
        output = lv_hu.

    CONDENSE lv_hu.

    call function 'ZEWM_CHECK_HU'
      EXPORTING
        lgnum      = i_lgnum
        hu         = lv_hu
      IMPORTING
        t_huhdr    = lt_huhdr
        t_huitm    = lt_huitm
        t_messages = lt_messages
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    IF sy-subrc <> 0.
      APPEND LINES OF lt_messages TO t_messages.
      RAISE error.
    ENDIF.

    READ TABLE lt_huhdr INTO ls_huhdr INDEX 1.

    SELECT * FROM /scwm/lagp UP TO 1 ROWS
    INTO ls_ewm_lagp
               WHERE lgnum = i_lgnum AND
                     lgpla = ls_huhdr-lgpla.
    ENDSELECT.
  ENDIF.


  IF ls_ewm_lagp IS NOT INITIAL.

*Valida bloqueios da posição
    IF ls_ewm_lagp-skzua IS NOT INITIAL.
* Posição & bloqueada para saída
      ls_message-msgid = 'ZEWM'.
      ls_message-msgnr = '002'.
      ls_message-msgtyp = 'E'.
      ls_message-msgv1 = ls_ewm_lagp-lgpla.

      APPEND ls_message TO t_messages.
      RAISE error.
    ENDIF.

    SELECT * FROM /scwm/aqua INTO TABLE t_aqua WHERE lgnum = i_lgnum
    AND lgpla = ls_ewm_lagp-lgpla ORDER BY PRIMARY KEY.

* Se foi indicada HU, ficar apenas com o stock da palete
    IF lv_hu IS NOT INITIAL.
      DELETE t_aqua WHERE huident <> lv_hu.
    ENDIF.

    IF t_aqua[] IS INITIAL AND i_check_stock IS NOT INITIAL.
* Posição & sem stock
      ls_message-msgid = 'ZEWM'.
      ls_message-msgnr = '001'.
      ls_message-msgtyp = 'E'.
      ls_message-msgv1 = ls_ewm_lagp-lgpla.

      APPEND ls_message TO t_messages.
      RAISE error.
    ENDIF.

  ENDIF.

  lgpla = ls_ewm_lagp-lgpla.
  huident = ls_huhdr-huident.

ENDFUNCTION.


*Messages
*----------------------------------------------------------
*
* Message class: ZEWM
*102 Remessa já lida.
*111 Data de validade & ultrapassada. Confirma?