FUNCTION zewm_check_hu.
*"----------------------------------------------------------------------
*"*"Interface local:
*" IMPORTING
*" REFERENCE(LGNUM) TYPE /SCWM/LGNUM
*" REFERENCE(HU) TYPE /SCWM/DE_HUIDENT
*" REFERENCE(I_CHECK_ERP) TYPE FLAG OPTIONAL
*" EXPORTING
*" REFERENCE(E_REFDOCNO) TYPE /SCDL/DL_REFDOCNO
*" REFERENCE(ES_VEKP) TYPE VEKP
*" REFERENCE(T_HUHDR) TYPE /SCWM/TT_HUHDR_INT
*" REFERENCE(T_HUITM) TYPE /SCWM/TT_HUITM_INT
*" REFERENCE(T_AQUA) TYPE /SCWM/TT_AQUA
*" REFERENCE(T_VEPO) TYPE TAB_VEPO
*" REFERENCE(T_MESSAGES) TYPE TAB_BDCMSGCOLL
*" EXCEPTIONS
*" ERROR
*"----------------------------------------------------------------------

* Global data declarations

* Descrição: Valida HU EWM, devolve cabeçalho e items


  DATA: ls_ewm_aqua     TYPE /scwm/aqua.
  DATA: lv_guid_hu      TYPE /scwm/guid_hu.
  DATA: lv_docid        TYPE /scwm/de_docid.
  DATA: lv_tabix        LIKE sy-tabix.
  DATA: ls_huitm        TYPE /scwm/s_huitm_int.
  DATA: ls_message      TYPE bdcmsgcoll.
  DATA: ls_gmhuref      TYPE /scwm/gmhuref.
  DATA: ls_docid        TYPE /scwm/dlv_docid_item_str.
  DATA: ls_include_data TYPE /scwm/dlv_query_incl_str_prd.

  DATA:
    lt_cat_so      TYPE rseloption,
    lt_owner_so    TYPE rseloption,
    lt_entitled_so TYPE rseloption,
    lt_charg_so    TYPE rseloption,
    lt_idplate_so  TYPE rseloption,
    lt_serid_so    TYPE rseloption,
    lt_hutyp_so    TYPE rseloption,
    lt_pmat_so     TYPE rseloption,
    lt_pmtyp_so    TYPE rseloption,
    lt_idart_so    TYPE rseloption,
    lt_ident_so    TYPE rseloption,
    ls_matnr_so    TYPE rsdsselopt,
    lt_matnr_so    TYPE rseloption,
    ls_vhi_so      TYPE rsdsselopt,
    lt_vhi_so      TYPE rseloption,
    lt_guid_hu     TYPE /scwm/tt_guid_hu,
    ls_guid_hu     LIKE LINE OF lt_guid_hu,
    ls_huhdr       TYPE /scwm/s_huhdr_int,
    lt_huhdr       TYPE /scwm/tt_huhdr_int,
    lt_huitm       TYPE /scwm/tt_huitm_int,
    lt_resource    TYPE /scwm/tt_guid_loc,
    lt_docid       TYPE /scwm/dlv_docid_item_tab,
    ls_stock_mon   TYPE /scwm/s_stock_mon.


** Verify if the HU exits
  CLEAR lv_guid_hu.
  SELECT  guid_hu UP TO 1 ROWS
    FROM /scwm/huhdr INTO lv_guid_hu
                        WHERE lgnum   = lgnum AND
                              huident = hu AND
                              letyp <> ''.
  ENDSELECT.

  IF sy-subrc = 0.

    ls_guid_hu-guid_hu = lv_guid_hu.
    APPEND ls_guid_hu TO lt_guid_hu.

* Get stock on real HUs only
    ls_vhi_so-sign   = 'I'.
    ls_vhi_so-option = 'EQ'.
    ls_vhi_so-low    = ''.
    APPEND ls_vhi_so TO lt_vhi_so.

    CALL FUNCTION '/SCWM/HU_SELECT_GEN'
      EXPORTING
        iv_lgnum        = lgnum
        it_guid_hu      = lt_guid_hu
* it_guid_lgpla = it_bin
* it_tu = it_tu
        ir_matnr        = lt_matnr_so
* it_matid = it_matid
        ir_batch        = lt_charg_so
        ir_serid        = lt_serid_so
        ir_pmtyp        = lt_pmtyp_so
        ir_pmat         = lt_pmat_so
        ir_hutyp        = lt_hutyp_so
        ir_idplate      = lt_idplate_so
        ir_vhi          = lt_vhi_so
        ir_entitled     = lt_entitled_so
        ir_owner        = lt_owner_so
        ir_cat          = lt_cat_so
        iv_filter_items = abap_true
* iv_user_status = iv_user_status
* iv_system_status = iv_system_status
        ir_addident     = lt_ident_so
        ir_idart        = lt_idart_so
      IMPORTING
* et_huhdr = lt_huhdr
* et_huitm = lt_huitm
        et_guid_hu      = lt_guid_hu
      EXCEPTIONS
        wrong_input     = 1
        not_possible    = 2
        OTHERS          = 3.
    IF sy-subrc <> 0.
      IF sy-msgid = '/LIME/CORE' AND sy-msgno = '625'.
