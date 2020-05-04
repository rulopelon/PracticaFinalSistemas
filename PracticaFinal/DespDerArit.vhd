library ieee;
use ieee.std_logic_1164.all;

entity DespDerArit is
generic(
	bits: integer:= 69);
port(
	a,b : in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0));
end DespDerArit;
architecture behavorial of DespDerArit is
begin
	
	--solo se desplaza la a
	salida(bits-1)<= a(bits-1);
	Salida(bits-2 downto 0)<= a(bits-1 downto 1);
	
	
	
end behavorial;
	