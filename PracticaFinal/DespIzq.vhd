library ieee;
use ieee.std_logic_1164.all;

entity DespIzq is
generic(
	bits: integer:= 69);
port(
	a,b : in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0));
end DespIzq;

architecture behavorial of DespIzq is

begin
	
	--solo se desplaza la a
	salida(bits-1 downto 1) <= a(bits-2 downto 0);
	salida(0)<= '0';
end behavorial;
	