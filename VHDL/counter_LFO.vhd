-------------------------------------------------------
--! @file
--! @brief LFO counter entity
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! Description of Entity
entity counter_LFO is
		Port ( 
				clk : in  STD_LOGIC; --! clock (100 MHz)
				sample_clk : in  STD_LOGIC; --! Logical one
				count_max : in STD_LOGIC_VECTOR(31 downto 0); --! Amount of clks until clk_out becomes 1
				count_duty : in  STD_LOGIC_VECTOR(31 downto 0);	--! Amount of clks after clk_out became 1 for it to become 0 again
				clk_out : out  STD_LOGIC --! Clock enable output
				);
end counter_LFO;


--! @brief LFO counter
--! @detailed Clock enable component for LFO
architecture arch of counter_LFO is


signal clk4holder : STD_LOGIC:='1'; --! Temporary clock_out
signal count_max_S :  STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000"; --! Temporary maximum value
signal count_duty_S :  STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000"; --! Temporary duty value
signal counter4 :  STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000"; --! Counter that counts up to count_max_S
BEGIN



clk_out <= clk4holder;

--! Increases counter4 by one for each clk, sets count_max_S and count_duty_S, changes the clock enable output
process(clk)
BEGIN 
    IF rising_edge(clk) then
	  if sample_clk = '1' then

		if counter4 = "00000000000000000000000000000000" then
			count_max_S <= STD_LOGIC_VECTOR(unsigned(count_max) + 3);--to_integer(unsigned(count_max))+3;
	   		count_duty_S <= count_duty;--to_integer(unsigned(count_duty));
			counter4 <= STD_LOGIC_VECTOR(unsigned(counter4) + 1);
   		elsif counter4 = count_duty_S then
   			clk4holder <='0';
			count_max_S <= STD_LOGIC_VECTOR(unsigned(count_max) + 3);--to_integer(unsigned(count_max))+3;
	   		count_duty_S <= count_duty;--to_integer(unsigned(count_duty));		
   			counter4 <= STD_LOGIC_VECTOR(unsigned(counter4) + 1);
		elsif counter4 = count_max_S then
   			clk4holder <='1';
			counter4 <= "00000000000000000000000000000001";
		else
			counter4 <= STD_LOGIC_VECTOR(unsigned(counter4) + 1);
		end if;
   	   end if;
   	 end IF;
    end process;
end arch;
