-------------------------------------------------------
--! @file
--! @brief Several echoes (reverb) entity
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! Description of Entity
ENTITY signal_added IS
	PORT(input_1 : IN  std_logic_vector(11 downto 0); --! No delayed waveform
	    input_2:IN std_logic_vector(11 downto 0); --! 1/4 of the full delayed waveform
	    clk : IN STD_LOGIC; --! sample clock (40 kHz)
        input_3:IN std_logic_vector(11 downto 0); --! 2/4 of the full delayed waveform
        input_4:IN std_logic_vector(11 downto 0);--! 3/4 of the full delayed waveform
        input_5:IN std_logic_vector(11 downto 0);--! Full delayed waveform
	 effect_out : OUT std_logic_vector(11 downto 0)); --! Output of the added waveforms
END signal_added;


--! @brief Several echoes added (reverb)
--! @detailed Adds several delayed waveforms to make a reverb waveforms
ARCHITECTURE behavior OF signal_added IS
signal temp: STD_LOGIC_VECTOR(23 downto 0):= (Others=> '0'); --! temporary output before modulation
	
BEGIN

--! Adds all the delayed waveforms and sends them out to the output. Also makes it signed during calculation and then converts back to unsigned.
process(clk)
begin
    if(rising_edge(clk)) then
        temp<=std_logic_vector(signed(unsigned(input_1)-2048)*128+signed(unsigned(input_2)-2048)*64+signed(unsigned(input_3)-2048)*32+signed(unsigned(input_4)-2048)*16+signed(unsigned(input_5)-2048)*8);
        effect_out<=std_logic_vector(signed(temp(19 downto 8))+2048);--change magnitude here
    end if;
end process;
END behavior;
