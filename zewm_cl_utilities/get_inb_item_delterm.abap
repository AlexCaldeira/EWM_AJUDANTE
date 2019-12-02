**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Get Inbound Delivery items delivery terms
**************************************************************************

  method get_inb_item_delterm.

    data lo_sp_prd_inb   type ref to /scdl/cl_sp_prd_inb.
    data lo_message_box  type ref to /scdl/cl_sp_message_box.

    data lt_item_key type /scdl/t_sp_k_item.
    data lt_item_out type /scdl/t_sp_a_item_delterm.

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

    " Select Items
    lo_sp_prd_inb->select(
      exporting
        inkeys       = it_inbdlv_items
        aspect       = /scdl/if_sp_c=>sc_asp_item_delterm           " '/SCDL/S_SP_A_ITEM_DELTERM' - Aspect: Item Delivery Terms
      importing
        outrecords   = et_inbdlv_items_delterm
        rejected     = ev_rejected
*        return_codes = et_return_codes
    ).

    et_messages = lo_sp_prd_inb->get_message_box( )->get_messages(  ).

  endmethod.