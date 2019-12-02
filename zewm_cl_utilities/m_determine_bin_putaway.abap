**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Obtains positions for putaway
**************************************************************************

  method m_determine_bin_putaway.

    free: gt_aqua, gt_lagp.

    call function '/SCWM/PUT_BIN_DET'
      exporting
        it_putreq    = it_putreq
        iv_lock      = iv_lock
        iv_partdet   = iv_partdet
        it_lagp_excl = it_lagp_excl
        io_log       = io_log
      importing
        et_putres    = et_putres
        et_bapiret   = et_bapiret
        ev_severity  = ev_severity.

    rt_aqua = gt_aqua.
    et_lagp = gt_lagp.

  endmethod.