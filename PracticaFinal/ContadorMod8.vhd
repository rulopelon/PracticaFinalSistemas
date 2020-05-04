library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ContadorMod8 is
port(
	enable, reset, clock: in std_logic;
	salida:out std_logic_vector(2 downto 0));
	end ContadorMod8;
architecture behavorial of ContadorMod8 is
signal contador : unsigned(2 downto 0);
begin 

	process(reset, clock)
	begin 
	
		if reset = '0' then 
			contador <= (others=>'0');
		elsif clock 'event and clock = '1' then
				if enable ='1' then
					if contador<8 then 
						contador <= contador + 1;
					else 
						contador <= (others=>'0');
					end if;
			end if;
		end if;
	
	end process;
	salida <= std_logic_vector(contador);
end behavorial;