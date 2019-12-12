FUNCTION zewm_wt_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*" IMPORTING
*" VALUE(IV_LGNUM) TYPE /SCWM/LGNUM
*" VALUE(IV_UPDATE_TASK) TYPE /SCWM/RL03AVERBU DEFAULT 'X'
*" VALUE(IV_COMMIT_WORK) TYPE /SCWM/RL03ACOMIT DEFAULT 'X'
*" VALUE(IV_WTCODE) TYPE /SCWM/DE_WTCODE OPTIONAL
*" VALUE(IV_BNAME) TYPE /SCWM/LVS_BNAME DEFAULT SY-UNAME
*" VALUE(IS_RFC_QUEUE) TYPE /SCWM/S_RFC_QUEUE OPTIONAL
*" VALUE(IT_CREATE) TYPE ZEWMTT_TO_CREATE_INT OPTIONAL
*" VALUE(IT_CREATE_EXC) TYPE /SCWM/TT_CONF_EXC OPTIONAL
*" VALUE(IV_PROCESSOR_DET) TYPE XFELD DEFAULT SPACE
*" EXPORTING
*" VALUE(EV_TANUM) TYPE /SCWM/TANUM
*" VALUE(ET_LTAP_VB) TYPE /SCWM/TT_LTAP_VB
*" VALUE(ET_BAPIRET) TYPE BAPIRETTAB
*" VALUE(EV_SEVERITY) TYPE BAPI_MTYPE
*" EXCEPTIONS
*" ERROR
*"----------------------------------------------------------------------

  DATA: lt_create    TYPE /scwm/tt_to_create_int,
        ls_create    LIKE LINE OF lt_create,
        ls_create_in TYPE zewms_to_create_int.

  LOOP AT it_create INTO ls_create_in.
    CLEAR ls_create.
    MOVE-CORRESPONDING ls_create_in TO ls_create.
    APPEND ls_create TO lt_create.
  ENDLOOP.


  CALL FUNCTION '/SCWM/TO_CREATE'
    EXPORTING
      iv_lgnum         = iv_lgnum
      iv_update_task   = 'X'
      iv_commit_work   = 'X'
      iv_wtcode        = iv_wtcode
      iv_bname         = sy-uname
      is_rfc_queue     = is_rfc_queue
      it_create        = lt_create
      it_create_exc    = it_create_exc
      iv_processor_det = iv_processor_det
    IMPORTING
      ev_tanum         = ev_tanum
      et_ltap_vb       = et_ltap_vb
      et_bapiret       = et_bapiret
      ev_severity      = ev_severity.


ENDFUNCTION.


*Messages
*----------------------------------------------------------
*
* Message class: ZEWM
*102 Remessa já lida.
*111 Data de validade & ultrapassada. Confirma?