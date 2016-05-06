library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity LFO is
		Port ( 
				clk, sample_clk : in  STD_LOGIC;
			LFO : OUT STD_LOGIC_VECTOR(6 downto 0);
				LFO_depth : IN STD_LOGIC_VECTOR(6 downto 0);
				LFO_frequency : in STD_LOGIC_VECTOR(6 downto 0);
				mode : IN STD_LOGIC_VECTOR(1 downto 0);
				LFO_from_micro : in STD_LOGIC_VECTOR(31 downto 0);
			LFO_to_micro : out STD_LOGIC_VECTOR(31 downto 0)
			);
end LFO;


architecture arch of LFO is


COMPONENT counter IS
      PORT(clk:IN STD_LOGIC;
      	   sample_clk : in  STD_LOGIC;
           count_max: IN STD_LOGIC_VECTOR(11 downto 0);
	   count_duty: IN STD_LOGIC_VECTOR(11 downto 0);
	   clk_out: OUT STD_LOGIC);
END COMPONENT counter;

SIGNAL time_S, count_L : STD_LOGIC_VECTOR(11 downto 0):="000000000000";
SIGNAL gain, count : STD_LOGIC:='0';
--SIGNAL count_L : integer:=0;

BEGIN




process(clk)
BEGIN
	if(rising_edge(clk)) then
		LFO_to_micro(6 downto 0) <= LFO_frequency;
		LFO_to_micro(13 downto 7) <= LFO_depth;
        if(count_L = "000000000000") then
            if(mode = "10") then				-- sawtooth
                time_S <= STD_LOGIC_VECTOR((unsigned(LFO_from_micro(11 downto 0))) SLL 1);
        
            else						-- triangle and square
                time_S <= LFO_from_micro(11 downto 0);
        
            end if;
		end if;
	end if;
end process;


counter_LFO_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
         sample_clk => sample_clk,
	 	  count_max => time_S,
		  count_duty => "000000000001",
		  clk_out => count);


process(clk)
BEGIN
	if(rising_edge(clk)) then   
	   	if sample_clk = '1' then
			if (count='1') then
				if(gain = '0') then			-- rise
					count_L <= STD_LOGIC_VECTOR(unsigned(count_L) + 1);
					if(count_L = "00000" & STD_LOGIC_VECTOR((unsigned(LFO_depth)-1))) then	-- change to fall
						gain <= '1';

					end if;

				elsif(gain = '1') then			-- fall
					count_L <= STD_LOGIC_VECTOR(unsigned(count_L) - 1);
					if(mode = "10") then		-- sawtooth
						gain <= '0';
						count_L <= "000000000000";

					else				-- triangle and square
						if(count_L = "000000000001") then	-- change to rise
							gain <='0';
							count_L <= "000000000000";

						end if;
					end if;
				end if;
			end if;
			-- send out
			if(mode = "01") then				-- square
				if(gain = '0') then			-- high
					LFO <= LFO_depth;
				else					-- low
					LFO <= "0000000";

				end if;
			else						-- sawtooth and triangle
				LFO <=count_L(6 downto 0);

			end if;
	  	end if;
	end if;
end process;

end arch;




