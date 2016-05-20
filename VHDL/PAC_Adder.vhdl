-------------------------------------------------------
--! @file
--! @brief Phase Accumulator adder
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

--! The inputs to be added are the phase increment and the actual value in the Phase accumulator register, output is stores again in Phase accumulator register
ENTITY PAC_adder IS
	PORT(add:in STD_LOGIC_VECTOR(20 downto 0); --! Phase Increment value
		  actual:in STD_LOGIC_VECTOR(20 downto 0);--! Actual value stored in Phase accumulator register
	 	  s:out STD_LOGIC_VECTOR(20 downto 0) --! output of the addition
);
END PAC_adder;

--! Adds!
ARCHITECTURE arch_PAC_adder OF PAC_adder IS

BEGIN

	s<=actual+add;

END arch_PAC_adder;