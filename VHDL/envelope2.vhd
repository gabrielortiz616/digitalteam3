-------------------------------------------------------
--! @file
--! @brief Envelope entity
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! Description of Entity
entity envelope is
		Generic(WIDTH_wave: INTEGER :=12); --! Amount of bits in the input and output
		Port ( 
				clk : in  STD_LOGIC; --! clock (100 MHz)
				sample_clk : in  STD_LOGIC; --! sample clock (40 kHz)
				FWave : in  STD_LOGIC_VECTOR (WIDTH_wave-1 downto 0); --! Input waveform to the envelope
				time_release : in STD_LOGIC_VECTOR(6 downto 0); --! Amount of time for release stage coming from MIDI interface
				time_attack : in STD_LOGIC_VECTOR(6 downto 0); --! Amount of time for attack stage coming from MIDI interface
				time_sustain : in STD_LOGIC_VECTOR(6 downto 0); --! Amount of time for sustain stage coming from MIDI interface
	  			NOTE_ON: IN STD_LOGIC; --! Note on message coming from MIDI interface
				EWave: out  STD_LOGIC_VECTOR (WIDTH_wave-1 downto 0) --! Output waveform from the envelope
				);
end envelope;


--! @brief Envelope
--! @detailed The envelope takes in an input waveform and scales the amplitude of it depending on what stage it is in. How long each stage is depends on the inputs from MIDI interface.
architecture arch of envelope is

--- Components definition ----
COMPONENT counter IS
      PORT(clk:IN STD_LOGIC; -- Clock
      	   sample_clk : in  STD_LOGIC; -- Sample clock
           count_max: IN STD_LOGIC_VECTOR(11 downto 0); -- Amount of clocks until clk_out changes to a 1
	   count_duty: IN STD_LOGIC_VECTOR(11 downto 0); -- Amount of clocks from clk_out changes to a 1 until it becomes a 0
	   clk_out: OUT STD_LOGIC); -- Clock enable output
END COMPONENT counter;

SIGNAL countS_S: INTEGER := 0; --! Counter for the sustain stage
SIGNAL countA_S: INTEGER := 0; --! Counter for the attack stage
SIGNAL countR_S : INTEGER := 63; --! Counter for the release stage
SIGNAL timeA_S: STD_LOGIC_VECTOR(11 downto 0); --! Count_max sent to counter component for attack
SIGNAL timeR_S: STD_LOGIC_VECTOR(11 downto 0); --! Count_max sent to counter component for release
SIGNAL timeS_S: STD_LOGIC_VECTOR(11 downto 0); --! Count_max sent to counter component for sustain
SIGNAL countA : STD_LOGIC:='0'; --! Clock enable from the counter component for attack
SIGNAL countR : STD_LOGIC:='0'; --! Clock enable from the counter component for release
SIGNAL countS : STD_LOGIC:='0'; --! Clock enable from the counter component for sustain
SIGNAL attack : STD_LOGIC:='0'; --! A '1' if envelope is in attack stage
SIGNAL sustain : STD_LOGIC:='0'; --! A '1' if envelope is in sustain stage
SIGNAL release : STD_LOGIC:='0'; --! A '1' if envelope is in release stage
SIGNAL idle : STD_LOGIC:='1'; --! A '1' if envelope is idle
SIGNAL time_attack_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for attack time sent from MIDI interface
SIGNAL time_sustain_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for sustain time sent from MIDI interface
SIGNAL time_release_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for release time sent from MIDI interface
BEGIN

--! Clock enable component for the attack stage
counter_attack_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
         sample_clk => sample_clk,
	 	  count_max => timeA_S,
		  count_duty => "000000000001",
		  clk_out => countA);

--! Clock enable component for sustain stage
counter_sustain_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
         sample_clk => sample_clk,
	 	  count_max => timeS_S,
		  count_duty => "000000000001",
		  clk_out => countS);

--! Clock enable component for the sustain stage
counter_release_comp:
COMPONENT counter
         PORT MAP(clk=>clk,
          sample_clk => sample_clk,
	 	  count_max => timeR_S,
		  count_duty => "000000000001",
		  clk_out => countR);
-- 1 second we want this one to trigger every 64/25 * 3,125,000


--! Scales the input voltage depending on the stage and how long it has been in that stage and sends it out. Also converts the output to oscillate around 2048 instead of 0
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
					countR_S <= countR_S - 5;	
				elsif(countR_S > 39) then 
					countR_S <= countR_S - 4;	
				elsif(countR_S > 30) then
					countR_S <= countR_S - 3;	
				elsif(countR_S > 15) then 
					countR_S <= countR_S - 2;
				elsif(countR_S > 0) then
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
                    EWave <= STD_LOGIC_VECTOR(signed(FWave) + 2048);
                elsif(release='1') then
                    EWave <= STD_LOGIC_VECTOR((signed(STD_LOGIC_VECTOR(signed(FWave(11 downto 6))*(countR_S/2))) SLL 1) + 2048);
                else
                    EWave <= "100000000000";
         end if;

       end if;
	end if;
end process;
end arch;
