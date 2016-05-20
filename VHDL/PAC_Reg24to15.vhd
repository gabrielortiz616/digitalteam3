-------------------------------------------------------
--! @file
--! @brief Stores the value coming out from the PAC Adder and generates input to look up tables
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

--! It is fed by the PAC Adder and outputs value to PAC adder (21 bits) and look up tables (12 bits)
ENTITY reg24to12 IS
PORT(D : IN STD_LOGIC_VECTOR(20 DOWNTO 0); --! Input from PAC Addder
	  reset : IN STD_LOGIC; --! Reset
	  slowclk : IN STD_LOGIC; --! Sample Clock
	  clk : IN STD_LOGIC; --! Main Clock
	  midi_note : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --! MIDI Note?
	  Q24 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0); --! Output to PAC Adder (21 bits)
	  Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); --! Output to look-up-tables (12 bits)
END reg24to12;


--! Stores the value coming out from the PAC Adder and generates input to look up tables by truncating the actual value. 
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