
--este componente va a sustituir a la ram, puesto que va a tener una ram dentro así como los registros que permiten la entrada y salida de datos desde los perifericos
DIRECCIONES:
	Display1 8001
	Display2 8002
	Display3 8003
	Display4 8004
	Boton 8005

entity interfazExteriorInterior
port(
	port (
	d_in : in std_logic_vector (15 downto 0);
	dir : in std_logic_vector (15 downto 0);
	re : in std_logic ; -- Read enable
	we : in std_logic ; -- Write enable
	d_out : out std_logic_vector (15 downto 0);
	salidaPulsador: out std_logic,
	clk : in std_logic,
	entradaBoton in: std_logic,
	salidaDiplay1: out std_logic_vector(15 downto 0),
	salidaDiplay2: out std_logic_vector(15 downto 0),
	salidaDiplay3: out std_logic_vector(15 downto 0),
	salidaDiplay4: out std_logic_vector(15 downto 0),
	);
	end interfazExteriorInterior;
	
architecture structural of interfazExteriorInterior

signal enableRamEscritura :std_logic; -- señal controlada por el multiplexor que elige si se activa  la ram para escribirla
signal enableRamLectura :std_logic; -- señal controlada por el multiplexor que elige si se activa  la ram para leerla
signal enablePerifericoEscritura: std_logic; -- señal que controla si se activan los perifericos de salida o no
signal enablePerifericoLectura: std_logic; -- señal que controla si se activan los perifericos de entrada o no
signal enableFlipFlop1,enableFlipFlop2,enableFlipFlop3,enableFlipFlop4 : std_logic; --estos enables controlan que registro se escribe y cual no
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
	component Demultiplexor4
		port(
		entrada :in std_logic;
		salida1,salida2,salida3,salida4 : out std_logic;
		selector :in std_logic_vector(1 downto 0));
	end component;
	

begin

enableRamEscritura = we and not(dir(15)); -- de esta forma se activa solo cuando la direccion es de la mitad inferior
enableRamLectura = re and dir(15);
enablePrerifericoLectura = re and not(dir(15));
enablePerifericoEscritura = we and dir(15);

	iRAM:RAM
		generic map(palabras=>64)
		port map(
			d_in =>d_in,
			dir =>dir,
			re=>enableRamLectura,
			we=>enableRamEscritura,
			d_out=>salidaRam );
			
	Multiplexor_SalidaPeriferico : Demultiplexor4		-- este demultiplexor, decide a que flip flop se va a activar
	-- las entradas y salidas son std_logics normales
		port map(
			entrada =>enablePerifericoEscritura,
			salida1 => enableFlipFlop1,
			salida2 =>enableFlipFlop2,
			salida3=>enableFlipFlop3,
			salida4=>enableFlipFlop4,
			selector =>dir(3 downto 0));
			
	--flipflops para poder almacenar la salida a los displays
	FlipFlop1:Registro
		generic map(bits=>8)
		port map(
			entrada=>d_in(7 downto 0),
			enable=>enableFlipFlop1,
			salida=>salidaDisplay1,
			clk=>clk,
			reset=>reset);
	FlipFlop2:Registro
		generic map(bits=>8)
		port map(
			entrada=>d_in(7 downto 0),
			enable=>enableFlipFlop2,
			salida=>salidaDisplay2,
			clk=>clk,
			reset=>reset);
	FlipFlop3:Registro
		generic map(bits=>8)
		port map(
			entrada=>d_in(7 downto 0),
			enable=>enableFlipFlop3,
			salida=>salidaDisplay3,
			clk=>clk,
			reset=>reset);
	FlipFlop4:Registro
		generic map(bits=>8)
		port map(
			entrada=>d_in(7 downto 0),
			enable=>enableFlipFlop4,
			salida=>salidaDisplay4,
			clk=>clk,
			reset=>reset);
	--multiplexor que elige que se saca, si la ram o la salida del pulsador
	SelectorSalida :Multiplexor2
		port map(
			entrada1 <= "000000000000000"&signalBoton,
			entrada2 <= salidaRam,
			selector <= enableRamLectura);	-- de esta forma se reutiliza una señal, se ahorra hardware y se activa solo si se activa la ram, si no saca la señal del boton
			
		)
end structural;