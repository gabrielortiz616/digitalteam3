-------------------------------------------------------
--! @file
--! @brief MAIN ENTITY
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

--! Description of top entity Entity
ENTITY TOP_Entity is
    GENERIC(N:INTEGER:=4);
    PORT(clk : IN STD_LOGIC; --! Clock (100 MHz)	
        RESET : IN STD_LOGIC; --! Reset by dip switch on AC701		   
        midi_in : in STD_LOGIC; --! Input signal from MIDI keyboard		   
        from_micro_reg0 : IN STD_LOGIC_VECTOR(7 downto 0); --! User Interface "What should be change", example: Oscillator Wave type
        from_micro_reg1 : IN STD_LOGIC_VECTOR(7 downto 0); --! Parameter to be change, example: Sine
        to_micro_reg2 : OUT STD_LOGIC_VECTOR(31 downto 0); --! Offset and Duty cycle values for LCD display
        from_micro_reg3 : IN STD_LOGIC_VECTOR(31 downto 0); --! LP a coefficients input from microblaze
        from_micro_reg4 : IN STD_LOGIC_VECTOR(31 downto 0); --! LP b coefficients input from microblaze
        to_micro_reg5 : OUT STD_LOGIC_VECTOR(31 downto 0);  --! LP cut-off frequency and quality factor output to microblaze
        from_micro_reg6 : IN STD_LOGIC_VECTOR(31 downto 0); --! HP a coefficients input from microblaze
        from_micro_reg7 : IN STD_LOGIC_VECTOR(31 downto 0); --! HP b coefficients input from microblaze
        to_micro_reg8 : OUT STD_LOGIC_VECTOR(31 downto 0);  --! HP cut-off frequency and quality factor output to microblaze
        from_micro_reg9 : IN STD_LOGIC_VECTOR(31 downto 0); --! Supposed to be used for bandpass
        from_micro_reg10 : IN STD_LOGIC_VECTOR(31 downto 0); --! Supposed to be used for bandpass
        to_micro_reg11 : OUT STD_LOGIC_VECTOR(31 downto 0); --! Supposed to be used for bandpass
        from_micro_reg12 : IN STD_LOGIC_VECTOR(31 downto 0); --! Input time for clock enable component inside LFO from microblaze
        to_micro_reg13 : OUT STD_LOGIC_VECTOR(31 downto 0);  --! Output amplitude and frequency for LFO to microblaze
        to_micro_reg14 : OUT STD_LOGIC_VECTOR(31 downto 0); 
        I2S : out STD_LOGIC_VECTOR(3 downto 0);
--		WS_out : J3 4
--	    SD_out : J3 6
--	    I2S_clk : J3 8
--	    I2S_right : J3 10
        ADC_SPI : out STD_LOGIC_VECTOR(2 downto 0); --12 14 16 
        ADC_SPI_IN : in STD_LOGIC; -- J3 18
        SPI : out STD_LOGIC_VECTOR(3 downto 0)); -- Connected to DAC on the AC701 Board
END TOP_Entity;


--! Description of Top-entity Architecture
ARCHITECTURE arch_TOP_Entity OF TOP_Entity IS
SIGNAL sample_clk_temp : STD_LOGIC;
SIGNAL sclk_en_temp : STD_LOGIC;
SIGNAL clk_spi_temp : STD_LOGIC;
SIGNAL midi_note : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL wave_type1 : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL wave_type2 : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL note_on_temp : STD_LOGIC;
SIGNAL midi_pitch_temp, pitch_temp : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL rate_temp : STD_LOGIC;
SIGNAL duty_cycle_temp1 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000010"; 
SIGNAL pitch_on_out_temp : STD_LOGIC;
SIGNAL midi_pitch_on_out_temp :STD_LOGIC;
SIGNAL duty_cycle_temp2 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000010"; 
SIGNAL duty_cycle_midi : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL offset_temp : STD_LOGIC_VECTOR(6 DOWNTO 0);  
SIGNAL offset_midi : STD_LOGIC_VECTOR(6 DOWNTO 0);  
SIGNAL osc_out_temp1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL osc_out_temp2 : STD_LOGIC_VECTOR(11 DOWNTO 0);

