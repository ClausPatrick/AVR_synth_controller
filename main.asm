 
.EQU            TWI_slave_address_write         = 0x70                  ;0b01011000
.EQU            TWI_slave_adr_Oscillator_A      = 0x70                  ;0b01011000
.EQU            TWI_slave_adr_Oscillator_B      = 0x72                  ;0b01011010
.EQU            TWI_slave_adr_Oscillator_C      = 0x74                  ;0b01011100
.EQU            TWI_slave_adr_Oscillator_D      = 0x76                  ;0b01011110
.EQU            TWI_slave_adr_ADSR_A            = 0x78                  ;0b01011000
.EQU            TWI_slave_adr_ADSR_B            = 0x7a                  ;0b01011010
.EQU            TWI_slave_adr_ADSR_C            = 0x7c                  ;0b01011100
.EQU            TWI_slave_adr_ADSR_D            = 0x7e                  ;0b01011110
.equ            TWI_LED_Address                         = 0b01000000
.equ        Note_slot_location          = 0x140
.equ        Note_on_buffer              = 0x148
.equ        Note_off_buffer             = 0x150
.EQU            SAA_control                             = 0b01110111
.EQU            TWI_start_flag                  = 0x08
.EQU            TWI_rep_start_flag              = 0x10
.EQU            TWI_slave_addr_ack              = 0x18
.EQU            TWI_slave_addr_nack             = 0x20
.EQU            TWI_Datain_ack                  = 0x28
.EQU            TWI_Datain_nack                 = 0x30
.EQU            TWI_arb_lost_                   = 0x38
.EQU            TWI_clock                               = 0x48          ;scl freq = 100kHz at 16MHz xtal (72 dec as per avr315 app note)
 
.EQU            Miclock                                 = 0xf8
.EQU            Misense                                 = 0xfe
.EQU            Mistop                                  = 0xfc
.EQU            Mistart                                 = 0xfa
.EQU            MiNootUit                               = 0x80
.EQU            MiNootAan                               = 0x90
.equ            synul                                   = 0x77
.equ            syeen                                   = 0x60
.equ            sytwee                                  = 0x3b
.equ            sydrie                                  = 0x79
.equ            syvier                                  = 0x6c
.equ            syvijf                                  = 0x5d
.equ            syzes                                   = 0x5f
.equ            syzeven                          = 0x70
.equ            syacht                                   = 0x7f
.equ            synegen                          = 0x7d
.equ            syA                                             = 0x7e
.equ            syB                                      = 0x4f
.equ            syC                                      = 0x17
.equ            syD                                      = 0x6b
.equ            syE                                      = 0x1f
.equ            syF                                      = 0x1e
.equ            syMin                                   = 0x08
.equ            syBo                                    = 0x3c
.equ            syBe                                     = 0x4b
.equ            syPunt                                   = 0x80 
.equ            Speicher_beg                    = 0x0060
.equ            Speicher_end                    = 0x045f
.equ            LCD_return_home                 = 0b00000011
.equ            Buffer_Begin                    = 0x140
.equ            Buffer_End                              = 0x180
 
.DEF            Links_of_Rechts =       r1
.def            User_Settings   =       r2              ;Line_Offset
.def            I2C_HeadCount   =   r3
.DEF            Sense_Tel               =       r4
.DEF            ADC_Data2               =       r5
;.DEF           ADC_Temp                =       r6
.DEF            SymBool_H               =       r7
.DEF            SymBool_L               =       r8
.def            TWI_Address             =       r9
.def            TWI_Data                =       r10
.def            DirecTorC               =       r11
.def            data_in0                =       r12
.def            Y_Pointer_OFF   =       r13
.def            Y_Pointer_ON    =       r14
.def            Midi_Settings   =       r15
.DEF            Temp                    =       r16
.DEF            Flank_Reg               =       r17
.DEF            Temp3                   =       r18
.DEF            DirecTor                =       r19
.def            LCD_Data                =       r20
.DEF            DirecTorB               =       r21
;.def           UART_Temp_Data  =       r22
.DEF            Traag1                  =       r23
.DEF            Traag2                  =       r24
.DEF            Pos_X                   =       r25
 
.ORG    0x000
                                rjmp            RESET
.ORG    0x010 ;URXCaddr        ;
                                rjmp    TIM0_ovfl
.ORG    0x012 ;URXCaddr        ;
                                rjmp    UART_RXCP
;.cseg
;____________________________________________________________________________________________________________________
 
RESET:                       
                        ldi Temp, low(RAMEND)
                        out SPL, Temp
                        ldi     Temp, high(RAMEND)
                        out sph, Temp
/*                                              ldi             Yh, high(2*0x140)
                                                ldi             Yl, low(2*0x140)
                                                ldi             Temp, 0xff
                                                st              y, Temp*/              
;ADC Multiplexer Selection Register –ADMUX
;REFS1 REFS0 ADLAR – MUX3 MUX2 MUX1 MUX0
;MUX3..0 Single Ended Input
;0000 ADC0
;0001 ADC1
;0010 ADC2
;0011 ADC3
;0100 ADC4
;0101 ADC5
;0110 ADC6
;0111 ADC7
;ADC Control andStatus Register A –ADCSRA
;ADEN ADSC ADFR ADIF ADIE ADPS2 ADPS1 ADPS0
;ADPS2 ADPS1 ADPS0 Division Factor
;0 0 0 2
;0 0 1 2
;0 1 0 4
;0 1 1 8
;1 0 0 16
;1 0 1 32
;1 1 0 64
;1 1 1 128
                        ldi             Temp, 0b01100110
                        sts             ADMUX, Temp
                        ldi             Temp, 0b10001111
                        sts             ADCSRA, Temp
                        ldi             Temp, 72
                        sts             twbr, Temp
 
                        ldi             temp, 0b00110000
                        out             ddrc, temp
                        ldi             temp, 0b00000110
                        out             ddrb, temp
                        ldi             temp, 0b11111100
                        out             ddrd, temp
 
/*                      cbi                     ddrc, 0         ;Button 4
                        cbi                     ddrc, 1         ;Button 3
                        cbi                     ddrc, 2         ;Button 2
                        cbi                     ddrc, 3         ;Button 1
 
                        sbi                     ddrc, 4         ;SDA
                        sbi                     ddrc, 5         ;SCL   
 
                        cbi                     ddrb, 0         ;Button 5
                        sbi                     ddrb, 1         ;Led1[Green]
                        sbi                     ddrb, 2         ;Led5[Red]
                        cbi                     ddrb, 3         ;Button 6
                        cbi                     ddrb, 4         ;Button 7
                        cbi                     ddrb, 5         ;Button 8
 
                        sbi                     ddrd, 2         ;lcd_RS
                        sbi                     ddrd, 3         ;lcd_En
                        sbi                     ddrd, 4         ;lcd_D4
                        sbi                     ddrd, 5         ;lcd_D5
                        sbi                     ddrd, 6         ;lcd_D6
                        sbi                     ddrd, 7         ;lcd_D7                 */
                               
                        ldi                     Temp, 0x20
                init_loop:
                        rcall   VerTraag_lang
                        dec                     Temp
                        brne            init_loop
                        sbi                     PortB, 2                ;Led5[Red]__INVERTED!
                        sbi                     PortB, 1                ;Led1[Green]__INVERTED!
                        ldi                     Temp, 0
 
 
LCD_init:
                        clr             Temp
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000                        ;0
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00111000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000                        ;0
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00111000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000                        ;0
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00101000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
 
                        ldi             Temp, 0b00100000
                        rcall   push_PortD_and_Vertraag_lang
                        ;out            PortD, Temp
                        ;rcall  VerTraag_lang
                       
                        rjmp            init_lcd_instr_                        
 
                push_PortD_and_Vertraag_lang:
                        out             PortD, Temp
                        rcall   VerTraag_lang  
                        rcall   VerTraag_lang
                        ret
 
 
                init_lcd_instr_:
                        ldi             LCD_Data, 0b00101000            ;1      ;0b0010/N/F/xx
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        ldi             LCD_Data, 0b00101000            ;1      ;0b0010/N/F/xx
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        ldi             LCD_Data, 0b00101000            ;3      ;0b0010/N/F/xx         
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        ldi             LCD_Data, 0b00001110            ;5      ;0b00001/D/C/B 
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        ldi             LCD_Data, 0b00000001            ;7      ;0b00000001
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        ldi             LCD_Data, 0b00000110            ;9      ;0b000001/ID/S
                        rcall   LCD_write_Instruction
                        rcall   VerTraag_lang
                        rcall   VerTraag_lang
                        ;sbi            ADCSRA, 6
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation_>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        ldi             LCD_Data, 0b10000000            ;-------------------1-------------
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
                        ldi             LCD_Data, 0x40
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
 
                        ldi             temp3, 0x06
                        rcall   Push_Line_Nill
                        ldi             temp3, 0x02
                        rcall   Push_Line_Black
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x48
                        rcall   LCD_write_Instruction           ;-------------------2-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x04
                        rcall   Push_Line_Nill
                        ldi             temp3, 0x04
                        rcall   Push_Line_Black
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x50
                        rcall   LCD_write_Instruction           ;-------------------3-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x02
                        rcall   Push_Line_Nill
                        ldi             temp3, 0x06
                        rcall   Push_Line_Black
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x58
                        rcall   LCD_write_Instruction           ;-------------------4-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x08
                        rcall   Push_Line_Nill
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x60
                        rcall   LCD_write_Instruction           ;-------------------5-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x02
                        rcall   Push_Line_Black
                        ldi             temp3, 0x06
                        rcall   Push_Line_Nill
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x68
                        rcall   LCD_write_Instruction           ;-------------------6-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x04
                        rcall   Push_Line_Black
                        ldi             temp3, 0x04
                        rcall   Push_Line_Nill
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x70
                        rcall   LCD_write_Instruction           ;-------------------7-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x06
                        rcall   Push_Line_Black
                        ldi             temp3, 0x02
                        rcall   Push_Line_Nill
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_character generation
                        ldi             LCD_Data, 0x68
                        rcall   LCD_write_Instruction           ;-------------------8-------------
                        rcall   VerTraag
 
                        ldi             temp3, 0x04
                        rcall   Push_Line_Black
                        ldi             temp3, 0x04
                        rcall   Push_Line_Nill
 
                        rjmp    initialisation_dir              ;Skip the following two subs;
 
Push_Line_Nill:                
                        ldi             LCD_Data, 0b00000000
                        rcall   LCD_write_Data
                        rcall   VerTraag
                        dec             temp3
                        brne    Push_Line_Nill                 
ret            
 
