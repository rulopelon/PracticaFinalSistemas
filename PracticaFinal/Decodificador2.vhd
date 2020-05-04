library ieee;
use ieee.std_logic_1164.all;


entity Decodificador2 is
port(
	salida1,salida2 : out std_logic;
	selector :in std_logic);
	end Decodificador2;
	
architecture behavorial of Decodificador2 is 
begin
	salida1<= '1' when selector='0' else '0';
	salida2<= '1' when selector='1' else '0';
end behavorial;