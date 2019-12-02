**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Get Packing Material for material to pack
**************************************************************************
**********************************************************************
* Selects Packing Material from table ZEWM_HUTYP_PACKM.
*
* Supply ETIAR or MATNR of the content item (in the second case
* the Material ETIAR will be determined for you and WILL take
* precedence over the supplied ETIAR.
*
* The method will start by searching for a Packing Material for the
* ETIAR you supplied and, if none is found, will search for a
* generic Packing Material (empty ETIAR on ZEWM_HUTYP_PACKM)
*
* Finally it will check if the packing material that was found
* actually exists on the material master data (MARA) and, for your
* convenience, select both 16 and 22 MATIDs
*
**********************************************************************
  method get_pack_material.

    data lv_etiar_filter type etiar.
    data lv_etiar_empty  type etiar.
    data lv_matnr        type matnr.
    data ls_user         type /scwm/user.
    data lv_lgnum        type /scwm/lgnum.

    if iv_lgnum is supplied.
      lv_lgnum = iv_lgnum.

    else.
      "Get Lgnum
      call function '/SCWM/RSRC_USER_GET'
        exporting
          iv_uname = sy-uname
        importing
          es_user  = ls_user.

      lv_lgnum = ls_user-lgnum.
    endif.

    if iv_etiar is supplied.
      " ETIAR supplied, use it as filter
      lv_etiar_filter = iv_etiar.
    endif.

    if iv_matnr is supplied.
      " MATNR of the packed content was supplied, use it as filter
      clear lv_etiar_filter. " It takes precedence over ETIAR filter

      call function 'CONVERSION_EXIT_MATN1_INPUT'
        exporting
          input  = iv_matnr
        importing
          output = lv_matnr.

      " Search for supplied material ETIAR to filter
      select single etiar
        into @data(lv_matnr_etiar)
        from mara
       where matnr eq @lv_matnr.

      if sy-subrc is not initial.
        " Unknown Material
        raise supplied_matnr_unknown.
      else.
        " Set material ETIAR as ETIAR filter
        lv_etiar_filter = lv_matnr_etiar.
      endif.

    endif.

    " Search for specific ETIAR (filter)
    select single pack_matnr
      into @data(lv_pack_material)
      from zewm_hutyp_packm
     where lgnum eq @lv_lgnum
       and hutyp eq @iv_hutyp
       and etiar eq @lv_etiar_filter.

    if sy-subrc is not initial.

      " Search for generic ETIAR (ETIAR = '')
      select single pack_matnr
        into @lv_pack_material
        from zewm_hutyp_packm
        where lgnum eq @lv_lgnum
          and hutyp eq @iv_hutyp
          and etiar eq @lv_etiar_empty.

    endif.

    if lv_pack_material is initial.
      " No packing material found, either specific or generic
      raise no_pack_material_found.
    endif.

    " Packing material IDs were requested, so...go get them
    select single matnr scm_matid_guid16 scm_matid_guid22
      into ( ev_pack_material, ev_pack_matid_16, ev_pack_matid_22 )
      from mara
     where matnr eq lv_pack_material.

    if sy-subrc is not initial.
      " Packing material on ZEWM_HUTYP_PACKM not found on Material Master data
      raise pack_material_unknown.
    endif.

  endmethod.