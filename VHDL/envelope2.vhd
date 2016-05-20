LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity envelope is
		Generic(WIDTH_wave: INTEGER :=12);
		Port ( 
				clk : in  STD_LOGIC;
				sample_clk : in  STD_LOGIC;
				FWave : in  STD_LOGIC_VECTOR (WIDTH_wave-1 downto 0);
				time_release, time_attack, time_sustain : in STD_LOGIC_VECTOR(6 downto 0);
	  			NOTE_ON: IN STD_LOGIC;
				attack_debug : OUT STD_LOGIC;
				EWave: out  STD_LOGIC_VECTOR (WIDTH_wave-1 downto 0)
				);
end envelope;



architecture arch of envelope is


COMPONENT counter IS
      PORT(clk:IN STD_LOGIC;
      	   sample_clk : in  STD_LOGIC;
           count_max: IN STD_LOGIC_VECTOR(11 downto 0);
	   count_duty: IN STD_LOGIC_VECTOR(11 downto 0);
	   clk_out: OUT STD_LOGIC);
END COMPONENT counter;

-- Should take in the filtered waves and scale the amplitude of each by X 
-- Where X is a factor of 0% to 100% and is increased from 0 to 100 during the 
-- attack time. and then is held at 100% for the sustain time and then go from
-- 100 to 0 during the release time.
SIGNAL count_S, countS_S, countA_S: INTEGER := 0;
SIGNAL timeA_S, timeR_S, timeS_S: STD_LOGIC_VECTOR(11 downto 0);
SIGNAL countR_S : INTEGER := 63;
SIGNAL countA,countR,attack,sustain,release, countS : STD_LOGIC:='0';
SIGNAL idle : STD_LOGIC:='1';
SIGNAL max : INTEGER;
SIGNAL time_attack_temp, time_sustain_temp, time_release_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000";
BEGIN

counter_attack_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
         sample_clk => sample_clk,
	 	  count_max => timeA_S,
		  count_duty => "000000000001",
		  clk_out => countA);
-- 1 second we want this one to trigger every 3,125,000 cycles

counter_sustain_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
         sample_clk => sample_clk,
	 	  count_max => timeS_S,
		  count_duty => "000000000001",
		  clk_out => countS);

counter_release_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
          sample_clk => sample_clk,
	 	  count_max => timeR_S,
		  count_duty => "000000000001",
		  clk_out => countR);
-- 1 second we want this one to trigger every 64/25 * 3,125,000



max <= 64;

process(clk)
BEGIN
	if(rising_edge(clk)) then
	timeA_S <= "00000" & time_attack;	
    	timeS_S <= "00000" & time_sustain;    
    	timeR_S <= STD_LOGIC_VECTOR(unsigned("00000" & time_release) SLL 3);    
	   if sample_clk = '1' then
		if (countA='1') then
			if(attack='1') then
				if(countA_S < 63) then
					--count_S <= countA_S + 1;
					countA_S <= countA_S + 1;
				else
					attack <= '0';	
					sustain <= '1';	
				end if;
			end if;
		end if;
		if (countS='1') then
		if (sustain='1') then
			if((countS_S < 128) or (NOTE_ON='1')) then
				countS_S <= countS_S + 1;
			else
					sustain <= '0';
					release <= '1';
			end if;
		end if;
		end if;
		if (countR='1' ) then
			if(release='1') then
				if(countR_S > 45) then
					--count_S <= countR_S - 5;
					countR_S <= countR_S - 5;	
				elsif(countR_S > 39) then 
					--count_S <= countR_S - 4;
					countR_S <= countR_S - 4;	
				elsif(countR_S > 30) then
					--count_S <= countR_S - 3;
					countR_S <= countR_S - 3;	
				elsif(countR_S > 15) then 
					--count_S <= countR_S - 2;	
					countR_S <= countR_S - 2;
				elsif(countR_S > 0) then
					--count_S <= countR_S - 1;	
					countR_S <= countR_S - 1;
				else
					release <= '0';
					idle <= '1';
				end if;	 	 		
			end if;
		end if;
		if(idle='1') then
			if(NOTE_ON = '1') then
				countS_S <= 0;
				idle <= '0';
				countR_S <= 63;	
				countA_S <= 0;
				attack <= '1';
			end if;
		end if;
		if(attack='1') then
                    EWave <= STD_LOGIC_VECTOR((signed(STD_LOGIC_VECTOR(signed(FWave(11 downto 6))*(countA_S/2))) SLL 1) + 2048);
                elsif(sustain='1') then
                    EWave <= STD_LOGIC_VECTOR(signed(FWave) + 2048);--STD_LOGIC_VECTOR(signed(FWave(11 downto 6))*64 + 2048);
                elsif(release='1') then
                    EWave <= STD_LOGIC_VECTOR((signed(STD_LOGIC_VECTOR(signed(FWave(11 downto 6))*(countR_S/2))) SLL 1) + 2048);
                else
                    EWave <= "100000000000";
         end if;

       end if;
	end if;
end process;



end arch;
