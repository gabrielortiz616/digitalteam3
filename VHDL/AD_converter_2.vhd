LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY AD_converter IS
   GENERIC (WIDTH_AD:INTEGER:=12);
   PORT(clk: IN STD_LOGIC;   
		CS_AD :OUT STD_LOGIC;
		SCK_AD :OUT STD_LOGIC;
		D_in :OUT STD_LOGIC;
		clk_spi :IN STD_LOGIC;
		spi_enable :IN STD_LOGIC;
		spi_start :IN STD_LOGIC;			
		D_out :IN STD_LOGIC;
		data_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END AD_converter;

ARCHITECTURE arch_AD_converter OF AD_converter IS

SIGNAL count1: INTEGER:=0;
SIGNAL start_S, SGL_DIFF, ODD_SIGN, MS_BF: STD_LOGIC;
SIGNAL start_temp : STD_LOGIC;
signal data : STD_LOGIC_VECTOR(11 downto 0);
BEGIN

SGL_DIFF <= '1';
ODD_SIGN <= '1';
MS_BF <= '0';

data_k:
PROCESS(clk)                                       
BEGIN
	IF rising_edge(clk) THEN
		IF(spi_start = '1') THEN
			start_S <= '1';
--			finish <= '0';
		ELSIF ((spi_enable='1') AND (start_S = '1')) THEN
			IF(count1 <= 0) THEN	
				CS_AD <= '0';
				D_in <= '1';
			ELSIF(count1 <= 1) THEN
				D_in <= SGL_DIFF;
			ELSIF(count1 <= 2) THEN
				D_in <= ODD_SIGN;
			ELSIF(count1 <= 3) THEN
				D_in <= MS_BF;
			ELSIF(count1 <= 6) THEN
				data(11) <= D_out;
			ELSIF(count1 <= 7) THEN
				data(10) <= D_out;
			ELSIF(count1 <= 8) THEN
				data(9) <= D_out;
			ELSIF(count1 <= 9) THEN
				data(8) <= D_out;
			ELSIF(count1 <= 10) THEN
				data(7) <= D_out;
			ELSIF(count1 <= 11) THEN
				data(6) <= D_out;				
			ELSIF(count1 <= 12) THEN
				data(5) <= D_out;				
			ELSIF(count1 <= 13) THEN
				data(4) <= D_out;				
			ELSIF(count1 <= 14) THEN
				data(3) <= D_out;				
			ELSIF(count1 <= 15) THEN
				data(2) <= D_out;
			ELSIF(count1 <= 16) THEN
				data(1) <= D_out;
			ELSIF(count1 <= 17) THEN
				data(0) <= D_out;
				CS_AD <= '1';
			END IF;
	
			IF count1 <= 17 THEN
				count1 <= count1 + 1;
			ELSE
				count1 <= 0;
--				finish <= '1';
				start_S <='0';
			END IF;	
		END IF;
	END IF;
END PROCESS data_k;

SCK_k: PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
	IF (clk_spi = '1') THEN
		SCK_AD <= '1';
	ELSE
		SCK_AD <= '0';
	END IF;
END IF;
	
end process SCK_k;

END arch_AD_converter;