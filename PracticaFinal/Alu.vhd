library ieee;
use ieee.std_logic_1164.all;

entity ALU is
generic(
	bits : integer:= 5);
port(
	a,b :in std_logic_vector(bits-1 downto 0);
	salida :out std_logic_vector(bits-1 downto 0);
	ov,z,co: out std_logic;
	opAlu: in std_logic_vector(3 downto 0));
end ALU;

architecture structural of ALU is
signal resultComparadorCompleto,resultDespIzq,resultDespDerArit,resultDespDerLog,resultOpNAND,resultSumadorRestador,resultMutiplicacionSin,resultMultiplicacionCon: std_logic_vector(bits-1 downto 0);
signal resultComparador : std_logic;
signal SumaResta : std_logic;
signal ceros: std_logic_vector(bits-2 downto 0); --tiene que tener un bit menos que la salida
signal overflowSuma,coSuma,zSuma,zMultiCon,zMultiSin: std_logic;
signal overflowMultiSin, overflowMultiCon : std_logic;

begin 
	--se pone la señal de ceros a cero
	ceros <= (others => '0');
	zMultiCon<= '0';
	zMultiSin<= '0';
	
	Comparador: entity work.SLTU
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		salida=> resultComparador);
	
	
	resultComparadorCompleto <= ceros &resultComparador;
	
	
	DesplazadorIzquierda: entity work.DespIzq
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		salida=> resultDespIzq);
	
	
	DesplazadorDerechaArit: entity work.DespDerArit
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		salida=> resultDespDerArit);
	
		
	DesplazadorDerechaLogico: entity work.DespDerLog
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		salida=> resultDespDerLog);
	
	
	NANDificador: entity work.OperadorNAND
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		salida=> resultOpNAND);

	
	--cogemos el bit menos significativo de opAlu
	SumaResta<= opAlu(0);
	
	SumRest: entity work.SumadorRestador
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		ov=> overflowSuma,
		z=>zSuma,
		co=> coSuma,
		sn_r=>SumaResta,
		salida=> resultSumadorRestador);
	
	
	MultiplicacionSin: entity work.MultiSin
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		ov=> overflowMultiSin,
		salida=> resultMutiplicacionSin);

	
	MultiplicacionCon: entity work.MultiCon
	generic map(
		bits => bits)
	port map(
		a => a,
		b => b,
		ov=> overflowMultiCon,
		salida=> resultMultiplicacionCon);

		
	--se elige la salida que se quiere ejecutar
	with opAlu select salida <=
		resultSumadorRestador when "0000",
		resultSumadorRestador when "0001",
		resultMultiplicacionCon when "0010",
		resultMutiplicacionSin when "0011",
		resultOpNAND when "0100",
		resultDespIzq when "0101",
		resultDespDerArit when "0110",
		resultDespDerLog when "0111",
		resultComparadorCompleto when "1000",
		(others=>'0') when others;
	 with opAlu select ov <=
		overflowSuma when "0000",
		overflowSuma when "0001",
		overflowMultiCon when "0010",
		overflowMultiSin when "0011",
		'0' when others;
	with opAlu select z <= 
		zSuma when "0000",
		zSuma when "0001",
		zMultiCon when "0010",
		zMultiSin when "0011",
		'0' when others;
	with opAlu select co <= 
		coSuma when "0000",
		coSuma when "0001",
		'0' when others;
	
	
		
end structural;
	
	
		

