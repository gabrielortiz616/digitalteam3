LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Wave_MUX IS
PORT(clk : IN STD_LOGIC; -- clock.
      mux_in_sine : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- sine input.
	  mux_in_triangle : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- triangle input.
	  mux_in_square : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- square input.
	  mux_in_sawtooth : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- sawtooth input.
	  mux_in_whitenoise : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- whitenoise input.
	  wave_type : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	  mux_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- output.
END Wave_MUX;

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