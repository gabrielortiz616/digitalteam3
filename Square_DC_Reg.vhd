LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY Square_DC_Reg IS
PORT(D : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- duty cycle input.
     counter_size : IN STD_LOGIC_VECTOR(11 dOWNTO 0); -- counter size input.
	 reset : IN STD_LOGIC; -- Reset
	 clk : IN STD_LOGIC; -- clock.
	 slowclk : IN STD_LOGIC; -- clock.
	 Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- output.
END Square_DC_Reg;

ARCHITECTURE arch_Square_DC_Reg OF Square_DC_Reg IS

BEGIN
    PROCESS(clk, reset)
    BEGIN
        IF reset = '0' THEN
				Q <= (others => '0');
        ELSIF rising_edge(clk) THEN
            IF slowclk ='1' THEN
                IF D = "0000000" THEN
                     Q <= std_logic_vector(shift_right(unsigned(counter_size), 1)); 
                ELSIF D >= "0000001" AND D<"0000010" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
			    ELSIF D >= "0000010" AND D<"0000011" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));      
                ELSIF D >= "0000011" AND D<"0000100" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));                     
                ELSIF D >= "0000100" AND D<"0000101" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));					 
                ELSIF D >= "0000101" AND D<"0000110" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0000110" AND D<"0000111" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6)));                
			    ELSIF D >= "0000111" AND D<"0001000" THEN
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0001000" AND D<"0001001" THEN                        
 					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4)));
                ELSIF D >= "0001001" AND D<"0001010" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0001010" AND D<"0001011" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));
                ELSIF D >= "0001011" AND D<"0001100" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                ELSIF D >= "0001100" AND D<"0001101" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5)));                                     
                ELSIF D >= "0001101" AND D<"0001110" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                ELSIF D >= "0001110" AND D<"0001111" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6)));
                ELSIF D >= "0001111" AND D<"0010000" THEN                        
 					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0010000" AND D<"0010001" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3)));
                ELSIF D >= "0010001" AND D<"0010010" THEN                        
 					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                ELSIF D >= "0010010" AND D<"0010011" THEN                        
 					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6)));  
                ELSIF D >= "0010011" AND D<"0010100" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0010100" AND D<"0010101" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));
                ELSIF D >= "0010101" AND D<"0010110" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0010110" AND D<"0010111" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))); 
                ELSIF D >= "0010111" AND D<"0011000" THEN                        
    				 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0011000" AND D<"0011001" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4)));      
                ELSIF D >= "0011001" AND D<"0011010" THEN                        
					 Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                ELSIF D >= "0011010" AND D<"0011011" THEN                        
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));  
                ELSIF D >= "0011011" AND D<"0011100" THEN                        
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                ELSIF D >= "0011100" AND D<"0011101" THEN                        
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5)));  
                ELSIF D >= "0011101" AND D<"0011110" THEN                        
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                ELSIF D >= "0011110" AND D<"0011111" THEN                         
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 6)));   
                ELSIF D >= "0100000" AND D<"0100001" THEN                         
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 7)));                                            
                ELSIF D >= "0100001" AND D<"0100010" THEN                         
                     Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)));  
                ELSIF D >= "0100010" AND D<"0100011" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                 ELSIF D >= "0100011" AND D<"0100100" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));      
                 ELSIF D >= "0100100" AND D<"0100101" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));                     
                 ELSIF D >= "0100101" AND D<"0100110" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));                     
                 ELSIF D >= "0100110" AND D<"0100111" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0100111" AND D<"0101000" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6)));                
                 ELSIF D >= "0101000" AND D<"0101001" THEN
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0101001" AND D<"0101010" THEN                        
                       Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4)));
                 ELSIF D >= "0101010" AND D<"0101011" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0101011" AND D<"0101100" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));
                 ELSIF D >= "0101100" AND D<"0101101" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                 ELSIF D >= "0101101" AND D<"0101110" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5)));                                     
                 ELSIF D >= "0101110" AND D<"0101111" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                 ELSIF D >= "0101111" AND D<"0110000" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6)));
                 ELSIF D >= "0110000" AND D<"0110001" THEN                        
                       Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0110001" AND D<"0110010" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 3)));
                 ELSIF D >= "0110010" AND D<"0110011" THEN                        
                       Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                 ELSIF D >= "0110011" AND D<"0110100" THEN                        
                       Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6)));  
                 ELSIF D >= "0110100" AND D<"0110101" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0110101" AND D<"0110110" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));
                 ELSIF D >= "0110110" AND D<"0110111" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0110111" AND D<"0111000" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))); 
                 ELSIF D >= "0111000" AND D<"0111001" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "0111001" AND D<"0111010" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 4)));      
                 ELSIF D >= "0111010" AND D<"0111011" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                 ELSIF D >= "0111100" AND D<"0111101" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));  
                 ELSIF D >= "0111101" AND D<"0111110" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                 ELSIF D >= "0111110" AND D<"0111111" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 5)));  
                 ELSIF D >= "0111111" AND D<"1000000" THEN                        
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                 ELSIF D >= "1000000" AND D<"1000001" THEN                         
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)) + unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 6)));   
                 ELSIF D >= "1000001" AND D<"1000010" THEN                         
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1))+ unsigned(shift_right(unsigned(counter_size), 7)));                                            
                 ELSIF D >= "1000010" AND D<"1000011" THEN                         
                      Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 1)));     
                      ELSIF D >= "1000011" AND D<"1000100" THEN
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));                     
                      ELSIF D >= "1000100" AND D<"1000101" THEN
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));                     
                      ELSIF D >= "1000101" AND D<"1000110" THEN
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1000110" AND D<"1000111" THEN
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6)));                
                      ELSIF D >= "1000111" AND D<"1001000" THEN
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1001000" AND D<"1001001" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4)));
                      ELSIF D >= "1001001" AND D<"1001010" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1001010" AND D<"1001011" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));
                      ELSIF D >= "1001011" AND D<"1001100" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                      ELSIF D >= "1001100" AND D<"1001101" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5)));                                     
                      ELSIF D >= "1001101" AND D<"1001110" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                      ELSIF D >= "1001110" AND D<"1001111" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6)));
                      ELSIF D >= "1001111" AND D<"1010000" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1010000" AND D<"1010001" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 3)));
                      ELSIF D >= "1010001" AND D<"1010010" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                      ELSIF D >= "1010010" AND D<"1010011" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6)));  
                      ELSIF D >= "1010011" AND D<"1010100" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1010100" AND D<"1010101" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));
                      ELSIF D >= "1010101" AND D<"1010110" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1010110" AND D<"1010111" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))); 
                      ELSIF D >= "1010111" AND D<"1011000" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1011000" AND D<"1011001" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 4)));      
                      ELSIF D >= "1011001" AND D<"1011010" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                      ELSIF D >= "1011010" AND D<"1011011" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));  
                      ELSIF D >= "1011011" AND D<"1011100" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                      ELSIF D >= "1011100" AND D<"1011101" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 5)));  
                      ELSIF D >= "1011101" AND D<"1011110" THEN                        
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                      ELSIF D >= "1011110" AND D<"1011111" THEN                         
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 6)));   
                      ELSIF D >= "1100000" AND D<"1100001" THEN                         
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)) + unsigned(shift_right(unsigned(counter_size), 7)));                                            
                      ELSIF D >= "1100001" AND D<"1100010" THEN                         
                           Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 2)));  
                      ELSIF D >= "1100010" AND D<"1100011" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                       ELSIF D >= "1100011" AND D<"1100100" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));      
                       ELSIF D >= "1100100" AND D<"1100101" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));                     
                       ELSIF D >= "1100101" AND D<"1100110" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));                     
                       ELSIF D >= "1100110" AND D<"1100111" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1100111" AND D<"1101000" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6)));                
                       ELSIF D >= "1101000" AND D<"1101001" THEN
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1101001" AND D<"1101010" THEN                        
                             Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 4)));
                       ELSIF D >= "1101010" AND D<"1101011" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1101011" AND D<"1101100" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));
                       ELSIF D >= "1101100" AND D<"1101101" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                       ELSIF D >= "1101101" AND D<"1101110" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 5)));                                     
                       ELSIF D >= "1101110" AND D<"1101111" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                       ELSIF D >= "1101111" AND D<"1110000" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 6)));
                       ELSIF D >= "1110000" AND D<"1110001" THEN                        
                             Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1110001" AND D<"1110010" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 3)));
                       ELSIF D >= "1110010" AND D<"1110011" THEN                        
                             Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7))); 
                       ELSIF D >= "1110011" AND D<"1110100" THEN                        
                             Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 6)));  
                       ELSIF D >= "1110100" AND D<"1110101" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)) + unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1110101" AND D<"1110110" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 5)));
                       ELSIF D >= "1110110" AND D<"1110111" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1110111" AND D<"1111000" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 6))); 
                       ELSIF D >= "1111000" AND D<"1111001" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4))+ unsigned(shift_right(unsigned(counter_size), 7)));
                       ELSIF D >= "1111001" AND D<"1111010" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 4)));      
                       ELSIF D >= "1111010" AND D<"1111011" THEN                        
                            Q <= std_logic_vector(  unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                       ELSIF D >= "1111100" AND D<"1111101" THEN                        
                            Q <= std_logic_vector( unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 6)));  
                       ELSIF D >= "1111101" AND D<"1111110" THEN                        
                            Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 5))+ unsigned(shift_right(unsigned(counter_size), 7)));  
                       ELSIF D >= "1111110" AND D<"1111111" THEN                        
                            Q <= std_logic_vector(unsigned(shift_right(unsigned(counter_size), 6)));  
                ELSE                     
                     Q <= std_logic_vector(shift_right(unsigned(counter_size), 1)); 
                END IF;                                                                                                        			         
			END IF;
        END IF;
    END PROCESS;
END arch_Square_DC_Reg;
