; ==========================================================
;  CONVERSOR DE BASES NUMERICAS (DECIMAL <-> BINARIO) - 8085
;  Numeros de 8 bits (0 a 255)
;
;  Parte 1: decimal -> binario (8 caracteres ASCII '0'/'1')
;  Parte 2: binario (texto ASCII) -> valor -> decimal ASCII
;  Parte 3: verificacao (volta binario -> decimal e compara)
; ==========================================================

; ---------- Mapa de memoria ----------
IN_DECIMAL    EQU 2000H ; 1 byte : numero decimal de entrada
OUT_BIN       EQU 2100H ; 8 bytes: binario gerado (ASCII)
IN_BIN        EQU 2200H ; 8 bytes: binario de entrada (ASCII)
VALOR_BIN     EQU 2300H ; 1 byte : valor numerico do binario lido
OUT_DECIMAL   EQU 2400H ; 3 bytes: decimal gerado (centena,dezena,unidade)
VERIFICA      EQU 2500H ; 00 = conversao conferida, FF = falhou
ERRO_FLAG     EQU 2501H ; 00 = ok, FF = caractere invalido no binario


; ---
ORG 0000H
LXI SP,27FFH            ; inicializa a pilha
XRA A
STA ERRO_FLAG           ; limpa flags
STA VERIFICA
; ---


; DECIMAL é convertido para BINÁRIO
MVI A,181               ; numero decimal de teste (B5H)
STA IN_DECIMAL
LDA IN_DECIMAL
LXI D,OUT_BIN           ; DE = destino do texto binario
CALL DEC_PARA_BIN

; BINÁRIO é converido para DECIMAL
LXI H,BIN_ROM           ; origem: texto "11001010" guardado no programa
LXI D,IN_BIN           ; destino: RAM
MVI C,08H
CALL COPIA_BLOCO        ; copia 8 bytes para a memoria de entrada

LXI H,IN_BIN
CALL BIN_PARA_VALOR     ; A = valor, CY = 1 se erro
JC  ERRO_ENTRADA
STA VALOR_BIN
LXI H,OUT_DECIMAL
CALL VALOR_PARA_ASCII   ; grava 3 digitos decimais ASCII

; Resultado obtido pela conversão é verificado
LXI H,OUT_BIN
CALL BIN_PARA_VALOR     ; volta o binario gerado para numero
JC  ERRO_ENTRADA
LXI H,IN_DECIMAL
CMP M                   ; compara com o decimal original
JNZ FALHA
XRA A
STA VERIFICA            ; 00 = confere
HLT

FALHA:
    MVI A,0FFH
    STA VERIFICA
    HLT

ERRO_ENTRADA:
    MVI A,0FFH
    STA ERRO_FLAG
    HLT

; ==========================================================
;  DEC_PARA_BIN
;  Entrada: A = numero | DE = endereco de destino (8 bytes)
;  Saida  : 8 caracteres ASCII '0'/'1' (bit 7 primeiro)
;  Usa    : A, B, C, D, E
; ==========================================================
DEC_PARA_BIN:
    MVI C,08H               ; 8 bits
DPB_LOOP:
    RLC                     ; bit 7 vai para o carry
    MOV B,A                 ; guarda o numero rotacionado
    MVI A,00H               ; (MVI nao altera o carry)
    ACI 30H                 ; A = 30H + carry  -> '0' ou '1'
    STAX D                  ; grava o caractere
    INX D
    MOV A,B                 ; recupera o numero
    DCR C
    JNZ DPB_LOOP
    RET

; ==========================================================
;  BIN_PARA_VALOR
;  Entrada: HL = endereco do texto binario (8 caracteres)
;  Saida  : A = valor numerico | CY = 0 ok, CY = 1 se algum
;           caractere nao for '0' nem '1'
;  Metodo : acumulador = acumulador*2 + bit
;  Usa    : A, B, C, D, HL
; ==========================================================
BIN_PARA_VALOR:
    MVI C,08H
    MVI D,00H               ; D = acumulador
BPV_LOOP:
    MOV A,M                 ; le o caractere
    SUI 30H                 ; '0'->0, '1'->1, outros -> invalido
    CPI 02H
    JNC BPV_ERRO            ; se A >= 2, caractere invalido
    MOV B,A                 ; B = bit
    MOV A,D
    ADD A                   ; acumulador * 2
    ADD B                   ; + bit
    MOV D,A
    INX H
    DCR C
    JNZ BPV_LOOP
    MOV A,D
    ORA A                   ; zera o carry (sem erro)
    RET
BPV_ERRO:
    STC                     ; CY = 1 sinaliza erro
    RET

; ==========================================================
;  VALOR_PARA_ASCII
;  Entrada: A = numero (0-255) | HL = destino (3 bytes)
;  Saida  : centena, dezena e unidade em ASCII
;  Usa    : A, B, C, HL
; ==========================================================
VALOR_PARA_ASCII:
    MVI C,100
    CALL CONTA_DIG          ; digito das centenas
    MVI C,10
    CALL CONTA_DIG          ; digito das dezenas
    ADI 30H                 ; o que sobrou = unidades
    MOV M,A
    RET

; ---------- CONTA_DIG ----------
;  Subtrai C de A enquanto A >= C, contando em B (ASCII).
;  Grava o digito em [HL], avanca HL. A fica com o resto.
CONTA_DIG:
    MVI B,30H               ; comeca em '0'
CD_LOOP:
    CMP C                   ; A - C (carry se A < C)
    JC  CD_FIM
    SUB C
    INR B
    JMP CD_LOOP
CD_FIM:
    MOV M,B
    INX H
    RET

; ==========================================================
;  COPIA_BLOCO
;  Entrada: HL = origem | DE = destino | C = quantidade
; ==========================================================
COPIA_BLOCO:
    MOV A,M
    STAX D
    INX H
    INX D
    DCR C
    JNZ COPIA_BLOCO
    RET

; ==========================================================
;  DADO CONSTANTE: texto "11001010" (= 202 decimal)
; ==========================================================
BIN_ROM:
    DB 31H,31H,30H,30H,31H,30H,31H,30H
