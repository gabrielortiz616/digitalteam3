-------------------------------------------------------
--! @file
--! @brief Pseudo random number generator for white noise
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Outputs random number of 12 bit
entity WhiteNoise is
    generic ( width : integer :=  24 ); 
port (
      clk : in std_logic; --! Clock
      sample_clk : in std_logic; --! Sample Clock
      random_num : out std_logic_vector (11 downto 0) --! Random number out            
    );
end WhiteNoise;

--! Linear Feedback shift register used to generate white noise
architecture arch_WhiteNoise of WhiteNoise is
begin
	process(clk)
	variable rand_temp : std_logic_vector(width-1 downto 0):=(width-1 => '1',others => '0');
	variable temp : std_logic := '0';
	begin
		if(rising_edge(clk)) then
		  if sample_clk ='1' then
			temp := rand_temp(width-1) xor rand_temp(width-2);
			rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
			rand_temp(0) := temp;
		  end if;
		end if;
		random_num <= rand_temp(11 downto 0);
	end process;
END;
