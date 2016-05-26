-------------------------------------------------------
--! @file
--! @brief counter entity
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! Description of Entity
entity counter is
		Port ( 
				clk : in  STD_LOGIC; --! clock (100 MHz)
				sample_clk : in  STD_LOGIC; --! sample clock (40 kHz)
				count_max  : in  STD_LOGIC_VECTOR(11 downto 0); --! Amount of clks until clk_out becomes 1
				count_duty : in  STD_LOGIC_VECTOR(11 downto 0); --! Amount of clks after clk_out became 1 for it to become 0 again
				clk_out : out  STD_LOGIC --! Clock enable output
				);
end counter;


--! @brief LFO counter
--! @detailed Clock enable component
architecture arch of counter is


signal counter4 : INTEGER :=0; --! Counter that counts up to count_max_S
signal clk4holder : STD_LOGIC:='1'; --! Temporary clock_out
signal count_max_S : INTEGER :=0; --! Temporary maximum value
signal count_duty_S : INTEGER :=0; --! Temporary duty value
BEGIN



clk_out <= clk4holder;

--! Increases counter4 by one for each clk, sets count_max_S and count_duty_S, changes the clock enable output
process(clk)
BEGIN 
    IF rising_edge(clk) then
	  if sample_clk = '1' then

		if counter4 = 0 then
			count_max_S <= to_integer(unsigned(count_max))+3;
	   		count_duty_S <= to_integer(unsigned(count_duty));
			counter4 <= counter4 + 1;
   		elsif counter4 = count_duty_S then
   			clk4holder <='0';
			count_max_S <= to_integer(unsigned(count_max))+3;
	   		count_duty_S <= to_integer(unsigned(count_duty)); 		
   			counter4 <= counter4 + 1;
		elsif counter4 = count_max_S then
   			clk4holder <='1';
			counter4 <= 1;
		else
			counter4 <= counter4 + 1;
		end if;
   	   end if;
   	 end IF;
    end process;
end arch;
