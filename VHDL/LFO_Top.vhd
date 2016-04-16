library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity LFO is
 port( clk:in std_logic;
       sample_clk:in std_logic;
       rate_out : out std_logic;   
       LFO_gain_main_in: in std_logic_vector(6 downto 0);
       LFO_freq_main_in: in std_logic_vector(6 downto 0);
       lfo_out:out std_logic_vector(7 downto 0));
end LFO;


architecture beh of LFO is

  
  signal clk_divide: std_logic;
  signal ratex: std_logic_vector(13 downto 0):="00000000000000";
  signal gain: std_logic_vector(2 downto 0);



component LFO_clk is
       Port(clk_in:in std_logic;
            sample_clk:in std_logic;
            rate_div : in std_logic_vector(13 downto 0);
            clk_out :out std_logic);
    end component;
    

component LFO_freq is
          port (LFO_freq_in : in std_logic_vector(6 downto 0);
                rate : out std_logic_vector(13 downto 0));
     end component; 
     
component LFO_gain is
           port (LFO_gain_in : in std_logic_vector(6 downto 0);
                 gain : out std_logic_vector(2 downto 0);
                 clk_in: in std_logic);
    end component;
 



 Begin

    m1 :  LFO_clk 
		port map(clk_in => clk,
		         sample_clk => sample_clk,
				 rate_div =>ratex, 
				 clk_out => clk_divide);

    LUT1 : LFO_freq 
			port map (LFO_freq_in => LFO_freq_main_in, 
                          rate =>ratex);
    
    LUT2 : LFO_gain 
			port map(LFO_gain_in => LFO_gain_main_in, 
				    gain => gain ,
				    clk_in => clk );

Process(clk)
  
 	 variable flag0: std_logic :='0';
  	 variable f: std_logic_vector(4 downto 0):="00001";
  	 variable count: std_logic_vector(4 downto 0):="00000";
       variable count1: std_logic_vector(4 downto 0):="00000";
  
  begin
    IF rising_edge(clk) THEN -- send start condition
      IF sample_clk = '1' THEN
       IF clk_divide = '1' THEN
        if(count>="10010" or count<="00000" ) then
        	flag0:=not flag0;
    	   end if;
        if (flag0='1') then
          count:=std_logic_vector(unsigned(count)+(unsigned(f)));
        elsif (flag0='0') then
          count:=std_logic_vector(unsigned(count)-(unsigned(f)));
        end if;
      lfo_out <=std_logic_vector(unsigned(count)*unsigned(gain));
       END IF;
      END IF;
    END IF; 
   rate_out <= clk_divide;
 

end Process;
    
end beh;




