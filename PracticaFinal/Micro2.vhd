library ieee;
use ieee.std_logic_1164.all;

entity Micro2 is 
generic(bits:integer:=16);
port(
	clk : in std_logic;
	reset: in std_logic;
	entradaPeriferico1,entradaPeriferico2,entradaPeriferico3,entradaPeriferico4,entradaPeriferico5,entradaPeriferico6,entradaPeriferico7,entradaPeriferico8: in std_logic; --entradas de los switches del periferico
	salidaDisplay1,salidaDisplay2,salidaDisplay3,salidaDisplay4 : out std_logic_vector(7 downto 0));
	end Micro2;
architecture structural of Micro2 is

signal op_ALU: std_logic_vector(3 downto 0);
signal Mux_PC,Mux_Banco,selDirE,SelALUB: std_logic_vector(1 downto 0);
signal salida_mux_selDirE,codop:std_logic_vector(2 downto 0);
signal wr_PC,ena_IR,ena_Banco,ena_ALU,wr_mem_d,rd_mem_d,z,ov,co,wr_PC_cond,SelALUA: std_logic;
signal PC,SAlu,salida_mux_pc,salida_pc,salida_rom,salida_ir,salida_mux_banco,salida_mux_ALUA,salida_mux_ALUB,RegA,RegB,MDatos,ALUOut:std_logic_vector(15 downto 0);
signal enPc : std_logic;
signal aux2 : std_logic_vector(15 downto 0);
signal aux1 : std_logic_vector(15 downto 0);
signal irControl: std_logic_vector(3 downto 0);
signal enableRam :std_logic; -- señal controlada por el multilpexor que elige si se activa  la ram 
signal enablePeriferico: std_logic; -- señal controlada por el multilpexor que elige si se activa  el periferico
signal enableFlipFlop1,enableFlipFlop2,enableFlipFlop3,enableFlipFlop4 : std_logic; --estos enables controlan que registro se escribe y cual no
signal signalPeriferico: std_logic_vector(15 downto 0);
signal salidaMultiplexorperiferico: std_logic_vector(15 downto 0); 	--señal que contiene lo que entra en vez de Mdatos

	component ALU
	generic(
	bits : integer:= 5);
	port(
	a,b :in std_logic_vector(bits-1 downto 0);
	salida :out std_logic_vector(bits-1 downto 0);
	ov,z,co: out std_logic;
	opAlu: in std_logic_vector(3 downto 0));
	end component;
	
	component ROM
	port(
    clk: in std_logic; -- La ROM es síncrona
    en_pc: in std_logic; -- Y tiene un enable
    dir: in std_logic_vector(15 downto 0); -- Bus de direcciones
    dat: out std_logic_vector(15 downto 0) ); -- Salida de datos
	end component;
	
	component Registro 
	generic(bits : integer:= 16);
	port(
	entrada : in std_logic_vector(bits-1 downto 0);
	enable:in  std_logic;
	salida : out std_logic_vector(bits-1 downto 0);
	clk,reset : in std_logic);
	end component;
	
	component RAM 
	generic( palabras: integer:= 64);
	port (
	d_in : in std_logic_vector (15 downto 0);
	dir : in std_logic_vector (15 downto 0);
	re : in std_logic ; -- Read enable
	we : in std_logic ; -- Write enable
	d_out : out std_logic_vector (15 downto 0));
	end component;
	
	component Multiplexor4 
	generic(bits: integer:= 16);
	port(
	entrada1,entrada2,entrada3,entrada4 :in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0);
	selector :in std_logic_vector(1 downto 0));
	end component;
	
	component Multiplexor2 
	generic(
	bits : integer:= 16);
	port(
	entrada1,entrada2:in std_logic_vector(bits-1 downto 0);
	salida : out std_logic_vector(bits-1 downto 0);
	selector :in std_logic);
	end component;
	
	component Control
	port(
		reset_n : in std_logic;
		clk:in std_logic;
		SelALUA:out std_logic;
		codop : in std_logic_vector(2 downto 0);
		en_IR,en_ALU,wr_PC_cond,wr_PC,en_Banco,re_men_d,wr_men_d : out std_logic;
		IR : in std_logic_vector(3 downto 0);
		AluOp : out std_logic_vector(3 downto 0);
		SelALUB,SelPC, SelDirE, mux_banco: out std_logic_vector(1 downto 0)
		);
	end component;
	
	component BancoRegistros 
	generic(nbits : integer:= 16);
	port(
		DirB,DirA : in std_logic_vector(2 downto 0);
		clk,reset : in std_logic;
		dirEsc: in std_logic_vector(2 downto 0);
		enable : in std_logic;
		datoEsc : in std_logic_vector(nbits-1 downto 0);
		salidaA: out std_logic_vector(nbits-1 downto 0);
		salidaB: out std_logic_vector(nbits-1 downto 0));
		
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

