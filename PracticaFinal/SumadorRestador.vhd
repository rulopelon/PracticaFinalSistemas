library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity SumadorRestador is 
generic(
	bits: integer:= 69);
port(
	a,b : in std_logic_vector(bits-1 downto 0);
	ov,z,co : out std_logic;
	sn_r : in std_logic; --indica si hay que hacer una suma o una resta
	salida : out std_logic_vector(bits-1 downto 0));
	end SumadorRestador;
	
architecture behavorial of SumadorRestador is
	constant c_one : std_logic_vector := conv_std_logic_vector(1, b'length);

	signal suma: std_logic_vector(bits-1 downto 0);
	signal complemento_a_2: std_logic_vector(bits-1 downto 0);
	
	begin
	
	complemento_a_2 <= not(b) + c_one;
	
	suma <= a+b when sn_r = '0' else a+complemento_a_2;
	
	co<= suma(bits-1);
	ov <= suma(bits-1) xor suma(bits-2);
	
	salida <= suma(bits-1 downto 0);
	z <= '1' when unsigned(suma) = 0 else '0';
	
end behavorial;
