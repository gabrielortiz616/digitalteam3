LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

ENTITY DAC is
      GENERIC(N:INTEGER:=4);
      PORT(CLK : IN STD_LOGIC;
           sclk_en : IN STD_LOGIC;
           data  : IN STD_LOGIC_VECTOR(23 downto 0);
           DIN  : OUT STD_LOGIC;
           LDAC : OUT STD_LOGIC;
           CS : OUT STD_LOGIC);
END DAC;

ARCHITECTURE arch_DAC OF DAC IS
SIGNAL config_bits1 : STD_LOGIC_VECTOR(11 DOWNTO 0) := "0000" & "0010" & "0000"; 
SIGNAL config_bits2 : STD_LOGIC_VECTOR(11 DOWNTO 0) := "0000" & "0010" & "0011"; 
SIGNAL array_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL send : STD_LOGIC :='0';
SIGNAL DIN_temp : STD_LOGIC :='0';
SIGNAL sclk_temp : STD_LOGIC :='0';
SIGNAL cs_temp : STD_LOGIC :='0';
SIGNAL channel : STD_LOGIC :='0';
--SIGNAL mosi : STD_LOGIC;


BEGIN

   DAC_PRC : PROCESS(clk)
   VARIABLE counter : INTEGER := 0;
   BEGIN
    IF rising_edge(clk) THEN -- send start condition
        IF sclk_en = '1' THEN
         IF channel = '0' THEN
            IF send = '0' THEN
               --array_out <= config_bits & data_from_adc;
               array_out <= config_bits1 & data(23 downto 12) & "0000" & "0000";
               send <= '1';
               counter := 0;
               ldac <= '1';
            ELSIF send = '1'  THEN
               IF counter = 31 THEN
                cs <= '1';
                cs_temp <= '1';
                send <= '0';
                counter := 0;
                channel <= '1';
                ldac <= '0';
                DIN <= '0';
                DIN_temp <= '0';
               ELSE
                cs <= '0';
                cs_temp <= '0';
                DIN <= array_out(31 - counter);
                DIN_temp <= array_out(31 - counter);
                counter := counter + 1;
               END IF;    
             END IF;
           ELSE
               IF send = '0' THEN
                  --array_out <= config_bits & data_from_adc;
                  array_out <= config_bits2 & data(11 downto 0) & "0000" & "0000";
                  send <= '1';
                  counter := 0;
                  ldac <= '1';
               ELSIF send = '1'  THEN
                  IF counter = 31 THEN
                   cs <= '1';
                   cs_temp <= '1';
                   send <= '0';
                   counter := 0;
                   ldac <= '0';
                   channel <= '0';
                   DIN <= '0';
                   DIN_temp <= '0';
                  ELSE
                   cs <= '0';
                   cs_temp <= '0';
                   DIN <= array_out(31 - counter);
                   DIN_temp <= array_out(31 - counter);
                   counter := counter + 1;
                  END IF;    
                END IF;
            END IF;
        END IF;
    END IF;
    END PROCESS;
 
           
END arch_DAC;

