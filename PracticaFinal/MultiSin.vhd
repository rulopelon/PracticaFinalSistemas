library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity MultiSin is
generic(
	bits: integer:= 69);
port(
	a,b : in std_logic_vector(bits-1 downto 0);
	ov: out std_logic;
	z : out std_logic;
	salida : out std_logic_vector(bits-1 downto 0));
end MultiSin;
architecture behavorial of MultiSin is 
	constant bitMenos1 : integer := bits-1;
	signal resultado : std_logic_vector(2*bitMenos1+1 downto 0); --para no tener problemas con el resultado
	signal over : std_logic;
begin
	resultado <= std_logic_vector(unsigned(a)*unsigned(b));
	salida <=resultado(bitMenos1 downto 0);
	
	overflow : process(resultado)
	begin
	over<='0';
		for i in bits-1 to 2*bits -1 loop
			if resultado(i) /= '0' then 
				over <= '1';
			end if;
			
			end loop;
			if unsigned(resultado) = 0 then 
				z <= '1';
			else 
				z<= '0';
			end if;
		
	end process;
	ov <= over;
	
end behavorial;


	