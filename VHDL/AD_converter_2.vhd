----------------------------------------------
--     Author: Gabriel Ortiz Betancur
--     DAT093
--     2015
----------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;	
 
ENTITY adc_interface IS
	PORT(clk : IN STD_LOGIC;
		 sample_clock : IN STD_LOGIC;
		 sclk_in : IN STD_LOGIC;
		 sclk_en : IN STD_LOGIC;
		 miso : IN STD_LOGIC;
		 sclk_out : OUT STD_LOGIC; 
		 mosi : OUT STD_LOGIC;
		 cs: OUT STD_LOGIC := '1'; -- active 0
		 data_to_dac : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END adc_interface;
 
ARCHITECTURE arch_adc_interface OF adc_interface IS

	CONSTANT start_cond : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111"; -- (3)start, (2 DOWNTO 1)single ended mode,(0)MSB first 
	SIGNAL send : STD_LOGIC;
	SIGNAL receive : STD_LOGIC;
	SIGNAL started : STD_LOGIC :='0';
	SIGNAL data_in : STD_LOGIC_VECTOR(12 DOWNTO 0);

BEGIN -- architecture
	sclk_out <= sclk_in;

	ADC_PRC : PROCESS(clk,sclk_in,sample_clock)
		VARIABLE counter_send : INTEGER := 0;
		VARIABLE counter_receive : INTEGER := 0;
	BEGIN
			IF rising_edge(clk) THEN -- send start condition
				IF sample_clock = '1' AND started = '0' THEN				
					IF started = '0' THEN
						send <= '1';
						counter_send := 0;
						send <= '1';
						--Led(0) <= '1';
						started <= '1';
					END IF;
				ELSIF sclk_en = '1' THEN	
					IF send = '1' THEN	
						IF counter_send = 4 THEN -- start condition sent, start receiving data
							receive <= '1'; 
							send <= '0';
							counter_send := 0;
							mosi <= '0';
							--Led(1) <= '1';
						ELSE	
							cs <= '0';
							mosi <= start_cond(3 - counter_send);
							counter_send := counter_send + 1;
						END IF;
					ELSIF receive = '1' THEN -- receive data
						IF counter_receive = 13 THEN
							started <= '0';
							counter_receive := 0;
							receive <= '0';
							data_to_dac <= data_in(11 DOWNTO 0); -- bit 12 is null
							--Led(2 DOWNTO 0) <= data_in(10 DOWNTO 8);
							--Led(3) <= '1';
							cs <= '1';
						ELSE
							data_in(12 - counter_receive) <= miso;
							counter_receive := counter_receive + 1;
							--Led(3) <= miso;
						END IF; 
					END IF;
				END IF;
			END IF;
	END PROCESS;
END arch_adc_interface;