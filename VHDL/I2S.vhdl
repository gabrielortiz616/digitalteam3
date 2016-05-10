-- I2S master
-- Used to test I2S receiver
-- 2016-02-05

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IIS_master IS
	generic(N: integer := 12); -- Number of registers used.
	port(
		clk, reset: IN STD_LOGIC;
		parallel_right_data, parallel_left_data: IN STD_LOGIC_VECTOR (0 to N-1); 			-- Left and right channel data
		serial_clk_out, word_select, serial_data, right_channel_indicator: OUT STD_LOGIC
	);
END IIS_master;

ARCHITECTURE IIS_master_architecture OF IIS_master IS
	-- Constants
	CONSTANT RESET_ACTIVE: STD_LOGIC := '0'; -- Choose if reset is active high or low.
	CONSTANT CLOCK_DIVIDER: INTEGER := 189; -- Master clock/Desired Clock = constant, 100MHz/12Bitar*44,1kHz = 189, 5 debug --378 for 200MHz
	CONSTANT RIGHT_CHANNEL: STD_LOGIC := '1';
	
	-- Signals 
	SIGNAL s_word_select: STD_LOGIC;
BEGIN
 
	word_select <= s_word_select;
 
PROCESS(clk, reset)
Variable clock_count: INTEGER := 0;
Variable data_index: INTEGER := 0;

BEGIN
	IF(reset = RESET_ACTIVE) THEN
		clock_count := 0;
		data_index := 0;
		s_word_select <= '0';
		serial_clk_out <= '0';
	ELSE
		IF(rising_edge(clk))THEN
			
			IF(clock_count = CLOCK_DIVIDER/2) THEN 	-- Clock low, send out low I2S clock, new data and check word select done.
				serial_clk_out <= '0';				-- I2S clock low
				IF(data_index = 0) THEN 			-- First time, means that we should change word_select
					s_word_select <= not s_word_select;					
				ELSE -- Not first time just output data
					IF(s_word_select = RIGHT_CHANNEL) THEN -- Output right channel data
						right_channel_indicator <= '1';
						serial_data <= parallel_right_data(data_index-1);
					ELSE --Output left channel data
						right_channel_indicator <= '0';
						serial_data <= parallel_left_data(data_index-1);
					END IF;				
				END IF;
				clock_count := clock_count+1;
			ELSIF(clock_count = CLOCK_DIVIDER) THEN	-- Clock high, send out high I2S clock and increase data index.
				serial_clk_out <= '1';				-- I2S clock high
				IF(data_index = N) THEN				-- Final time, means reset data index to 0
					data_index := 0;
					clock_count := 0;
				ELSE
					data_index := data_index+1;		-- Increment parallel data index
				END IF;
				clock_count := 0;
			ELSE
				clock_count := clock_count+1;
			END IF;
		END IF;
	END IF;
END PROCESS;
 
END IIS_master_architecture;











