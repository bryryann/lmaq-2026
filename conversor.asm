; --------- CONVERSOR DECIMAL-BINÁRIO ----------
; DISCIPLINA: Linguagem de Máquina
; DOCENTE: Laura Beatriz Alves
; PROCESSADOR: Intel 8085
; ----------------------------------------------

; MAPA DE MEMÓRIA
; ----- ENTRADAS
IN_DECIMAL  EQU 2000H ; Decimal de entrada (1 byte)
IN_BIN      EQU 2100H ; Binário de entrada (8 bytes)

; ----- SAÍDAS
OUT_DECIMAL EQU 2200H ; Decimal de saída (3 bytes)
OUT_BIN     EQU 2300H ; Binário de saída (8 bytes)

; ----- OUTROS
VALOR_BIN   EQU 2400H ; Valor numérico do binário (1 byte)
VERIFICA    EQU 2500H ; Resultado da verificação (?/1 byte)
ERRO_FLAG   EQU 2501H ; Indicador de erro (1 byte)

ORG 0000H

INICIO:
    ; Inicializar pilha

    ; Limpar registradores e variáveis

    ; Carregar número decimal de entrada

    ; Chamar rotina decimal para binário

    ; Prepara entrada binária

    ; Chamar rotina binário para valor

    ; Converter valor para decimal (ASCII)

    ; Realizar verificacao

    ; Fim programa

    HLT


; TRATAMENTO DE ERRO
ERRO_ENTRADA:
    ; Registrar erro
    HLT


; FALHA NA VERIFICACAO
FALHA:
    ; Registrar falha
    HLT

; ROTINAS DO CONVERSOR
DEC_PARA_BIN:
    ; Implementar posteriormente
    RET


BIN_PARA_VALOR:
    ; Implementar posteriormente
    RET

VALOR_PARA_ASCII:
    ; Implementar posteriormente
    RET

; DADOS DO PROGRAMA
BIN_ROM:
    ; Inserir os 8 caracteres binarios