Push_Line_Black:                       
                        ldi             LCD_Data, 0b00011111
                        rcall   LCD_write_Data
                        rcall   VerTraag
                        dec             temp3
                        brne    Push_Line_Black
 
 

                initialisation_dir:
 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_END_character generation_END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
                        clr             Temp
                        sts             UBRR0H, Temp                   
             
                        ldi             Temp, 0x0f      ; baudrate = 31250,                                                                                                     
                        sts             UBRR0L, Temp
 
                        clr             Temp
                        ori             Temp, 0b00011000
                        sts             UCSR0B, Temp
                        ldi             Temp, 0b00000110
                        sts             UCSR0c, Temp
                        ldi             zl, low(2*0x720)
                        ldi             zh, high(2*0x720)
                        rcall   Print_Menu
 
                        clr             Temp
                        mov             DirecTor, Temp
                        mov             DirecTorB, Temp
                        mov             DirecTorC, Temp
                        ldi             Yh, high(0x140)                                                         ;Y-reg is voor midi verwerking.
                        ldi             Yl, low(0x140)
                clear_midi_slots:
                        st              y+, Temp
                        cpi             yl, 0x58
                        brne    clear_midi_slots
                        ldi             Yh, high(Note_on_buffer)                                        ;Y-reg is voor midi verwerking.
                        ldi             Yl, low(Note_on_buffer)
                        mov             Y_Pointer_OFF, Yl                                                               ;Clearing all Directive registers.
                        ldi             temp, low(Note_off_buffer)
                        mov             Y_Pointer_ON, Yl                                                                ;Clearing all Directive registers.
 
                        mov             I2C_HeadCount, Temp
                        mov             User_settings, Temp
                        ldi             Temp, 0b00010000                                                        ;Setting to Polyphony, 4 midi notes for 4 slots, as default.
                        mov             Midi_Settings, Temp
                        ldi             Temp, 0x80
                init_loop2:
                        rcall   VerTraag_lang
                        dec             Temp
                        brne    init_loop2
 
                        rcall   Load_Buffer
                        rcall   VerTraag
                        rcall   Load_Template
                        rcall   VerTraag
                        rcall   Sub_Scherm_Volmaken
                        rcall   VerTraag
 
 
                Timer_0_initialisation:
/*                      ldi             Temp, 0b00000101
                        out             tCCR0b, Temp
                        LDI             Temp, 0
                        sts             tCNT0, Temp
                        LDI             Temp, 0b00000001
                        sts             TIMSK0, Temp*/
 
                        ldi             Temp, TWI_LED_Address
                        mov             TWI_Address, Temp
                        ldi             Temp, 0xfe
                        mov             TWI_Data, Temp
                        rcall   TWI_MONO_write_routine
                        ldi             temp, 0
                        mov             sense_tel, temp
 
/*      I2C_Enumeration:
                ldi             temp, 0xff
                mov             I2C_HeadCount, temp                                                                     ;Assuming all Slaves are present.
 
 
                Calling_OscA:
                                ldi             temp,   TWI_slave_adr_Oscillator_A              
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_OscB                    ;Branch if Zero.
                                ldi             temp, 0b11111110
                                and             I2C_HeadCount, temp            
                        Calling_OscB:
                                ldi             temp,   TWI_slave_adr_Oscillator_B              
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_OscC                    ;Branch if Zero.
                                ldi             temp, 0b11111101
                                and             I2C_HeadCount, temp                                            
                        Calling_OscC:
                                ldi             temp,   TWI_slave_adr_Oscillator_C              
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_OscD                    ;Branch if Zero.
                                ldi             temp, 0b11111011
                                and             I2C_HeadCount, temp    
                        Calling_OscD:
                                ldi             temp,   TWI_slave_adr_Oscillator_D              
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_ADSR_A                  ;Branch if Zero.
                                ldi             temp, 0b11110111
                                and             I2C_HeadCount, temp    
                        Calling_ADSR_A:
                                ldi             temp,   TWI_slave_adr_ADSR_A            
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_ADSR_B                  ;Branch if Zero.
                                ldi             temp, 0b11101111
                                and             I2C_HeadCount, temp    
                        Calling_ADSR_B:
                                ldi             temp,   TWI_slave_adr_ADSR_B            
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_ADSR_C                  ;Branch if Zero.
                                ldi             temp, 0b11011111
                                and             I2C_HeadCount, temp    
                        Calling_ADSR_C:
                                ldi             temp,   TWI_slave_adr_ADSR_C            
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Calling_ADSR_D                  ;Branch if Zero.
                                ldi             temp, 0b10111111
                                and             I2C_HeadCount, temp    
                        Calling_ADSR_D:
                                ldi             temp,   TWI_slave_adr_ADSR_D            
                                rcall   Address_Rep_Proc
                                tst             TWI_Address
                                breq    Address_OK                      ;Branch if Zero.
                                ldi             temp, 0b01111111
                                and             I2C_HeadCount, temp    
 
 
 
                        Address_OK:
                                tst             TWI_Data
                                breq    Data_OK
 
 
 
                        Data_Ok:
 
                                ret
 
 
 
 
                                Address_Rep_Proc:
                                                        mov             TWI_Address, temp
                                                        ldi             temp, 0x01
                                                        mov             TWI_Data, temp
                                                        ;rcall  TWI_MONO_write_routine
                                                ret*/
 
;____________________________________________________________________________________________________________________
        main:                                                          
                        ldi                     Temp, 0b11000011                                ;
                        sts                     ADCSRA, Temp
                        ldi                     Temp, 0b10011000        ;zet rxcien AAN
                        sts                     UCSR0B, Temp
                        sei    
                        rcall           ADC_rout
                        ldi                     Zl, low(2*0x100)                                        ;Allen ALPHA QUADRANT en BETA QUADRANT worden hier gevuld.
                        ldi                     Zh, high(2*0x100)
                        add                     Zl, Links_of_Rechts                                     ;Links of Rechts. ACD_Positie1
                        sbrc            DirecTorB, 5
                        rcall           Neg_org
                        sbrs            DirecTorB, 5
                        rcall           Pos_org        
                        st                      Z, ADC_Data2                                            ;Links_of_Rechts, van potentiometer.
                        rcall           Force_Sym
                        rcall           Load_Template                  
                        rcall           VerTraag
                        ;rcall          Sub_Scherm_Volmaken                                     ;********************************<terug activeren!
                        ;----test
                        rcall           Midi_Clean
                                ldi             zl, low(0x140)
                                ldi             zh, high(0x140)
                                ldi             LCD_Data, 0x80         
                                rcall   LCD_write_Instruction
                                rcall   VerTraag
 
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
                                ld              Temp, z+
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
/*                              ldi             LCD_Data, 0xc0                                          ;zet display positie op $10 + $80 voor command
                                rcall   LCD_write_Instruction
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 0
                                ldi             temp, 'A'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 1
                                ldi             temp, 'B'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 2
                                ldi             temp, 'C'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 3
                                ldi             temp, 'D'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 4
                                ldi             temp, 'E'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 5
                                ldi             temp, 'F'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 6
                                ldi             temp, 'G'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
 
                                ldi             temp, ' '
                                sbrc    I2C_HeadCount, 7
                                ldi             temp, 'H'
 
                                mov             LCD_Data, Temp
                                rcall   LCD_write_Data
                                rcall   VerTraag
*/
 
 
 
                                ;rcall  TWI_MONO_write_routine                                         
/*                              sbic PinC, 3
                        rcall test_hl_flank_3 ;goto if released
                sbis PinC, 3
                        rcall test_lh_flank_3 ;goto if pressed*/
                sbic PinC, 2
                        rcall test_hl_flank_2 ;goto if released
                sbis PinC, 2
                        rcall test_lh_flank_2 ;goto if pressed
 
                sbic PinC, 1
                        rcall test_hl_flank_1 ;goto if released
                sbis PinC, 1
                        rcall test_lh_flank_1 ;goto if pressed      
                sbic PinC, 0
                        rcall test_hl_flank_0 ;goto if released
                sbis PinC, 0
                        rcall test_lh_flank_0 ;goto if pressed                                                  
                                sbic PinB, 0                                    ;Button 7   /step left
                        rcall test_hl_flank_B_0 ;goto if released
                sbis PinB, 0
                        rcall test_lh_flank_B_0 ;goto if pressed
                sbic PinB, 3
                        rcall test_hl_flank_B_1 ;/BUTTON_5/ goto if released
                sbis PinB, 3
                        rcall test_lh_flank_B_1 ;goto if pressed      
                sbic PinB, 4
                        rcall test_hl_flank_B_2 ;goto if released
                sbis PinB, 4
                        rcall test_lh_flank_B_2 ;goto if pressed      
                sbic PinB, 5                                    ;Button 8   /step right
                        rcall test_hl_flank_B_3 ;goto if released
                sbis PinB, 5
                        rcall test_lh_flank_B_3 ;goto if pressed                                                                                                                                                  
                                ldi                     Temp, 0xff
                                mov                     TWI_Data, Temp
                                ldi                     Temp, TWI_LED_Address
                                mov                     TWI_Address, Temp
                                rcall           TWI_MONO_write_routine
                                rcall           VerTraag
                                sbis            PinC, 3                                 ;goto Menu
                                rcall           Mn_Menu
                                sbrc            DirecTorB, 2                    ;goto Mn_Flush_Poly
                                rcall           Mn_Flush_Poly
                                sbrc            DirecTorB, 3                    ;goto Mn_Flush_Mono
                                rcall           Mn_Flush_Mono
                                sbrc            DirecTorB, 4                    ;goto Mn_Forced_Algoritm
                                rcall           Mn_Forced_Algoritm
                                ;sbrc           DirecTorB, 5
                                ;rcall          Mn_Pos_Neg
                                rjmp            main
;____________________________________________________________________________________________________________________
;
 
Neg_org:                                               
                        dec                     Zl
                        ldi                     Temp, 0
                        st                      Z+, Temp                                                ;Links_of_Rechts, van potentiometer.
                        ;inc                    Zl
                        ret
;____________________________________________________________________________________________________________________
Pos_org:                                               
                        inc                     Zl
                        ldi                     Temp, 0
                        st                      -Z, Temp                                                ;Links_of_Rechts, van potentiometer.
                        ;dec                    Zl
                        ret                    
