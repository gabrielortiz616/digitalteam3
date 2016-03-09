LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Square_RS_Latch IS
PORT(clk : IN STD_LOGIC; -- counter overflow
     count_ov : IN STD_LOGIC; -- counter overflow
	 comparator_out : IN STD_LOGIC; -- comparator out 
	 Square_Out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- comparator out.
END Square_RS_Latch;

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

