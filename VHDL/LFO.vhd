-------------------------------------------------------
--! @file
--! @brief LFO entity
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--! Description of Entity
entity LFO is
		Port ( 
				clk :IN STD_LOGIC; --! clock (100 MHz)
				sample_clk : in  STD_LOGIC; --! clock (40 kHz)
			LFO : OUT STD_LOGIC_VECTOR(6 downto 0); --! Output from the LFO
				LFO_depth : IN STD_LOGIC_VECTOR(6 downto 0); --! Max amplitude of the LFO coming from MIDI Interface
				LFO_frequency : in STD_LOGIC_VECTOR(6 downto 0); --! Frequency coming from MIDI Interface
				mode : IN STD_LOGIC_VECTOR(1 downto 0); --! Wave type selected by the user interface
				LFO_from_micro : in STD_LOGIC_VECTOR(31 downto 0); --! Amount of clock cycles between increases calculated by microblaze
			LFO_to_micro : out STD_LOGIC_VECTOR(31 downto 0) --! Frequency and amplitude sent out to microblaze
			);
end LFO;

--! @brief LFO
--! @detailed The LFO component receives inputs from MIDI interface and the user interface to generate the desired waveforms at the desired frequency. It uses a counter to increase the amplitude of the wave which is increased with an intervall depending on the input from microblaze.
architecture arch of LFO is

--- Components definition ----

COMPONENT counter_LFO IS
      PORT(clk:IN STD_LOGIC; -- clock
      	   sample_clk : in  STD_LOGIC; -- Used for other components to scale up the amount of clock cycles needed for a change in clk_out
           count_max: IN STD_LOGIC_VECTOR(31 downto 0); -- Amount of clock cycles until componet sets clk_out to 1
	   count_duty: IN STD_LOGIC_VECTOR(31 downto 0); -- Amount of clock cycles from clk_out gets 1 until it gets back to 0
	   clk_out: OUT STD_LOGIC); -- Clock enable
END COMPONENT counter_LFO;

SIGNAL time_S : STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000"; --! Temporary signal for translating the microblaze input to the correct interval for each wavetype and then sent to a counter
SIGNAL count_L : STD_LOGIC_VECTOR(11 downto 0):="000000000000"; --! Counter for sending out as LFO output
SIGNAL gain : STD_LOGIC:='0'; --! Used to select between rise or fall state
SIGNAL count : STD_LOGIC:='0'; --! Used for clock enabling a increase of count_L

BEGIN



--! Takes in parameters from MIDI and sends them to microblaze. Also takes in parameter from microblaze to set clock enable interval depending on wave type
process(clk)
BEGIN
	if(rising_edge(clk)) then
		LFO_to_micro(6 downto 0) <= LFO_frequency;
		LFO_to_micro(13 downto 7) <= LFO_depth;
        if(mode = "10") then				-- sawtooth
            time_S <= STD_LOGIC_VECTOR((unsigned(LFO_from_micro(31 downto 0))) SLL 1);
    
        else						-- triangle and square
            time_S <= LFO_from_micro(31 downto 0);
    
        end if;
        
	end if;
end process;

--! Clock enable with the interval set by microblaze
counter_LFO_comp:
COMPONENT counter_LFO
         PORT MAP(clk=>clk,
         sample_clk => '1',
	 	  count_max => time_S,
		  count_duty => "00000000000000000000000000000001", 
		  clk_out => count); 

--! Calculates the output depending on how many clock enables have come from the counter component and what mode has been chosen
process(clk)
BEGIN
	if(rising_edge(clk)) then   
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
end process;

end arch;




