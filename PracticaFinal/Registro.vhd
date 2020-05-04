library ieee;
use ieee.std_logic_1164.all;

entity Registro is 
generic(bits : integer:= 16);
port(
	entrada : in std_logic_vector(bits-1 downto 0);
	enable:in  std_logic;
	salida : out std_logic_vector(bits-1 downto 0);
	clk,reset : in std_logic);

	end Registro;
architecture behavorial of Registro is 
signal valor : std_logic_vector(bits-1 downto 0);
begin
		process(clk, reset,enable)
			begin
				if reset = '0' then 
					valor <= (others=>'0');
	
				elsif clk'event and clk = '1' and enable = '1' then 
						--if enable  = '1' then 
							valor <= entrada;
							--end if;
					end if;
			
		end process;
	salida <= valor;
	
end behavorial;