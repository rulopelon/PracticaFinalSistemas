library ieee;
use ieee.std_logic_1164.all;


entity Demultiplexor4 is
port(
	entrada :in std_logic;
	salida1,salida2,salida3,salida4 : out std_logic;
	selector :in std_logic_vector(1 downto 0));
	end Demultiplexor4;
	
architecture behavorial of Demultiplexor4 is 
begin
	salida1 <= entrada when selector = "00" else '0';
	salida2 <= entrada when selector = "01" else '0';
	salida3 <= entrada when selector = "10" else '0';
	salida4 <= entrada when selector = "11" else '0';
	
end behavorial;