SIGNAL offset_int_temp : STD_LOGIC_VECTOR(4 DOWNTO 0); 
SIGNAL duty_int_temp : STD_LOGIC_VECTOR(6 DOWNTO 0); 
SIGNAL offset_int_temp_prev : STD_LOGIC_VECTOR(4 DOWNTO 0); 
SIGNAL duty_int_temp_prev : STD_LOGIC_VECTOR(6 DOWNTO 0);  
SIGNAL lfo_out_temp : STD_LOGIC_VECTOR(6 DOWNTO 0); --! Temporary for LFO output
SIGNAL lfo_mode_temp : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Controls which wavetype LFO should use
SIGNAL offset_null : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL filter_mode_temp : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Controls if cut-off frequency should be controlled by LFO or MIDI


--ADC OUTPUT---
SIGNAL adc_data_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);


SIGNAL FWave_temp : STD_LOGIC_VECTOR(11 downto 0); --! Temporary filtered output
SIGNAL FWave_temp_LP : STD_LOGIC_VECTOR(11 downto 0); --! Temporary filtered output from lowpass
SIGNAL FWave_temp_HP : STD_LOGIC_VECTOR(11 downto 0); --! Temporary filtered output from highpass
SIGNAL EWave_temp : STD_LOGIC_VECTOR(11 downto 0); --! Temporary enveloped wave
SIGNAL Wave_OUT_temp : STD_LOGIC_VECTOR(11 downto 0); --! Temporary output to DAC or I2S
SIGNAL Q_temp : STD_LOGIC_VECTOR(6 downto 0); --! Temporary for quality factor in filters
SIGNAL time_sustain_temp  : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for time of the sustain stage in envelope
SIGNAL time_release_temp  : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for time for release stage in envelope
SIGNAL time_attack_temp  : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for time for attack stage in envelope
SIGNAL cut_off_temp  : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for cut-off frequency in filters
SIGNAL LFO_max_temp  : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for LFO amplitude
SIGNAL LFO_freq_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for LFO frquency
SIGNAL time_echo_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000"; --! Temporary for delay for echo and reverb
SIGNAL midi_ch_temp : std_logic_vector(3 downto 0);


SIGNAL output_temp : STD_LOGIC_VECTOR(23 downto 0); --! Signal going to DAC

-- FLAGS for GUI----
SIGNAL flag_duty_cycle1 : STD_LOGIC; --! Flag for chosing between LFO and MIDI for controlling duty cycle of oscillator 1
SIGNAL flag_duty_cycle2 : STD_LOGIC; --! Flag for chosing between LFO and MIDI for controlling duty cycle of oscillator 2
SIGNAL flag_offset : STD_LOGIC; --! Flag for chosing between LFO and MIDI for controlling offset of oscillator 2
SIGNAL flag_out : STD_LOGIC_VECTOR(2 downto 0); --! Flag for chosing between parameter to change
SIGNAL flag_filter_mode : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Flag for chosing between LFO and MIDI for controlling cut-off frequency of filters
SIGNAL flag_filter_type : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Flag for chosing between HP, LP or no filter at all
SIGNAL flag_lfo_type : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Flag for chosing between wave type of LFO
SIGNAL flag_effect_type : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Flag for chosing which effect should be activated



-----------------echo signal
signal comb_output1:std_logic_vector(11 downto 0); --! Temporary for amount of delay (1/10 of total delay)
signal comb_output2:std_logic_vector(11 downto 0); --! Temporary for amount of delay (2/10 of total delay)
signal comb_output3:std_logic_vector(11 downto 0); --! Temporary for amount of delay (3/10 of total delay)
signal comb_output4:std_logic_vector(11 downto 0); --! Temporary for amount of delay (4/10 of total delay)
signal comb_output5:std_logic_vector(11 downto 0); --! Temporary for amount of delay (5/10 of total delay)
signal comb_output6:std_logic_vector(11 downto 0); --! Temporary for amount of delay (6/10 of total delay)
signal comb_output7:std_logic_vector(11 downto 0); --! Temporary for amount of delay (7/10 of total delay)
signal comb_output8:std_logic_vector(11 downto 0); --! Temporary for amount of delay (8/10 of total delay)
signal comb_output9:std_logic_vector(11 downto 0); --! Temporary for amount of delay (9/10 of total delay)
signal comb_output10:std_logic_vector(11 downto 0); --! Temporary for amount of delay (10/10 of total delay)
signal echo_temp :std_logic_vector(11 downto 0); --! Temporary for echo output
signal reverb_temp:std_logic_vector(11 downto 0); --! Temporary for reverb output
---------------------------------------------------

