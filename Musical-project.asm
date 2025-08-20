                        * = 49152

; Commodore 64 Musical Project
; By Stephen Morrow (C) 8/18/25 by C64Brain
; https://www.c64brain.com/
; Compiler: CBM Prg Studio Editor (v)4.5.0

; Voice 1: Noise
; Voice 2: Pulse

SID = 54272
TIMER = $08                  ; Timers - fast and slow, updated every frame
SLOW_TIMER = $09
                lda #147
                jsr $ffd2
                lda #0
                sta 53281  

                jsr spritesetup 
                jsr WipeSIDSound
start

; s=54272 (when used in Basic)

                lda #33
                sta $d404        ; voice 1: control register: 54276 (s+4)
                lda #17
                sta $d40b        ; voice 2: control register: 54283 (s+11)
                lda #65
                sta $d412        ; voice 3: control register: 54290 (s+18)

                lda #31           ; 3 - 5 (3 to 5)
                sta $d405        ; $d405: Attack / Decay:s+5 (voice 1) : 54277
                lda #3
                sta $d40c        ; $d40c: Attack / Decay:s+12 (voice 2): 54284
                lda #65
                sta $d413        ; $d413: Attack / Decay:s+19 (voice 3): 54291     

                lda #128         ; 5 - 12 (5 to 12)
                sta $d406        ; vc 1: Sustain/Release register: 54278 (s+6)
                lda #0
                sta $d40d        ; vc 2: Sustain/Release register: 54285 (s+13)
                lda #243
                sta $d414        ; vc 3: Sustain/Release register: 54292 (s+20)

                lda #8
                sta SID+24        ; SID volume (0-15)

; Pulse Width init
                lda #8
                sta $d402        ; voice 1:Pulse width (low) :  54274
                sta $d403        ; voice 2:Pulse width (high):  54275
                lda #128
                sta $d409        ; voice 2: Pulse width (low):  54281    
                sta $d40a        ; voice 2: Pulse width (high): 54282
                lda #11
                sta $d410        ; voice 3: Pulse width (low) : 54288   
                sta $d411        ; voice 3: Pulse width (high): 54289
                                
mainloop                       
                lda tunes,x        
                sta $d400         ; voice 1 freq control (low): 54272 (s+2)
                sta $d407         ; voice 2 freq control (low): 54279 (s+7)
                sta $d40e         ; voice 3 freq control (low): 54286 (s+14)
                sta 53287
                inx
                lda tunes,x
                sta $d401         ; voice 1 freq control (high): 54273
                sta $d408         ; voice 2 freq control (high): 54280
                sta $d40f         ; voice 2 freq control (high): 54287
                sta 53248
                cmp #0
                bne scanline1
                ldx #0

scanline1
                jsr Counters
                jsr DisplayMessage

                inc $d020
                jmp start

WipeSIDSound
                ldy #24
                lda #0
clearSID
                sta SID,y
                dey
                bpl clearSID
                rts

spritesetup
                lda #1
                sta 53269
                lda #110
                sta 53249
                rts

DisplayMessage
                ldy #0
drawmsg
                lda jollytune,y
                sec
                sbc #64
                sta 1114,y
                tya
                clc
                adc #1
                lsr 
                sta 55386,y
                iny
                cpy #14
                bne drawmsg
                rts

Counters
                lda counter1
                inc counter1    ; increase counter1
                sta $d405       ; $d405: Attack / Decay (voice 1)
                bne Counters
                lda counter2
                dec counter2    ; decrease counter2
                sta $d40c       ; $d405: Attack / Decay (voice 2)
                bne Counters

                lda #0
                sta counter1
                lda speed
                sta counter2
                rts                

counter1 byte 5         ; counts up
counter2 byte 55       ; counts down      

decayreleasevc1 byte 5
decayreleasevc2 byte 10


speed byte 55

value byte 254

jollytune byte "JOLLY OLE TUNE"

tunes
        byte 143,10
        byte 143,12
        byte 24,14
        byte 210,15
        byte 195,16
        byte 195,16

        byte 209,18
        byte 195,16
        byte 210,15
        byte 195,16
        byte 209,18
        byte 96,22
        byte 30,25
        byte 96,22
        byte 31,21
        byte 209,18
        byte 195,16
        byte 210,15
        byte 195,16
        byte 00,00
        
