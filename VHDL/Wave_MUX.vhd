-------------------------------------------------------
--! @file
--! @brief Selectes the signal to be output according to the selection from the user interface
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

--! Inputs include the waveforms from the look up tables and the wave type selected on the user interface
ENTITY Wave_MUX IS
PORT(clk : IN STD_LOGIC; --! clock.
      mux_in_sine : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! sine input.
	  mux_in_triangle : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! triangle input.
	  mux_in_square : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! square input.
	  mux_in_sawtooth : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! sawtooth input.
	  mux_in_whitenoise : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! whitenoise input.
	  wave_type : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --! Wave type selection
	  mux_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); --! output wave from the oscillators.
END Wave_MUX;

--! The mux selects the waveform that should be output from the oscillator according to the request of the user
ARCHITECTURE arch_Wave_MUX OF Wave_MUX IS

BEGIN
	PROCESS (wave_type, clk)
	BEGIN
		CASE wave_type IS
			when "000" => mux_out <= mux_in_sine;
			when "001" => mux_out <= mux_in_triangle;
			when "010" => mux_out <= mux_in_square;
			when "011" => mux_out <= mux_in_sawtooth;
			when "100" => mux_out <= mux_in_whitenoise;
			when others => mux_out <= "000000000000";
		END CASE;
	END PROCESS;


END arch_Wave_MUX;