LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clk_enable IS
	PORT(clk : IN STD_LOGIC;
		  sample_clk : OUT STD_LOGIC;
		  sclk : OUT STD_LOGIC;
		  sclk_en : OUT STD_LOGIC);
END clk_enable;

ARCHITECTURE behavior OF clk_enable IS
	SIGNAL counter_slow : INTEGER range 0 TO 100000000;
	SIGNAL counter_sclk : INTEGER range 0 TO 100000000 :=0;
    SIGNAL counter_en : INTEGER range 0 TO 100000000 :=0;

BEGIN
	PROCESS(clk)
    variable int_sclk : STD_LOGIC := '1';
	BEGIN
		IF rising_edge(clk) THEN			
			IF counter_slow = 2500-1 THEN
				sample_clk <= '1';
				counter_slow <= 0;
			ELSE 
				sample_clk <= '0';
				counter_slow <= counter_slow + 1;
			END IF;
            counter_sclk <= counter_sclk + 1;
            IF counter_sclk = 50-1 THEN
                int_sclk := not int_sclk;
                sclk <= int_sclk;
                counter_sclk <= 0;
            END IF;
            IF counter_en = 100-1 THEN
                sclk_en <= '1';
                counter_en <= 0;
            ELSE 
                sclk_en <= '0';
                counter_en <= counter_en + 1;
            END IF;			
		END IF;
	END PROCESS;
END behavior;
