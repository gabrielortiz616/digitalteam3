-------------------------------------------------------
--! @file
--! @brief delayer entity
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! Description of Entity
entity comb_filter is                     
		Generic(	WIDTH_filter:INTEGER:=12); --! Amount of bits in the input and output 
		Port ( 
				clk : in  STD_LOGIC; --! sample clock (40 kHz)
				x_IN : in  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0); --! Input waveform
				time_echo : in STD_LOGIC_VECTOR(6 downto 0); --! Amount of delay between sent out sample from the input. Comes from MIDI interface
				FWave : out  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0) --! Output waveform
				);
end comb_filter;

--! @brief Delayer
--! @detailed Delays the input depending on the time that comes from MIDI interface
architecture arch of comb_filter is

type x_HEIGHT is array (0 to 4064) of STD_LOGIC_VECTOR(WIDTH_filter-1 downto 0);
signal x_S : x_HEIGHT; --! Saves old samples
signal x_Selected : STD_LOGIC_VECTOR(11 downto 0); --! The selected sampled
signal y_S0: STD_LOGIC_VECTOR(WIDTH_filter-1 downto 0):= (Others=> '0'); --! Temporary output
signal a2 : INTEGER; --! Integer to scale the amplitude of the output if needed
signal reflect : STD_LOGIC_VECTOR(WIDTH_filter*2-1 downto 0):= (Others=> '0'); --! The reflected waveform. Can be used if wanted to reduce the amplitude of the output

begin

a2 <= 4096; --control how large the echo is. 4096 is normal wayform


--! Samples the input and saves them for 4065 samples. Also sends out the delayed wave depending on the amount of delay set by MIDI interface.
sample: process(clk)
begin
	if rising_edge(clk) then
		x_S(0)  <= x_IN;
		for count_value in 1 to 4064 loop
		      x_S(count_value) <= x_S(count_value-1);
		end loop;
		x_Selected <= x_S(to_integer(unsigned(time_echo))*32);
		FWave <= y_S0;

	end if;
end process sample;

--! Calculates the output. Is just the delayed wave if not changed to using reflect which has a scaled amplitude depending on the coefficient a2
filter: process(clk)
begin
	if rising_edge(clk) then
		reflect<=STD_LOGIC_VECTOR(unsigned(x_Selected)*a2);
		-- y_S0 <= reflect(23 downto 12); -- If want to use scaling instead take away the commenting on this line
        y_S0 <= x_Selected; -- If want to use scaling instead comment this line
	end if;
end process filter;
end arch;









