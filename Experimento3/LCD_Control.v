`timescale 1ns / 1ps
`define STATE_RESET 0
`define STATE_POWERON_INIT_0_A 1
`define STATE_POWERON_INIT_0_B 2
`define STATE_POWERON_INIT_1 3
`define STATE_POWERON_INIT_2_A 4
`define STATE_POWERON_INIT_3_B 5
module Module_LCD_Control
  (
   input wire       Clock,
   input wire       Reset,
   output wire      oLCD_Enabled,
   output reg       oLCD_RegisterSelect, //0=Command, 1=Data
   output wire      oLCD_StrataFlashControl,
   output wire      oLCD_ReadWrite,
   output reg [3:0] oLCD_Data
   );
   reg              rWrite_Enabled;
   assign oLCD_ReadWrite = 0; //I only Write to the LCD display, never Read from it
   assign oLCD_StrataFlashControl = 1; //StrataFlash disabled. Full read/write access to LCD
   reg [7:0]        rCurrentState,rNextState;
   reg [31:0]       rTimeCount;
   reg              rTimeCountReset;
   wire             wWriteDone;
   //----------------------------------------------
   //Next State and delay logic
   always @ ( posedge Clock )
     begin
        if (Reset)
          begin
             rCurrentState = `STATE_RESET;
             rTimeCount <= 32'b0;
          end
        else
          begin
             if (rTimeCountReset)
               rTimeCount <= 32'b0;
             else
               rTimeCount <= rTimeCount + 32'b1;
             rCurrentState <= rNextState;
          end
     end
   //----------------------------------------------
   //Current state and output logic
   always @ ( * )
     begin
        case (rCurrentState)
          //------------------------------------------
          `STATE_RESET:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h0;
               oLCD_RegisterSelect = 1'b0;
               rTimeCountReset = 1'b0;
               rNextState = `STATE_POWERON_INIT_0_A;
            end
          //------------------------------------------
          /*
           Wait 15 ms or longer.
           The 15 ms interval is 750,000 clock cycles at 50 MHz.
           */
          `STATE_POWERON_INIT_0_A:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h0;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b0;
               if (rTimeCount > 32'd750000 )
                 rNextState = `STATE_POWERON_INIT_0_B;
               else
                 rNextState = `STATE_POWERON_INIT_0_A;
            end
          //------------------------------------------
          `STATE_POWERON_INIT_0_B:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h0;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1; //Reset the counter here
               rNextState = STATE_POWERON_INIT_1;
            end
          //------------------------------------------
          /*
           Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
           */
          `STATE_POWERON_INIT_1:
            begin
               rWrite_Enabled = 1'b1;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               if ( wWriteDone )
                 rNextState = `STATE_POWERON_INIT_2_A;
               else
                 rNextState = `STATE_POWERON_INIT_1;
            end
          //------------------------------------------
          /*
           Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
           */
          `STATE_POWERON_INIT_2_A:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b0;
               if (rTimeCount > 32'd205000 )
                 rNextState = `STATE_POWERON_INIT_2_B;
               else
                 rNextState = `STATE_POWERON_INIT_2_A;
            end
          //------------------------------------------
          `STATE_POWERON_INIT_2_B:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               rNextState = `STATE_POWERON_INIT_3;
            end
          //------------------------------------------
           /*
           Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
           */
          `STATE_POWERON_INIT_3:
            begin
               rWrite_Enabled = 1'b1;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               if ( wWriteDone )
                 rNextState = `STATE_POWERON_INIT_4;
               else
                 rNextState = `STATE_POWERON_INIT_3;
            end
          //------------------------------------------
          /*
           Wait 100 us or longer, which is 5,000 clock cycles at 50 MHz.
           */
          `STATE_POWERON_INIT_4:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b0;
               if (rTimeCount > 32'd5000 )
                 rNextState = `STATE_POWERON_INIT_5;
               else
                 rNextState = `STATE_POWERON_INIT_4;
            end
          //------------------------------------------
          `STATE_POWERON_INIT_5:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               rNextState = `STATE_POWERON_INIT_6;
            end
          //------------------------------------------
           /*
           Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
           */
          `STATE_POWERON_INIT_6:
            begin
               rWrite_Enabled = 1'b1;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               if ( wWriteDone )
                 rNextState = `STATE_POWERON_INIT_7;
               else
                 rNextState = `STATE_POWERON_INIT_6;
            end
          /*
           Wait 40 us or longer, which is 2,000 clock cycles at 50 MHz.
           */          
          //------------------------------------------
          `STATE_POWERON_INIT_7:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b0;
              if (rTimeCount > 32'd2000 )
                 rNextState = `STATE_POWERON_INIT_7;
               else
                 rNextState = `STATE_POWERON_INIT_8;
            end
          //------------------------------------------
          `STATE_POWERON_INIT_8:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               rNextState = `STATE_POWERON_INIT_9;
            end
          //------------------------------------------
           /*
           Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
           */
          `STATE_POWERON_INIT_9:
            begin
               rWrite_Enabled = 1'b1;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b1;
               if ( wWriteDone )
                 rNextState = `STATE_POWERON_INIT_10;
               else
                 rNextState = `STATE_POWERON_INIT_9;
            end
          /*
           Wait 40 us or longer, which is 2,000 clock cycles at 50 MHz.
           */          
          //------------------------------------------
          `STATE_POWERON_INIT_10:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h3;
               oLCD_RegisterSelect = 1'b0; //these are commands
               rTimeCountReset = 1'b0;
              if (rTimeCount > 32'd2000 )
                 rNextState = `STATE_POWERON_INIT_11;
               else
                 rNextState = `STATE_POWERON_INIT_10;
            end
          //------------------------------------------          
          default:
            begin
               rWrite_Enabled = 1'b0;
               oLCD_Data = 4'h0;
               oLCD_RegisterSelect = 1'b0;
               rTimeCountReset = 1'b0;
               rNextState = `STATE_RESET;
            end
          //------------------------------------------
        endcase
     end
endmodule
