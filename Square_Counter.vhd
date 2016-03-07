LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY Square_Counter IS
PORT(counter_size : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- Count number to get the desired frequency
	  reset : IN STD_LOGIC; -- Reset
	  clk : IN STD_LOGIC; -- clock.
	  slowclk : IN STD_LOGIC; -- clock.
	  overflow : OUT STD_LOGIC; -- clock.
	  square_counter_out: OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); 
END Square_Counter;

ARCHITECTURE arch_Square_Counter OF Square_Counter IS

	SIGNAL freq_count : INTEGER range 0 TO 100000000;

BEGIN


    PROCESS(clk, reset, counter_size)
    VARIABLE counter_sample : INTEGER range 0 TO 100000000;
    BEGIN
        IF reset = '0' THEN
            counter_sample := 0;
        ELSIF rising_edge(clk) THEN
            IF freq_count /= to_integer(unsigned(counter_size)) THEN
                freq_count <= to_integer(unsigned(counter_size));
                counter_sample := 0;
            END IF;
            IF slowclk = '1' THEN
				IF counter_sample = freq_count-1 THEN
					overflow <= '1';
					counter_sample := 0;
				ELSE 
					overflow <= '0';
					counter_sample := counter_sample + 1;
				END IF;
				square_counter_out <= STD_LOGIC_VECTOR(to_unsigned(counter_sample, 12));
			END IF;
        END IF;
    END PROCESS;
END arch_Square_Counter;
