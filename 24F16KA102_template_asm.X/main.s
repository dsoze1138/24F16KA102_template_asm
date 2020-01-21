    .nolist
    .title " Sample PIC24F Assembler Source Code"
    .sbttl " PORTB bit pulser"
    .psize 1000,132
    .list
;   
; File: main.s
; Target: PIC24F16KA102
; IDE: MPLABX V5.25
; Compiler: XC16 v1.41
;   
; Description:
;   This is a simple "hello world" demo
;   it pulses the bits on PORTB from 
;   bit 0 to bit 15.
;   
    .include "p24F16KA102.inc"
    .text
    .global __reset 
__reset: 
    mov     #__SP_init,w15      ; Initalize the Stack Pointer 
    mov     #__SPLIM_init,w0    ; Initialize the Stack Pointer Limit Register 
    mov     w0, SPLIM 
    nop                         ; Add NOP to follow SPLIM initialization 
    
    call    _wreg_init          ; Set all woring registers to zero 
    
    call    _PIC_init           ; Initialize this PIC 
    
    mov     #0x0000,w0          ; Set all GPIO pins as outputs 
    mov     w0,TRISA
    mov     w0,TRISB
;   
; Do a simple "hello world" bit pulser 
;   
    mov     #0x01,w5 
HelloLoop: 
    mov     w5,LATA
    mov     w5,LATB
    call    delay 
    rlnc    w5,w5 
    
    bra     HelloLoop 
;   
; Delay loop 
;   
delay: 
    mov     #0xffff,w6 
dloop: 
    nop
    nop
    nop
    nop
    dec     w6,w6 
    cp0     w6 
    bra     nz,dloop 
    return 
;   
; Initialize W registers to zero 
;   
_wreg_init: 
    clr     w0 
    mov     w0,w14 
    repeat  #12 
    mov     w0,[++w14] 
    clr     w14 
    return 
    
;   
; Initialize this PIC 
;   
_PIC_init: 
    mov     #0,w0 
    mov.w   w0,CLKDIV           ; Set for default clock operations 
    
    bset    INTCON1,#NSTDIS     ; Disable interrupt nesting 
    
    mov     #0xFFFF,w0 
    mov.w   w0,AD1PCFG          ; Set for digital I/O 
    
    return 
    
; 
; Setup the interrupt vectors 
; for system traps. 
; 
    .global  __OscillatorFail 
    .global  __AddressError 
    .global  __StackError 
    .global  __MathError 
    
    .global  __AltOscillatorFail 
    .global  __AltAddressError 
    .global  __AltStackError 
    .global  __AltMathError 
    
    
    .text 
    
; Default Exception Vector handlers if ALTIVT(INTCON2<15>) = 0 
    
; Oscillator Fail Trap 
__OscillatorFail: 
    bclr    INTCON1, #OSCFAIL 
    nop 
    bra     $-2 
    retfie 
    
; Address Error Trap 
__AddressError: 
    bclr    INTCON1, #ADDRERR 
    nop 
    bra     $-2 
    retfie 
    
; Stack Error Trap 
__StackError: 
    bclr    INTCON1, #STKERR 
    nop 
    bra     $-2 
    retfie 
    
; Math Error Trap 
__MathError: 
    bclr  INTCON1, #MATHERR 
    nop 
    bra     $-2 
    retfie 
    
    
; Alternate Exception Vector handlers if ALTIVT(INTCON2<15>) = 1 
    
; Alternate Oscillator Fail Trap 
__AltOscillatorFail: 
    bclr  INTCON1, #OSCFAIL 
    nop 
    bra     $-2 
    retfie 
    
; Alternate Address Error Trap 
__AltAddressError: 
    bclr  INTCON1, #ADDRERR 
    nop 
    bra     $-2 
    retfie 
    
; Alternate Stack Error Trap 
__AltStackError: 
    bclr  INTCON1, #STKERR 
    nop 
    bra     $-2 
    retfie 
    
; Alternate Math Error Trap 
__AltMathError: 
    bclr  INTCON1, #MATHERR 
    nop 
    bra     $-2 
    retfie 
    
    .end 
