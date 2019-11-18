********************************************************
********************************************************
***                                                  *** 
***   Criar uma HU vazia para ser feito o PACK       ***
***                                                  ***  
********************************************************
********************************************************


*Criar o objecto que vamos precisar de utilizar
DATA: g_create TYPE REF TO /scwm/cl_wm_packing.
CREATE OBJECT g_create.

*Inicializar a classe com armazém que queremos usando o init
CALL METHOD g_create->init EXPORTING iv_lgnum = p_lgnum.

*Chamar a função para inicializar o processamento da WT
CALL FUNCTION '/SCWM/TO_INIT_NEW' EXPORTING iv_lgnum = p_lgnum.

*De seguida chamar o método CREATE_HU da interface /SCWM/IF_PACK_BAS
*passando o material a HU e o storage bin onde a HU necessita
*de ser criada e depois charmar o método SAVE

CLEAR es_huhdr.
CALL METHOD g_create->/scwm/if_pack_bas~create_hu
  EXPORTING
    iv_pmat = lv_pmat          "Packaging Material
    iv_huident = lv_huident    "CASE name - Nome da HU
    iv_location = lv_location  "Storage bin
  RECEIVING
    es_hundr = es_huhdr
  EXCEPTIONS 
    error = 1
    OTHERS = 2.

  IF sy-subrc = 0.
    CALL METHOD g_create->/scwm/if_pack_bas~save
      EXCEPTIONS
        error = 1
        OTHERS = 2.
  ELSE.
    "Executar Rotina de Erro

  ENDIF.
