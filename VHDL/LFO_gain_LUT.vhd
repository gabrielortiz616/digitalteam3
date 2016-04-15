library ieee;
use ieee.std_logic_1164.all;
entity LFO_gain is
 port (LFO_gain_in : in std_logic_vector(6 downto 0);
    gain : out std_logic_vector(2 downto 0);
    clk_in: in std_logic);
 end entity LFO_gain;
 
 architecture arch_LFO_gain of LFO_gain is
   Begin

     process(clk_in)
       
      begin
     if( LFO_gain_in <= "0000001") then
     gain <= "001";
   elsif("0000011" >= LFO_gain_in and LFO_gain_in >"0000001") then
     gain <= "010";
   elsif("0000111" >= LFO_gain_in and LFO_gain_in >"0000011" ) then
     gain <= "011";
   elsif("0001111" >= LFO_gain_in and LFO_gain_in >"0000111") then
     gain <= "100";
   elsif("0011111" >= LFO_gain_in and LFO_gain_in >"0001111" ) then
     gain <= "101";
   elsif("0111111" >= LFO_gain_in and LFO_gain_in >"0011111") then
     gain <= "110";
   elsif("1111111" >= LFO_gain_in and LFO_gain_in >"0111111" ) then
     gain <= "111";
   end if;
 
   end process;
   end arch_LFO_gain ;