;___________________________________________________________________________________________________________________
Midi_Clean:
                                                        push    Temp
                                                        push    Temp3
                                                        push    yh
                                                        push    yl
                                                        sbrs    DirecTor, 4
                                                        rjmp    Skip_Clean_1
                                                        ldi             Yh, high(0x140)
                                                        ldi             Yl, low(0x140)                                                 
                                                        ld              Temp3, y+
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_2
                                                        inc             yl
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_3
                                                        inc             yl
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_4
                                                Skip_Clean_1:
                                                        sbrs    DirecTor, 5
                                                        rjmp    Skip_Clean_2                                                   
                                                        ldi             Yh, high(0x142)
                                                        ldi             Yl, low(0x142)                                                 
                                                        ld              Temp3, y+
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_3
                                                        inc             yl
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_4
                                                Skip_Clean_2:
                                                        ldi             Yh, high(0x144)
                                                        ldi             Yl, low(0x144)                                                 
                                                        ld              Temp3, y+
                                                        inc             yl
                                                        ld              Temp, y
                                                        cp              Temp3, Temp
                                                        breq    Clean_slot_4
                                                        rjmp    Einde_Clean
                                                Clean_slot_2:
                                                                ldi             Temp, 0b11011111
                                                                and             DirecTor, Temp
                                                                rjmp    Cleaning
                                                Clean_slot_3:
                                                                ldi             Temp, 0b10111111
                                                                and      DirecTor, Temp
                                                                rjmp    Cleaning
                                                Clean_slot_4:
                                                                ldi             Temp, 0b01111111
                                                                and      DirecTor, Temp
                                                                rjmp    Cleaning
                                                                Cleaning:
                                                                        ldi             Temp, 0
                                                                        st              y+, Temp
                                                                        st              y+, Temp
                                        Einde_Clean:
                                                pop             yl
                                                pop             yh
                                                pop             Temp3
                                                pop             Temp
                        ret
;=================================================
 
test_lh_flank_2:                                                ;Button  2   ========================
                sbrc Flank_Reg, 2
                        rjmp lh_flank_2
                ret
 
                lh_flank_2:
                        andi    Flank_Reg, 0b11111011 ;flank bit
                                                ori             DirecTorB, 0b00000010
                                                ;ror            TWI_Data
                                                ;ldi            Temp, 0xff
                                                ;mov            TWI_Data, Temp                                         
                                ret
 
test_hl_flank_2:
 
                sbrs Flank_Reg, 2
                        rjmp hl_flank_2
                ret
                        hl_flank_2:
                                ori     Flank_Reg, 0b00000100 ;flank bit
                ret
 
;=================================================
 
test_lh_flank_1:                                                ;Button  3   ========================
                sbrc Flank_Reg, 1
                        rjmp lh_flank_1
                ret
 
                lh_flank_1:
                        andi    Flank_Reg, 0b11111101 ;flank bit
                                                ori             DirecTorB, 0b00000100
                                                ;ror            TWI_Data                                               
                                ret
 
test_hl_flank_1:
 
                sbrs Flank_Reg, 1
                        rjmp hl_flank_1
                ret
 
                        hl_flank_1:
                                ori     Flank_Reg, 0b00000010 ;flank bit
                ret
;=================================================
 
test_lh_flank_0:                                                ;Button  4   ========================
                sbrc Flank_Reg, 0               ;
                        rjmp lh_flank_0
                ret
 
                lh_flank_0:
                        andi    Flank_Reg, 0b11111110 ;flank bit
                                                ori             DirecTorB, 0b00001000
                                                ;ror            TWI_Data                                               
                                ret
 
test_hl_flank_0:
 
                sbrs Flank_Reg, 0
                        rjmp hl_flank_0
                ret
 
                        hl_flank_0:
                                ori     Flank_Reg, 0b00000001 ;flank bit
                ret
;=================================================
;=================================================
 
 
test_lh_flank_B_1:                                             ;Button  5   ========================
                sbrc Flank_Reg, 5               ;Forced Algoritm Choice
                        rjmp lh_flank_1_B
                ret
 
                lh_flank_1_B:
                        andi    Flank_Reg, 0b11011111                   ;flank bit
                                                ori             DirecTorB, 0b00010000                   ;Bit4
                                                ;ror            TWI_Data                                               
                                ret
 
test_hl_flank_B_1:
 
                sbrs Flank_Reg, 5
                        rjmp hl_flank_1_B
                ret
 
                        hl_flank_1_B:
                                ori     Flank_Reg, 0b00100000 ;flank bit
 
                ret
;=================================================
 
test_lh_flank_B_2:                                             ;Button  6   ========================
                sbrc Flank_Reg, 6               ;Pos/Neg
                        rjmp lh_flank_2_B
                ret
 
                lh_flank_2_B:
                        andi    Flank_Reg, 0b10111111           ;flank bit
                                                sbrs    DirecTorB, 5
                                                inc             Links_of_Rechts
 
                                                sbrc    DirecTorB, 5
                                                dec             Links_of_Rechts
 
                                                push    Temp
                                                ldi             Temp, 0b00100000                        ;Bit5
                                                eor             DirecTorB, Temp
                                                pop             Temp
 
                                ret
 
test_hl_flank_B_2:
 
                sbrs Flank_Reg, 6
                        rjmp hl_flank_2_B
                ret
 
                        hl_flank_2_B:
                                ori     Flank_Reg, 0b01000000 ;flank bit
                ret
 
 
;=================================================
 
 
test_lh_flank_B_0:                                             ;Button 7   ========================
                sbrc Flank_Reg, 4               ;Step Left
                        rjmp lh_flank_0_B
                ret
 
                lh_flank_0_B:
                        andi    Flank_Reg, 0b11101111 ;flank bit
                                                push    Temp
                                                ldi             Temp, 0
                                                sbrc    DirecTorB, 5
                                                ldi             Temp, 1
 
                                                cp              Links_of_Rechts, Temp
                                                breq    Is_al_op_begin
                                                dec             Links_of_Rechts
                                                dec             Links_of_Rechts
                                               
                                        Is_al_op_begin:
                                                pop             Temp                                           
                                                ori             DirecTorB, 0b01000000                  
                                ret
 
test_hl_flank_B_0:
 
                sbrs Flank_Reg, 4
                        rjmp hl_flank_0_B
                ret
 
                        hl_flank_0_B:
                                ori     Flank_Reg, 0b00010000 ;flank bit
                ret
;=================================================
 
test_lh_flank_B_3:                                              ;Button 8   ========================
                sbrc Flank_Reg, 7               ;Step Right
                        rjmp lh_flank_3_B
                ret
 
                lh_flank_3_B:
                        andi    Flank_Reg, 0b01111111 ;flank bit
                                                push    Temp
                                                ldi             Temp, 0b00001111
                                                sbrc    DirecTorB, 5
                                                ldi             Temp, 0b00001110
                                                cp              Links_of_Rechts, Temp
                                                breq    Uiterst_rechts
                                                inc             Links_of_Rechts
                                                inc             Links_of_Rechts
                                einde_lh_flank_3_B:
                                                ori             DirecTorB, 0b10000000
                                                ror             TWI_Data                                       
                                                pop             Temp
                                ret
 
                                Uiterst_rechts:
                                                ldi             Temp, 0
                                                mov             Links_of_Rechts, Temp
                                                rjmp    einde_lh_flank_3_B
 
test_hl_flank_B_3:
 
                sbrs Flank_Reg, 7
                        rjmp hl_flank_3_B
                ret
 
                        hl_flank_3_B:
                                ori     Flank_Reg, 0b10000000 ;flank bit
                        ret
rjmp main
 
;____________________________________________________________________________________________________________________
LCD_write_Instruction:
                        mov             Temp, LCD_Data
                        rcall   VerTraag
                        andi    Temp, 0b11110000                                ;Meest signifikante nibble eerst
                        out             PortD, Temp
                        rcall   VerTraag
                        ori             Temp, 0b00001000                                ;E hoog maken
                        out             PortD, Temp
                        rcall   VerTraag
                        andi    Temp, 0b11110000                                ;E laag maken
                        out             PortD, Temp
                        rcall   VerTraag
                        mov             Temp, LCD_Data
                        swap    Temp                                                    ;nibbles verwisselen
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        ori             Temp, 0b00001000
                        out             PortD, Temp
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        ret
 
LCD_write_Data:
                        mov             Temp, LCD_Data
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        ori             Temp, 0b00001100
                        out             PortD, Temp
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        mov             Temp, LCD_Data
                        swap    Temp
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        ori             Temp, 0b00001100
                        out             PortD, Temp
                        rcall   VerTraag
                        andi    Temp, 0b11110000
                        out             PortD, Temp
                        rcall   VerTraag
                        ret
;____________________________________________________________________________________________________________________
 
Load_Template:                                                                                 
                        push    Temp
                        push    Temp3
                        ldi             Xl, low(2*0x0c0)                                        ;Vanuit SRAM halen we data binnen die daar elder werd opgevuld.
                        ldi             Xh, high(2*0x0c0)                                       ;Hier vullen we de geheugenspoel met Waardes die hier ook in Symbolen worden omgezet.
                        ldi             Zl, low(2*0x100)                                       
                        ldi             Zh, high(2*0x100)
 
                Volgende_Z_Template:
                        ld              Temp, Z+
                        mov             Symbool_h, Temp
                        rcall   Graphic_processing_Positive
                        st              X, Symbool_h
                        adiw    X, 0x10                                                         ;Springen van de eerste rij naar de tweede
                        st              X, Symbool_l
                        ld              Temp, Z+
                        mov             Symbool_h, Temp
                        rcall   Graphic_processing_Negative
                        adiw    X, 0x10                                                         ;Springen van de tweede rij naar de derde
                        st              X, Symbool_l
                        adiw    X, 0x10                                                         ;Springen van de derde rij naar de vierde
                        st              X, Symbool_h
                        sbiw    X, 0x2f                                                         ;Springen van de vierde rij naar de eerste maar met eentje minder opdat we op de volgende in X komen.
                        cpi             Zl, 0x20                                                        ;Alle vakken zijn gevuld
                        brne    Volgende_Z_Template
                        pop             Temp3
                        pop             Temp
                        RET
