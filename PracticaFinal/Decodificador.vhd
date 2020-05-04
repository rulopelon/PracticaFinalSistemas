library ieee;
use ieee.std_logic_1164.all;


entity Decodificador is
port(
	numeroEntrada : in std_logic_vector(2 downto 0);
	salidaActivacion1,salidaActivacion2,salidaActivacion3,salidaActivacion4,salidaActivacion5,salidaActivacion6,salidaActivacion7,salidaActivacion8: out std_logic);
	
	end Decodificador;
	
architecture behavorial of Decodificador is
begin

	--salidaActivacion8 <= '0' when numeroEntrada = "111" else '1';
	salidaActivacion8 <= '0' when numeroEntrada = "000" else '1';
	salidaActivacion7 <= '0' when numeroEntrada = "001" else '1';
	salidaActivacion6 <= '0' when numeroEntrada = "010" else '1';
	salidaActivacion5 <= '0' when numeroEntrada = "011" else '1';
	salidaActivacion4 <= '0' when numeroEntrada = "100" else '1';
	salidaActivacion3 <= '0' when numeroEntrada = "101" else '1';
	salidaActivacion2 <= '0' when numeroEntrada = "110" else '1';
	salidaActivacion1 <= '0' when numeroEntrada = "111" else '1';
end behavorial;