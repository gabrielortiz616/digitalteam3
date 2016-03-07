LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

ENTITY TOP_Entity is
      GENERIC(N:INTEGER:=4);
      PORT(clk : IN STD_LOGIC;	
		   RESET : IN STD_LOGIC;
           from_micro_reg0 : IN STD_LOGIC_VECTOR(7 downto 0);
           from_micro_reg1 : IN STD_LOGIC_VECTOR(7 downto 0);
           to_micro : out STD_LOGIC_VECTOR(4 downto 0);
		   --LED
           LED_port : out STD_LOGIC_VECTOR(3 downto 0);
           midi_in : in STD_LOGIC;
           SPI : out STD_LOGIC_VECTOR(3 downto 0));
END TOP_Entity;

ARCHITECTURE arch_TOP_Entity OF TOP_Entity IS
SIGNAL sample_clk_temp : STD_LOGIC;
SIGNAL sclk_en_temp : STD_LOGIC;
--SIGNAL clk : STD_LOGIC;
--signal O : std_logic;
--signal I : std_logic;
--signal IB : std_logic;
SIGNAL midi_note : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL midi_note_fake : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL wave_type1 : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL wave_type2 : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL note_on_temp : STD_LOGIC;
SIGNAL rate_temp : STD_LOGIC;
SIGNAL note_ch_temp : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL midi_control_temp : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL midi_control_data_temp : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL control_temp : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL duty_cycle_temp : STD_LOGIC_VECTOR(6 DOWNTO 0); 
SIGNAL duty_cycle_temp2 : STD_LOGIC_VECTOR(6 DOWNTO 0); 
SIGNAL duty_cycle_midi : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL offset_temp : STD_LOGIC_VECTOR(6 DOWNTO 0);  
SIGNAL offset_midi : STD_LOGIC_VECTOR(6 DOWNTO 0);  
SIGNAL osc_out_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL osc_out_temp2 : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL offset_temp1 : STD_LOGIC_VECTOR(6 DOWNTO 0);  -- MISSING CONNECTION FROM MIDI
SIGNAL duty_cycle_temp1 : STD_LOGIC_VECTOR(6 DOWNTO 0); -- MISSING CONNECTION FROM MIDI

SIGNAL lfo_out_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL offset_null : STD_LOGIC_VECTOR(4 DOWNTO 0);



-- Joakim

SIGNAL oscout_temp,FWave_temp, EWave_temp, Wave_OUT_temp : STD_LOGIC_VECTOR(11 downto 0);
--SIGNAL midi_note_temp: STD_LOGIC_VECTOR(7 DOWNTO 0);
--SIGNAL wave_type_temp: STD_LOGIC_VECTOR(1 DOWNTO 0);
--SIGNAL duty_cycle_temp: STD_LOGIC_VECTOR(11 DOWNTO 0);
--SIGNAL offset_temp: STD_LOGIC_VECTOR(4 DOWNTO 0);
--SIGNAL reset, note_on_temp : STD_LOGIC;
SIGNAL Q_temp : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL time_sustain_temp, time_release_temp, time_attack_temp, cut_off_temp,
	LFO_max_temp, LFO_freq_temp, velocity_temp : STD_LOGIC_VECTOR(6 downto 0):="0100000";
SIGNAL midi_ch_temp : std_logic_vector(3 downto 0);
SIGNAL output_temp : STD_LOGIC_VECTOR(23 downto 0);


-- FLAGS for GUI----
SIGNAL flag_duty_cycle1 : STD_LOGIC;
SIGNAL flag_duty_cycle2 : STD_LOGIC;
SIGNAL flag_offset : STD_LOGIC;
SIGNAL flag_out : STD_LOGIC_VECTOR(1 downto 0);

---- Missing
--SIGNAL OE_AC701, CS_AC701 : STD_LOGIC;
--SIGNAL LFO_wave : STD_LOGIC_VECTOR(11 downto 0);

COMPONENT clk_enable IS
	PORT(clk : IN STD_LOGIC;
        sample_clk : OUT STD_LOGIC;
        sclk : OUT STD_LOGIC;
        sclk_en : OUT STD_LOGIC);
END COMPONENT;

COMPONENT midi is port   
(      CLK: IN STD_LOGIC;
       midi_in   : in  std_logic;
       note_on_out   : out  std_logic;
       midi_ch   : out std_logic_vector(3 downto 0);
       midi_control   : out std_logic_vector(6 downto 0);
       midi_control_data   : out std_logic_vector(6 downto 0);
       midi_note_out : out  std_logic_vector(7 downto 0)
       );
