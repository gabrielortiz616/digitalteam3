-------------------------------------------------------
--! @file
--! @brief Handles the MIDI messages, sorting by status and values
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Handles the MIDI Messages, main input is the MIDI channel from the keyboard
entity midi is 
port(  CLK: IN STD_LOGIC; --! Clock 100MHz
       midi_in   : in  std_logic; --! MIDI data in from keyboard
       note_on_out   : out  std_logic; --! Note On signal
       pitch_on_out   : out  std_logic; --! Pitch bend wheel modified signal 
       midi_ch   : out std_logic_vector(3 downto 0); --! channel in MIDI 
       midi_control   : out std_logic_vector(6 downto 0); --! MIDI control knobs changed
       midi_control_data   : out std_logic_vector(6 downto 0); --! Value of the MIDI Control Knob changed
       midi_pitch : OUT STD_LOGIC_VECTOR(6 downto 0); --! Value of the Pitch bend rotation
       midi_note_out: out  std_logic_vector(7 downto 0) --! MIDI Note to be played
       );
end midi;

--! Filters the messages according to the status, recognize the note on or note of messages as well as the pitchbend or control messages. Captures the data from each messages and assigns it to the specific signal out.
architecture rtl of midi is
type midi_state_type is (status,note_off,note_on,no_status,velocity,controllers,control_data,pitchbend,no_status_pitch,pitchbend2,pitchfake,pitchfake2); --! States of the state machine
signal midi_new       : std_logic; --! Recognize a new message
signal midi_velo :  std_logic_vector(6 downto 0) := "0000000"; --! MIDI Velocity
signal midi_note :  std_logic_vector(6 downto 0) := "0000000"; --! MIDI Note
signal uart_busy    : std_logic; --! UART is Busy
signal midi_data       : std_logic_vector(7 downto 0); --! Data received from the RS232 interface
signal midi_state      : midi_state_type := status; --! Actual state of the state machine
signal next_midi_state : midi_state_type := status; --! next stage of the state machine
signal falling         : std_logic := '0'; --! Recognize falling edge 
signal off             : std_logic := '0'; --! Note OFF
signal key             : std_logic := '0'; --! '1' if a key in the keyboard has been pressed
signal pitch_on        : std_logic := '0'; --! '1' Pitch bend is being modified
signal pitch           : std_logic := '0'; --! Pitch bend roation value
signal pitch_off1       : std_logic := '0'; --! '1' if pitch bend is not longer being modified
signal midi_pitch_null :  std_logic_vector(6 downto 0) := "0000000"; --! Pitch less significant value that can be ignored}


COMPONENT RS232
PORT ( RXD      : in   STD_LOGIC;
                        RX_Data  : out  STD_LOGIC_VECTOR (7 downto 0);
                        RX_Busy  : out  STD_LOGIC;
                        TXD      : out  STD_LOGIC;
                        TX_Data  : in   STD_LOGIC_VECTOR (7 downto 0);
                        TX_Start : in   STD_LOGIC;
                        TX_Busy  : out  STD_LOGIC;
                        CLK      : in   STD_LOGIC
                        ); 
    
end COMPONENT;

COMPONENT edge_detect is
  port (async_sig : in std_logic;
        clk       : in std_logic;
        --rise      : out std_logic);
        fall      : out std_logic);
end COMPONENT;

begin

uart1: RS232
port map(midi_in,midi_data,uart_busy,open,"00000000",'0',open,clk);
uart_edge: edge_detect
port map(uart_busy,clk,falling);