;____________________________________________________________________________________________________________________
 
        Load_Buffer:
                        push    Temp
                        push    Temp3
                        ldi             Xl, low(2*0x100)                                        ;We halen data vanuit het ProgrammaGeheugen en vullen het Buffer geheugen
                        ldi             Xh, high(2*0x100)                                       ;
                        ldi             Zl, low(2*SAW_Tab)                                      ;Allen ALPHA QUADRANT en BETA QUADRANT worden hier gevuld.
                        ldi             Zh, high(2*SAW_Tab)
 
                Volgende_Z_Buffer:
                        lpm             Temp, Z+
                        st              x+, Temp
                        cpi             Xl, 0x10                                ;cpi            Zl, 0x10                        ;Alle vakken zijn gevuld
                        brne    Volgende_Z_Buffer
                        rcall   Force_Sym
                        pop             Temp3
                        pop             Temp
                RET
 
        Force_Sym:
                        push    Temp
                        push    Temp3                  
                        ldi             Zl, low(2*0x100)                                        ;Alleen ALPHA QUADRANT en BETA QUADRANT worden hier gevuld.
                        ldi             Zh, high(2*0x100)
                        ldi             Xl, low(2*0x108)                                        ;Alleen ALPHA QUADRANT en BETA QUADRANT worden hier gevuld.
                        ldi             Xh, high(2*0x108)
                        sbrs    DirecTorC, 2
                        rjmp    Force_Sym_B2
                        sbrc    DirecTorC, 3
                        rjmp    Alg_C
                        rjmp    Alg_D          
                Force_Sym_B2:
                        sbrc    DirecTorC, 3
                        rjmp    Alg_A
                        rjmp    Alg_B                                                  
        Alg_A:                                                                                                         
                Loop_Alg_A:
                        ld              Temp, Z+                                                        ;Deze Algoritme zet z[n] in x[n],   n = {0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}
                        st              x+, Temp
                        cpi             Zl, 0x10                                                       
                        brne    Loop_Alg_A
                        rjmp    Einde_Force_Sym
        Alg_B:
                        adiw    X, 0x10
                Loop_Alg_B:
                        ld              Temp, Z+                                                        ;Deze Algoritme zet z[n] in x[$F - n],   n = {0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}
                        st              -X, Temp
                        cpi             Zl, 0x10                                                       
                        brne    Loop_Alg_B
                        rjmp    Einde_Force_Sym
        Alg_C:
                Loop_Alg_C:
                        ld              Temp, Z+
                        ld              Temp3, Z+
                        st              x+, Temp3
                        st              x+, Temp
                        cpi             Zl, 0x10                                                       
                        brne    Loop_Alg_C
                        rjmp    Einde_Force_Sym
        Alg_D:
                        adiw    X, 0x10
                Loop_Alg_D:
                        ld              Temp, Z+                                                        ;Deze Algoritme zet z[n] in x[$F - n],   n = {0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}
                        ld              Temp3, Z+
                        st              -X, Temp3
                        st              -X, Temp
                        cpi             Zl, 0x10                                                       
                        brne    Loop_Alg_D
        Einde_Force_Sym:       
                        pop             Temp3
                        pop             Temp
                        RET
;____________________________________________________________________________________________________________________
 
                Sub_Scherm_Volmaken:                                    ;Pos_X wordt als routineteller gebruikt. We spoelen geheugen door naar LCD naarwaar Z wijst.
                        push            Temp
                        push            Pos_X
                        ldi             Zl, low(2*0x0c0)                                        ;Vanuit SRAM halen we data binnen die daar elder werd opgevuld.
                        ldi             Zh, high(2*0x0c0)              
                        ldi             LCD_Data, 0X80                                          ;LCD_Data, 0b00000010 RETURN HOME
                        rcall   LCD_write_Instruction  
                        rcall   VerTraag
                        clr             Pos_X
                Verder_Vol:            
                        ld              Temp, Z+                                                        ;Haal SYMBOOL uit het geheugen
                        mov             LCD_Data, Temp
                        rcall   LCD_write_Data
                        rcall   VerTraag
                        inc             Pos_X                                                          
                        cpi             Pos_X, 0x10                                                     ;als we bij 15(F) zijn zijn we op de laatste positie van lijn 1 en moeten we het adress van het begin op de tweede lijn uitsturen
                        breq    Eerste_Rij_af                                           ;B_Volmaken
                        cpi             Pos_X, 0x20                                                     ;als we bij 31(1F) zijn zijn we op de laatste positie van lijn 2 en moeten we het adress van het begin op de derde lijn uitsturen
                        breq    Tweede_Rij_af
                        cpi             Pos_X, 0x30                                                     ;als we bij 47(2F) zijn zijn we op de laatste positie van lijn 3 en moeten we het adress van het begin op de vierde lijn uitsturen
                        breq    Derde_Rij_af
                        cpi             Pos_X, 0x40                                                     ;als we bij 63(3F) zijn zijn we op de laatste positie van lijn 4 en moeten we het adress van het begin op de eerste lijn uitsturen
                        breq    Vierde_Rij_af
                        rjmp    Verder_Vol
                Eerste_Rij_af:
                        ldi             LCD_Data, 0xC0                                          ;zet display positie op $40 + $80 voor command
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
                        rjmp    Verder_Vol
                Tweede_Rij_af:
                        ldi             LCD_Data, 0x90                                          ;zet display positie op $10 + $80 voor command
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
                        rjmp    Verder_Vol
                Derde_Rij_af:
                        ldi             LCD_Data, 0xD0                                          ;zet display positie op $50 + $80 voor command
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
                        rjmp    Verder_Vol
                Vierde_Rij_af:
                        ldi             LCD_Data, 0X80                                          ;zet display positie op $00 + $80 voor command en spring uit deze routine
                        rcall   LCD_write_Instruction
                        rcall   VerTraag
                        rjmp    Einde_schrijf_Vol
        Einde_schrijf_Vol:
                        pop             Pos_X
                        pop             Temp
                        ret
 
;____________________________________________________________________________________________________________________
        Graphic_processing_Positive:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_Graphic_processing_>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>      
;Takes data (which is a value, going from 0 to 100%) from SymBool_L and converts it to a Character defined by the Character Generator CGROM and puts the result in SymBool_L and SymBool_H
 
;       .....   .....   .....   .....   .....   11111   11111   11111   11111  
;       .....   .....   .....   .....   .....   11111   11111   11111   11111  
;       .....   .....   .....   11111   .....   .....   11111   11111   11111  
;       .....   .....   .....   11111   .....   .....   11111   11111   11111  
;       .....   .....   11111   11111   .....   .....   .....   11111   11111  
;       .....   .....   11111   11111   .....   .....   .....   11111   11111  
;       .....   11111   11111   11111   .....   .....   .....   .....   11111  
;       .....   11111   11111   11111   .....   .....   .....   .....   11111  
 
;       Ch0             Ch1             Ch2             Ch3             Ch4             Ch5             Ch6             Ch7             Ch8                    
;       $20             $00             $01             $02             $03             $04             $05             $06             $FF            
;                                              
                                push            Temp
                                push            Temp3                  
                                sbrc            SymBool_H, 7
                                rjmp            Is_7_Pos
                                sbrc            SymBool_H, 6
                                rjmp            Is_6_Pos
                                sbrc            SymBool_H, 5
                                rjmp            Is_5_Pos
                                sbrc            SymBool_H, 4
                                rjmp            Is_4_Pos
                                sbrc            SymBool_H, 3
                                rjmp            Is_3_Pos
                                sbrc            SymBool_H, 2
                                rjmp            Is_2_Pos
                                sbrc            SymBool_H, 1
                                rjmp            Is_1_Pos
                                sbrc            SymBool_H, 0
                                rjmp            Is_0_Pos
 
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x20                             ;0/4
                                rjmp            Einde_GP_Positive
 
                Is_0_Pos:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x00                             ;1/4
                                rjmp            Einde_GP_Positive
 
                Is_1_Pos:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x01                             ;2/4
                                rjmp            Einde_GP_Positive
 
                Is_2_Pos:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x02                             ;3/4
                                rjmp            Einde_GP_Positive
 
                Is_3_Pos:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Positive
 
                Is_4_Pos:
                                ldi                     Temp, 0x00                              ;1/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Positive
 
                Is_5_Pos:
                                ldi                     Temp, 0x01                              ;2/4                           
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Positive
 
                Is_6_Pos:
                                ldi                     Temp, 0x02                              ;3/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Positive
 
                Is_7_Pos:
                                ldi                     Temp, 0xFF                              ;4/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Positive
 
                        Einde_GP_Positive:
                                mov                     SymBool_H, Temp
                                mov                     SymBool_L, Temp3
 
                                pop                     Temp3
                                pop                     Temp
 
                RET
 
        Graphic_processing_Negative:
       
                push            Temp
                push            Temp3
                               
                                sbrc            SymBool_H, 7
                                rjmp            Is_7_Neg
                                sbrc            SymBool_H, 6
                                rjmp            Is_6_Neg
                                sbrc            SymBool_H, 5
                                rjmp            Is_5_Neg
                                sbrc            SymBool_H, 4
                                rjmp            Is_4_Neg
                                sbrc            SymBool_H, 3
                                rjmp            Is_3_Neg
                                sbrc            SymBool_H, 2
                                rjmp            Is_2_Neg
                                sbrc            SymBool_H, 1
                                rjmp            Is_1_Neg
                                sbrc            SymBool_H, 0
                                rjmp            Is_0_Neg
 
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x20                             ;0/4
                                rjmp            Einde_GP_Negative
 
                Is_0_Neg:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x04                             ;1/4
                                rjmp            Einde_GP_Negative
 
                Is_1_Neg:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x05                             ;2/4
                                rjmp            Einde_GP_Negative
 
                Is_2_Neg:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0x06                             ;3/4
                                rjmp            Einde_GP_Negative
 
                Is_3_Neg:
                                ldi                     Temp, 0x20                              ;0/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Negative
 
                Is_4_Neg:
                                ldi                     Temp, 0x04                              ;1/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Negative
 
                Is_5_Neg:
                                ldi                     Temp, 0x05                              ;2/4                           
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Negative
 
                Is_6_Neg:
                                ldi                     Temp, 0x06                              ;3/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Negative
 
                Is_7_Neg:
                                ldi                     Temp, 0xFF                              ;4/4
                                ldi                     Temp3, 0xFF                             ;4/4
                                rjmp            Einde_GP_Negative
 
                        Einde_GP_Negative:
                                mov                     SymBool_H, Temp
                                mov                     SymBool_L, Temp3
                               
                                pop                     Temp3
                                pop                     Temp
 
                RET
 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<_END_Graphic_processing_END_<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;
;____________________________________________________________________________________________________________________
;define Traag1, Traag2
                                                                VerTraag:
                                                                ;cbi                    PortB, 1                ;Led1[Green]
                                                                        push    traag1
                                                                        push    traag2
 
                                                                                ldi Traag1, 0x10
 
                                                                        Subtra2:
                                                                                ldi Traag2, 0x10
 
                                                                        Subtra1:
                                                                                dec Traag2
                                                                                brne Subtra1
                                                                                dec Traag1
                                                                                brne Subtra2
 
                                                                ;sbi                    PortB, 1                ;Led1[Green]
                                                                        pop             traag2
                                                                        pop             traag1
                                                                ret
 
                                                                VerTraag_lang:
                                                                ;cbi                    PortB, 1                ;Led1[Green]
                                                                        push    traag1
                                                                        push    traag2
 
                                                               
                                                                                ldi Traag1, 0xff
                                                                        Subtra2_lang:
                                                                                ldi Traag2, 0xff
 
                                                                        Subtra1_lang:
                                                                                dec Traag2
                                                                                brne Subtra1_lang
                                                                                dec Traag1
                                                                                brne Subtra2_lang
 
                                                                ;sbi                    PortB, 1                ;Led1[Green]
 
                                                                        pop             traag2
                                                                        pop             traag1
 
                                                                ret
