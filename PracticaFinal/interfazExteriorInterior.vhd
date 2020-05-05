library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--este componente va a sustituir a la ram, puesto que va a tener una ram dentro así como los registros que permiten la entrada y salida de datos desde los perifericos
--DIRECCIONES:
--	Display1 8001
--	Display2 8002
--	Display3 8003
--	Display4 8004
--	Boton 8005
-- numeros 8006

entity interfazExteriorInterior is 
	port (
		d_in : in std_logic_vector (15 downto 0);
		dir : in std_logic_vector (15 downto 0);
		re : in std_logic ; -- Read enable
		we : in std_logic ; -- Write enable
		d_out : out std_logic_vector (15 downto 0);
		clk : in std_logic;
		entradaBoton :in std_logic;
		entradaNumero :in std_logic_vector(7 downto 0);
		mierda: out std_logic_vector(7 downto 0);
		mierda1: out std_logic_vector(7 downto 0);
		mierda2: out std_logic_vector(7 downto 0);
		mierda3: out std_logic_vector(7 downto 0)
	);
	end interfazExteriorInterior;
	
architecture structural of interfazExteriorInterior is

signal enableRamEscritura :std_logic; -- señal controlada por el multiplexor que elige si se activa  la ram para escribirla
signal enableRamLectura :std_logic; -- señal controlada por el multiplexor que elige si se activa  la ram para leerla
signal enablePerifericoEscritura: std_logic; -- señal que controla si se activan los perifericos de salida o no
signal enablePerifericoLectura: std_logic; -- señal que controla si se activan los perifericos de entrada o no
signal salidaRam : std_logic_vector(15 downto 0);

	component RAM 
	generic( palabras: integer:= 64);
	port (
		d_in : in std_logic_vector (15 downto 0);
		dir : in std_logic_vector (15 downto 0);
		re : in std_logic ; -- Read enable
		we : in std_logic ; -- Write enable
		d_out : out std_logic_vector (15 downto 0);
		salidaDiplay1 :out std_logic_vector(7 downto 0));
	end component;
	
	component Decodificador2 
	port(
		salida1,salida2 : out std_logic;
		selector :in std_logic);
	end component;
	
begin
	iRAM:RAM
		generic map(palabras=>64)
		port map(
			d_in =>d_in,
			dir =>dir,
			re=>enableRamLectura,
			we=>enableRamEscritura,
			d_out=>salidaRam );
			
	asignacion:process(clk)
		begin
		if clk'event and clk = '1' then --flanco de subida 
			if dir <= "8000" and we = '1' then 		-- en el caso de que se quiera escribir un dato, tanto de salida como en la ram
				enableRamEscritura<= '1';
			elsif dir = "8001" and we = '1' then 
				salidaDisplay1 <= d_in(7 downto 0);
			elsif dir = "8002" and we = '1' then
				salidaDisplay1 <= d_in(7 downto 0);
			elsif dir = "8003" and we = '1' then 
				salidaDisplay1 <= d_in(7 downto 0);
			elsif dir = "8004" and we = '1' then
				salidaDisplay1 <= d_in(7 downto 0);
			elsif dir = "8001" and we = '1' then 
				salidaDisplay1 <= d_in(7 downto 0);
			elsif dir<= "8000" and re = '1' then 
				enableRamLectura <= '1';
			end if;
		end if;
	end process asignacion;
	
	process(dir,re)
		begin
		if dir <= "8000" and re ='1' then 
			d_out<= salidaRam;
		elsif dir = "8005" and re = '1' then 
			d_out <= "000000000000000"&entradaBoton;
		elsif dir = "8006" and re = '1' then 
			d_out <= "00000000"&entradaNumero;
		end if;
	end process;

end structural;