library ieee;
USE ieee.std_logic_1164.all;


entity Multiplexor2 is
generic(
	bits : integer:= 16);
port(
	entrada1,entrada2:in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0);
	selector :in std_logic);
	end Multiplexor2;
	
architecture behavorial of Multiplexor2 is 
begin
	with selector select salida <=
		entrada1 when '0',
		entrada2 when '1',
		(others=>'0') when others;
end behavorial;