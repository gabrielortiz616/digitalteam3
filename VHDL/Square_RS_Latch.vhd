-------------------------------------------------------
--! @file
--! @brief Generates the square wave by toggling between '1' when the square counters overflow and '0' when the comparator inputs are equal 
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! Receives the overflow bit of the counter and the output of the comparator, outputs the square wave
ENTITY Square_RS_Latch IS
PORT(clk : IN STD_LOGIC; --! Clock
     count_ov : IN STD_LOGIC; --! counter overflow
	 comparator_out : IN STD_LOGIC; --! comparator out 
	 Square_Out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); --! Square wave out
END Square_RS_Latch;

--! When the counter set the overflow bit, the latch outputs '1' which is the high part of the square wave, when the counter value is the same as the duty cycle register value, then the comparator output is set to '1' which resets the Latch and set the square wave low value
ARCHITECTURE arch_Square_RS_Latch OF Square_RS_Latch IS
SIGNAL notQ : STD_LOGIC;
SIGNAL square_one : STD_LOGIC;
BEGIN

PROCESS(count_ov, comparator_out, clk)
    BEGIN
    IF rising_edge(clk) THEN 
        IF comparator_out = '1' THEN
           Square_Out <= (others => '0');
        ELSIF count_ov = '1' THEN
           Square_Out <= (others => '1');
        END IF;
    END IF;
END PROCESS;
END arch_Square_RS_Latch;

