library ieee;
USE ieee.std_logic_1164.all;

entity PracticaFinal is 
generic(bits:integer:=16);
port(
	clk : in std_logic;
	reset: in std_logic;
	entradaNumero: in std_logic_vector(7 downto 0);
	salidaDisplays: out std_logic_vector(15 downto 0);
	Digito1,Digito2,Digito3,Digito4,Digito5,Digito6,Digito7,Digito8: out std_logic); --para saber cual de las pantalla encender
end PracticaFinal;
architecture structural of PracticaFinal is 

signal salidaDisplay1,salidaDisplay2,salidaDisplay3,salidaDisplay4: std_logic_vector(7 downto 0);

	component Display16Seg is 
	port(
		salidaSegmento: out std_logic_vector(16 downto 0);
		Digito1,Digito2,Digito3,Digito4,Digito5,Digito6,Digito7,Digito8: out std_logic;
		entrada1,entrada2,entrada3,entrada4,entrada5,entrada6,entrada7,entrada8 : in std_logic_vector(7 downto 0);
		clock,reset: in std_logic);
	end component;
	
	component Micro2 is
	generic(bits:integer:=16);
	port(
		clk : in std_logic;
		reset: in std_logic;
		entradaNumero: in std_logic_vector(7 downto 0);
		salidaDisplay1, salidaDisplay2, salidaDisplay3, salidaDisplay4: out std_logic_vector(7 downto 0)
		); --entradas de los switches del periferico
	end component;
	--signal salidaSegmento,Digito1,Digito2,Digito3,Digito4,Digito5,Digito6,Digito7,Digito8:std_logic;
	

begin 


	Disp : Display16Seg
		port map(
			salidaSegmento=> salidaDisplays,
			Digito1=>Digito1,
			Digito2=>Digito2,
			Digito3=> Digito3,
			Digito4=>Digito4,
			Digito5=>Digito5,
			Digito6=>Digito6,
			Digito7=>Digito7,
			Digito8=>Digito8,
			entrada1=>salidaDisplay1,
			entrada2=>salidaDisplay2,
			entrada3=>salidaDisplay3,
			entrada4=>salidaDisplay4,
			entrada5=>"--------",		-- se dejan vacios ya que solo queremos mostrar cuatro numeros
			entrada6=>"--------",
			entrada7=>"--------",
			entrada8=>"--------",
			clock => clk,
			reset => reset);
	Micro: Micro2
		generic map (bits=>16)
		port map(
			clk=>clk,
			reset=> reset,
			entradaNumero=>entradaNumero,
			salidaDisplay1=>salidaDisplay1,
			salidaDisplay2=>salidaDisplay2,
			salidaDisplay3=>salidaDisplay3,
			salidaDisplay4=>salidaDisplay4);
	

end structural;