;____________________________________________________________________________________________________________________
;____________________________________________________________________________________________________________________
 
                Mn_Flush_Poly:
                                        andi    DirecTorB, 0b11111011
                                        ret
 
                Mn_Flush_Mono:
                                        andi    DirecTorB, 0b11110111
                                        ret
                       
                Mn_Forced_Algoritm:
                                        andi    DirecTorB, 0b11101111
                                        push    Temp
                                        ldi             Temp, 0b00000100                                        ;Voorbereiding om Bit2 te inverteren,
                                        sbrc    DirecTorC, 3                                            ;indien Bit3 hoog is.
                                        eor             DirecTorC, Temp
                                        ldi             Temp, 0b00001000
                                        eor             DirecTorC, Temp                                         ;Bit3 wordt iedere keer geinverteerd.
                                        pop             Temp
                                        ;rcall  Force_Sym
                                        ret
                       
                Mn_Pos_Neg:    
                                        andi    DirecTorB, 0b11011111
                                        ret
       
                Mn_menu:        ;Hier komen we als PinC, 3 laag is, dus als knop wordt ingedrukt.                                                               ;<<<<<<<<<<<<<Menu
                                        ;andi   DirecTorB, 0b11111110
                                        ldi             zl, low(2*0x640)
                                        ldi             zh, high(2*0x640)
 
                                        sbi                     PortB, 2                ;MONO5[Red]__INVERTED!          ***********test*************
 
                                        rcall   Print_Menu
                                Mn_Menu_wacht:
                                        sbis    PinC, 3                        
                                        rjmp    Mn_Menu_wacht
 
                                        Mn_menu_loop:
                                                sbis    pinC, 3
                                                rjmp    Mn_Next1
 
                                                sbis    pinC, 2
                                                rjmp    Mn_Midi
 
                                                sbis    pinC, 1
                                                rjmp    Mn_Exit
 
                                                sbis    pinC, 0
                                                rjmp    Mn_Route_to_oscillator
 
                                                rjmp    Mn_menu_loop                                                                                                                                            ;>>>>>>>>>>>>>>Menu
 
                                                Mn_Next1:                                                                                                                                                                       ;<<<<<<<<<<<<<Next1
                                                        ldi             zl, low(2*0x660)
                                                        ldi             zh, high(2*0x660)
                                                        rcall   Print_Menu
                                                        Mn_Next1_wacht:
                                                                sbis    pinC, 3
                                                                rjmp    Mn_Next1_wacht
 
                                                                Mn_Next1_loop:
                                                                        sbis    pinC, 3
                                                                        rjmp    Mn_Next2
 
                                                                        sbis    pinC, 2
                                                                        rjmp    Mn_Exit
 
                                                                        sbis    pinC, 1
                                                                        rjmp    Mn_Load_Form
 
                                                                        sbis    pinC, 0
                                                                        rjmp    Mn_Safe_Form
 
                                                                        rjmp    Mn_Next1_loop                                                                                                           ;>>>>>>>>>>>>>>>>Next1
 
 
                                                                                Mn_Next2:                                                                                                                               ;<<<<<<<<<<<<<Next2                    
                                                                                        ldi             zl, low(2*0x6c0)
                                                                                        ldi             zh, high(2*0x6c0)
                                                                                        rcall   Print_Menu
                                                                                        Mn_Next2_wacht:
                                                                                                sbis    pinC, 3
                                                                                                rjmp    Mn_Next2_wacht
 
                                                                                                Mn_Next2_loop:
                                                                                                        Mn_Exit_Next2:
                                                                                                                sbis    pinC, 2
                                                                                                                rjmp    Mn_Exit_Menu
 
                                                                                                        Mn_Load_Form:
                                                                                                                Mn_Load_Form_wacht:
                                                                                                                sbis    pinC, 1
                                                                                                                rjmp    Mn_Load_Form_wacht
 
                                                                                                        Mn_Safe_Form:
                                                                                                                Mn_Safe_Form_wacht:
                                                                                                                sbis    pinC, 0
                                                                                                                rjmp    Mn_Safe_Form_wacht
                                                                                                                rjmp    Mn_Next2_loop
 
                                                Mn_Midi:                                                                                                                                                        ;<<<<<<<<<<<<<<Midi
                                                        ldi             zl, low(2*0x740)
                                                        ldi             zh, high(2*0x740)
                                                        rcall   Print_Menu
                                                        Mn_Midi_wacht:
                                                                sbis    pinC, 2
                                                                rjmp    Mn_Midi_wacht
                                                                rcall   Mn_Midi_Print_Settings
 
                                        Mn_Midi_Loop2:
                                                        sbis    PinC, 3
                                                        rjmp    Channel_Up
                                                        sbis    PinC, 2
                                                        rjmp    Channel_Down
                                                        sbis    PinC, 1
                                                        rjmp    Note_Poly_Mono
                                                        sbis    PinC, 0
                                                        rjmp    User_Submit
                                                                rjmp    Mn_Midi_Loop2
 
 
                                                Channel_Up:
 
                                                                        ldi             Temp, 0b00001111                                ;Don't care for other than channel bits.
                                                                        and             Temp, Midi_Settings
                                                                        cpi             Temp, 0x0f                                              ;Skip increment if max = 16 is reached.
                                                                        breq    Ch_Max_limit
                                                                        inc             Temp
 
                                                                Ch_Max_limit:
                                                                                or              Midi_Settings, Temp
                                                                                ori             Temp, 0b11110000
                                                                                and             Midi_Settings, Temp
                                                                                ;sbis   PinC, 3
                                                                                ;rjmp   Ch_Max_limit                                                           
                                                                                rcall   Mn_Midi_Print_Settings
                                                                        Channel_Up_Wacht:
                                                                                sbis    PinC, 3                                                 ;Wait for button release.
                                                                                rjmp    Channel_Up_Wacht                                                                               
                                                                                        rjmp    Mn_Midi_Loop2
 
                                                Channel_Down:
 
                                                                        ldi             Temp, 0b00001111                                ;Don't care for other than channel bits.
                                                                        and             Temp, Midi_Settings
                                                                        cpi             Temp, 0x00                                              ;Skip decrement if MIN = 0 is reached.
                                                                        breq    Ch_Min_limit
                                                                        dec             Temp
 
                                                                Ch_Min_limit:
                                                                                or              Midi_Settings, Temp
                                                                                ori             Temp, 0b11110000
                                                                                and             Midi_Settings, Temp
                                                                                ;sbis   PinC, 3
                                                                                ;rjmp   Ch_Min_limit   
                                                                                rcall   Mn_Midi_Print_Settings
                                                                        Channel_Down_Wacht:
                                                                                sbis    PinC, 2                                                 ;Wait for button release.
                                                                                rjmp    Channel_Down_Wacht
                                                                                        rjmp    Mn_Midi_Loop2
 
                                        Note_Poly_Mono:
 
                                                                ldi             Temp, 0b00010000
                                                                eor             Midi_Settings, Temp
                                                                rcall   Mn_Midi_Print_Settings                                          ;Midi_Settings.4: Poly(0) / Mono(0).
 
                                                        Note_Poly_Mono_loop:
                                                                sbis    PinC, 1                                                                
                                                                rjmp    Note_Poly_Mono_loop
                                                                                rjmp    Mn_Midi_Loop2
 
 
                                                                                        Mn_Midi_Print_Settings:
                                                                                                                ldi             zl, low(2*0x760)
                                                                                                                ldi             zh, high(2*0x760)                                                                      
                                                                                                                                                                                        ;Schrijf huidig Midi-Channel nummer en Poly/Mono setting op het scherm.
 
                                                                                                                ldi             LCD_Data, 0xc7                                          ;LCD_Data, 0b00000010 RETURN HOME
                                                                                                                rcall   LCD_write_Instruction  
                                                                                                                rcall   VerTraag
                                                                                                                mov             Temp, Midi_Settings
                                                                                                                andi    Temp, 0b00001111                                        ;Veeg alles behalve midi kanaal.
                                                                                                                add             zl, Temp
                                                                                                                cpi             Temp, 0x09
                                                                                                                brsh    Plus_tien
                                                                                                                clr             Temp                                                            ;Als minder dan 10, zal het tiental leeg ' ' zijn.
                                                                                                                rjmp    skip_plus_tien
                                                                                                        Plus_tien:
                                                                                                                ldi             Temp, '1'
                                                                                                        skip_plus_tien:
                                                                                                                mov             LCD_Data, Temp                                          ;Zend ofwel leeg karakter ofwel '1'.
                                                                                                                rcall   LCD_write_Data
                                                                                                                rcall   VerTraag
                                                                                                                lpm             Temp, z
                                                                                                                mov             LCD_Data, Temp
                                                                                                                rcall   LCD_write_Data
                                                                                                                rcall   VerTraag
 
 
                                                                                                                ldi             LCD_Data, 0x9c                                                                                                                                                                                                                                                                                                  ;zet display positie op $40 + $80 voor command
                                                                                                                rcall   LCD_write_Instruction
                                                                                                                rcall   VerTraag
                                                                                                                ldi             Temp, 'P'
                                                                                                                sbrc    Midi_Settings, 4
                                                                                                                ldi             Temp, 'M'                                                       ;Zend ofwel 'P' karakter ofwel 'M'.
                                                                                                                mov             LCD_Data, Temp
                                                                                                                rcall   LCD_write_Data
                                                                                                                ret
                                User_Submit:
                                        Mn_Midi_einde:                                                                                                                                                                                          ;<<<<<<<<<<<<<<Midi
/*                                              pop             zl
                                                pop             zh
                                                pop             Temp3
                                                pop             Temp
                                                out             sreg, Temp
                                                pop             Temp*/
                                ret
 
                                                Mn_Exit_Menu:                                                                                                                                                                                   ;<<<<<<<<<<<<<<Exit
                                                        sbis    pinC, 1
                                                        rjmp    Mn_Exit_Menu
                                                        rjmp    Mn_Exit
 
                                                Mn_Route_to_oscillator:                                                                                                                                                                 ;<<<<<<<<<<<<<<Route to oscillator             
                                                        ldi             zl, low(2*0x6a0)
                                                        ldi             zh, high(2*0x6a0)
                                                        rcall   Print_Menu
                                                        Mn_Route_to_oscillator_wacht:
                                                                sbis    pinC, 0
                                                                rjmp    Mn_Route_to_oscillator_wacht
 
                                                Mn_Exit:                        ;
                                                        ;ldi            zl, low(2*0x680)
                                                        ;ldi            zh, high(2*0x680)
                                                        ;rcall  Print_Menu
 
                                        ret
