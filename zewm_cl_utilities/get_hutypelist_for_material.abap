**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Get HU types List for material to pack
**************************************************************************

  method get_hutypelist_for_material.

    data lv_matnr       type matnr.
    data lv_no_etiar    type etiar.
    data lr_pack_matnr  type vhilm.
    data lt_output_list type t_ty_hutyp_list.
    data ls_user         type /scwm/user.
    data lv_lgnum        type /scwm/lgnum.

    "Get Lgnum
    call function '/SCWM/RSRC_USER_GET'
      exporting
        iv_uname = sy-uname
      importing
        es_user  = ls_user.

    lv_lgnum = ls_user-lgnum.

    " Check if INPUT corresponds to a MATID
    data(lv_matid_16) = conv /scmb/mdl_matid( iv_material ).
    data(lv_matid_22) = conv /sapapo/matid( iv_material ).

    select single matnr
      into lv_matnr
      from mara
     where scm_matid_guid16 eq lv_matid_16
        or scm_matid_guid22 eq lv_matid_22.

    if sy-subrc is not initial.

      " INPUT was not a MATID
      call function '/SCWM/RF_PRODUCT_INPUT'
        exporting
          input    = iv_material
        importing
          ev_matnr = lv_matnr.

    endif.

    if lv_matnr is not initial.

      " Get material ETIAR for HUTYP selection
      select single etiar
        into @data(ls_material_etiar)
        from mara
       where matnr eq @lv_matnr.

      if sy-subrc is initial.

        " Select all Hu Types (and corresponding packing materials and texts) for supplied material's ETIAR
        select zewm_hutyp_packm~hutyp, zewm_hutyp_packm~pack_matnr, thutypt~text
          into table @data(lt_specific_hutypes)
          from zewm_hutyp_packm
         inner join thutypt on thutypt~hutyp eq zewm_hutyp_packm~hutyp
         where zewm_hutyp_packm~lgnum eq @lv_lgnum
           and zewm_hutyp_packm~etiar eq @ls_material_etiar
           and thutypt~langu eq @sy-langu.

        " Select Generic Hu Types (with no ETIAR)
        select zewm_hutyp_packm~hutyp, zewm_hutyp_packm~pack_matnr, thutypt~text
          into table @data(lt_generic_hutypes)
          from zewm_hutyp_packm
         inner join thutypt on thutypt~hutyp eq zewm_hutyp_packm~hutyp
         where zewm_hutyp_packm~etiar eq @lv_no_etiar
           and thutypt~langu eq @sy-langu.

        if lt_specific_hutypes[] is not initial
        or lt_generic_hutypes[]  is not initial.

          " Add Speficic ETIAR HU types to output list
          loop at lt_specific_hutypes into data(ls_specific).

            " Add specific HU type to output list
            append initial line to lt_output_list assigning field-symbol(<fs_hutyp_list>).
            <fs_hutyp_list>-hutyp         = ls_specific-hutyp.
            <fs_hutyp_list>-hutyp_desc    = ls_specific-text.
            <fs_hutyp_list>-pack_matnr    = ls_specific-pack_matnr.
            unassign <fs_hutyp_list>.

          endloop.

          " Add Generic ETIAR HU types to output list
          loop at lt_generic_hutypes into data(ls_generic).

            read table lt_output_list transporting no fields with key hutyp = ls_generic-hutyp.
            if sy-subrc is initial.
              " Specific HU type already listed for output, move along
              continue.
            endif.
            " Add generic HU type to output list
            append initial line to lt_output_list assigning <fs_hutyp_list>.
            <fs_hutyp_list>-hutyp         = ls_generic-hutyp.
            <fs_hutyp_list>-hutyp_desc    = ls_generic-text.
            <fs_hutyp_list>-pack_matnr    = ls_generic-pack_matnr.
            unassign <fs_hutyp_list>.

          endloop.

          if lt_output_list[] is not initial.

            " Select MATIDs for packing materials
            select matnr, scm_matid_guid16, scm_matid_guid22
              into table @data(lt_pack_matids)
              from mara
               for all entries in @lt_output_list
             where matnr       eq @lt_output_list-pack_matnr.

            if sy-subrc is initial.

              loop at lt_output_list into data(ls_output).

                " Check if determined packing material exists
                read table lt_pack_matids into data(ls_pack_matid) with key matnr = ls_output-pack_matnr.
                if sy-subrc is initial.
                  " It does, add it to finished output list
                  ls_output-pack_matid_16 = ls_pack_matid-scm_matid_guid16.
                  ls_output-pack_matid_22 = ls_pack_matid-scm_matid_guid22.
                  append ls_output to et_hutyp_list.
                endif.

              endloop.
            else.
              " Unknown pack materials
              raise no_pack_materials_found.
            endif.

          endif.
        else.
          " No HU types found
          raise no_hutypes_found.
        endif.
      else.
        " No ETIAR was found for material on MARA
        raise no_etiar_for_material.
      endif.
    else.
      " INPUT was not even a Material
      raise unknown_supplied_material.
    endif.

  endmethod.