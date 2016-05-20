-------------------------------------------------------
--! @file
--! @brief Sampling clock and SPI clock generation
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! This entity generates the sampling clock and the SPI clock from the main 100 MHz clock
ENTITY clk_enable IS
	PORT(clk : IN STD_LOGIC; --! Main Clock 100 MHz
		  sample_clk : OUT STD_LOGIC;  --! Sample Clock 40 kHz
		  sclk : OUT STD_LOGIC;  --! SPI Clock 1MHz
		  sclk_en : OUT STD_LOGIC); --! SPI Clock Enable
END clk_enable;

--! Generates the clocks needed in the project
ARCHITECTURE behavior OF clk_enable IS
	SIGNAL counter_slow : INTEGER range 0 TO 100000000; --! For the sample clock
	SIGNAL counter_sclk : INTEGER range 0 TO 100000000 :=0; --! For SPI clock
    SIGNAL counter_en : INTEGER range 0 TO 100000000 :=0; --! For SPI Clock enable

	
BEGIN

	PROCESS(clk)
    variable int_sclk : STD_LOGIC := '1';
    variable int_sclk_spi : STD_LOGIC := '1';
	BEGIN
		IF rising_edge(clk) THEN	

			--! Sample Clock 40kHz
			IF counter_slow = 2500-1 THEN
				sample_clk <= '1';
				counter_slow <= 0;
			ELSE 
				sample_clk <= '0';
				counter_slow <= counter_slow + 1;
			END IF;
			
			--! SPI Clock 1MHz
            counter_sclk <= counter_sclk + 1;
            IF counter_sclk = 50-1 THEN
                int_sclk := not int_sclk;
                sclk <= int_sclk;
                counter_sclk <= 0;
            END IF;
            			
			--! SPI Clock Enable
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
