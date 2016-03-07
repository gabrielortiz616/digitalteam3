library ieee;
use ieee.std_logic_1164.all;
entity Controls_LUT is
 port ( address : in std_logic_vector(6 downto 0);
    data : out std_logic_vector(3 downto 0));
 end entity Controls_LUT;
 architecture arch_Controls_LUT of Controls_LUT is
    type mem is array (0 to 15) of std_logic_vector(3 downto 0);
    constant Control_rom : mem := (
    0 => "0000", --
    1 => "0001", 
    2 => "0010",
    3 => "0011", 
    4 => "0100", 
    5 => "0101", 
    6 => "0110", 
    7 => "0111", 
    8 => "1000",  
    9 => "1001",  
    10 => "1010", 
    11 => "1011", 
    12 => "1100", 
    13 => "1101", 
    14 => "1110", 
    15 => "1111"); 
    
begin
 process (address)
 begin
  case address is
     when "1010010" => data <= Control_rom(0);  -- 52
     when "1010011" => data <= Control_rom(1);  -- 53
     when "0011100" => data <= Control_rom(2);  -- 1C
     when "0011101" => data <= Control_rom(3);  -- 1D 
     when "0010000" => data <= Control_rom(4);  -- 10
     when "1010000" => data <= Control_rom(5);  -- 50
     when "0010010" => data <= Control_rom(6);  -- 12
     when "0010011" => data <= Control_rom(7);  -- 13
     when "1001010" => data <= Control_rom(8);  -- 4A
     when "1000111" => data <= Control_rom(9);  -- 47
     when "1010001" => data <= Control_rom(10);  -- 51 
     when "1011011" => data <= Control_rom(11);  -- 5B
     when "0000010" => data <= Control_rom(12);  -- 2
     when "0001010" => data <= Control_rom(13);  -- A
     when "0000101" => data <= Control_rom(14);  -- 5
     when "0010101" => data <= Control_rom(15);  -- 15
     when others => data <= "0000";
    end case;
 end process;
end arch_Controls_LUT;
