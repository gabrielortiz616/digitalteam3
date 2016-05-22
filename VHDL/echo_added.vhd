-------------------------------------------------------
--! @file
--! @brief Echo added entity
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--! Description of Entity
ENTITY echo_added is
	PORT(source: in std_logic_vector(11 downto 0); --! Input waveform
		echo: in std_logic_vector(11 downto 0); --! Delayed input waveform
		Fwave: out std_logic_vector(11 downto 0) --! Added output waveform
	);
end echo_added;

--! @brief Echo added
--! @detailed Add the latest waveform and the delayed waveform together
ARCHITECTURE arch of echo_added IS
	SIGNAL g_A, g_B :std_logic_vector(11 downto 0); --! Temporary input waveforms
signal a,b : INTEGER; --! Scaling factors for inpput to make output not overflow
signal temp:  std_logic_vector(23 downto 0):= (Others=> '0'); --! Temporary output
BEGIN

--! Sets the amount of decrease the inputs should have in amplitude. 128 is no decrease
a<=64;
b<=32;

--! Changes variable name of inputs
g_A<=source;
g_B<=echo;

--! Calculates the output and makes it signed
temp<=std_logic_vector(signed(unSIGNED(g_A)-2048)*a+signed(unSIGNED(g_B)-2048)*b);

--! Modulate to the output and makes it unsigned again
Fwave <= std_logic_vector(signed(temp(18 downto 7)) + 2048);
END arch;