;____________________________________________________________________________________________________________________
;Scherm van tekst voorzien.
;We gebruiken pos_x als positieteller, en vullen alle 64 vaken op.
;Z-register toont aan waar in het programma geheugen we data ophalen, deze moet gezet zijn voordat deze routine wordt opgeroepen.
 
                        Print_Menu:                                                                                    
                                        push    pos_X
                                        clr             pos_x
                                        ldi             LCD_Data, 0x80                                          ;zet display positie op $40 + $80 voor command
                                        rcall   LCD_write_Instruction
                                        rcall   VerTraag
                                Print_Menu_L1:
                                        lpm             Temp, z+
                                        mov             LCD_Data, Temp
                                        rcall   LCD_write_Data
                                        rcall   VerTraag
                                        inc             pos_X
                                        cpi             pos_X, 0x10
                                        brne    Print_Menu_L1
                                        ldi             LCD_Data, 0xc0                                          ;zet display positie op $10 + $80 voor command
                                        rcall   LCD_write_Instruction
                                        rcall   VerTraag
                                Print_Menu_L2:
                                        lpm             Temp, z+
                                        mov             LCD_Data, Temp
                                        rcall   LCD_write_Data
                                        rcall   VerTraag
                                        inc             pos_X
                                        cpi             pos_X, 0x20
                                        brne    Print_Menu_L2
                                        ldi             LCD_Data, 0x90                                          ;zet display positie op $50 + $80 voor command
                                        rcall   LCD_write_Instruction
                                        rcall   VerTraag
                                Print_Menu_L3:
                                        lpm             Temp, z+
                                        mov             LCD_Data, Temp
                                        rcall   LCD_write_Data
                                        rcall   VerTraag
                                        inc             pos_X
                                        cpi             pos_X, 0x30
                                        brne    Print_Menu_L3
                                        ldi             LCD_Data, 0Xd0                                          ;zet display positie op $00 + $80 voor command en spring uit deze routine
                                        rcall   LCD_write_Instruction
                                        rcall   VerTraag
                                Print_Menu_L4:
                                        lpm             Temp, z+
                                        mov             LCD_Data, Temp
                                        rcall   LCD_write_Data
                                        rcall   VerTraag
                                        inc             pos_X
                                        cpi             pos_X, 0x40
                                        brne    Print_Menu_L4
                                        pop             pos_x
                                ret
;____________________________________________________________________________________________________________________
 
 
        TWI_MONO_write_routine:
                        push    Temp
                ;/1/____________________________________/1/
                        ldi             Temp, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
                        sts             TWCR, Temp
                ;/2/____________________________________/2/
                Wait_MONO1:
                        lds             Temp,TWCR
                        sbrs    Temp,TWINT
                        rjmp    Wait_MONO1
                ;/3/____________________________________/3/
                        lds             Temp,TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, TWI_start_flag
                        brne    Error_MONO_start
                        mov             Temp, TWI_Address
                        sts             TWDR, Temp
                        ldi             Temp, (1<<TWINT) | (1<<TWEN)
                        sts             TWCR, Temp
                ;/4/____________________________________/4/
                Wait_MONO2:
                        lds             Temp,TWCR
                        sbrs    Temp,TWINT
                        rjmp    Wait_MONO2
                ;/5/____________________________________/5/
                        lds             Temp,TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, 0x18              ;ack on slave address?
                        brne    Error_MONO_address
                ;Flush_to_osc:                                                                                          ;z<                     ------------
                        ;ld             Temp, Z+
                        mov             Temp, TWI_Data
                        ;ldi            Temp, 0b11111111
                        sts             TWDR, Temp
                        ldi             Temp, (1<<TWINT) | (1<<TWEN)
                        sts             TWCR, Temp
                ;/6/____________________________________/6/
                Wait_MONO3:
                        lds             Temp, TWCR
                        sbrs    Temp, TWINT
                        rjmp    Wait_MONO3
                ;/7/____________________________________/7/
                        lds             Temp, TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, 0x28
                        brne    Error_MONO_data
                        ;cpi            Zl, 0x1f
                        ;brne   Flush_to_osc                                                                    ;z>                     ------------
                        ;sbi                    PortB, 1                ;MONO1[Green]__INVERTED!
                        ;sbi                    PortB, 2                ;MONO5[Red]__INVERTED!
 
                        clr             temp                                                                                            ;Clear Timer Counter (watchdog postpone).
                        mov             sense_tel, temp
                        mov             TWI_Address, temp
                        mov             TWI_Data, temp
                        rjmp    einde_TWI_MONO
                ;/8/____________________________________/8/
                Error_MONO_start:
                        ;sbi                    PortB, 1                ;MONO1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;MONO5[Red]__INVERTED!
                        ldi             temp, 0xff
                        mov             TWI_Address, temp
                        rjmp    einde_TWI_MONO
                Error_MONO_address:
                        ;sbi                    PortB, 1                ;MONO1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;MONO5[Red]__INVERTED!
                        clr             temp                                                                                            ;Clear Timer Counter (watchdog postpone).
                        mov             sense_tel, temp
                        mov             TWI_Data, temp
                        rjmp    einde_TWI_MONO
                Error_MONO_data:
                        ;sbi                    PortB, 1                ;MONO1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;MONO5[Red]__INVERTED!
                        clr             temp                                                                                            ;Clear Timer Counter (watchdog postpone).
                        mov             sense_tel, temp
                        mov             TWI_Address, temp
                einde_TWI_MONO:
                        ;-----STOP--------                                             
                        ldi             Temp, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)          
                        sts             TWCR, Temp
                        ;pop            Zh
                        ;pop            Zl
                        pop             Temp
                                ;Mn_TWI__Wacht:
                                        ;sbic   PinC, 2
                                ;rjmp   Mn_TWI__Wacht
                        ret
;____________________________________________________________________________________________________________________
 
        TWI_write_routine:
                        push    Temp
                        push    Zl
                        push    Zh
                        ;cbi                    PortB, 2                ;MONO5[Red]__INVERTED!
                        ldi             Zh, high(2*0x100)
                        ldi             Zl, low(2*0x100)
 
 
                ;/1/____________________________________/1/
                        ldi             Temp, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
                        sts             TWCR, Temp
                ;/2/____________________________________/2/
                wait1:
                        lds             Temp,TWCR
                        sbrs    Temp,TWINT
                        rjmp    wait1
                ;/3/____________________________________/3/
                        lds             Temp,TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, TWI_start_flag
                        brne    ERROR_start
                        ldi             Temp, TWI_slave_address_write
                        sts             TWDR, Temp
                        ldi             Temp, (1<<TWINT) | (1<<TWEN)
                        sts             TWCR, Temp
                ;/4/____________________________________/4/
                wait2:
                        lds             Temp,TWCR
                        sbrs    Temp,TWINT
                        rjmp    wait2
                ;/5/____________________________________/5/
                        lds             Temp,TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, 0x18              ;ack on slave address?
                        brne    ERROR_address
                Flush_to_osc:                                                                                           ;z<                     ------------
                        ld              Temp, Z+                       
                        sts             TWDR, Temp
                        ldi             Temp, (1<<TWINT) | (1<<TWEN)
                        sts             TWCR, Temp
                ;/6/____________________________________/6/
                wait3:
                        lds             Temp,TWCR
                        sbrs    Temp,TWINT
                        rjmp    wait3
                ;/7/____________________________________/7/
                        lds             Temp,TWSR
                        andi    Temp, 0xF8
                        cpi             Temp, 0x28
                        brne    ERROR_data
                        cpi             Zl, 0x1f
                        brne    Flush_to_osc                                                                    ;z>                     ------------
                        clr             temp 						;Clear Timer Counter (watchdog postpone).
                        mov             sense_tel, temp
                        mov             TWI_Address, temp
                        mov             TWI_Data, temp
                        rjmp    einde_TWI
                ;/8/____________________________________/8/
                error_start:
                        ;sbi                    PortB, 1                ;Led1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;Led5[Red]__INVERTED!
                        rjmp    einde_TWI
                error_address:
                        ;sbi                    PortB, 1                ;Led1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;Led5[Red]__INVERTED!
                        rjmp    einde_TWI
                error_data:
                        ;s;bi                   PortB, 1                ;Led1[Green]__INVERTED!
                        ;cbi                    PortB, 2                ;Led5[Red]__INVERTED!
                einde_TWI:
                        ;-----STOP--------
                        ldi             Temp, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)          
                        sts             TWCR, Temp
                        pop             Zh
                        pop             Zl
                        pop             Temp
                        cbi                     PortB, 1                ;Led1[Green]__INVERTED!
                                ;Mn_TWI__Wacht:
                                        ;sbic   PinC, 2
                                ;rjmp   Mn_TWI__Wacht
                        ret    
;____________________________________________________________________________________________________________________
 
ADC_rout:
                cli
                push            Temp
                in                      Temp, SREG
                push            Temp
                ;push           Temp3          
                lds                     Temp, ADCH
                mov                     ADC_Data2, Temp
                ;lds                    Temp, admux
;ADC Multiplexer Selection Register –ADMUX
;REFS1 REFS0 ADLAR – MUX3 MUX2 MUX1 MUX0
;MUX3..0 Single Ended Input
;0000 ADC0
;0001 ADC1
;0010 ADC2
;MUX3..0 Single ended input
;0000 ADC0
;0001 ADC1
;0010 ADC2
;0011 ADC3
;0100 ADC4
;0101 ADC5
;0110 ADC6
;0111 ADC7             
                ;sbrc           Temp, 1                         ;als admux 0010 ADC2 hoog was ganaar stap1 waar we ADC0 ervan maken
                ;rjmp           ADC2toADC0
                ;sbrc           Temp, 0                         ;als admux 0001 ADC1 hoog was ganaar stap2 waar we ADC2 ervan maken
                ;rjmp           ADC1toADC2                             
        ;ADC0toADC1:                                                                   
        ;---Links_of_Rechts---0
                ;ori                    Temp, 0b00000001
                ;sts                    admuX, Temp
                ;mov                    Links_of_Rechts, Temp3
                ;rjmp           Einde_ADCV
        ;ADC2toADC0:                                                                   
                ;---ADC_Data2---2
                ;andi           Temp, 0b11111100
                ;sts                    admuX, Temp
                ;mov                    ADC_Data2, Temp3
                ;rjmp           Einde_ADCV
 
        ;ADC1toADC2:                                                                   
 
                ;---ACD_Positie1---1
                ;ori                    Temp, 0b00000010
                ;andi           Temp, 0b11111110
                ;sts                    admuX, Temp
                ;mov                    Temp, Temp3
                ;swap           Temp
                ;andi           Temp, 0b00001110
                ;mov                    ACD_Positie1, Temp
                ;mov                    ACD_Positie1, Temp3
                ;rjmp           Einde_ADCV
 
        ;Einde_ADCV:           
               
                ;pop                    Temp3
                pop                     Temp
                out                     SREG, Temp
                pop                     Temp
                sei