* MESSAGE s157(/scwm/lc1) DISPLAY LIKE 'E'.

        ls_message-msgid = '/SCM/LC1'.
        ls_message-msgnr = '157'.
        ls_message-msgtyp = 'E'.

        APPEND ls_message TO t_messages.
      ELSE.
* MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
* WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
* DISPLAY LIKE 'E'.

        ls_message-msgid = sy-msgid.
        ls_message-msgnr = sy-msgno.
        ls_message-msgtyp = sy-msgty.
        ls_message-msgv1 = sy-msgv1.
        ls_message-msgv2 = sy-msgv2.
        ls_message-msgv3 = sy-msgv3.
        ls_message-msgv4 = sy-msgv4.

        APPEND ls_message TO t_messages.
      ENDIF.

      RAISE error.
    ENDIF.

    CALL FUNCTION '/SCWM/HU_READ_MULT'
      EXPORTING
        it_guid_hu   = lt_guid_hu
      IMPORTING
        et_huhdr     = lt_huhdr
        et_huitm     = lt_huitm
      EXCEPTIONS
        wrong_input  = 1
        not_possible = 2
        OTHERS       = 3.

    IF sy-subrc <> 0.

      ls_message-msgid = sy-msgid.
      ls_message-msgnr = sy-msgno.
      ls_message-msgtyp = sy-msgty.
      ls_message-msgv1 = sy-msgv1.
      ls_message-msgv2 = sy-msgv2.
      ls_message-msgv3 = sy-msgv3.
      ls_message-msgv4 = sy-msgv4.

      APPEND ls_message TO t_messages.

      RAISE error.
    ENDIF.

    t_huhdr = lt_huhdr.
    t_huitm = lt_huitm.

    " Stock
    SELECT *
      FROM /scwm/aqua INTO TABLE t_aqua
      WHERE lgnum   = lgnum AND
            huident = hu.

    " Documento Referencia
    READ TABLE t_huitm INDEX 1 INTO ls_huitm.
    IF sy-subrc = 0.
      SELECT refdocno UP TO 1 ROWS
        FROM /scdl/db_refdoc INTO e_refdocno
        WHERE docid     = ls_huitm-qdocid AND
              refdoccat = 'ERP'.
      ENDSELECT.
    ENDIF.
  ENDIF.

** Validar dados de HU no ERP
  IF i_check_erp = abap_true AND lt_guid_hu[] IS INITIAL.

    SELECT * UP TO 1 ROWS
      FROM vekp INTO es_vekp
      WHERE exidv = hu
      AND status NE '0060'
      ORDER BY venum DESCENDING.
    ENDSELECT.

    IF sy-subrc = 0.
* ls_guid_hu-guid_hu = lv_guid_hu.
* APPEND ls_guid_hu TO lt_guid_hu.

      SELECT *
        FROM vepo INTO TABLE t_vepo
        WHERE venum = es_vekp-venum.

* TODO mapear campos para as tabelas do EWM

      IF es_vekp-vpobj = '01'. " Entrega
        e_refdocno = es_vekp-vpobjkey.
      ENDIF.
    ENDIF.

    SELECT guid_hu UP TO 1 ROWS
    FROM /scwm/gmhuhdr INTO lv_guid_hu
    WHERE lgnum   = lgnum AND
          huident = hu.
    ENDSELECT.

    IF sy-subrc = 0.
      ls_guid_hu-guid_hu = lv_guid_hu.
      APPEND ls_guid_hu TO lt_guid_hu.

      SELECT * UP TO 1 ROWS
        FROM /scwm/gmhuref INTO ls_gmhuref
        WHERE guid_hu = lv_guid_hu.
      ENDSELECT.

      CLEAR: ls_docid.
      ls_docid-docid  = ls_gmhuref-docid.
      ls_docid-doccat = ls_gmhuref-doccat.
      APPEND ls_docid TO lt_docid.

      CLEAR: ls_include_data.
      ls_include_data-head_status = abap_true.
      ls_include_data-item_status = abap_true.

      call function 'ZEWM_DLV_MANAGEMENT_PRD'
        EXPORTING
          it_docid        = lt_docid
          is_include_data = ls_include_data
        IMPORTING
          et_hu_headers   = lt_huhdr
          et_hu_items     = lt_huitm.

      DELETE lt_huhdr WHERE guid_hu     <> lv_guid_hu.
      DELETE lt_huitm WHERE guid_parent <> lv_guid_hu.

      t_huhdr = lt_huhdr.
      t_huitm = lt_huitm.
    ENDIF.
  ENDIF.


IF lt_guid_hu[] IS INITIAL.
  ls_message-msgid = 'ZEWM'.
  ls_message-msgnr = '003'.
  ls_message-msgtyp = 'E'.
  ls_message-msgv1 = hu.

  APPEND ls_message TO t_messages.

  RAISE error.
ENDIF.

ENDFUNCTION.


*Messages
*----------------------------------------------------------
*
* Message class: ZEWM
*102 Remessa já lida.
*111 Data de validade & ultrapassada. Confirma?