library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
entity MultiCon is
generic(
	bits: integer:= 69);
port(
	a,b : in std_logic_vector(bits-1 downto 0);
	ov: out std_logic;
	z : out std_logic;
	salida : out std_logic_vector(bits-1 downto 0));
end MultiCon;
architecture behavorial of MultiCon is 
	constant bitMenos1 : integer := bits-1;
	signal resultado : std_logic_vector(2*bitMenos1+1 downto 0); --para no tener problemas con el resultado
	signal over : std_logic;
begin
	resultado <= std_logic_vector(signed(a)*signed(b));
	salida <=resultado(bits-1 downto 0);
	
	overflow : process(resultado)
	begin
	over<='0';
	for i in bits-1 to 2*bits -1 loop
			if resultado(i) /= resultado(bits-1) then 
				over <= '1';
			end if;
			end loop;
		if signed(resultado) = 0 then 
			z <= '1';
		else 
			z <= '0';
		end if;
		
	end process;
	ov <= over;
	
end behavorial;


	