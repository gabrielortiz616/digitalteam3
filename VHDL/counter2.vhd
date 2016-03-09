LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity counter is
		Port ( 
				clk : in  STD_LOGIC;
				sample_clk : in  STD_LOGIC;
				count_max, count_duty : in  STD_LOGIC_VECTOR(11 downto 0);	-- count_duty = 1 <= 1 clock on '1' and the rest '0'
				clk_out : out  STD_LOGIC
				);
end counter;



architecture arch of counter is


signal counter4 : INTEGER :=0;
signal clk4holder : STD_LOGIC:='1';
signal count_max_S, count_duty_S : INTEGER :=0;
BEGIN



clk_out <= clk4holder;

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
