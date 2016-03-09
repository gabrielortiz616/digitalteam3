LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY reg24to12 IS
PORT(D : IN STD_LOGIC_VECTOR(20 DOWNTO 0); -- input.
	  reset : IN STD_LOGIC; -- Reset
	  slowclk : IN STD_LOGIC; -- slowclock.
	  clk : IN STD_LOGIC; -- fastclock.
	  midi_note : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  Q24 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
	  Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- output.
END reg24to12;

ARCHITECTURE arch_reg24to12 OF reg24to12 IS

BEGIN

    PROCESS(clk, slowclk, reset)
    BEGIN
        IF reset = '0' THEN
            Q <= (others => '0');
				Q24 <= (others => '0');
        ELSIF rising_edge(clk) THEN
            IF slowclk ='1' THEN
                Q <= D(20 downto 9);
					 Q24 <= D;
		    END IF;
        END IF;

    END PROCESS;

END arch_reg24to12;