enPc <=wr_PC or (wr_PC_cond and z);
PC <= "0000000000000000";
signalPeriferico<= "00000000" &entradaPeriferico1 & entradaPeriferico2 &entradaPeriferico3 &entradaPeriferico4 &entradaPeriferico5 &entradaPeriferico6 &entradaPeriferico7 & entradaPeriferico8;

irControl<= salida_ir(3 downto 0);
	Muliplexor_PC:Multiplexor4
		generic map(bits=>bits)
		port map(
			entrada1=>AluOut,
			entrada2=>sAlu,
			entrada3=>RegA,
			entrada4=>"0000000000000000",
			selector=>Mux_PC,
			salida=>salida_mux_pc);
	iPC:Registro
		generic map(bits=>bits)
		port map(
			entrada=>salida_mux_pc,
			enable=>enPc,
			salida=>salida_pc,
			clk=>clk,
			reset=>reset);
	iROM:ROM
	port map(
	    clk=>clk, -- La ROM es síncrona
		 en_pc => enPc,
		 dir=>salida_mux_pc, -- Bus de direcciones
		 dat=>salida_rom); -- Salida de datos
	
	iIR:Registro
		generic map(bits=>bits)
		port map(
			entrada=>salida_rom,
			enable=>ena_IR,
			salida=>salida_ir,
			clk=>clk,
			reset=>reset);	

	aux2 <= salida_ir(9 downto 0)& "000000";
	
	Multiplexor_Banco:Multiplexor4
		generic map(bits=>bits)
		port map(
			entrada1=>AluOut,
			entrada2=>Mdatos,
			entrada3=>PC,
			entrada4=>aux2,
			selector=>Mux_Banco,
			salida=>salida_mux_banco);
	
	Multiplexor_SelDirE: Multiplexor4
		generic map(bits=>3)
		port map(
			entrada1=>salida_ir(6 downto 4),
			entrada2=>salida_ir(9 downto 7),
			entrada3=>salida_ir(12 downto 10),
			entrada4=>"000",
			selector=>selDirE,
			salida=>salida_mux_selDirE);
	iBancoRegistros:BancoRegistros
	generic map(nbits=>bits)
	port map(
		DirA=>salida_ir(12 downto 10),
		DirB=>salida_ir(9 downto 7),
		clk=>clk,
		reset=>reset,
		dirEsc=>salida_mux_selDirE,
		enable=>ena_Banco,
		datoEsc=>salida_mux_banco,
		salidaA=>RegA,
		salidaB=>RegB);
	Multiplexor_SelAlUA: Multiplexor2
		generic map(bits=>bits)
		port map(
		entrada1=>RegA,
		entrada2=>salida_pc,
		salida=>salida_mux_ALUA,
		selector=>SelALUA);
		
		aux1 <= salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6) &salida_ir(6 downto 0);
		
	Multiplexor_SelALUB: Multiplexor4
		generic map(bits=>bits)
		port map(
			entrada1=>RegB,
			entrada2=> "0000000000000001",
			entrada3=>aux1,
			entrada4=>"0000000000000000",
			selector=>SelALUB,
			salida=>salida_mux_ALUB);
	iALU: Alu
		generic map(bits=>bits)
		port map(
			a=>salida_mux_ALUA,
			b=>salida_mux_ALUB,
			salida=>SAlu,
			ov=>ov,
			z=>z,
			co=>co,
			opAlu=>op_ALU);
	iReg:Registro
		generic map(bits=>bits)
		port map(
			entrada=>SAlu,
			enable=>ena_ALU,
			salida=>ALUOut,
			clk=>clk,
			reset=>reset);
	iRAM:RAM
		generic map(palabras=>64)
		port map(
			d_in =>RegB,
			dir =>ALUOut,
			re=>rd_mem_d,
			we=>wr_mem_d,
			d_out=>Mdatos );
			
	codop <= salida_ir(15 downto 13);
	iControl:Control
		port map(
			reset_n=>reset,
			clk =>clk,
			codop=>codop,
			en_IR=>ena_IR,
			en_ALU=> ena_ALU,
			wr_PC_cond=>wr_PC_cond,
			wr_PC=>wr_PC,
			en_Banco=>ena_Banco,
			re_men_d=>rd_mem_d,
			wr_men_d=>wr_mem_d,
			IR=>irControl,
			AluOp=>op_ALU,
			SelALUA=>SelALUA,
			SelALUB=>SelALUB,
			SelPC=>Mux_PC,
			SelDirE=>SelDirE,
			mux_banco=>Mux_Banco);
	

end structural;