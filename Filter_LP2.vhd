library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity biquad_ver2 is
		Generic(	WIDTH_filter:INTEGER:=12;
             			Taps:INTEGER:=3;
				WIDTH_LFO: INTEGER :=12);
		Port ( 
				clk, OE_AC701, CS_AC701, sample_clk : in  STD_LOGIC;
				x_IN : in  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0);
				LFO : in STD_LOGIC_VECTOR(WIDTH_LFO-1 downto 0);
				knob : IN STD_LOGIC_VECTOR(6 downto 0);
				Q_in : in STD_LOGIC_VECTOR(6 downto 0);
				knob_active : IN STD_LOGIC;
				LFO_active : IN STD_LOGIC;
				FWave : out  STD_LOGIC_VECTOR (WIDTH_filter-1 downto 0)
				);
end biquad_ver2;

--------------------------------------------------------------------------------
-- Architecture and formula declaration

architecture arch of biquad_ver2 is

-- v(n) = g*x(n)
-- y(n) = v(n) + B1*v(n-1) + B2*v(n-2) - a1*y(n-1) - a2*y(n-2)

--------------------------------------------------------------------------------
-- signal declaration

type x_HEIGHT is array (0 to Taps-1) of STD_LOGIC_VECTOR(WIDTH_filter-1 downto 0);

signal x_S0,x_S1,x_S2, y_S0, y_S1, y_S2 : STD_LOGIC_VECTOR(WIDTH_filter-1 downto 0):= (Others=> '0');
signal G,B0,B1,B2,a0,a1,a2,v0,v1,v2,Q,wp,N,fs, frac, temp ,frac2 : INTEGER;
signal filtered : STD_LOGIC_VECTOR(WIDTH_filter*2-1 downto 0):= (Others=> '0');
--type Real is range --usually double precision floating point-- ;
signal clk_S : STD_LOGIC;
SIGNAL fc : STD_LOGIC_VECTOR(11 downto 0);
SIGNAL B0_temp,a1_temp,a2_temp, fc_temp, Q_temp : STD_LOGIC_VECTOR(7 downto 0);

--COMPONENT counter IS
--      PORT(clk:IN STD_LOGIC;
--           count_max: IN INTEGER;
--	   count_duty: IN INTEGER;
--	   clk_out: OUT STD_LOGIC);
--END COMPONENT counter;
--
--
--COMPONENT Coef is
--		Port ( 
--				fc, Q : IN STD_LOGIC_VECTOR(7 downto 0);
--				CS_AC701, OE_AC701 : IN STD_LOGIC; --WE_AC701;
--				a1,a2,B0 : OUT STD_LOGIC_VECTOR(7 downto 0)
--				);
--end COMPONENT;

--------------------------------------------------------------------------------
-- Coeficient declaration and calculation

begin

-- Testing variables
 --fc <= 2000;      	-- cutoff
 --fs <= 40000;     	-- sampling

--------------------- Conversion to fraction is needed
-- Solution to conversion
-- Take most variables multiplied with 2^(W-2) (-2 because last bit makes it negative)
-- frac2 <= WIDTH_filter-2;
-- frac <= 2**frac2;

-- Calculation of coeficient

--counter_filter_comp:
--COMPONENT counter
--         PORT MAP(clk=>clk,
--	 	  count_max => 4,
--		  count_duty => 3,
--		  clk_out => clk_S);

process(clk)
BEGIN
	if(rising_edge(clk)) then
		if(LFO_active = '1') then
			--fc <= STD_LOGIC_VECTOR(unsigned(LFO)/16); 		--12 bits are 4096 worth

		elsif(knob_active = '1') then
			--fc <= STD_LOGIC_VECTOR(unsigned(knob) * 32/16);
		
		else
			fc <= "000001111101"; -- 2000/16
		end if;
	end if;
end process;

--Coef_comp: Coef
--port map( 	fc => fc,
--		Q => Q_in,
--		CS_AC701 => CS_AC701, 
--		OE_AC701 => OE_AC701,--WE_AC701,
--		a1 => a1_temp,
--		a2 => a2_temp,
--		B0 => B0_temp
--		);


--B0 <= to_integer(to_unsigned(B0_temp))*32;
--B1 <= 2*to_integer(to_unsigned(B0_temp))*32;
--B2 <= to_integer(to_unsigned(B0_temp))*32;
--a0 <= 1024;
--a1 <= to_integer(to_unsigned(a1_temp))*32;
--a2 <= to_integer(to_unsigned(a2_temp))*32;


 G <= 300;
-- B0 <= 656;--20;
-- B1 <= 2*B0;--40;
-- B2 <= B0;
-- a0 <= 256;--1024;
-- a1 <= -1597;---6394;---1597;
-- a2 <= 655;--655;

 B0 <= 1*G;--21*G;
 B1 <= 2*B0;
 B2 <= B0;
 a0 <= 1024*G;
 a1 <= 1957*G;--1599*G;
 a2 <= 937*G;--657*G;


-- When simulating check so that they have the correct value

--------------------------------------------------------------------------------
-- Sampling process

sample: process(clk)
begin
	if rising_edge(clk) then
		if(sample_clk = '1') then
			x_S0  <= STD_LOGIC_VECTOR(unsigned(x_IN)-2048);
			x_S1 <= x_S0;
			x_S2 <= x_S1;
			FWave <= STD_LOGIC_VECTOR(signed(y_S0)+2048); --y_S0(5 downto 0))*63
			y_S1 <= y_S0;
			y_S2 <= y_S1;
		end if;
	end if;
end process sample;

--------------------------------------------------------------------------------
-- Filter calculation of the output
--v0<=to_integer(signed(x_S(0)))*g;
--v1<=to_integer(signed(x_S(1)))*g;
--v2<=to_integer(signed(x_S(2)))*g;

filter: process(clk)
begin
	if rising_edge(clk) then

		filtered <= STD_LOGIC_VECTOR((a1*signed(y_S1) - a2*signed(y_S2) +		-- Y part which is y(n-1)*a1 - y(n-2)*a2
				B0*signed(x_S0) + B1*signed(x_S1) + B2*signed(x_S2)));	-- X part which is x(n)*B0 + x(n-1)*B1 + x(n-2)*B2
		

--		filtered <= STD_LOGIC_VECTOR(unsigned(x_S0)*B0 + unsigned(x_S1)*B1 + unsigned(x_S2)*B2 
--				- unsigned(y_S1)*a1 - unsigned(y_S2)*a2 + a0*4096); -- - a0?

	end if;

end process filter;

y_S0 <= filtered(WIDTH_filter*2-1 downto WIDTH_filter);


end arch;




-- One way would to have 1 first-order and then 3 second-orders after
-- G is evenly distributed as 4th sqrt(G)






