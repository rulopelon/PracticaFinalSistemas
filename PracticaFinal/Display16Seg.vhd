library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display16Seg is 
	port(
		salidaSegmento: out std_logic_vector(16 downto 0);
		Digito1,Digito2,Digito3,Digito4,Digito5,Digito6,Digito7,Digito8: out std_logic;
		entrada1,entrada2,entrada3,entrada4,entrada5,entrada6,entrada7,entrada8 : in std_logic_vector(7 downto 0);
		clock,reset: in std_logic);
	end Display16Seg;
	
architecture structural of Display16Seg is
--declaracion de todas la señales necesarias
component Multiplexor
	port(
		entrada1,entrada2,entrada3,entrada4,entrada5,entrada6,entrada7,entrada8 :in std_logic_vector(7 downto 0);
		salida : out std_logic_vector(7 downto 0);
		selector :in std_logic_vector(2 downto 0));
	end component;
	
component ContadorMod8
	port(
		enable, reset, clock : in std_logic;
		salida:out std_logic_vector(2 downto 0));
	end component;
component AsciiA16Seg
  port (
    clk : in  std_logic;
    e   : in  std_logic_vector(7 downto 0);    -- Entrada en ASCII
    s   : out std_logic_vector(16 downto 0));  -- Salida (16 segmentos)
                                               -- el bit 0 es el segmento A
	end component;
component ContadorEspera 
port(
	salidaEnable :out std_logic;
	reset,clock : in std_logic);
end component;
component Decodificador 
port(
	numeroEntrada : in std_logic_vector(2 downto 0);
	salidaActivacion1,salidaActivacion2,salidaActivacion3,salidaActivacion4,salidaActivacion5,salidaActivacion6,salidaActivacion7,salidaActivacion8: out std_logic);
	
	end component;
	
signal contador : std_logic_vector(2 downto 0); 
signal salida_multiplexor: std_logic_vector(7 downto 0);
signal salidaContEspera: std_logic;


begin
	multi: Multiplexor
		port map(
			entrada1=> entrada1,
			entrada2=> entrada2,
			entrada3=>entrada3,
			entrada4=>entrada4,
			entrada5=>entrada5,
			entrada6=>entrada6,
			entrada7=>entrada7,
			entrada8=> entrada8,
			salida => salida_multiplexor,
			selector=> contador);
	deco: Decodificador
		port map(
			numeroEntrada=> contador,
			salidaActivacion1=>Digito1,
			salidaActivacion2=>Digito2,
			salidaActivacion3=>Digito3,
			salidaActivacion4=>Digito4,
			salidaActivacion5=>Digito5,
			salidaActivacion6=>Digito6,
			salidaActivacion7=>Digito7,
			salidaActivacion8=>Digito8);
	Cont8 : ContadorMod8
		port map(
			enable => salidaContEspera,
			reset => reset,
			clock=>clock,
			salida=> contador);
	ContEsp: ContadorEspera
		port map(
			reset=>reset,
			clock =>clock,
			salidaEnable=>salidaContEspera);
	Ascii: AsciiA16Seg
		port map(
			clk => clock,
			s =>salidaSegmento,
			e =>salida_multiplexor);

end structural;
