library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
generic( palabras: integer:= 64);
port (
	d_in : in std_logic_vector (15 downto 0);
	dir : in std_logic_vector (15 downto 0);
	re : in std_logic ; -- Read enable
	we : in std_logic ; -- Write enable
	d_out : out std_logic_vector (15 downto 0));
end RAM;
architecture rtl of RAM is
	type mem_t is array(0 to palabras-1) of std_logic_vector (15 downto 0);
	signal ram_block : mem_t;
begin
	process (re , we , d_in,dir)
	begin
		if we = '1' then
			ram_block ( to_integer (unsigned(dir ))) <= d_in;
		elsif re = '1' then
			d_out <= ram_block ( to_integer (unsigned(dir )));
		end if;
	end process;
end rtl;