-----COMPONENTS DEFINITION----------
--! Component clock enable
COMPONENT clk_enable IS
	PORT(clk : IN STD_LOGIC;
      sample_clk : OUT STD_LOGIC;
      sclk : OUT STD_LOGIC;
      sclk_en : OUT STD_LOGIC);
END COMPONENT;

--! Component midi
COMPONENT midi is 
	port(clk: IN STD_LOGIC;
       midi_in   : in  std_logic;
       note_on_out   : out  std_logic;
       midi_ch   : out std_logic_vector(3 downto 0);
       midi_control   : out std_logic_vector(6 downto 0);
       midi_control_data   : out std_logic_vector(6 downto 0);
       midi_note_out : out  std_logic_vector(7 downto 0)
       );
end COMPONENT;

--! Component OSC Main
COMPONENT OSC_Main
	PORT(midi_note:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		wave_type:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		duty_cycle:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		offset:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0);  
		duty_integer_out : out STD_LOGIC_VECTOR (6 downto 0);         
		clk : IN STD_LOGIC;
		midi_pitch:IN STD_LOGIC_VECTOR(6 DOWNTO 0);           
		pitch_on_in   : in  std_logic;     
		sample_clk : IN STD_LOGIC;
		reset:IN STD_LOGIC;
		oscout:OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END COMPONENT;

--! Component LFO
COMPONENT LFO
	Port ( 
		clk, sample_clk : in  STD_LOGIC;
		LFO : OUT STD_LOGIC_VECTOR(6 downto 0);
		LFO_depth : IN STD_LOGIC_VECTOR(6 downto 0);
		LFO_frequency : in STD_LOGIC_VECTOR(6 downto 0);
		mode : IN STD_LOGIC_VECTOR(1 downto 0);
		LFO_from_micro : in STD_LOGIC_VECTOR(31 downto 0);
		LFO_to_micro : out STD_LOGIC_VECTOR(31 downto 0)
		);
end COMPONENT;

--! Component DAC
COMPONENT DAC
	PORT(CLK : IN STD_LOGIC;
	   data  : IN STD_LOGIC_VECTOR(23 downto 0);
	   sclk_en : IN STD_LOGIC;
	   DIN  : OUT STD_LOGIC;
	   LDAC : OUT STD_LOGIC;
	   CS : OUT STD_LOGIC);
END COMPONENT DAC;

--! Component Envelope
COMPONENT envelope
	port(
		clk : IN STD_LOGIC;
		sample_clk : IN STD_LOGIC;
		time_sustain : IN STD_LOGIC_VECTOR(6 downto 0);
		time_release : IN STD_LOGIC_VECTOR(6 downto 0);
		time_attack : IN STD_LOGIC_VECTOR(6 downto 0);
		FWave : IN STD_LOGIC_VECTOR(11 downto 0);
		NOTE_ON : IN STD_LOGIC;
		EWave : OUT STD_LOGIC_VECTOR(11 downto 0));
END COMPONENT;


