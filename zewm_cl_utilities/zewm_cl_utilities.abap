**************************************************************************
* Class attributes. *
**************************************************************************
*Instantiation: Public
*Message class:
*State: Implemented
*Final Indicator: X
*R/3 Release: 753

**************************************************************************
* Public section of class. *
**************************************************************************
class ZEWM_CL_UTILITIES definition
  public
  final
  create public .

public section.

  types:
    begin of ty_hu_serial,
        huident type exidv,
        serial  type exidv2,
      end of ty_hu_serial .
  types:
    begin of ty_hutyp_list,
        hutyp         type cifhutyp,
        hutyp_desc    type de_desc40,
        pack_matnr    type vhilm,
        pack_matid_16 type /scmb/mdl_matid,
        pack_matid_22 type /sapapo/matid,
      end of ty_hutyp_list .
  types:
    t_ty_hutyp_list type standard table of ty_hutyp_list .
  types:
    begin of ty_sample_serial_number,
        aufnr   type aufk-aufnr,
        matnr   type vepo-matnr,
        batch   type vepo-charg,
        hutyp   type mara-hutyp,
        huident type vekp-exidv,
        serial  type vekp-exidv2,
      end of ty_sample_serial_number .
  types:
    t_ty_sample_serial_number type standard table of ty_sample_serial_number .
  types:
    begin of ty_material_ean,
        meinh   type lrmei, " Alternative UoM
        umrez   type umrez, " Counter
        umren   type umren, " Denominator
        ean     type ean11, " EAN
        numtp   type numtp, " EAN type
        msehl   type msehl, " UoM Description
        set_ewm type xfeld, " Set as EWM Standard
      end of ty_material_ean .
  types:
    ty_t_material_eans type standard table of ty_material_ean .
  types:
    begin of ty_fixed_bin,
        lgnum    type /scwm/lgnum,
        matid    type /scwm/de_matid,
        entitled type /scwm/de_entitled,
        lgpla    type /scwm/lgpla,
        lgtyp    type /scwm/lgtyp,
        matnr    type /scwm/de_matnr,
      end of ty_fixed_bin .
  types:
    ty_t_fixed_bins type standard table of ty_fixed_bin .
  types:
    begin of ty_splitable,
        vbeln type vbeln_vl,
        posnr type posnr_vl,
      end of ty_splitable .
  types:
    ty_t_splitable type table of ty_splitable with non-unique key vbeln posnr .
  types:
    begin of ty_subitem_data,         batchno  type /scdl/s_sp_a_item_product-batchno,         exp_date type datum,         quantity type /scdl/s_sp_a_item_quantity-qty,         uom      type /scdl/s_sp_a_item_quantity-uom,       end of ty_subitem_data .
  types:
    ty_t_subitem_data type table of ty_subitem_data with non-unique key batchno .
  types:
    begin of ty_hutyp_packmat,
        hutyp     type /scwm/de_hutyp,
        hutyptext type /scwm/de_hutypt,
        matnr     type mara-matnr,
        matkl     type mara-matkl,
        etiar     type mara-etiar,
        etifo     type mara-etifo,
        matid_16  type /scmb/mdl_matid,
        matid_22  type /sapapo/matid,
        maktx     type /sapapo/maktx,
        huart     type ean128_hu_art,
      end of ty_hutyp_packmat .
  types:
    ty_t_hutyp_packmat type table of ty_hutyp_packmat with non-unique key hutyp .
  types:
    begin of ty_delivery,
        vbeln type vbeln_vl,
        posnr type posnr_vl,
        kunnr type kunnr,
      end of ty_delivery .
  types:
    ty_t_delivery type table of ty_delivery with non-unique key vbeln posnr .
  types:
    ty_r_docno type range of /scdl/db_proch_i-docno .

  class-data MR_STOCK_CATEGORY type /SCWM/DE_CAT .
  class-data MR_FUNCTION type RS38L_FNAM .
  class-data MR_EXECUTE type SAP_BOOL .
  class-data MT_STOCK type /SCWM/TT_AQUA_INT .
  class-data MR_RAW_MATERIAL type SAP_BOOL .
  constants MR_OPT_NE type OPTION value 'NE' ##NO_TEXT.
  constants MR_OPT_EQ type OPTION value 'EQ' ##NO_TEXT.
  constants MR_OPT_BT type OPTION value 'BT' ##NO_TEXT.
  constants MR_OPT_GE type OPTION value 'GE' ##NO_TEXT.
  constants MR_OPT_LE type OPTION value 'LE' ##NO_TEXT.
  constants MR_OPT_LT type OPTION value 'LT' ##NO_TEXT.
  constants MR_OPT_GT type OPTION value 'GT' ##NO_TEXT.
  constants MR_SIGN_I type SIGN value 'I' ##NO_TEXT.
  constants MR_SIGN_E type SIGN value 'E' ##NO_TEXT.
  constants MR_GET type STRING value 'GET' ##NO_TEXT.
  constants MR_SET type STRING value 'SET' ##NO_TEXT.
  class-data GV_GET_ALL_POS type XFELD .
  class-data MR_MEINS type MEINS .
  class-data MR_ANFML type /SCWM/DE_QUANTITY .
  class-data MT_HUS type ZEWM_TT_HUIDENT .
  class-data MR_STOCK_TYPE type ZEWM_MSTOCK_TYPE .
  class-data MR_PICKING type SAP_BOOL .
  class-data MR_TASKS_PICKING_CREATE type SAP_BOOL .
  class-data GT_AQUA type /SCWM/TT_AQUA .
  class-data GT_LAGP type /SCWM/TT_LAGP .
  class-data MR_FEVOR type FEVOR .
  class-data MR_WERKS type WERKS_D .
  class-data MR_ARBPL type ARBPL .
  class-data MR_NEW type SAP_BOOL .
  class-data MR_LFART type LFART .
  class-data MR_PSTYV type PSTYV_VL .
  class-data MR_MATNR type MATNR .
  class-data MR_STRATEGY_PICK type SAP_BOOL .

  methods CONVERT_MATID_TO_MATNR
    importing
      value(I_MATID) type /SCWM/DE_MATID
    returning
      value(R_MATNR) type MATNR .
  methods CONVERT_MATNR_TO_MATID
    importing
      value(I_MATNR) type MATNR
    returning
      value(R_MATID) type /SCWM/DE_MATID .
  methods MATID_GUID_CONVERT
    importing
      value(IV_GUID16) type ANY optional
      value(IV_GUID22) type ANY optional
    exporting
      value(EV_GUID16) type ANY
      value(EV_GUID22) type ANY .
  methods CONVERT_TO_HUIDENT
    importing
      I_VALUE type CHAR20
    returning
      value(R_HUIDENT) type /SCWM/HUHDR-HUIDENT .
  methods M_CONVERSIONS
    importing
      IS_INPUT type ANY
      IS_FUNCNAME type RS38L_FNAM
    exporting
      ES_OUTPUT type ANY
      EV_EXCEPTION type ABAP_BOOL
    raising
      CX_SY_CONVERSION_ERROR .
  methods M_SET_RANGE
    importing
      IS_LOW type ANY
      IS_FIELDNAME type ANY optional
      IS_HIGH type ANY optional
      IS_OPTION type ANY default 'EQ'
      IS_SIGN type ANY default 'I'
      IS_COLLECT type XFELD optional
      IV_ALLOW_EMPTY type SAP_BOOL optional
    changing
      ET_RANGE type STANDARD TABLE .
  methods M_GET_USER_DATA
    importing
      IS_UNAME type SY-UNAME
      IS_RF type FLAG optional
    exporting
      ES_USER type ZEWM1_USER
      ES_LGNUM type LGNUM
      ES_LGNUM_EWM type /SCWM/LGNUM .
  methods M_CONTROL_CHANGES
    importing
      IV_FUNCTION type SYST-UCOMM optional
    changing
      value(CR_DATA) type ANY .
  methods M_GET_INTERNAL_TABLE_FIELDCAT
    importing
      IT_TABLE type ANY TABLE optional
      IR_STRUCTURE type TABNAME optional
    returning
      value(ET_FIELDCAT) type LVC_T_FCAT .
  methods M_SET_MESSAGE
    importing
      value(IM_ID) type SY-MSGID
      value(IM_TYPE) type SY-MSGTY
      value(IM_NUMBER) type ANY
      IM_V1 type ANY optional
      IM_V2 type ANY optional
      IM_V3 type ANY optional
      IM_V4 type ANY optional
      IM_LIKE type SY-MSGTY default 'S' .
  methods M_DO_COMMIT .
  methods M_DO_ROLLBACK .
  methods M_SHOW_SYS_MESSAGE .
  methods M_SPLIT_TEXT
    importing
      I_TEXT type ANY
      I_LINES type SYINDEX
      I_MAX_SIZE type I default 20
    exporting
      E_LINE1 type ANY
      E_LINE2 type ANY
      E_LINE3 type ANY
      E_LINE4 type ANY
      E_LINE5 type ANY
      E_LINE6 type ANY .
  methods M_SHOW_RF_MESSAGE
    importing
      I_MSGTY type SY-MSGTY default 'E'
      I_MSGNR type SY-MSGNO
      I_MSGID type SY-MSGID default 'ZRF'
      I_MSGV1 type SY-MSGV1 optional
      I_MSGV2 type SY-MSGV2 optional
      I_MSGV3 type SY-MSGV3 optional
      I_MSGV4 type SY-MSGV4 optional
    exporting
      E_RET_CODE type ZRF_RET_CODE .
  methods M_GET_PARAMETER_VALUE
    importing
      value(IV_PARAM) type NAME_FELD
      value(IV_LGNUM) type /SCWM/LGNUM optional
    exporting
      value(EV_SINGLE_VALUE) type ANY
      value(ET_RANGE) type STANDARD TABLE
      value(ET_TABLE) type ZEWM1_ZTCA00001_T
    raising
      ZCX_EWM_PROCESS .
  methods M_DETERMINE_BIN
    importing
      I_LGNUM type /SCWM/LGNUM
      I_MATID type /SCWM/DE_MATID
      I_PROCTY type /SCWM/DE_PROCTY
      I_ENTITLED type /SCWM/DE_ENTITLED
      S_CHARG type /LIME/R_CHARG
      S_HUIDENT type /SCWM/TT_HUIDENT_R optional
    exporting
      ET_PUTRES type /SCWM/TT_PUTREQ
      ET_BAPIRET type BAPIRETTAB .
  methods CONVERT_TO_EXIDV
    importing
      I_VALUE type CHAR20
    returning
      value(R_EXIDV) type VEKP-EXIDV .
  methods VALIDATE_STGE_LOC_EWM
    importing
      I_LGORT type LGORT_D
      I_WERKS type WERKS_D optional
    returning
      value(R_IS_EWM) type SAP_BOOL .
  methods STOCK_TYPE_DETERMINE
    importing
      value(I_LGORT) type LGORT_D
      value(I_WERKS) type WERKS_D
      value(I_LOGSYS) type LOGSYS optional
      value(IT_CATLOCN) type ZEWM_CT_CATLOCN optional
    exporting
      value(RT_STOCK_CATEGORY) type ZEWM_TT_S001
      value(ER_LGNUM) type /SCWM/LGNUM
      value(ER_CAT) type /SCWM/DE_CAT .
  methods STORAGE_LOCATION_DETERMINE
    importing
      IV_LGNUM type /SCWM/LGNUM
      IV_CAT type /SCWM/DE_CAT
      IV_CATLOCN type /SCWM/DE_CATLOCN default 'FF'
      IV_LOGSYS type LOGSYS optional
    returning
      value(RV_LGORT) type LGORT_D .
  methods M_SET_RANGE_FROM_TABLE
    importing
      value(IT_TABLE) type ANY TABLE
      value(IV_TABLE_FIELD) type ANY
      IS_FIELDNAME type ANY optional
      IS_HIGH type ANY optional
      value(IS_OPTION) type ANY default 'EQ'
      value(IS_SIGN) type ANY default 'I'
      IR_COLLECT type XFELD optional
    changing
      value(ET_RANGE) type STANDARD TABLE .
  methods ENCODE_EAN128
    importing
      IV_PROFILE type EAN128_PROFILE
      IS_EAN128_DATA type EAN128
    exporting
      EV_DATAMATRIX type CHAR1024
      ET_MESSAGES type BAPIRET2_TAB
    exceptions
      CX_ENCODE_ERROR .
  methods DECODE_EAN128
    importing
      value(IV_BARCODE) type ZDATAMATRIX
      IV_CHECK_PREFIX type FLAG optional
    exporting
      value(ES_EAN128) type EAN128
      value(ET_RETURN) type BAPIRET2_TAB
    exceptions
      ERROR .
  methods GET_PACKMAT_FROM_HUTYP
    importing
      IV_EWM_LGNUM type /SCWM/LGNUM
      IV_MATNR type MATNR
      IR_HUTYP type ZEWM_TT_S_HUTYPE_RNG optional
      IR_VHART type ZEWM_TT_S_VHIART_RNG optional
    exporting
      ET_HUTYP_PACKMAT type TY_T_HUTYP_PACKMAT .
  methods SPLIT_DELIVERY_ITEM
    importing
      IV_EWM_LGNUM type /SCWM/LGNUM
      IS_SPLITABLE type TY_SPLITABLE
      IV_SUBITEMS type INT4
      IT_SUBITEM_DATA type TY_T_SUBITEM_DATA .
  methods M_POPUP_TO_CONFIRM
    importing
      value(IV_TITLEBAR) type TEXT132 default SPACE
      value(IV_DIAGNOSE_OBJECT) type DOKHL-OBJECT default SPACE
      value(IV_TEXT_QUESTION) type TEXT132
      value(IV_TEXT_BUTTON_1) type TEXT132 default 'Ja'
      value(IV_ICON_BUTTON_1) type ICON-NAME default SPACE
      value(IV_TEXT_BUTTON_2) type TEXT132 default 'Nein'
      value(IV_ICON_BUTTON_2) type ICON-NAME default SPACE
      value(IV_DEFAULT_BUTTON) type CHAR1 default '1'
      value(IV_DISPLAY_CANCEL_BUTTON) type CHAR1 default 'X'
      value(IV_USERDEFINED_F1_HELP) type DOKHL-OBJECT default SPACE
      value(IV_START_COLUMN) type SY-CUCOL default 25
      value(IV_START_ROW) type SY-CUROW default 6
      value(IV_POPUP_TYPE) type ICON-NAME optional
      IV_QUICKINFO_BUTTON_1 type TEXT132 default SPACE
      IV_QUICKINFO_BUTTON_2 type TEXT132 default SPACE
    returning
      value(EV_ANSWER) type CHAR1 .
  methods GET_MATNR_INFO
    importing
      IV_INPUT type DATA
    exporting
      EV_MATID type /SCWM/DE_MATID
      EV_MATNR type /SCWM/DE_MATNR
      EV_MAKTX type MAKTX
      EV_MATEAN type /SCWM/DE_RF_EAN11
      EV_EAN_UOM type MEINH
      EV_XCHPF type XCHPF .
  methods GET_OPEN_INB
    importing
      IR_DOCNO type TY_R_DOCNO .
  methods M_DETERMINE_BIN_STOCK_REM
    importing
      value(I_MATID) type /SCWM/AQUA-MATID
      value(I_LGNUM) type /SCWM/AQUA-LGNUM
      I_CHARG type CHARG_D optional
      value(I_PROCTY) type /SCWM/DE_PROCTY
      value(I_QUAN) type /SCWM/DE_AVLQUAN
      I_CAT type /LIME/STOCK_CATEGORY optional
      I_HUIDENT type /SCWM/AQUA-HUIDENT optional
      I_LGPLA type /SCWM/LGPLA optional
      I_ENTITLED type /SCWM/DE_ENTITLED optional
      I_ENTITLED_ROLE type /SCWM/DE_ENTITLED_ROLE optional
      I_OWNER type /SCWM/DE_OWNER optional
      I_OWNER_ROLE type /LIME/OWNER_ROLE optional
      I_UNIT type /SCWM/DE_BASE_UOM optional
      IT_REMREQ type /SCWM/TT_REMREQ optional
      I_CHECK_DOCCAT type SAP_BOOL optional
      I_BATCHID type /SCWM/DE_BATCHID optional
      I_VGBEL type VGBEL optional
      I_VGPOS type VGPOS optional
      IT_CAT type ZEWM_RN_LIME_STOCK_CATEGORY optional
    exporting
      value(ET_REMRES) type /SCWM/TT_REMREQ
      value(ET_BAPIRET) type BAPIRETTAB
      value(EV_SEVERITY) type BAPI_MTYPE
      value(ET_AQUAY) type /SCWM/TT_AQUAY
      value(CT_QMAT) type /SCWM/TT_AQUA_INT
      value(CT_QSPERR) type /SCWM/TT_AQUA .
  methods ON_GET_DELIVERY_TASKS
    importing
      value(IT_DOCNO) type /SCWM/DLV_DOCNO_ITEMNO_TAB
      I_CONF_TSK type SAP_BOOL optional
      I_OPEN_TSK type SAP_BOOL optional
    exporting
      value(ET_ORDIM_O) type ZCL_HDB_BASE=>T_ORDIM_O
      value(ET_ORDIM_C) type ZCL_HDB_BASE=>T_ORDIM_C
      value(ET_REFDOC) type /SCDL/DL_DB_REFDOC_TAB
    raising
      ZCX_BC_BASE .
  methods ON_GET_LGNUM_BY_VKORG
    importing
      I_VKORG type VKORG
    returning
      value(R_LGNUM) type /SCWM/LGNUM .
  methods GET_MATNR_FULL_INFO
    importing
      IV_INPUT type DATA
    exporting
      EV_MATNR type /SCWM/DE_MATNR
      EV_MATID_16 type /SCMB/MDL_MATID
      EV_MATID_22 type /SAPAPO/MATID
      EV_MEINS type MEINS
      EV_MAKTX type MAKTX
      EV_MATKL type MATKL
      EV_ETIAR type ETIAR
      EV_ETIFO type ETIFO
      EV_MTART type MTART
      EV_XCHPF type XCHPF
      EV_HUTYP type CIFHUTYP
      ET_MATEANS type TY_T_MATERIAL_EANS
      ET_FIXED_BINS type TY_T_FIXED_BINS .
  methods ON_CHECK_ITEM_STOCK_ORIGIN
    importing
      value(IT_STOCK_TYPE) type ZEWM_TT_ORDERS
    returning
      value(OT_STOCK_TYPE) type ZEWM_TT_ORDERS .
  methods DETERMINE_LABEL_SERIAL_NUMBER
    importing
      IV_WERKS type HUM_WERKS
      IR_MATNR type RANGES_MATNR
      IR_BATCH type RANGES_CHARG_TT
    changing
      ET_SERIAL_NUMBERS type T_TY_SAMPLE_SERIAL_NUMBER
    exceptions
      CONSTANTS_NOT_FOUND .
  methods LOCK_WAIT
    importing
      IS_KEYWORD type ANY optional
      I_GARG type EQEGRAARG optional
      I_MANDT type MANDT default SY-MANDT
      I_ELEMENT1 type ANY optional
      I_ELEMENT2 type ANY optional
      I_ELEMENT3 type ANY optional
      I_GNAME type EQEGRANAME default 'KEYWORD'
      I_WAIT type INT4 default 10 .
  methods SSCC_CHECK
    importing
      IF_SSCC type EXIDV optional
      IF_WERK type T313Y-WERK optional
      IF_LGORT type T313Y-LGORT optional
      IF_LGNUM type T313Z-LGNUM optional
      IF_HUART type EAN128_HU_ART default '3'
      IF_FOREIGN_SSCC type BOOLE_D default ' '
      IF_BAPI_CALL type XFELD default ' '
    exceptions
      ILN_NOT_FOUND
      INVALID_CALL
      INVALID_CUSTOMIZING
      INVALID_ILN
      INVALID_NO_OUT_OF_RANGE
      INVALID_SSCC
      INTERNAL_ERROR
      ERROR_ON_NUMBER_RANGE .
  methods GET_INB_ITEM_ADDITIONAL_QUANT
    importing
      IV_EWM_LGNUM type /SCWM/LGNUM
      IT_INBDLV_ITEMS type /SCDL/T_SP_K_ITEM
      IV_QTY_ROLE type /SCDL/DL_QTY_ROLE default 'OQ'
      IV_QTY_CATEGORY type /SCDL/DL_QTY_CATEGORY default 'REQ'
    exporting
      ET_INBDLV_ITEMS_ADD_QUANT type /SCDL/T_SP_A_ITEM_ADDMEAS
      EV_REJECTED type BOOLE_D
      ET_MESSAGES type /SCDL/DM_MESSAGE_TAB .
  methods GET_INB_ITEM_DELTERM
    importing
      IV_EWM_LGNUM type /SCWM/LGNUM
      IT_INBDLV_ITEMS type /SCDL/T_SP_K_ITEM
    exporting
      EV_REJECTED type BOOLE_D
      ET_MESSAGES type /SCDL/DM_MESSAGE_TAB
      ET_INBDLV_ITEMS_DELTERM type /SCDL/T_SP_A_ITEM_DELTERM .
  methods M_DETERMINE_BIN_PUTAWAY
    importing
      IT_PUTREQ type /SCWM/TT_PUTREQ
      IV_LOCK type /SCWM/DE_LOCK optional
      IV_PARTDET type /SCWM/DE_BINGN optional
      IT_LAGP_EXCL type /SCWM/TT_LAGP_KEY optional
      IO_LOG type ref to /SCWM/CL_LOG optional
    exporting
      ET_PUTRES type /SCWM/TT_PUTREQ
      ET_BAPIRET type BAPIRETTAB
      EV_SEVERITY type BAPI_MTYPE
      ET_LAGP type /SCWM/TT_LAGP
    returning
      value(RT_AQUA) type /SCWM/TT_AQUA
    raising
      /SCWM/CX_CORE .
  methods GET_WERKS_BY_ENTITLED
    importing
      IV_ENTITLED type /SCWM/DE_ENTITLED
    returning
      value(RV_WERKS) type WERKS_D .
  methods GET_PACK_MATERIAL
    importing
      IV_HUTYP type CIFHUTYP
      IV_ETIAR type ETIAR optional
      IV_MATNR type MATNR optional
      IV_LGNUM type /SCWM/LGNUM optional
    exporting
      EV_PACK_MATERIAL type VHILM
      EV_PACK_MATID_16 type /SCMB/MDL_MATID
      EV_PACK_MATID_22 type /SAPAPO/MATID
    exceptions
      SUPPLIED_MATNR_UNKNOWN
      NO_PACK_MATERIAL_FOUND
      PACK_MATERIAL_UNKNOWN .
  methods GET_HUTYPELIST_FOR_MATERIAL
    importing
      IV_MATERIAL type DATA
    exporting
      ET_HUTYP_LIST type T_TY_HUTYP_LIST
    exceptions
      NO_PACK_MATERIALS_FOUND
      NO_HUTYPES_FOUND
      NO_ETIAR_FOR_MATERIAL
      UNKNOWN_SUPPLIED_MATERIAL .
  methods GET_CURRENT_HU_SERNUM
    importing
      IV_AUFNR type AUFNR
      IV_HUTYPE type /SCWM/DE_HUTYP
    exporting
      ES_HUSERIAL type TY_HU_SERIAL .

**************************************************************************
* Private section of class. *
**************************************************************************
  private section.

**************************************************************************
* Protected section of class. *
**************************************************************************
  protected section.