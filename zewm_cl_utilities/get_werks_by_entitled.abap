**************************************************************************
*   Method attributes.                                                   *
**************************************************************************
*Instantiation: Public
*Description: Obtains the werks associated to the entitled
**************************************************************************

  method get_werks_by_entitled.

    select single werks from t001w
      into rv_werks
      where kunnr eq iv_entitled.

  endmethod.