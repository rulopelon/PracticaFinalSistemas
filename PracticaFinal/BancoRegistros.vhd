library ieee;
use ieee.std_logic_1164.all;

entity BancoRegistros is 
	generic(nbits : integer:= 16);
	port(
		DirB,DirA : in std_logic_vector(2 downto 0);
		clk,reset : in std_logic;
		dirEsc: in std_logic_vector(2 downto 0);
		enable : in std_logic;
		datoEsc : in std_logic_vector(nbits-1 downto 0);
		salidaA: out std_logic_vector(nbits-1 downto 0);
		salidaB: out std_logic_vector(nbits-1 downto 0));
		
	end BancoRegistros;
architecture behavorial of BancoRegistros is 

 
 signal enable0,enable1,enable2,enable3,enable4,enable5,enable6,enable7 :std_logic;
 signal salidaRegistro0,salidaRegistro1,salidaRegistro2,salidaRegistro3,salidaRegistro4,salidaRegistro5,salidaRegistro6,salidaRegistro7: std_logic_vector(nbits-1 downto 0);
 component Registro
	generic(bits : integer:= 16);
	port(
		entrada : in std_logic_vector(bits-1 downto 0);
		enable:in  std_logic;
		salida : out std_logic_vector(bits-1 downto 0);
		clk, reset : in std_logic);
	end component;
	
 begin
 
  registro0 : Registro
	generic map(bits =>nbits)
	port map(
		entrada => "0000000000000000",
		enable => enable0,
		salida=> salidaRegistro0,
		reset=> reset,
		clk=> clk
		);
		
	registro1 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable1,
			salida=>salidaRegistro1,
			reset=> reset,
			clk=> clk);
	registro2 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable2,
			salida=>salidaRegistro2,
			reset=> reset,
			clk=> clk);
	registro3 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable3,
			salida=>salidaRegistro3,
			reset=> reset,
			clk=> clk);
	registro4 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable4,
			salida=>salidaRegistro4,
			reset=> reset,
			clk=> clk);
	registro5 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable5,
			salida=>salidaRegistro5,
			reset=> reset,
			clk=> clk);
	registro6 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable6,
			salida=>salidaRegistro6,
			reset=> reset,
			clk=> clk);
	registro7 : Registro
		generic map(bits =>nbits)
		port map(
			entrada => datoEsc,
			enable => enable7,
			salida=>salidaRegistro7,
			reset=> reset,
			clk=> clk);

--salida de A
			with DirA select salidaA <=
			   salidaRegistro0 when "000",
				salidaRegistro1 when  "001", 
				salidaRegistro2 when  "010", 
				salidaRegistro3 when  "011",
				salidaRegistro4 when  "100",
				salidaRegistro5 when  "101",
				salidaRegistro6 when  "110",
				salidaRegistro7 when  "111",
				"0000000000000000" when others;
--salida de B
			with DirB select salidaB <=
			   salidaRegistro0 when "000",
				salidaRegistro1 when  "001", 
				salidaRegistro2 when  "010", 
				salidaRegistro3 when  "011",
				salidaRegistro4 when  "100",
				salidaRegistro5 when  "101",
				salidaRegistro6 when  "110",
				salidaRegistro7 when  "111",
				"0000000000000000" when others;
-- demultiplexor de la entrada
			enable0 <= '1' when dirEsc  = "000" else '0';
			enable1 <= '1' when dirEsc  = "001" else '0';
			enable2 <= '1' when dirEsc  = "010" else '0';
			enable3 <= '1' when dirEsc  = "011" else '0';
			enable4 <= '1' when dirEsc  = "100" else '0';
			enable5 <= '1' when dirEsc  = "101" else '0';
			enable6 <= '1' when dirEsc  = "110" else '0';
			enable7 <= '1' when dirEsc  = "111" else '0';
end behavorial;



