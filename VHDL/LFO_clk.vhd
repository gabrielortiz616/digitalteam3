library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;


entity LFO_clk  is
    Port(clk_in:in std_logic;
         sample_clk:in std_logic;
         rate_div : in std_logic_vector(14 downto 0);
         clk_out :out std_logic);
    end LFO_clk ;
 

architecture beh1 of LFO_clk is

    SIGNAL counter_sclk : INTEGER range 0 TO 100000000 :=0;
    SIGNAL counter_en : INTEGER range 0 TO 100000000 :=0;
    SIGNAL counter_div : INTEGER range 0 TO 100000000 :=0;



  
Begin
  
  Process(clk_in)

variable clockcount : std_logic_vector(14 downto 0):    ="000000000000000";
variable x : std_logic:= '0';
variable m : std_logic_vector(14 downto 0) := "000000000000001";
  
   begin
    IF rising_edge(clk_in) THEN
       IF sample_clk = '1' THEN
        if (clockcount = rate_div-1) then
          clk_out <= '1';
          clockcount := "000000000000000";
        else
          clockcount     :=std_logic_vector(unsigned(clockcount)+unsigned(m));
          clk_out <= '0';
        end if;
        END IF;
    END IF;

    end process;
  
  end beh1;
      