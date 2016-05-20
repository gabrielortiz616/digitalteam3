-------------------------------------------------------
--! @file
--! @brief Receives data from the MIDI interface and organize it to control the different parameters in the system
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! The inputs come from the MIDI interface and are organized into different signals for controlling the system parameters
entity MIDI_par is
		Port ( 
				clk : in  STD_LOGIC; --! Clock
				midi_in   : in  std_logic; --! MIDI In
				Q_value, cut_off, LFO_max, LFO_freq, time_sustain,
				time_release, time_attack, osc_offset, duty_cycle :
				OUT STD_LOGIC_VECTOR(6 downto 0); --! Parameters to be modified
				midi_ch   : out std_logic_vector(3 downto 0); --! MIDI Channel
				note_on : OUT STD_LOGIC; --! Note ON signal
                pitch_on_out   : out  std_logic; --! Pitch ON				
				midi_pitch : OUT STD_LOGIC_VECTOR(6 downto 0); --! Pitch bend rotation value                
				midi_note : OUT STD_LOGIC_VECTOR(7 downto 0) --! MIDI Note Number
				);
end MIDI_par;


--! Receives data from the MIDI interface and organize it to control the different parameters in the system
architecture arch of MIDI_par is



COMPONENT midi is port   
( 
       CLK: IN STD_LOGIC;
       midi_in   : in  std_logic;
       note_on_out   : out  std_logic;
       pitch_on_out   : out  std_logic; 
       midi_ch   : out std_logic_vector(3 downto 0);
       midi_control   : out std_logic_vector(6 downto 0);
       midi_control_data   : out std_logic_vector(6 downto 0);
       midi_pitch : OUT STD_LOGIC_VECTOR(6 downto 0); 
       midi_note_out : out  std_logic_vector(7 downto 0)
       );
end COMPONENT;

SIGNAL midi_control_temp : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL midi_control_data_temp : STD_LOGIC_VECTOR(6 downto 0);

BEGIN



midi1 : midi   
        port map( 
               CLK => clk,
               midi_in => midi_in,
               midi_ch => midi_ch,
               midi_control => midi_control_temp,
               midi_control_data => midi_control_data_temp,
               note_on_out => note_on,
               pitch_on_out => pitch_on_out,             
               midi_pitch => midi_pitch,
               midi_note_out => midi_note
               );




process(clk)
BEGIN
	IF(rising_edge(clk)) then
--		IF(midi_control_temp = "XXXXXX") then -- setting keyboad note
--			midi_note <= midi_note_temp;
		IF(midi_control_temp = "1000111") then  --! Controls the Duty Cycle of the Oscillators -- CHANNEL 10
     		duty_cycle <= midi_control_data_temp;

		ELSIF(midi_control_temp = "1001010") then  --! Controls the Offset of the second oscillator -- CHANNEL 9
			osc_offset <= midi_control_data_temp;

		ELSIF(midi_control_temp = "1010011") then --! setting time_sustain -- Channel 1
			time_sustain <= midi_control_data_temp;

		ELSIF(midi_control_temp = "0011100") then --! setting time_release -- Channel 2
			time_release <= midi_control_data_temp;

		ELSIF(midi_control_temp = "1010010") then --! setting time_attack --  Channel 3
			time_attack <= midi_control_data_temp;

		ELSIF(midi_control_temp = "1010001") then --! setting LFO frequency -- CHANNEL 11
			LFO_freq <= midi_control_data_temp;

		ELSIF(midi_control_temp = "1011011") then --! setting LFO Amplitude -- CHANNEL 12
			LFO_max <= midi_control_data_temp;

		ELSIF(midi_control_temp = "0011101") then -- setting cut-off -- CHANNEL 4
			cut_off <= midi_control_data_temp;

		ELSIF(midi_control_temp = "0010000") then -- setting resonance -- CHANNEL 5
			Q_value <= midi_control_data_temp;
		END IF;
	END IF;
END PROCESS;

end arch;






