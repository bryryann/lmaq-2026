; --------- CONVERSOR DECIMAL->BINÁRIO ----------
; DISCIPLINA: Linguagem de Máquina
; DOCENTE: Laura Beatriz Alves
; PROCESSADOR: Intel 8085
; ----------------------------------------------

; MAPA DE MEMÓRIA
IN_DECIMAL  EQU 2000H ; Decimal ASCII (3 caracteres + terminador)
OUT_BIN     EQU 2300H ; Binário ASCII (8 caracteres)
VALOR_BIN   EQU 2400H ; Valor numérico intermediário (1 byte)
ERRO_FLAG   EQU 2501H ; Indicador de erro (1 byte)

ORG 0000H

INICIO:
    ; ----- Inicializar pilha
    LXI SP, 27FFH

    ; ----- Limpar registradores e variáveis
    MVI A, 00H
    MVI B, 00H
    MVI C, 00H
    MVI D, 00H
    MVI E, 00H
    MVI H, 00H
    MVI L, 00H

    STA VALOR_BIN
    STA ERRO_FLAG

    ; ----- Carregar número decimal de entrada
    LXI H, IN_DECIMAL
    MOV A, M
    MOV B, A
    INX H
    MOV A, M
    MOV C, A
    INX H
    MOV A, M
    MOV D, A

    ; ----- Verificar validade da entrada

    ; primeiro digito
    MOV A, B
    CPI 30H
    JC ERRO_ENTRADA
    CPI 33H
    JNC ERRO_ENTRADA

    ; segundo digito
    MOV A, C
    CPI 30H
    JC ERRO_ENTRADA
    CPI 3AH
    JNC ERRO_ENTRADA

    ; terceiro digito
    MOV A, D
    CPI 30H
    JC ERRO_ENTRADA
    CPI 3AH
    JNC ERRO_ENTRADA

    ; limite de 255
    MOV A, B
    CPI 32H
    JC ENTRADA_VALIDA
    JNZ ERRO_ENTRADA

    MOV A, C
    CPI 35H
    JC ENTRADA_VALIDA
    JNZ ERRO_ENTRADA

    MOV A, D
    CPI 36H
    JNC ERRO_ENTRADA

ENTRADA_VALIDA:

    ; ----- Chamar rotina decimal para binário

    ; ----- Armazenar resultado na memória

    ; ----- Realizar verificação (se necessário)

    ; ----- Fim programa
    HLT

; ROTINAS DO CONVERSOR
DEC_PARA_BIN:
    ; Implementar posteriormente
    RET

; TRATAMENTO DE ERRO
ERRO_ENTRADA:
    MVI A, 01H
    STA ERRO_FLAG
    HLT

; FALHA NA VERIFICACAO
FALHA:
    ; Registrar falha
    HLT

