-------------------------------------------------------
--! @file
--! @brief Main Oscillators entity
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;


--! Description of Entity
ENTITY OSC_Main is
      PORT(midi_note:IN STD_LOGIC_VECTOR(7 DOWNTO 0); --! Note number coming from the MIDI Interface 
           midi_pitch:IN STD_LOGIC_VECTOR(6 DOWNTO 0); --! Pitch Change value coming from the MIDI Interface
		   wave_type:IN STD_LOGIC_VECTOR(2 DOWNTO 0); --! Wave type selected by the user interface
           duty_cycle:IN STD_LOGIC_VECTOR(6 DOWNTO 0); --! Duty cycle coming from MIDI interface or LFO
           offset:IN STD_LOGIC_VECTOR(6 DOWNTO 0); --! Offset value coming from MIDI interface or LFO
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0); --! Offset integer value to show on the LCD display
           duty_integer_out : out STD_LOGIC_VECTOR (6 downto 0); --! Duty cycle integer value to show on the LCD display
           clk : IN STD_LOGIC; --! clock (100 MHz)
           pitch_on_in   : in  std_logic; --! Pitch bend ON signal
           sample_clk : IN STD_LOGIC; --! Sample clock (40kHz)
		   reset:IN STD_LOGIC; --! Reset signal active low
           oscout:OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); --! Output from the oscillator
END ENTITY OSC_Main;


--! @brief Oscillators
--! @detailed The oscillators component receives inputs from the MIDI interface and the user interface to generate the desired waveforms at the desired frequency. It uses a numerically controlled oscillator and look up tables to generate most of the waveforms and a counter for the square wave.
ARCHITECTURE arch_OSC_Main OF OSC_Main IS

SIGNAL increment_temp : STD_LOGIC_VECTOR(20 DOWNTO 0); --! Temporary increment for Pitch calculations
SIGNAL increment_temp1 : STD_LOGIC_VECTOR(41 DOWNTO 0); --! Temporary increment for Pitch calculations
SIGNAL increment_temp2 : STD_LOGIC_VECTOR(41 DOWNTO 0); --! Temporary increment for Pitch calculations
SIGNAL increment_midi : STD_LOGIC_VECTOR(20 DOWNTO 0); --! Phase increment after the MIDI Note to Increment LUT
SIGNAL counter_size_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Counter size for the square wave 
SIGNAL Q_temp24 : STD_LOGIC_VECTOR(20 DOWNTO 0); --!  24 bit output from the Phase accumulator register
SIGNAL Q_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! 12 bit output from the phase accumulator register
SIGNAL mux_in_triangle_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Triangle wave to mux
SIGNAL mux_in_sine_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Sine wave to mux
SIGNAL mux_in_square_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Square wave to mux 
SIGNAL mux_in_whitenoise_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! White noise wave to mux
SIGNAL mux_in_sawtooth_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Sawtooth wave to mux
SIGNAL D_temp : STD_LOGIC_VECTOR(20 DOWNTO 0); --! Input to phase accumulator register
SIGNAL overflow_temp : STD_LOGIC; --! Overflow for square wave and duty cycle controlling
SIGNAL square_counter_out_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Counter output for square wave
SIGNAL Square_Reg_Q_temp : STD_LOGIC_VECTOR(11 DOWNTO 0); --! Duty cycle register output
SIGNAL comp_out_temp : STD_LOGIC; --! Output of square comparator 
SIGNAL midi_note_temp : STD_LOGIC_VECTOR(7 DOWNTO 0); --! MIDI Note
SIGNAL midi_pitch_temp : STD_LOGIC_VECTOR(7 DOWNTO 0); --! MIDI Pitch 
SIGNAL pitch_inc_temp : STD_LOGIC_VECTOR(20 DOWNTO 0); --! Phase increment given by pitch

--- Components definition ----

