library ieee;
use ieee.std_logic_1164.all;

entity OperadorNAND is
generic(
	bits: integer:= 69);
port(

	a,b : in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0));
end OperadorNAND;
architecture behavorial of OperadorNAND is 
begin

	salida <= a nand b;
	
end behavorial;