end COMPONENT;

--COMPONENT Controls_LUT 
-- port ( address : in std_logic_vector(6 downto 0);
--    data : out std_logic_vector(3 downto 0));
-- end COMPONENT;

COMPONENT OSC_Main
      PORT(midi_note:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		   wave_type:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
           duty_cycle:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
           offset:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0);           
           clk : IN STD_LOGIC;
           sample_clk : IN STD_LOGIC;
		   reset:IN STD_LOGIC;
           oscout:OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END COMPONENT;

COMPONENT LFO
 port(clk:in std_logic;
      sample_clk : IN STD_LOGIC;
      rate_out : out std_logic;  
      LFO_freq_main_in : in std_logic_vector(7 downto 0);
	  lfo_out : out std_logic_vector(11 downto 0));
end COMPONENT;

COMPONENT DAC
      PORT(CLK : IN STD_LOGIC;
           data  : IN STD_LOGIC_VECTOR(23 downto 0);
           sclk_en : IN STD_LOGIC;
           DIN  : OUT STD_LOGIC;
           LDAC : OUT STD_LOGIC;
           CS : OUT STD_LOGIC);
END COMPONENT DAC;

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

COMPONENT biquad_ver2
  port(
		clk, OE_AC701, CS_AC701, sample_clk : in  STD_LOGIC;
		x_IN : in  STD_LOGIC_VECTOR (11 downto 0);
		LFO : in STD_LOGIC_VECTOR(11 downto 0);
		knob : IN STD_LOGIC_VECTOR(6 downto 0);
		Q_in : in STD_LOGIC_VECTOR(6 downto 0);
		knob_active : IN STD_LOGIC;
		LFO_active : IN STD_LOGIC;
	FWave : out  STD_LOGIC_VECTOR (11 downto 0));
END COMPONENT;

COMPONENT MIDI_par is
		Port ( 
			clk : in  STD_LOGIC;
			midi_in   : in  std_logic;
            Q_value, cut_off, LFO_max, LFO_freq, time_sustain,
            time_release, time_attack, osc_offset, duty_cycle :
            OUT STD_LOGIC_VECTOR(6 downto 0);
            midi_ch   : out std_logic_vector(3 downto 0);
            note_on : OUT STD_LOGIC;
            midi_note : OUT STD_LOGIC_VECTOR(7 downto 0)
            );
end COMPONENT;


BEGIN

--midi_note <= "00111100";
--offset_temp <= "00100";
--wave_type <= GPIO_DIP_SW3 & GPIO_DIP_SW2 & GPIO_DIP_SW1;


PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
    IF from_micro_reg0= "00000001" THEN -- CHANGE WAVE TYPE OSCILLATOR 1
        wave_type1 <= from_micro_reg1(2 downto 0);
        LED_port(0)<= '1';
        LED_port(1)<= '0';
    ELSIF from_micro_reg0= "00000010"  THEN -- CHANGE WAVE TYPE OSCILLATOR 2
        wave_type2 <= from_micro_reg1(2 downto 0);
        LED_port(0)<= '0';
        LED_port(1)<= '1';
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
            flag_out <= "00"; --output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & osc_out_temp(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));
        ELSIF from_micro_reg1(2 downto 0) = "001" THEN 
            flag_out <= "01";   --output_temp(23 downto 12) <= osc_out_temp;
        ELSIF from_micro_reg1(2 downto 0) = "010" THEN 
            flag_out <= "10";   --output_temp(23 downto 12) <= osc_out_temp2;
        END IF;    
    END IF;
    
    ------FLAGS ASSESMENT------
    IF flag_duty_cycle1 = '1' THEN 
         duty_cycle_temp <= lfo_out_temp(6 downto 0);           
    ELSE
         duty_cycle_temp <= duty_cycle_midi;
    END IF;
    IF flag_duty_cycle2 = '1' THEN 
        duty_cycle_temp2 <= lfo_out_temp(6 downto 0);        
    ELSE
        duty_cycle_temp2 <= duty_cycle_midi;
    END IF;  
    IF flag_offset = '1' THEN 
        offset_temp <= lfo_out_temp(6 downto 0);
    ELSE
        offset_temp <= offset_midi;
    END IF; 
    IF flag_out = "01" THEN 
        output_temp(23 downto 12) <= osc_out_temp;        
    ELSIF flag_out = "10" THEN 
        output_temp(23 downto 12) <= osc_out_temp2;    
    ELSE
        output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & osc_out_temp(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));   
    END IF;    

END IF;
END PROCESS;


