library ieee;
USE ieee.std_logic_1164.all;


entity Multiplexor8 is
port(
	entrada1,entrada2,entrada3,entrada4,entrada5,entrada6,entrada7,entrada8 :in std_logic_vector(7 downto 0);
	salida : out std_logic_vector(7 downto 0);
	selector :in std_logic_vector(2 downto 0));
	end Multiplexor8;
	
architecture behavorial of Multiplexor8 is 
begin
	with selector select salida <=
		entrada1 when "000",
		entrada2 when "001",
		entrada3 when "010",
		entrada4 when "011",
		entrada5 when "100",
		entrada6 when "101",
		entrada7 when "110",
		entrada8 when "111",
		"00000000" when others;
end behavorial;