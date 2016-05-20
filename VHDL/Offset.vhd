-------------------------------------------------------
--! @file
--! @brief Receives data of the Ooffset from the MIDI interface and reutrns how many notes the second oscillator should be shifted
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

--! The main input is the offfset value from the control knobs or LFO and the actual Note to be played, returns the new note to be played after offset
entity Offset_LUT is
   Port (  clk : IN STD_LOGIC; --! Clock
           offset_in : in STD_LOGIC_VECTOR (6 downto 0); --! Offset value
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0); -- Offset integer out to display in LCD display
           midi_note  : in STD_LOGIC_VECTOR (7 downto 0); --! Actual MIDI Note
           midi_note_temp : out STD_LOGIC_VECTOR (7 downto 0)); --! New MIDI Note to be played after the offset
end Offset_LUT;

--! Based on a look up table, receives a value in the range of 0 to 127 and returns a new MIDI note shifted in the range -8 to +7 notes-
architecture arch_Offset of Offset_LUT is

begin

PROCESS (clk)
BEGIN
IF (STD_LOGIC_VECTOR(signed(midi_note)-8)>= "00010101") and STD_LOGIC_VECTOR(signed(midi_note)+7)<= "01100111" THEN
    IF offset_in >= "0000000" and offset_in<"0001000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-8);
        offset_integer_out <= "11000";
    ELSIF offset_in >= "0001000" and offset_in<"0010000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-7);
        offset_integer_out <= "11001";
    ELSIF offset_in >= "0010000" and offset_in<"0011000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-6);
        offset_integer_out <= "11010";        
    ELSIF offset_in >= "0011000" and offset_in<"0100000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-5);
        offset_integer_out <= "11011";               
    ELSIF offset_in >= "0100000" and offset_in<"0101000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-4); 
        offset_integer_out <= "11100";              
    ELSIF offset_in >= "0101000" and offset_in<"0110000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-3);
        offset_integer_out <= "11101";             
    ELSIF offset_in >= "0110000" and offset_in<"0111000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-2);  
        offset_integer_out <= "11110";    
    ELSIF offset_in >= "0111000" and offset_in<"1000000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-1);  
        offset_integer_out <= "11111";            
    ELSIF offset_in >= "1000000" and offset_in<"1001000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-0);
        offset_integer_out <= "00000";              
    ELSIF offset_in >= "1001000" and offset_in<"1010000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+1);
        offset_integer_out <= "00001";            
    ELSIF offset_in >= "1010000" and offset_in<"1011000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+2);
        offset_integer_out <= "00010";            
    ELSIF offset_in >= "1011000" and offset_in<"1100000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+3);
        offset_integer_out <= "00011";            
    ELSIF offset_in >= "1100000" and offset_in<"1101000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+4);
        offset_integer_out <= "00100";     
    ELSIF offset_in >= "1101000" and offset_in<"1110000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+5);
        offset_integer_out <= "00101";
    ELSIF offset_in >= "1110000" and offset_in<"1111000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+6);
        offset_integer_out <= "00110"; 
    ELSIF offset_in >= "1111000" and offset_in<"1111111" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+7);
        offset_integer_out <= "00111";                                                                                                       
    END IF;        
ELSE
    midi_note_temp <= midi_note;
END IF;
END PROCESS;

end arch_Offset;
