library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity SLTU is
generic(
	bits: integer:= 69);
port (
	a,b : in std_logic_vector(bits-1 downto 0);
	salida : out std_logic);
end SLTU;

architecture behavorial of SLTU is
begin
salida <= '1' when unsigned(a) < unsigned(b) else '0';

end behavorial;
