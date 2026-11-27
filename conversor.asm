; --------- CONVERSOR DECIMAL->BINÁRIO ----------
; DISCIPLINA: Linguagem de Máquina
; DOCENTE: Laura Beatriz Alves
; PROCESSADOR: Intel 8085
; ----------------------------------------------

; MAPA DE MEMÓRIA
IN_DECIMAL  EQU 2000H ; Decimal ASCII (3 caracteres)
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
    CALL DEC_PARA_BIN

    CALL VERIFICA_BIN

    ; ----- Fim programa
    HLT

VERIFICA_BIN:
    MVI B, 00H
    LXI H, OUT_BIN
    MVI C, 08H

VERIFICA:
    MOV A, B
    RLC
    MOV B, A

    MOV A, M
    CPI 31H
    JNZ PROXIMO
    INR B

PROXIMO:
    INX H
    DCR C
    JNZ VERIFICA

    LDA VALOR_BIN
    CMP B
    JNZ FALHA

    RET

DEC_PARA_BIN:
    ; Converter ASCII para numero decimal
    MOV A, B
    SUI 30H
    MOV B, A

    MOV A, C
    SUI 30H
    MOV C, A

    ; Limpar acumulador
    MVI E, 00H

    ; Somar centenas
CENTENAS:
    MOV A, B
    ORA A
    JZ DEZENAS

    MOV A, E
    ADI 64H
    MOV E, A
    DCR B
    JMP CENTENAS

    ; Somar dezenas
DEZENAS:
    MOV A, C
    ORA A
    JZ UNIDADES

    MOV A, E
    ADI 0AH
    MOV E, A
    DCR C
    JMP DEZENAS

    ; Somar unidades
UNIDADES:
    MOV A, D
    SUI 30H
    ADD E
    STA VALOR_BIN

    ; Converter para binario ASCII
    MOV B, A
    LXI H, OUT_BIN
    MVI C, 08H

BINARIO:
    MOV A, B
    RLC
    MOV B, A

    MVI A, 30H
    JNC GRAVA
    INR A

GRAVA:
    MOV M, A
    INX H
    DCR C
    JNZ BINARIO

    RET

; TRATAMENTO DE ERRO
ERRO_ENTRADA:
    MVI A, 01H
    STA ERRO_FLAG
    HLT

; FALHA NA VERIFICACAO
FALHA:
    MVI A, 02H
    STA ERRO_FLAG
    HLT
