-------------------------------------------------------
--! @file
--! @brief Compares the value of the Square counter with the value stored in the duty cycle register
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.MATH_REAL.ALL;

--! Receives the value of the square counter and the duty cycle register, return a '1' when the values are equal.
ENTITY Square_Comparator IS
PORT(counter_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! counter in
	  reg_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --! register in
	  comp_out : OUT STD_LOGIC); --! Comparator Out.
END Square_Comparator;

--! Compares the value of the Square counter with the value stored in the duty cycle register
ARCHITECTURE arch_Square_Comparator OF Square_Comparator IS
BEGIN
	PROCESS(counter_in, reg_in)
	   BEGIN
			IF counter_in = reg_in THEN
				comp_out <= '1';
			ELSE
				comp_out <= '0'; 
			END IF;
		END PROCESS;
END arch_Square_Comparator;