COMPONENT MIDI_Count_LUT
      PORT(address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT MIDI_Increment_LUT
      PORT(address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(20 DOWNTO 0));  
END COMPONENT;

COMPONENT Pitch_LUT
 port ( address : in std_logic_vector(7 downto 0);
    data : out std_logic_vector(20 downto 0));
 end COMPONENT Pitch_LUT;
COMPONENT Offset_LUT
    Port ( clk : IN STD_LOGIC;
           offset_in : in STD_LOGIC_VECTOR (6 downto 0);
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0);
           midi_note:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           midi_note_temp : out STD_LOGIC_VECTOR (7 downto 0));
end COMPONENT;

COMPONENT PAC_adder
      PORT(add:in STD_LOGIC_VECTOR(20 downto 0);
		  actual:in STD_LOGIC_VECTOR(20 downto 0);
	 	  s:out STD_LOGIC_VECTOR(20 downto 0));  
END COMPONENT;

COMPONENT reg24to12
	PORT(D : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
		reset : IN std_logic;
		slowclk : IN STD_LOGIC; -- slowclock
		clk : IN STD_LOGIC; -- fastclock.
		midi_note : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Q24 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT Sine_LUT
	PORT(address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		data : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT Triangle_LUT
      PORT(address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT Sawtooth_LUT
      PORT(address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT Wave_MUX	
	PORT(clk : IN STD_LOGIC; -- clock.
	     mux_in_sine : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- sine input.
		 mux_in_triangle : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- triangle input.
	     mux_in_square : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- square input.
	     mux_in_sawtooth : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- sawtooth input.	  
	     mux_in_whitenoise : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- whitenoise input.	        
		 wave_type : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 mux_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- output.
END COMPONENT;

COMPONENT Square_Counter
PORT(counter_size : IN STD_LOGIC_VECTOR(11 DOWNTO 0); 
	  reset : IN STD_LOGIC; -- Reset
	  clk : IN STD_LOGIC; -- clock.
	  slowclk : IN STD_LOGIC; -- clock.
	  overflow : OUT STD_LOGIC; -- clock.
	  square_counter_out: OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END COMPONENT;

COMPONENT Square_Comparator 
PORT(counter_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- counter in
	  reg_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- register in
	  comp_out : OUT STD_LOGIC); -- comparator out.
END COMPONENT;

COMPONENT Square_DC_Reg
PORT(D : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- input.
     counter_size : IN STD_LOGIC_VECTOR(11 dOWNTO 0); -- counter size input.
      duty_integer_out : out STD_LOGIC_VECTOR (6 downto 0);
	  reset : IN STD_LOGIC; -- Reset
	  clk : IN STD_LOGIC; -- clock.
	  slowclk : IN STD_LOGIC; -- clock.
	  Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- output.
END COMPONENT;

COMPONENT Square_RS_Latch
PORT(clk : IN STD_LOGIC; -- counter overflow
      count_ov : IN STD_LOGIC; -- counter overflow
	  comparator_out : IN STD_LOGIC; -- comparator out 
	  Square_Out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- comparator out.
END COMPONENT;

COMPONENT WhiteNoise
port (
      clk : in std_logic;
      sample_clk : in std_logic;
      random_num : out std_logic_vector (11 downto 0)   --output vector            
    );
end COMPONENT;

BEGIN

--! Receives and address from MIDI interface and gives a phase increment
MIDI_Increment_LUT1 : MIDI_Increment_LUT 
   port map(
		address => midi_note_temp,
      data => increment_midi);

--! Receives and address from MIDI interface and gives a counter size for square wave	  
MIDI_Count_LUT1 : MIDI_Count_LUT  
   port map(
		address => midi_note_temp, 
        data => counter_size_temp);

--! Receives pitch change value from MIDI interface and give a phase increment multiplicator		
Pitch_LUT1 : Pitch_LUT 
   port map(
		address => '0' & midi_pitch,
        data => pitch_inc_temp);
		
--! Receives an offset value from MIDI interface or LFO and returns the Note to be played		
Offset_LUT1 : Offset_LUT 
   port map(
        clk => clk,
		offset_in => offset,
		offset_integer_out => offset_integer_out, 
		midi_note => midi_note, 
        midi_note_temp => midi_note_temp);

--! Phase accumulator adder		
PAC_adder1 : PAC_adder 
   port map(
      add => increment_temp, 
      actual => Q_temp24,
      s => D_temp);

--! Phase accumulator register	  
PAC_Register : reg24to12  
   port map(
      D => D_temp, 
      reset => reset,
      slowclk => sample_clk,
      clk => clk,
	  midi_note => midi_note_temp,
	  Q24 => Q_temp24,
      Q => Q_temp);

--! Receives the phase and returns the amplitude for sine wave	  
Sine_LUT1 : Sine_LUT 
   port map(
	  address => Q_temp,
      data => mux_in_sine_temp);

--! Receives the phase and returns the amplitude for triangle wave
Triangle_LUT1 : Triangle_LUT 
   port map(
	  address => Q_temp,
      data => mux_in_triangle_temp);
      
--! Receives the phase and returns the amplitude for sawtooth wave	  
Sawtooth_LUT1 : Sawtooth_LUT 
    port map(
      address => Q_temp,
      data => mux_in_sawtooth_temp);

--! Receive all the waveforms and the wave type from user interface and outputs the selected waveform	  
Wave_MUX1 : Wave_MUX 
   port map(clk => clk,
				mux_in_sine => mux_in_sine_temp,
				mux_in_triangle => mux_in_triangle_temp,
				mux_in_square => mux_in_square_temp,
				mux_in_sawtooth => mux_in_sawtooth_temp,
				mux_in_whitenoise => mux_in_whitenoise_temp,
				wave_type => wave_type,
        		mux_out => oscout);

--! Counter for square wave				
Square_Counter1 : Square_Counter  
   port map(
		counter_size => counter_size_temp,
		reset => reset,
		clk => clk,
		slowclk => sample_clk,
		overflow => overflow_temp,
        square_counter_out => square_counter_out_temp);

--! Comparator for sqaure wave and duty cycle
Square_Comparator1 : Square_Comparator 
   port map(
      counter_in => square_counter_out_temp, 
      reg_in => Square_Reg_Q_temp,
      comp_out => comp_out_temp);

--! Register for storing duty cycle value of square wave	  
Square_DC_Reg1 : Square_DC_Reg
   port map(
      D => duty_cycle, 
      counter_size => counter_size_temp, 
      duty_integer_out => duty_integer_out, 
      reset => reset,
      clk => clk,
      slowclk => sample_clk,
      Q => Square_Reg_Q_temp);

--! Set-Reset Latch for generating square wave
Square_RS_Latch1 : Square_RS_Latch  
   port map(
      clk => clk, 
      count_ov => overflow_temp, 
      comparator_out => comp_out_temp,
      Square_Out => mux_in_square_temp);

--! Pseudo random number generator for white noise 	  
WhiteNoise1 : WhiteNoise     
port map(
    clk => clk,
    sample_clk  => sample_clk,
    random_num  => mux_in_whitenoise_temp);           

--! Calculates the new phase increment when the pitch bend wheel is moved		
PROCESS(clk)
BEGIN
IF rising_edge(clk) THEN
    IF pitch_on_in = '1' then
        increment_temp1 <= STD_LOGIC_VECTOR(unsigned(increment_midi)*unsigned(pitch_inc_temp));
        increment_temp2 <= STD_LOGIC_VECTOR(unsigned(increment_temp1) srl 12);
        increment_temp <= increment_temp2(20 downto 0);
    else
        increment_temp <= increment_midi;
    END IF;         
END IF; 
END PROCESS;

END arch_OSC_Main;