ret            
;____________________________________________________________________________________________________________________               
                                Midi_Processing:
                        sei
                        cbi             PortB, 2                                                        ;Led5[Red]__INVERTED!
                        andi            DirecTor, 0b11110111                                    ;DirecTor.3:  1 = Two bytes in buffer, answering the call for processing.
                        sbrc            DirecTor, 1                                                             ;DirecTor.1:  1 = Note.ON, 0 = Note.OFF
                        rjmp            Fill_Slot
                        rjmp            Void_Slot
 
 
                        Fill_Slot:                                                                                      ;Two inbound bytes for Midi Note.ON
                                ldi             Yh, high(Note_On_Buffer)
                                ldi             Yl, low(Note_On_Buffer)
 
                                sbrs    DirecTor, 4                                                             ;First slot empty?
                                rjmp    Fill_Slot_1
                                sbrs    DirecTor, 5                                                             ;Second slot empty?
                                rjmp    Fill_Slot_2
                                sbrs    DirecTor, 6                                                             ;Third slot empty?
                                rjmp    Fill_Slot_3
                                sbrs    DirecTor, 7                                                             ;Fourth slot empty?
                                rjmp    Fill_Slot_4
 
 
                                        Fill_Slot_1:
                                                ori             DirecTor, 0b00010000                    ;Reserve Slot
                                                ldi             Temp, TWI_slave_adr_Oscillator_A
                                                mov             TWI_Address, Temp                                               ;Load address for oscillator_a
                                                ld              Temp, y+
                                                mov             TWI_Data, Temp
                                                ldi             Yh, high(Note_slot_location)
                                                ldi             Yl, low(Note_slot_location)
                                                st              y+, Temp
                                                ldi             LCD_Data, 0x80                                                                                                                                                                                                                                                                                                  ;zet display positie op $40 + $80 voor command
                                                ;rcall  Print_note
                                                ldi             Temp, TWI_slave_adr_ADSR_A
                                                rjmp    Einde_Midi_Processing_fill
 
                                        Fill_Slot_2:
                                                ori             DirecTor, 0b00100000                    ;Reserve Slot
                                                ldi             Temp, TWI_slave_adr_Oscillator_B
                                                mov             TWI_Address, Temp                                               ;Load address for oscillator_b
                                                ld              Temp, y+
                                                mov             TWI_Data, Temp
                                                ldi             Yh, high(0x142)
                                                ldi             Yl, low(0x142)
                                                st              y+, Temp
                                                ldi             LCD_Data, 0xc0                                                                                                                                                                                                                                                                                                  ;zet display positie op $40 + $80 voor command
                                                ;rcall  Print_note
                                                ldi             Temp, TWI_slave_adr_ADSR_B
                                                rjmp    Einde_Midi_Processing_fill
 
                                        Fill_Slot_3:
                                                ori             DirecTor, 0b01000000                    ;Reserve Slot
                                                ldi             Temp, TWI_slave_adr_Oscillator_C
                                                mov             TWI_Address, Temp                                               ;Load address for oscillator_C
                                                ld              Temp, y+
                                                mov             TWI_Data, Temp
                                                ldi             Yh, high(0x144)
                                                ldi             Yl, low(0x144)
                                                st              y+, Temp
                                                ldi             LCD_Data, 0x90                                                                                                                                                                                                                                                                                                  ;zet display positie op $40 + $80 voor command
                                                ;rcall  Print_note
                                                ldi             Temp, TWI_slave_adr_ADSR_C
                                                rjmp    Einde_Midi_Processing_fill            
 
                                        Fill_Slot_4:
                                                ori             DirecTor, 0b10000000                    ;Reserve Slot
                                                ldi             Temp, TWI_slave_adr_Oscillator_D
                                                mov             TWI_Address, Temp                                               ;Load address for oscillator_D
                                                ld              Temp, y
                                                mov             TWI_Data, Temp
                                                ldi             Yh, high(0x146)
                                                ldi             Yl, low(0x146)
                                                st              y+, Temp
                                                ldi             LCD_Data, 0xd0                                                                                                                                                                                                                                                                                                  ;zet display positie op $40 + $80 voor command
                                                ;rcall  Print_note
                                                ldi             Temp, TWI_slave_adr_ADSR_D
                                                rjmp    Einde_Midi_Processing_fill
 
                                                ;Print_note:
 
                                                Void_Slot:                                                                                      ;Two inbound bytes for Midi Note.OFF
                                                ldi             Yh, high(Note_Off_Buffer)
                                               ; ldi             Yl, low(Note_Off_Buffer)
                                                                                                mov                             yl, Y_Pointer_Off
                                                ld              Temp3, -Y
                                                ldi             Yh, high(Note_slot_location)
                                                ldi             Yl, low(Note_slot_location)
                                                ld              Temp, y+
                                                cp              Temp3, Temp
                                                brne                    skip_Void_Slot1
                                                rcall                   Void_Slot1
                                        skip_Void_Slot1:
 
                                                inc             Yl
                                                ld              Temp, y+
                                                cp              Temp3, Temp
                                                brne                    skip_Void_Slot2
                                                rcall                   Void_Slot2
                                        skip_Void_Slot2:
 
                                                inc             Yl
                                                ld              Temp, y+
                                                cp              Temp3, Temp
                                                brne                    skip_Void_Slot3
                                                rcall                   Void_Slot3
                                        skip_Void_Slot3:
 
                                                inc             Yl
                                                ld              Temp, y+
                                                cp              Temp3, Temp
                                                brne                    skip_Void_Slot4
                                                rcall                   Void_Slot4
                                        skip_Void_Slot4:
 
                                                rjmp            Void_no_match
 
 
                                        Void_Slot1:
                                                andi            DirecTor, 0b11101111                    ;Un-reserve Slot
                                        ;       ldi                     Yl, low(0x142)
                                                rcall           Einde_Midi_Processing_void
                                                ret                     ;rjmp         
 
                                        Void_Slot2:
                                                andi            DirecTor, 0b11011111                    ;Un-reserve Slot
                                        ;       ldi                     yl, low(0x144)
                                                rcall           Einde_Midi_Processing_void
                                                ret                     ;rjmp           Einde_Midi_Processing_void
 
                                        Void_Slot3:
                                                andi            DirecTor, 0b10111111                    ;Un-reserve Slot
                                        ;       ldi                     Yl, low(0x146)
                                                rcall           Einde_Midi_Processing_void
                                                ret                     ;rjmp           Einde_Midi_Processing_voidd
 
                                        Void_Slot4:
                                                andi            DirecTor, 0b01111111                    ;Un-reserve Slot
                                        ;       ldi                     Yl, low(Note_Off_Buffer)
                                                rcall           Einde_Midi_Processing_void
                                                ret                     ;rjmp           Einde_Midi_Processing_void;rjmp         Einde_Midi_Processing_void
 
                                                Einde_Midi_Processing_void:
                                                            ldi         Temp, 0
                                                            st          y, Temp
                                                            st          -y, Temp
                                                                                                                Void_no_match:
                                                                                                                        dec                     Y_Pointer_OFF
                                                            ;mov                        Y_Pointer_Off, Yl 
                                                                                                                        ;ldi                    Yh, high(Note_off_buffer)                                       ;Y-reg is voor midi verwerking.
                                                                                                                        ;ldi                    Yl, low(Note_off_buffer)
                                                                                                               
                                                                                                                        ldi                     temp, 0x50
                                                                                                                        cp                      Y_Pointer_OFF, temp
                                                                                                                        brne            Void_Slot
 
                                                                                                                        ;mov                    Y_Pointer_OFF, Yl      
                                                            ret;        rjmp    Einde_Midi_Processing                                         
 
                                                Einde_Midi_Processing_fill:
                                                        mov             TWI_Address, Temp                                               ;Load data for ADSR_A/B/C/D
                                                        ld              Temp, y+
                                                        mov             TWI_Data, Temp
                                                        ldi             Yh, high(Note_On_Buffer)
                                                        ldi             Yl, low(Note_On_Buffer)
                                                        mov             Y_Pointer_ON, Yl
 
                                                                Not_a_Stop:
                                                Einde_Midi_Processing:
 
 
                                ret
 
 
