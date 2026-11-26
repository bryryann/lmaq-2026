; --------- CONVERSOR DECIMAL->BINÁRIO ----------
; DISCIPLINA: Linguagem de Máquina
; DOCENTE: Laura Beatriz Alves
; PROCESSADOR: Intel 8085
; ----------------------------------------------

; MAPA DE MEMÓRIA
IN_DECIMAL  EQU 2000H ; Decimal ASCII (até 3 caracteres + terminador)
OUT_BIN     EQU 2300H ; Binário ASCII (8 caracteres)
VALOR_BIN   EQU 2400H ; Valor numérico intermediário (1 byte)
ERRO_FLAG   EQU 2501H ; Indicador de erro (1 byte)

ORG 0000H

INICIO:
    ; Inicializar pilha

    ; Limpar registradores e variáveis

    ; Carregar número decimal de entrada

    ; Verificar validade da entrada

    ; Chamar rotina decimal para binário

    ; Armazenar resultado na memória

    ; Realizar verificação (se necessário)

    ; Fim programa
    HLT

; ROTINAS DO CONVERSOR
DEC_PARA_BIN:
    ; Implementar posteriormente
    RET

; TRATAMENTO DE ERRO
ERRO_ENTRADA:
    ; Registrar erro
    HLT

; FALHA NA VERIFICACAO
FALHA:
    ; Registrar falha
    HLT

