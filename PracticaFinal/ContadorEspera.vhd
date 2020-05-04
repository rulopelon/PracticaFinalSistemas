library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity ContadorEspera is

port(
	salidaEnable :out std_logic;
	reset,clock : in std_logic);
end ContadorEspera;
	
architecture behavorial of ContadorEspera is
	
	signal contador : unsigned(15 downto 0);
	begin
	contar :process(reset, clock)
	begin 
		if reset = '0' then 
			contador <=(others=>'0');
		elsif clock'event and clock = '1' then 
			if contador < 2500 then 
				contador <= contador +1;
			else
				contador <= (others =>'0');
			end if;
		end if;
	end process;
	
salidaEnable <='1' when contador = 2500 else '0';
	
	
end behavorial;