--! Component lowpass filter
COMPONENT biquad_ver2
	port(
		clk : in  STD_LOGIC;
		sample_clk  : in  STD_LOGIC;
		x_IN : in  STD_LOGIC_VECTOR (11 downto 0);
		LFO : in STD_LOGIC_VECTOR(6 downto 0);
		knob : IN STD_LOGIC_VECTOR(6 downto 0);
		Q_in : in STD_LOGIC_VECTOR(6 downto 0);
		mode : IN STD_LOGIC_VECTOR(1 downto 0);
		FWave : out  STD_LOGIC_VECTOR (11 downto 0);
		Filter_from_microA : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_from_microB : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_to_micro : out STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;

--! Component highpass filter
COMPONENT highpass
	port(
		clk : in  STD_LOGIC;
		sample_clk  : in  STD_LOGIC;
		x_IN : in  STD_LOGIC_VECTOR (11 downto 0);
		LFO : in STD_LOGIC_VECTOR(6 downto 0);
		knob : IN STD_LOGIC_VECTOR(6 downto 0);
		Q_in : in STD_LOGIC_VECTOR(6 downto 0);
		mode : IN STD_LOGIC_VECTOR(1 downto 0);
		FWave : out  STD_LOGIC_VECTOR (11 downto 0);
		Filter_from_microA_HP : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_from_microB_HP : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_to_micro_HP : out STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;

--! Component bandpass filter (not functional)
COMPONENT bandpass
	port(
		clk : in  STD_LOGIC;
		sample_clk  : in  STD_LOGIC;
		x_IN : in  STD_LOGIC_VECTOR (11 downto 0);
		LFO : in STD_LOGIC_VECTOR(6 downto 0);
		knob : IN STD_LOGIC_VECTOR(6 downto 0);
		Q_in : in STD_LOGIC_VECTOR(6 downto 0);
		mode : IN STD_LOGIC_VECTOR(1 downto 0);
		FWave : out  STD_LOGIC_VECTOR (11 downto 0);
		Filter_from_microA_BP : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_from_microB_BP : in STD_LOGIC_VECTOR(31 downto 0);
		Filter_to_micro_BP : out STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;

--! Component MIDI control
COMPONENT MIDI_par is
	Port ( 
		clk : in  STD_LOGIC;
		midi_in   : in  std_logic;
		Q_value, cut_off, LFO_max, LFO_freq, time_sustain,
		time_release, time_attack, osc_offset, duty_cycle, time_echo :
		OUT STD_LOGIC_VECTOR(6 downto 0);
		midi_ch   : out std_logic_vector(3 downto 0);
		note_on : OUT STD_LOGIC;
		pitch_on_out   : out  std_logic;	 
		midi_pitch : OUT STD_LOGIC_VECTOR(6 downto 0);             
		midi_note : OUT STD_LOGIC_VECTOR(7 downto 0)
		);
end COMPONENT;

--! Component ADC
COMPONENT ADC_interface IS
	PORT(clk : IN STD_LOGIC;
		sample_clock : IN STD_LOGIC;
		sclk_in : IN STD_LOGIC;
		sclk_en : IN STD_LOGIC;
		miso : IN STD_LOGIC;
		sclk_out : OUT STD_LOGIC; 
		mosi : OUT STD_LOGIC;
		cs: OUT STD_LOGIC;
		data_to_dac : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END COMPONENT;

--! Component I2S
COMPONENT IIS_master is
	generic(N: integer := 12); -- Number of registers used.
	port(
		clk, reset: IN STD_LOGIC;
		parallel_right_data, parallel_left_data: IN STD_LOGIC_VECTOR (0 to N-1);             -- Left and right channel data
		serial_clk_out, word_select, serial_data, right_channel_indicator: OUT STD_LOGIC
	);
end COMPONENT;


--! Component Delayer
COMPONENT comb_filter is
			Generic(	WIDTH_filter:INTEGER:=12;
                 Taps:INTEGER:=3;
        WIDTH_LFO: INTEGER :=12);
    port(
                    clk : in  STD_LOGIC;
                    time_echo : in STD_LOGIC_VECTOR(6 downto 0);
                    x_IN : in  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0);
                    FWave : out  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0)
    );
end COMPONENT;

--! Component echo
COMPONENT echo_added is
    port(

        source: IN STD_LOGIC_VECTOR (11 downto 0);
        echo: IN STD_LOGIC_VECTOR (11 downto 0);            
        Fwave: OUT STD_LOGIC_VECTOR (11 downto 0)
    );
end COMPONENT;

--! Component Reverb
COMPONENT signal_added is
    port(

        input_1 : IN  std_logic_vector(11 downto 0);
        input_2:IN std_logic_vector(11 downto 0);
        input_3:IN std_logic_vector(11 downto 0);
        input_4:IN std_logic_vector(11 downto 0);
        input_5:IN std_logic_vector(11 downto 0);
        clk : IN STD_LOGIC;
        effect_out : OUT std_logic_vector(11 downto 0)
    );
end COMPONENT;

-----END COMPONENTS DEFINITION----------


BEGIN

--! Takes in signals from the user interface to execute them.
UserInterface :
PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
    IF from_micro_reg0= "00000001" THEN -- CHANGE WAVE TYPE OSCILLATOR 1
        wave_type1 <= from_micro_reg1(2 downto 0);
    ELSIF from_micro_reg0= "00000010"  THEN -- CHANGE WAVE TYPE OSCILLATOR 2
        wave_type2 <= from_micro_reg1(2 downto 0);
    ELSIF from_micro_reg0= "00000011"  THEN -- MIDI or LFO on Duty Cycle OSCILLATOR 1
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_duty_cycle1 <= '0';  --duty_cycle_temp <= duty_cycle_midi;
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_duty_cycle1 <= '1';  --duty_cycle_temp <= lfo_out_temp(6 downto 0);
        END IF;
    ELSIF from_micro_reg0= "00000100"  THEN -- MIDI or LFO on Duty Cycle OSCILLATOR 2
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_duty_cycle2 <= '0'; --duty_cycle_temp2 <= duty_cycle_midi;
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_duty_cycle2 <= '1'; --duty_cycle_temp2 <= lfo_out_temp(6 downto 0);
        END IF;
    ELSIF from_micro_reg0= "00000101"  THEN -- MIDI or LFO on Offset OSCILLATOR 2
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_offset <= '0'; --offset_temp <= offset_midi;
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_offset <= '1';  --offset_temp <= lfo_out_temp(6 downto 0);
        END IF; 
    ELSIF from_micro_reg0= "00000110"  THEN -- OUTPUT SELEC: ADD, OSC1, OSC2....
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_out <= "000"; --output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & osc_out_temp(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_out <= "001";   --output_temp(23 downto 12) <= osc_out_temp;
        ELSIF from_micro_reg1(2 downto 0) = "010" THEN 
            flag_out <= "010";   --output_temp(23 downto 12) <= osc_out_temp2;
        ELSIF from_micro_reg1(2 downto 0) = "011" THEN 
            flag_out <= "011";   --output_temp(23 downto 12) <= LFO;     
        ELSIF from_micro_reg1(2 downto 0) = "100" THEN 
            flag_out <= "100";   --output_temp(23 downto 12) <= ADC;  
        ELSIF from_micro_reg1(2 downto 0) = "101" THEN 
            flag_out <= "101";   --output_temp(23 downto 12) <= ADC+OSC2;                                        
        END IF; 
    ELSIF from_micro_reg0= "00000111"  THEN -- MIDI or LFO on Filter Cutoff frequency
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_filter_mode <= "00" ; --filter cutoff midi
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_filter_mode <= "01" ;  -- filter cutoff LFO
        END IF;
    ELSIF from_micro_reg0= "00001000"  THEN -- Filter Type
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_filter_type <= "00" ; -- Lowpass
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_filter_type <= "01" ;  -- Highpass
        ELSIF from_micro_reg1(2 downto 0) = "010" THEN 
            flag_filter_type <= "10" ;  -- None    
        END IF;
    ELSIF from_micro_reg0= "00001001"  THEN -- LFO Wavetype
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_lfo_type <= "00" ; -- Triangle
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_lfo_type <= "01" ;  -- Square
        ELSIF from_micro_reg1(2 downto 0) = "010" THEN 
                flag_lfo_type <= "10" ;  -- Sawtooth
        END IF; 
        
    ELSIF from_micro_reg0= "00001010"  THEN -- Effects
        IF from_micro_reg1(2 downto 0) = "000" THEN 
            flag_effect_type <= "00" ; -- None
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_effect_type <= "01" ;  -- Echo
        ELSIF from_micro_reg1(2 downto 0) = "010" THEN 
                flag_effect_type <= "10" ;  -- Reverb
        ELSIF from_micro_reg1(2 downto 0) = "011" THEN
                flag_effect_type <= "11" ; -- Vibrato
        END IF;      
                            		
    END IF;
    
    ------FLAGS ASSESMENT------
    IF flag_duty_cycle1 = '1' THEN 
         duty_cycle_temp1 <= lfo_out_temp;           
    ELSE
         duty_cycle_temp1 <= duty_cycle_midi;
    END IF;
    IF flag_duty_cycle2 = '1' THEN 
        duty_cycle_temp2 <= lfo_out_temp;        
    ELSE
        duty_cycle_temp2 <= duty_cycle_midi;
    END IF;  
    IF flag_offset = '1' THEN 
        offset_temp <= lfo_out_temp;
    ELSE
        offset_temp <= offset_midi;
    END IF; 
    IF flag_out = "001" THEN 
        output_temp(23 downto 12) <= osc_out_temp1;        
    ELSIF flag_out = "010" THEN 
        output_temp(23 downto 12) <= osc_out_temp2;  
    ELSIF flag_out = "011" THEN 
        output_temp(23 downto 12) <= lfo_out_temp & "00000";    
    ELSIF flag_out = "100" THEN 
        output_temp(23 downto 12) <= adc_data_temp; 
    ELSIF flag_out = "101" THEN         output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & adc_data_temp(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));                           
    ELSE
        output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & osc_out_temp1(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));   
    END IF;    
    IF flag_filter_mode = "01" THEN 
        filter_mode_temp <= "01";
    ELSE
        filter_mode_temp <= "00";
    END IF; 
    IF flag_filter_type = "01" THEN 
        FWave_temp <= FWave_temp_HP;
    ELSIF flag_filter_type = "10" THEN
        FWave_temp <= STD_LOGIC_VECTOR(unsigned(output_temp(23 downto 12))-2048);
    ELSE
        FWave_temp <= FWave_temp_LP; 
    END IF; 
    IF flag_lfo_type = "01" THEN 
        lfo_mode_temp <= "01";
    ELSIF flag_lfo_type = "10" THEN
       lfo_mode_temp <= "10"; 
    ELSE
        lfo_mode_temp <= "00";
    END IF; 
    
    IF flag_effect_type = "01" THEN 
            Wave_OUT_temp <= echo_temp; 
            pitch_temp <= midi_pitch_temp; 
            pitch_on_out_temp <= midi_pitch_on_out_temp;
        ELSIF flag_effect_type = "10" THEN
           Wave_OUT_temp <= reverb_temp;
           pitch_temp <= midi_pitch_temp;
           pitch_on_out_temp <= midi_pitch_on_out_temp;
        ELSIF flag_effect_type = "11" THEN
            pitch_temp <= lfo_out_temp;
            pitch_on_out_temp <= '1';
            Wave_OUT_temp <= EWave_temp; 
        ELSE
            pitch_temp <= midi_pitch_temp;
            pitch_on_out_temp <= midi_pitch_on_out_temp;
            Wave_OUT_temp <= EWave_temp;
    END IF; 

	IF offset_int_temp /= offset_int_temp_prev THEN
		to_micro_reg2 <= "000000000000000000000000000" & offset_int_temp;
		offset_int_temp_prev <= offset_int_temp;
	ELSIF duty_int_temp /= duty_int_temp_prev THEN
		to_micro_reg2 <= "1000000000000000000000000" & duty_int_temp;
		duty_int_temp_prev <= duty_int_temp;
	END IF;    
		
END IF;
END PROCESS;


clk_enable1 : clk_enable
   port map(
		clk => clk,
		sclk => clk_spi_temp,
		sclk_en => sclk_en_temp,
		sample_clk => sample_clk_temp);

SPI(0) <= clk_spi_temp;

--! Translates the MIDI control message to send the MIDI data message to a variable depending on its value
MIDI_par_comp : MIDI_par
	Port map( 
		clk => clk,
		midi_in => midi_in,
	    midi_note => midi_note,
	    time_sustain => time_sustain_temp,
        time_release => time_release_temp,
        time_attack => time_attack_temp,
        cut_off => cut_off_temp,
        LFO_max => LFO_max_temp,
        LFO_freq => LFO_freq_temp,
        Q_value => Q_temp,
        osc_offset => offset_midi,
        duty_cycle => duty_cycle_midi,
        midi_ch => midi_ch_temp,
        note_on => note_on_temp,
        pitch_on_out => midi_pitch_on_out_temp,
        time_echo => time_echo_temp,
        midi_pitch => midi_pitch_temp    
        );


OSC_Main1 : OSC_Main
	port map(midi_note => midi_note,
		     wave_type => wave_type1,
             duty_cycle => duty_cycle_temp1,
             offset => "1000000",
             offset_integer_out => offset_null,
             clk => clk,
             midi_pitch => pitch_temp,    
             pitch_on_in => pitch_on_out_temp,   
             sample_clk => sample_clk_temp,
		     reset => RESET,
             oscout => osc_out_temp1);

OSC_Main2 : OSC_Main
	port map(midi_note => midi_note,
		    wave_type => wave_type2,
            duty_cycle => duty_cycle_temp2,
            offset => offset_temp,
            offset_integer_out => offset_int_temp,
            duty_integer_out => duty_int_temp,
            clk => clk,
             midi_pitch => pitch_temp,    
            pitch_on_in => pitch_on_out_temp,    
            sample_clk => sample_clk_temp,
		    reset => RESET,
            oscout => osc_out_temp2);


--! Generates the waveform for LFO
LFO1 : LFO
 port map (clk => clk,
           sample_clk => sample_clk_temp, 
           mode => lfo_mode_temp,
           LFO_depth => LFO_max_temp,
           LFO_frequency => LFO_freq_temp,
           LFO_to_micro => to_micro_reg13,
           LFO_from_micro => from_micro_reg12,
	       LFO=> lfo_out_temp);

--! Lowpass filter
biquad_ver2_comp1:biquad_ver2
port map( 	clk => clk,
        sample_clk => sample_clk_temp,
	  	x_IN =>  output_temp(23 downto 12),
		LFO => lfo_out_temp,
		knob => cut_off_temp,
		Q_in => Q_temp,
		mode => filter_mode_temp,
	    FWave => FWave_temp_LP,
		Filter_from_microA => from_micro_reg3,
		Filter_from_microB => from_micro_reg4,
	    Filter_to_micro => to_micro_reg5);
	
--! Highpass filter 
highpass_comp:highpass
port map(     clk => clk,
		sample_clk => sample_clk_temp,
		  x_IN =>  output_temp(23 downto 12),
		LFO => lfo_out_temp,
		knob => cut_off_temp,
		Q_in => Q_temp,
		mode => filter_mode_temp,
		FWave => FWave_temp_HP,
		Filter_from_microA_HP => from_micro_reg6,
		Filter_from_microB_HP => from_micro_reg7,
		Filter_to_micro_HP => to_micro_reg8);
       
--! Envelope, scales the voltage of the input to it depending on the stage and the time it spent on it
envelope_comp1: envelope
  port map(
		clk => clk,
		sample_clk => sample_clk_temp,
		time_sustain => time_sustain_temp,
		time_release => time_release_temp,
		time_attack => time_attack_temp,
		FWave => FWave_temp,
		NOTE_ON => note_on_temp,
	    EWave => EWave_temp);
	    
--! Delays the input to it depending on time_echo (1/10 of total delay)	    
comb_effect_1: comb_filter
        port map(
                clk=>sample_clk_temp,
                x_IN=>EWave_temp,
                time_echo => time_echo_temp,
                FWave=>comb_output1);
--! Delays the input to it depending on time_echo (2/10 of total delay)  
        comb_effect_2: comb_filter
                port map(
                        clk=>sample_clk_temp,
                        x_IN=>comb_output1,
                        time_echo => time_echo_temp,
                        FWave=>comb_output2);
--! Delays the input to it depending on time_echo (3/10 of total delay)        
        comb_effect_3: comb_filter
        port map(
                clk=>sample_clk_temp,
                x_IN=>comb_output2,
                time_echo => time_echo_temp,
                FWave=>comb_output3);
--! Delays the input to it depending on time_echo (4/10 of total delay)         
        comb_effect_4: comb_filter
                port map(
                        clk=>sample_clk_temp,
                        x_IN=>comb_output3,
                        time_echo => time_echo_temp,
                        FWave=>comb_output4);
--! Delays the input to it depending on time_echo (5/10 of total delay)                        
        comb_effect_5: comb_filter
                                port map(
                                        clk=>sample_clk_temp,
                                        x_IN=>comb_output4,
                                        time_echo => time_echo_temp,
                                        FWave=>comb_output5);
--! Delays the input to it depending on time_echo (6/10 of total delay)        
        comb_effect_6: comb_filter
        port map(
                clk=>sample_clk_temp,
                x_IN=>comb_output5,
                time_echo => time_echo_temp,
                FWave=>comb_output6);
--! Delays the input to it depending on time_echo (7/10 of total delay)         
        comb_effect_7: comb_filter
                port map(
                        clk=>sample_clk_temp,
                        x_IN=>comb_output6,
                        time_echo => time_echo_temp,
                        FWave=>comb_output7);
--! Delays the input to it depending on time_echo (8/10 of total delay)        
        comb_effect_8: comb_filter
        port map(
                clk=>sample_clk_temp,
                x_IN=>comb_output7,
                time_echo => time_echo_temp,
                FWave=>comb_output8);
--! Delays the input to it depending on time_echo (9/10 of total delay)         
        comb_effect_9: comb_filter
                port map(
                        clk=>sample_clk_temp,
                        x_IN=>comb_output8,
                        time_echo => time_echo_temp,
                        FWave=>comb_output9);
--! Delays the input to it depending on time_echo (Full delay)                        
        comb_effect_10: comb_filter
                                port map(
                                        clk=>sample_clk_temp,
                                        x_IN=>comb_output9,
                                        time_echo => time_echo_temp,
                                        FWave=>comb_output10);
--! Sums up enveloped waveform and full delayed waveform
        echo: echo_added                 
         port map(
                            source=>EWave_temp,
                           echo=>comb_output10,
                          FWave=>echo_temp);
--! Sums up enveloped waveform, 2/10 delayed, 4/10 delayed, 6/10 delayed and 8/10 delayed waveform                                                                      
        several_echoes: signal_added           
         port map(
                                  input_1=>EWave_temp,
                                  clk => clk,
                                   input_2=>comb_output2,
                                   input_3=>comb_output4,
                                   input_4=>comb_output6,
                                   input_5=>comb_output8,
                                  effect_out=>reverb_temp);

--! Sends out Wave_OUT_temp to channel 1 on DAC
output_temp(11 downto 0) <= Wave_OUT_temp;

--! DAC
DAC1 : DAC
    port map(CLK => clk,
             sclk_en => sclk_en_temp,
             data  => output_temp,       
             DIN  => SPI(1),
             LDAC => SPI(2),
             CS => SPI(3));

--! ADC
ADC_interface_comp: ADC_interface 
PORT MAP(clk => clk,
       sample_clock => sample_clk_temp,
       sclk_in => clk_spi_temp,
       sclk_en => sclk_en_temp,
       miso => ADC_SPI_IN,
       sclk_out => ADC_SPI(1),
       mosi => ADC_SPI(2),
       cs => ADC_SPI(0),
       data_to_dac => adc_data_temp);

--! I2S
IIS_master1 : IIS_master
 port map(
	    parallel_right_data => output_temp(23 downto 12),
	    parallel_left_data => output_temp(23 downto 12),
        word_select=>I2S(0), 
        reset => RESET, 
        clk => clk,
        serial_clk_out => I2S(2),
        right_channel_indicator => I2S(3),     
        serial_data=> I2S(1));	
		
END arch_TOP_Entity;
