library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

ENTITY PAC_adder IS
	PORT(add:in STD_LOGIC_VECTOR(20 downto 0);
		  actual:in STD_LOGIC_VECTOR(20 downto 0);
	 	  s:out STD_LOGIC_VECTOR(20 downto 0)
);
END PAC_adder;

ARCHITECTURE arch_PAC_adder OF PAC_adder IS
BEGIN
	s<=actual+add;
END arch_PAC_adder;