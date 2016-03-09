LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY OSC_Main is
      PORT(midi_note:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		   wave_type:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
           duty_cycle:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
           offset:IN STD_LOGIC_VECTOR(6 DOWNTO 0);
           offset_integer_out : out STD_LOGIC_VECTOR (4 downto 0);
           clk : IN STD_LOGIC;
           sample_clk : IN STD_LOGIC;
		   reset:IN STD_LOGIC;
           oscout:OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END OSC_Main;

ARCHITECTURE arch_OSC_Main OF OSC_Main IS
SIGNAL out_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL increment_temp : STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL counter_size_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL Q_temp24 : STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL Q_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL mux_in_triangle_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL mux_in_sine_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL mux_in_square_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL mux_in_whitenoise_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL mux_in_sawtooth_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL D_temp : STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL overflow_temp : STD_LOGIC;
SIGNAL square_counter_out_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL Square_Reg_Q_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL comp_out_temp : STD_LOGIC;
SIGNAL midi_note_temp : STD_LOGIC_VECTOR(7 DOWNTO 0);


COMPONENT MIDI_Count_LUT
      PORT(address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));  
END COMPONENT;

COMPONENT MIDI_Increment_LUT
      PORT(address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           data : OUT STD_LOGIC_VECTOR(20 DOWNTO 0));  
END COMPONENT;

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


MIDI_Increment_LUT1 : MIDI_Increment_LUT
   port map(
		address => midi_note_temp,
      data => increment_temp);

MIDI_Count_LUT1 : MIDI_Count_LUT
   port map(
		address => midi_note_temp, 
        data => counter_size_temp);

Offset_LUT1 : Offset_LUT
   port map(
        clk => clk,
		offset_in => offset,
		offset_integer_out => offset_integer_out, 
		midi_note => midi_note, 
        midi_note_temp => midi_note_temp);

PAC_adder1 : PAC_adder
   port map(
      add => increment_temp, 
      actual => Q_temp24,
      s => D_temp);

PAC_Register : reg24to12
   port map(
      D => D_temp, 
      reset => reset,
      slowclk => sample_clk,
      clk => clk,
	  midi_note => midi_note_temp,
	  Q24 => Q_temp24,
      Q => Q_temp);

Sine_LUT1 : Sine_LUT
   port map(
	  address => Q_temp,
      data => mux_in_sine_temp);

Triangle_LUT1 : Triangle_LUT
   port map(
	  address => Q_temp,
      data => mux_in_triangle_temp);
      
Sawtooth_LUT1 : Sawtooth_LUT
    port map(
      address => Q_temp,
      data => mux_in_sawtooth_temp);

Wave_MUX1 : Wave_MUX
   port map(clk => clk,
				mux_in_sine => mux_in_sine_temp,
				mux_in_triangle => mux_in_triangle_temp,
				mux_in_square => mux_in_square_temp,
				mux_in_sawtooth => mux_in_sawtooth_temp,
				mux_in_whitenoise => mux_in_whitenoise_temp,
				wave_type => wave_type,
        		mux_out => oscout);

Square_Counter1 : Square_Counter
   port map(
		counter_size => counter_size_temp,
		reset => reset,
		clk => clk,
		slowclk => sample_clk,
		overflow => overflow_temp,
        square_counter_out => square_counter_out_temp);

Square_Comparator1 : Square_Comparator
   port map(
      counter_in => square_counter_out_temp, 
      reg_in => Square_Reg_Q_temp,
      comp_out => comp_out_temp);

Square_DC_Reg1 : Square_DC_Reg
   port map(
      D => duty_cycle, 
      counter_size => counter_size_temp, 
      reset => reset,
      clk => clk,
      slowclk => sample_clk,
      Q => Square_Reg_Q_temp);

Square_RS_Latch1 : Square_RS_Latch
   port map(
      clk => clk, 
      count_ov => overflow_temp, 
      comparator_out => comp_out_temp,
      Square_Out => mux_in_square_temp);

WhiteNoise1 : WhiteNoise      
port map(
    clk => clk,
    sample_clk  => sample_clk,
    random_num  => mux_in_whitenoise_temp);   --output vector            


END arch_OSC_Main;