;#####################--UART_SUBROUTINE--##########################################################################
 
 
                                UART_RXCP:               
                                                                                                                                ; Temp is void
                                                        cli
                                                        push    Temp
                                                        in      Temp, sreg
                                                        push    Temp
                                                        ;cbi                    PortB, 1                                                        ;MONO1[Green]__INVERTED!
                                                                                                               
                                                                                                                ldi             temp, 0
                                                                                                                mov             sense_tel, temp
                                                        mov             Temp, data_in0  ;<---uit maken
                                                        ;lds     Temp, UDR0      ;<---terug aan maken
                                                                                       
                                                        cpi     Temp, 0xfe                                        ;Filtering out Midi_ACT.
                                                        breq    Einde_Sub4
                                                        cpi     Temp, 0xf8                                        ;Filtering out Midi_CLOCK.
                                                        breq    Einde_Sub4
 
                                                        push    Temp3                                                                 
                                                        push    yl
                                                        push    traag1
 
                                                        sbrc    Temp, 7                                                   ;Check inbound byte if data or command.
                                                        rjmp    Midi_Command_in
 
                                                        sbrc    DirecTor, 0                                               ;Check inbound data if sense or non-sense.      Previous inbound byte was Note.ON or Note.OFF
                                                        rjmp    Data_in_is_voor_NootAAN_ofNootUIT     
                                                        rjmp    Einde_Sub1            
 
                                                Data_in_is_voor_NootAAN_ofNootUIT:
                                                                mov     data_in0, Temp
 
 
                                                                sbrc    DirecTor, 1                                       ;DirecTor.1:  1 = Note.ON, 0 = Note.OFF
                                                                rjmp    Note_ON_Velo_or_PitCh
                                                                rjmp    Note_OFF_Velo_or_PitCh
                                                                rjmp    Einde_Sub2
 
                                                        Note_ON_Velo_or_PitCh:
                                                                mov     Yl, Y_Pointer_ON                             ;Midi_stack position.                                                                                                                             
                                                                cbi                     PortB, 1                ;Led1[Green]__INVERTED!
                                                                sbrs    DirecTor, 2                                        ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
                                                                rjmp    Note_ON_PitCh
                                                                rjmp    Note_ON_Velo
 
                                                        Note_OFF_Velo_or_PitCh:
                                                                sbi                     PortB, 1                ;Led1[Green]__INVERTED!
                                                                sbrs    DirecTor, 2                                       ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
                                                                rjmp    Note_OFF_PitCh
                                                                rjmp    Note_OFF_Velo
 
                                                                Note_ON_PitCh:
                                                                        ori     DirecTor, 0b00000100              ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
                                                                        st      y, data_in0
                                                                        rjmp    Einde_Sub3
 
                                                                Note_ON_Velo:
                                                                        andi    DirecTor, 0b11111010                      ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
                                                                        ;andi   DirecTor, 0b11111110  
                                                                        ori     DirecTor, 0b00001000              ;DirecTor.3:  1 = Two bytes in buffer, call for processing.
                                                                        inc     yl
                                                                        st      y, data_in0
                                                                        mov     Y_Pointer_ON, yl
                                                                        rjmp    Einde_Sub1
 
                                                                Note_OFF_PitCh:
                                                                                                                                                mov     Yl, Y_Pointer_OFF                             ;Midi_stack position.
                                                                        ori     DirecTor, 0b00000100             ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
 
                                                                        st      y+, data_in0
                                                                        mov     Y_Pointer_OFF, yl
                                                                        rjmp    Einde_Sub3
 
                                                                Note_OFF_Velo:
                                                                        andi    DirecTor, 0b11111010                    ;DirecTor.2:  0 = Note.PItCH, 1 = Note.VELO
                                                                        ;andi   DirecTor, 0b11111110  
                                                                        ori     DirecTor, 0b00001000            ;DirecTor.3:  1 = Two bytes in buffer, call for processing.
                                                                        ;inc    yl
                                                                        ;ldi    Temp, 0
                                                                        ;st     y, Temp
                                                                        rjmp    Einde_Sub1
 
 
                                        Einde_Sub1:
                                                        sbrc    DirecTor, 3                                             ;Check if Midi Processing was called for.
                                                        rcall   Midi_Processing
                                                        rjmp    Einde_Sub3                                              ;Spring over Einde_Sub2 (D.tB.0 niet laag maken).
 
                                        Einde_Sub2:                                                                                     ;Wordt aangeroepen indien we een command binngenkregen voor een ander (niet onze) Midi-kanaal. Geen Note.ON en ook geen Note.OFF, volgende data negeren.
                                                        andi    DirecTor, 0b11111110                                                                    ;DirecTor.0:  0 = Volgende data die binnenkomt, negeren! 1 = Volgende data voor Note.ON, Note.OFF.
 
                                        Einde_Sub3:
                                                        pop             traag1
                                                        pop             yl                                                    
                                                        pop             Temp3
 
 
                                        Einde_Sub4:                                                                     ;From data.in = Midi_Clock or Midi_Act.
                                                        ;cbi            PortB, 1                                ;MONO1[Green]__INVERTED!
                                                        ;sbi            PortB, 2                                ;Led5[Red]__INVERTED!
                                                        pop             Temp
                                                        out             sreg, Temp
                                                        pop             Temp
                                                        sei
                                                                                                                ldi                             Temp, 0b00000101
                                                                                                                out                             tCCR0b, Temp
                                RETi
 
 
                                                Midi_Command_in:
                                                        mov             Temp3, Temp                                     ;Midi Channel check     /       Data in Temp not affected.
                                                        andi    Temp3,  0b00001111                                      ;Mask out (turn low) other than midi channel bits in Inbound Data Bit.
                                                        mov             traag1, Midi_Settings
                                                        andi    traag1, 0b00001111                                      ;Mask out (turn low) other than midi channel bits in Midi_Settings.
                                                        cp              Temp3, traag1
                                                        brne    Einde_Sub2                                              ;Not for our channel, user selected something different. Wordt aangeroepen indien we een command binngenkregen voor een ander (niet onze) Midi-kanaal.
 
                                                        ori             DirecTor, 0b00000001                            ;DirecTor.0: Following inbound data means something to us, for either note on or off.
                                                        cpi             Temp, MiNootAan               
                                                        breq    Data_in_is_NoteOn
                                                        cpi             Temp, MiNootUit                       
                                                        breq    Data_in_is_NoteOff
                                                        andi    DirecTor, 0b11111110                                                                    ;Geen Note.ON en ook geen Note.OFF, volgende data negeren.
                                                        rjmp    Einde_Sub3;1
 
                                                      Data_in_is_NoteOn:                                                      
                                                        ori             DirecTor, 0b00000010                            ;DirecTor.1:  1 = Note.ON, 0 = Note.OFF
                                                        rjmp    Einde_Sub3
 
                                                      Data_in_is_NoteOff:                                                      
                                                        andi    DirecTor, 0b11111101                                                                    ;DirecTor.1:  1 = Note.ON, 0 = Note.OFF
                                                        rjmp    Einde_Sub3
;#####################--SUBROUTINE--##########################################################################
 
TIM0_ovfl:
/*                                                      cli
                                               
                                                        push    temp
                                                        ldi             temp, 0x10
                                                        inc             sense_tel
 
                                                        cp              sense_tel, temp
                                                        brsh    midi_dead
                                                         cbi                     PortB, 1                ;MONO1[Green]__INVERTED!
                                                        sbi                     PortB, 2                ;MONO5[Red]__INVERTED!                                                 
                                                        pop                     temp
                                                        sei
                                                reti
                               
                                                midi_dead:
                                                        ldi             Temp, 0b0000000
                                                        out             tCCR0b, Temp
                                                         sbi             PortB, 1                ;MONO1[Green]__INVERTED!
                                                        cbi             PortB, 2                ;MONO5[Red]__INVERTED! 
                                                        ldi             temp, 0
                                                        mov             sense_tel, temp ;gewoon nul maken
                                                        pop             temp
                                                        sei*/
                                RETi
 
;.dseg
;***************************************************************************
.org    0x0780                           ;($c00) ;eerste 64 plaatsen zijn voor de display loop           ;***was 600***
 
        ; force table to begin at 256 byte boundary
 
;***************************************************************************
 
SQR_Tab: 
 
.db             0x1f, 0x00
.db             0x3f, 0x00
.db             0x5d, 0x00
.db             0x80, 0x00
.db             0x9b, 0x00
.db             0xba, 0x00
.db             0xd9, 0x00
.db             0xff, 0x00
.db             0x00, 0xff
.db             0x00, 0xd9
.db             0x00, 0xba
.db             0x00, 0x9b
.db             0x00, 0x80
.db             0x00, 0x5d
.db             0x00, 0x3f
.db             0x00, 0x1f
 
SAW_Tab:  ; 256 step sine wave table
 
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0xff, 0x00
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
.db             0x00, 0xff
 
SIN_Tab:  ; 256 step sine wave table
 
.db             0x63, 0x00
.db             0xb4, 0x00
.db             0xec, 0x00
.db             0xff, 0x00
.db             0xec, 0x00
.db             0xb4, 0x00
.db             0x62, 0x00
.db             0x00, 0x00
.db             0x00, 0x00
.db             0x00, 0x62
.db             0x00, 0xb4
.db             0x00, 0xec
.db             0x00, 0xff
.db             0x00, 0xec
.db             0x00, 0xb4
.db             0x00, 0x63
 
TRI_Tab:  ; 256 step sine wave table
 
.db             0x66, 0x00
.db             0x80, 0x00
.db             0xbf, 0x00
.db             0xff, 0x00
.db             0xbf, 0x00
.db             0x80, 0x00
.db             0x66, 0x00
.db             0x00, 0x00
.db             0x00, 0x00
.db             0x00, 0x66
.db             0x00, 0x80
.db             0x00, 0xbf
.db             0x00, 0xff
.db             0x00, 0xbf
.db             0x00, 0x80
.db             0x00, 0x66
 
.org    0x640                           ;($C80)
.db             '*', 'N', 'e', 'x', 't', ' ', ' ', ' ', ' ', ' ', '-', 'M', 'e', 'n', 'u', '-'
.db             '*', 'M', 'i', 'd', 'i', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'T', 'e', 'm', 'p', 'l', 'a', 't', 'e', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'T', 'o', ' ', 'O', 's', 'c', 'i', 'l', 'l', 'a', 't', 'o', 'r', ' ', ' '
 
 
.org    0x660                           ;($CC0)
.db             '*', 'N', 'e', 'x', 't', ' ', ' ', ' ', '-', 'M', 'e', 'n', 'u', ' ', '2', '-'
.db             '*', 'N', 'e', 'x', 't', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'L', 'o', 'a', 'd', ' ', 'F', 'o', 'r', 'm', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'S', 'a', 'v', 'e', ' ', 'F', 'o', 'r', 'm', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x680                           ;($D00)
.db             '1', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '6', '8', '0'
.db             '2', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '3', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '4', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x6a0                           ;($D40)
.db             '*', 'A', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '-', 'R', 'o', 'u', 't', 'e', ' '
.db             '*', 'B', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 't', 'o', ' ', ' '
.db             '*', 'C', ' ', ' ', ' ', 'O', 's', 'c', 'i', 'l', 'l', 'a', 't', 'o', 'r', '-'
.db             '*', 'D', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x6c0                           ;($D80)
.db             '*', 'N', 'e', 'x', 't', ' ', ' ', ' ', '-', 'M', 'e', 'n', 'u', ' ', '3', '-'
.db             '*', 'N', 'e', 'x', 't', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'L', 'o', 'a', 'd', ' ', 'F', 'o', 'r', 'm', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'S', 'a', 'v', 'e', ' ', 'F', 'o', 'r', 'm', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x6e0                           ;($DC0)
.db             '1', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '6', 'e', '0'
.db             '2', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '3', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '4', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x700                           ;($E00)
.db             '1', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '7', '0', '0'
.db             '2', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '3', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '4', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x720                           ;($E40)
.db             '1', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '7', '2', '0'
.db             '2', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '3', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '4', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
.org    0x740                           ;($E80)
.db             '*', '+', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '-', 'M', 'i', 'd', 'i', '-'
.db             '*', '-', ' ', ' ', 'C', 'h', ':', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
.db             '*', 'P', 'o', 'l', 'y', '/', 'M', 'o', 'n', 'o', ':', ' ', ' ', ' ', ' ', ' '
.db             '*', 'S', 'u', 'b', 'm', 'i', 't', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
 
.org    0x760                           ;($EC0)
.db             '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '1', '2', '3', '4', '5', '6'
.org    0x768                           ;($EC8)
.db             'A', 'B', 'C', 'D', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
 
 
