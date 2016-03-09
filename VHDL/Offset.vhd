library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Offset_LUT is
   Port (  clk : IN STD_LOGIC;
           offset_in : in STD_LOGIC_VECTOR (6 downto 0);
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0);
           midi_note  : in STD_LOGIC_VECTOR (7 downto 0);
           midi_note_temp : out STD_LOGIC_VECTOR (7 downto 0));
end Offset_LUT;

architecture arch_Offset of Offset_LUT is
SIGNAL offset_temp : STD_LOGIC_VECTOR (6 downto 0):="1000000" ;
begin

PROCESS (clk)
BEGIN
offset_temp <= offset_in;
IF (STD_LOGIC_VECTOR(signed(midi_note)-8)>= "00010101") and STD_LOGIC_VECTOR(signed(midi_note)+7)<= "01100111" THEN
    IF offset_temp >= "0000000" and offset_temp<"0001000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-8);
        offset_integer_out <= "11000";
    ELSIF offset_temp >= "0001000" and offset_temp<"0010000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-7);
        offset_integer_out <= "11001";
    ELSIF offset_temp >= "0010000" and offset_temp<"0011000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-6);
        offset_integer_out <= "11010";        
    ELSIF offset_temp >= "0011000" and offset_temp<"0100000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-5);
        offset_integer_out <= "11011";               
    ELSIF offset_temp >= "0100000" and offset_temp<"0101000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-4); 
        offset_integer_out <= "11100";              
    ELSIF offset_temp >= "0101000" and offset_temp<"0110000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-3);
        offset_integer_out <= "11101";             
    ELSIF offset_temp >= "0110000" and offset_temp<"0111000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-2);  
        offset_integer_out <= "11110";    
    ELSIF offset_temp >= "0111000" and offset_temp<"1000000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-1);  
        offset_integer_out <= "11111";            
    ELSIF offset_temp >= "1000000" and offset_temp<"1001000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)-0);
        offset_integer_out <= "00000";              
    ELSIF offset_temp >= "1001000" and offset_temp<"1010000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+1);
        offset_integer_out <= "00001";            
    ELSIF offset_temp >= "1010000" and offset_temp<"1011000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+2);
        offset_integer_out <= "00010";            
    ELSIF offset_temp >= "1011000" and offset_temp<"1100000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+3);
        offset_integer_out <= "00011";            
    ELSIF offset_temp >= "1100000" and offset_temp<"1101000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+4);
        offset_integer_out <= "00100";     
    ELSIF offset_temp >= "1101000" and offset_temp<"1110000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+5);
        offset_integer_out <= "00101";
    ELSIF offset_temp >= "1110000" and offset_temp<"1111000" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+6);
        offset_integer_out <= "00110"; 
    ELSIF offset_temp >= "1111000" and offset_temp<"1111111" THEN
        midi_note_temp <= STD_LOGIC_VECTOR(signed(midi_note)+7);
        offset_integer_out <= "00111";                                                                                                       
    END IF;        
ELSE
    midi_note_temp <= midi_note;
END IF;
END PROCESS;

end arch_Offset;
