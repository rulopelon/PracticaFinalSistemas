library ieee;
USE ieee.std_logic_1164.all;


entity Multiplexor4 is
generic(bits: integer:= 16);
port(
	entrada1,entrada2,entrada3,entrada4 :in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0);
	selector :in std_logic_vector(1 downto 0));
	end Multiplexor4;

architecture behavorial of Multiplexor4 is 
begin
	with selector select salida <=
		entrada1 when "00",
		entrada2 when "01",
		entrada3 when "10",
		entrada4 when "11",
		(others =>'0') when others;
end behavorial;
