**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Get Inbound Delivery items additional quantities
**************************************************************************

  method get_inb_item_additional_quant.

    data lo_sp_prd_inb   type ref to /scdl/cl_sp_prd_inb.
    data lo_message_box  type ref to /scdl/cl_sp_message_box.

    data lt_item_addqty_key type /scdl/t_sp_k_item_addmeas.
    data lt_item_addqty_out type /scdl/t_sp_a_item_addmeas.

    data lv_ewm_lgnum    type /scwm/lgnum.

    try.
        create object lo_message_box.

        " Create service provider object
        create object lo_sp_prd_inb
          exporting
            io_message_box = lo_message_box
            iv_doccat      = /scdl/if_dl_doc_c=>sc_doccat_inb_prd   " 'PDI' - Document Category Inbound Delivery
            iv_mode        = /scdl/cl_sp=>sc_mode_classic.          " 'C'   - Mode: Classic

      catch cx_root.
        " Error creating Service Provider object
        ev_rejected = abap_true.
        return.

    endtry.

    " Set warehouse that is to be used
    lv_ewm_lgnum = iv_ewm_lgnum.
    /scwm/cl_tm=>set_lgnum( lv_ewm_lgnum ).

    " Set delivery items
    loop at it_inbdlv_items into data(ls_inbdlv_item).

      append initial line to lt_item_addqty_key assigning field-symbol(<fs_item_addqty_key>).
      <fs_item_addqty_key>-docid        = ls_inbdlv_item-docid.
      <fs_item_addqty_key>-itemid       = ls_inbdlv_item-itemid.
      <fs_item_addqty_key>-qty_category = iv_qty_category.
      <fs_item_addqty_key>-qty_role     = iv_qty_role.
      unassign <fs_item_addqty_key>.

    endloop.

    " Select Quantities
    lo_sp_prd_inb->select(
      exporting
        inkeys       = lt_item_addqty_key
        aspect       = /scdl/if_sp_c=>sc_asp_item_addmeas " '/SCDL/S_SP_A_ITEM_ADDMEAS' - Aspect: Item Additional Units of Measure
      importing
        outrecords   = et_inbdlv_items_add_quant
        rejected     = ev_rejected
*        return_codes = et_return_codes
    ).

    et_messages = lo_sp_prd_inb->get_message_box( )->get_messages(  ).

  endmethod.