process begin
   wait until rising_edge(clk);
   midi_new <= '0';
   pitch_on_out <= pitch_on;
   if(falling = '1') then
      if(not (midi_data = "11111110" or midi_data = "11111000" or midi_data = "11111001" or midi_data = "11111010" or midi_data = "11111011" or midi_data = "11111100" or midi_data = "11111101"or midi_data = "11111111") ) then --active sense or clock
         case midi_state is
            when status =>
               midi_new <= '0';
               if(midi_data(7) = '0') and pitch = '0' and key='1' then    --no status byte and note on
                  midi_state <= no_status;
                  midi_note  <= midi_data(6 downto 0);
                  midi_velo  <= "0000000";                  
               elsif(midi_data(7) = '0') and pitch = '1' and off='0' then    --no status byte and pitchbend
                 midi_state <= no_status_pitch;
                 if (midi_data(6 downto 0) = "0000000") then 
                    pitch_off1 <= '1';
                 end if;                    
                 midi_pitch_null  <= midi_data(6 downto 0);
                 midi_velo  <= "0000000";                                   
               elsif(midi_data(7 downto 4) = "1000") then    --note off
                  midi_state <= note_off;
                  midi_ch    <= midi_data(3 downto 0);
                  midi_velo  <= "0000000";
                  off <= '1';
                  pitch_on <= '0';
                  note_on_out <= '0';
                  key <= '1';  
                  pitch <= '0';                 
               elsif(midi_data(7 downto 4) = "1001") then --note on
                  midi_state <= note_on;
                  midi_ch    <= midi_data(3 downto 0);
                  pitch_on <= '0';
                  key <= '1';
                  pitch <= '0';  
               elsif(midi_data(7 downto 4) = "1011") then    --Controllers
                  midi_state <= controllers;
                  midi_ch    <= midi_data(3 downto 0);
                  midi_velo  <= "0000000";
                  pitch_on <= '0';
                  key <= '0';  
                 pitch <= '0';                  
               elsif(midi_data(7 downto 4) = "1110") then    --PitchBend
                    pitch <= '1';
                    key <= '0';                 
                 if off='0' then
                    midi_state <= pitchbend;
                    midi_ch    <= midi_data(3 downto 0);
                    midi_velo  <= "0000000";
                    pitch_on <= '1';
                 else
                    midi_state <= pitchfake;  
                 end if;                  
               end if;                 
            when note_on =>
               if(midi_data(7) = '0') then
                  midi_note  <= midi_data(6 downto 0);
                  midi_state <= velocity;
               else
                  midi_state <= status;
               end if;
            when controllers =>
               if(midi_data(7) = '0') then
                  midi_control  <= midi_data(6 downto 0);
                  midi_state <= control_data;
               else
                  midi_state <= status;
               end if;
            when control_data =>
               if(midi_data(7) = '0') then
                  midi_control_data  <= midi_data(6 downto 0);
                  midi_state <= status;
               else
                  midi_state <= status;
               end if;
            when note_off =>
               if(midi_data(7) = '0') then
                  midi_note  <= midi_data(6 downto 0);
                  midi_state <= velocity;
               else
                  midi_state <= status;
               end if;
               
            when pitchbend =>                   -- if pitchbend status is recieved
                if(midi_data(7) = '0') then
                 midi_pitch_null  <= midi_data(6 downto 0);
                 midi_state <= pitchbend2;
                else
                 midi_state <= status;
                end if;
            when pitchfake =>                   -- if pitchbend status is recieved without a note on
                if(midi_data(7) = '0') then
                 midi_pitch_null  <= midi_data(6 downto 0);
                 midi_state <= pitchfake2;
                else
                 midi_state <= status;
                end if;
            when pitchfake2 =>                   -- if pitchbend status is recieved without a note on
                    if(midi_data(7) = '0') then
                     midi_pitch_null  <= midi_data(6 downto 0);
                     midi_state <= status;
                    else
                     midi_state <= status;
                    end if;                                    
            when pitchbend2 =>                   -- capture pitchbend value
                if(midi_data(7) = '0') then
                   midi_pitch  <= midi_data(6 downto 0);
                   midi_state <= status;
                else
                   midi_state <= status;
                end if;
                                 
            when no_status =>
               if(midi_data(7) = '0') and off = '1' then
                  midi_velo  <= midi_data(6 downto 0);
                  midi_state <= status;
                  off <= '0';
                  note_on_out <= '1';                         
               else
                  midi_state <= status;
                  off <= '1';
                  pitch_on <= '0';
                  note_on_out <= '0';                     
                  midi_velo  <= "0000000";
               end if;

            when no_status_pitch =>
               if(midi_data(7) = '0')  then
                  midi_pitch  <= midi_data(6 downto 0);
                  midi_state <= status;                  
               else
                  midi_state <= status;
               end if;

            when velocity =>
               if(midi_data(7) = '0') then
                  if(midi_data /= "00000000") then
                    off <= '0';
                    note_on_out <= '1';
                    midi_velo <= midi_data(6 downto 0);
                  elsif(midi_data = "00000000") then
                    off <= '1';
                    note_on_out <= '0';
                  else  -- NOTE OFF
                    midi_velo <= "0000000";
                    off <= '1';
                    pitch_on <= '0';
                    note_on_out <= '0';
                  end if;
                  midi_state <= status;
                  midi_new   <= '1'; 
               else
                  midi_state <= status;
               end if;
         end case;
      end if;
   end if;
end process;
midi_note_out <= '0' & midi_note;
end rtl;