clk_enable1 : clk_enable
   port map(
		clk => clk,
		sclk => SPI(0),
		sclk_en => sclk_en_temp,
		sample_clk => sample_clk_temp);

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
        note_on => note_on_temp
        );

--GPIO_LED_0 <= duty_cycle_temp(0);
--GPIO_LED_1 <= duty_cycle_temp(1);
--GPIO_LED_2 <= duty_cycle_temp(2);
--GPIO_LED_3 <= duty_cycle_temp(3);

OSC_Main1 : OSC_Main
	port map(midi_note => midi_note,
		     wave_type => wave_type1,
             duty_cycle => duty_cycle_temp,
             offset => "0000000",
             offset_integer_out => offset_null,
             clk => clk,
             sample_clk => sample_clk_temp,
		     reset => RESET,
             oscout => osc_out_temp);

OSC_Main2 : OSC_Main
	port map(midi_note => midi_note,
		    wave_type => wave_type2,
            duty_cycle => duty_cycle_temp2,
            offset => offset_temp,
            offset_integer_out => to_micro,
            clk => clk,
            sample_clk => sample_clk_temp,
		    reset => RESET,
            oscout => osc_out_temp2);

LFO1 : LFO
 port map (clk => clk,
           sample_clk => sample_clk_temp, 
           rate_out => rate_temp,
           LFO_freq_main_in => '0' & LFO_freq_temp,
	       lfo_out=> lfo_out_temp);



Q_temp <= "0010110";
cut_off_temp <= "0111110";

biquad_ver2_comp1:biquad_ver2
port map( 	clk => clk,
       sample_clk => sample_clk_temp,
		OE_AC701 => OE_AC701,
		CS_AC701 => CS_AC701,
	  	x_IN =>  osc_out_temp,
		LFO => LFO_wave,
		knob => cut_off_temp,
		Q_in => Q_temp,
		knob_active => '0',	-- Will be needed to be set by button
		LFO_active => '0',	-- Will be needed to be set by button
	FWave => FWave_temp); -- Wave_OUT_temp     FWave_temp
	

--time_attack_temp  <= "0010000";	--64
--time_sustain_temp <= "0010000";
--time_release_temp <= "0010000";


envelope_comp1: envelope
  port map(
		clk => clk,
		sample_clk => sample_clk_temp,
		time_sustain => time_sustain_temp,
		time_release => time_release_temp,
		time_attack => time_attack_temp,
		FWave => FWave_temp, -- FWave_temp   osc_out_temp
		NOTE_ON => note_on_temp,
	EWave => Wave_OUT_temp);

--output_temp(23 downto 12) <= STD_LOGIC_VECTOR(unsigned('0' & osc_out_temp(11 downto 1))+(unsigned('0' & osc_out_temp2(11 downto 1))));
output_temp(11 downto 0) <= Wave_OUT_temp;

DAC1 : DAC
    port map(CLK => clk,
             sclk_en => sclk_en_temp,
             data  => output_temp,--osc_out_temp & osc_out_temp2,            
             DIN  => SPI(1),
             LDAC => SPI(2),
             CS => SPI(3));


--FMC1_HPC_HA10_N <= midi_control_data_temp(0); --4
--FMC1_HPC_HA11_P <= note_on_temp; --6
----FMC1_HPC_HA11_N <= midi_control_data_temp(2); -- 8
--FMC1_HPC_HA12_P <= midi_control_data_temp(3); --10
--FMC1_HPC_HA12_N <= midi_control_data_temp(4); --12
--FMC1_HPC_HA13_P <= midi_control_data_temp(5); --14
--FMC1_HPC_HA13_N <= midi_control_data_temp(6); --16
--FMC1_HPC_HA14_P <= midi_in; --18
--PROCESS(clk)
--BEGIN
--IF control_temp = "0000" then
-- time_attack_temp <= midi_control_data_temp;
--END IF;
--IF control_temp = "0001" then
-- time_sustain_temp <= midi_control_data_temp;
--END IF;
--IF control_temp = "0010" then
-- time_release_temp <= midi_control_data_temp;
--END IF;
--IF control_temp = "0011" then
--time_attack_temp <= "0100000";	--64
--time_sustain_temp <= "0100000";
--time_release_temp <= "0100000";
--GPIO_LED_0 <= time_attack_temp(0);
--GPIO_LED_1 <= time_attack_temp(1);
--GPIO_LED_2 <= time_attack_temp(2);
--GPIO_LED_3 <= time_attack_temp(3);
--END IF;
--END PROCESS;

END arch_TOP_Entity;
