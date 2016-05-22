-------------------------------------------------------
--! @file
--! @brief Highpass filter entity
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! Description of Entity
entity highpass is
		Generic(	WIDTH_filter:INTEGER:=12; --! Amount of bits in the input and output 
				WIDTH_LFO: INTEGER :=7); --! Amount of bits from the LFO
		Port ( 
				clk : in STD_LOGIC; --! clock (100 MHz) 
				sample_clk : in  STD_LOGIC; --! clock (40 kHz)
				x_IN : in  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0); --! Input waveform to the highpass filter
				LFO : in STD_LOGIC_VECTOR(WIDTH_LFO-1 downto 0); --! Input waveform of the LFO
				knob : IN STD_LOGIC_VECTOR(6 downto 0); --! Input for controlling cut-off frequency from the MIDI interface
				Q_in : in STD_LOGIC_VECTOR(6 downto 0); --! Input for controlling quality factor from the MIDI interface
				mode :in STD_LOGIC_VECTOR(1 downto 0); --! Changes if cut-off frequency should depend on MIDI or LFO
			FWave : out  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0); --! Output of the filter
				Filter_from_microA_HP : in STD_LOGIC_VECTOR(31 downto 0); --! a coefficents calculated by microblaze
				Filter_from_microB_HP : in STD_LOGIC_VECTOR(31 downto 0); --! b coefficents calculated by microblaze
			Filter_to_micro_HP : out STD_LOGIC_VECTOR(31 downto 0) --! Sending out cut-off frequency and quality factor to microblaze
			);
end highpass;

--! @brief Highpass filter
--! @detailed The filter takes in an input waveform and is put into the transfer function to calculate the output.
architecture arch of highpass is

signal x_S0,x_S1,x_S2, y_S0, y_S1, y_S2, filtered2 : STD_LOGIC_VECTOR(WIDTH_filter-1 downto 0):= (Others=> '0'); --! Temporary inputs and outputs
signal B0,B1,B2,a0,a1,a2 : INTEGER; --! Coefficents to calculate the output
signal filtered : STD_LOGIC_VECTOR(WIDTH_filter*2-1 downto 0):= (Others=> '0'); --! Output before modulation have been done after put in the transfer function
SIGNAL fc : STD_LOGIC_VECTOR(11 downto 0); --! Temporary cut-off frequency

begin

--! Sets cut-off frequency from MIDI or LFO depending on mode and sends to microblaze
process(clk)
BEGIN
	if(rising_edge(clk)) then
		if(mode = "01") then
			fc <= LFO & "00000";  

		elsif(mode = "00") then
			fc <= knob & "00000";
			
		else
			fc <= "011111010000"; 
		end if;
		Filter_to_micro_HP(11 downto 0) <= fc;
		Filter_to_micro_HP(18 downto 12) <= Q_in ;
		
	end if;
end process;

--! Takes in coefficients from microblaze and calculates the missing ones
B0 <= to_integer(unsigned(Filter_from_microB_HP(11 downto 0)));
B1 <= -2*B0;
B2 <= B0;
a0 <= 1024;
a1 <= -to_integer(unsigned(Filter_from_microA_HP(11 downto 0)));
a2 <= to_integer(unsigned(Filter_from_microA_HP(23 downto 12)));

--! Samples the input and output. Also sets the input to oscillate around 0 instead at 2048
sample: process(clk)
begin
	if rising_edge(clk) then
		if(sample_clk = '1') then
			x_S0  <= STD_LOGIC_VECTOR(unsigned(x_IN)-2048);
			x_S1 <= x_S0;
			x_S2 <= x_S1;
			FWave <= y_S0;
			y_S1 <= y_S0;
			y_S2 <= y_S1;
		end if;
	end if;
end process sample;

--! Calculates the output of the transfer function
filter: process(clk)
begin
	if rising_edge(clk) then
		filtered <= STD_LOGIC_VECTOR((-a1*signed(y_S1) - a2*signed(y_S2) + a0 +	
				B0*signed(x_S0) + B1*signed(x_S1) + B2*signed(x_S2)));
	end if;
end process filter;

--! Modulates the output of the transfer function so that it gives the correct output
filtered2 <= STD_LOGIC_VECTOR(signed(filtered(WIDTH_filter*2-1) & filtered(WIDTH_filter*2-3 downto WIDTH_filter-1)));
y_S0 <= STD_LOGIC_VECTOR(signed(filtered2) SLL 1);

end arch;









