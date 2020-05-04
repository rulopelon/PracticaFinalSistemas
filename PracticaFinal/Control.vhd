library ieee;
use ieee.std_logic_1164.all;

entity Control is 
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
end Control;

architecture behavorial of Control is

type estado is (reset, fetch, decod,lui3, arit3, beq3,addi3,lwsw3,jalr3,arit4,addi4,lw4,sw4,lw5);
signal estado_actual, estado_siguiente : estado;
begin



VarEstado: process(clk,reset_n)
begin
	if reset_n = '0' then
	estado_actual<= reset;
	else
		if clk'event and clk = '1' then
			estado_actual <= estado_siguiente;
		end if;
	end if;
end process VarEstado;

TransicionEstados : process(estado_actual,codop)
begin
	estado_siguiente <= estado_actual;
	case estado_actual is
		when reset => 
			estado_siguiente<= fetch;
		when fetch =>  
			estado_siguiente <= decod;
		when decod => 
			if codop = "000" then 
				estado_siguiente <= arit3;
			elsif codop = "011" then
				estado_siguiente <= lui3;
			elsif codop = "110" then
				estado_siguiente <= beq3;
			elsif codop = "001" then
				estado_siguiente <= addi3;
			elsif codop = "101" then
				estado_siguiente <= lwsw3;
			elsif codop = "111" then
				estado_siguiente <= jalr3;
			elsif codop = "100" then
				estado_siguiente <= lwsw3;
			end if;
		when lui3 =>  
			estado_siguiente <= fetch;
		when arit3 => 
			estado_siguiente <= arit4;
		when beq3 => 
			estado_siguiente <= fetch;
		when addi3 => 
			estado_siguiente <= addi4;
		when lwsw3 => 
			if codop = "100" then
				estado_siguiente <= sw4;
			elsif codop = "101" then 
				estado_siguiente <= lw4;
			end if;
		when jalr3 => 
			estado_siguiente <= fetch;
		when arit4 =>  
			estado_siguiente <= fetch;
		when addi4 => 
			estado_siguiente <= fetch;
		when lw4 => 
			estado_siguiente <= lw5;
		when sw4 =>  
			estado_siguiente <= fetch;
		when lw5=>
			estado_siguiente<= fetch;
		end case;
end process;

Salida : process(estado_actual,IR)
begin
SelALUA<= '0';
SelALUB<= "00";
SelPC<= "11";
SelDirE<="11";
mux_banco<="00";
AluOp<= "0000";
en_IR<= '0';
en_ALU<= '0';
wr_PC_cond<= '0';
wr_PC<= '0';
en_Banco<= '0';
re_men_d<= '0';
wr_men_d<= '0'; 
 case estado_actual is
	when reset =>
		SelPC <= "11";
		wr_PC <= '1';
	when fetch =>
		en_IR<= '1';
		SelALUA <= '1';
		SelALUB <= "01";
		AluOp <= "0000";
		SelPC <= "01";
		wr_PC <= '1';
	when decod =>
		SelALUA <= '1';
		SelALUB <= "10";
		AluOp <= "0000";
		en_ALU <= '1';
	when lui3 =>
		mux_banco <= "11";
		SelDirE <= "10";
		en_Banco <= '1';
	when arit3 =>
		SelALUA <= '0';
		SelALUB <= "00";
		AluOp <= IR;
		en_Alu<= '1';
	when arit4=>
		mux_banco <= "00";
		SelDirE<= "00";
		en_banco<= '1';
	when beq3 =>
		SelALUA <= '0';
		SelALUB <= "00";
		AluOp <= "0001";
		SelPC<= "00";
		wr_PC_cond <= '1';
	when addi3 =>
		SelALUA <= '0';
		SelALUB <= "10";
		AluOp <= "0000";
		en_ALU <= '1';
	when addi4 => 
		mux_banco <= "00";
		SelDirE<="01";
		en_banco<= '1';
	when lwsw3 =>
		SelALUA <= '0';
		SelALUB <= "10";
		AluOp <= "0000";
		en_ALU<= '1';
	when lw4=>
		re_men_d <='1';
	when sw4=>
		wr_men_d <='1';
	when jalr3 =>
		mux_banco<= "10";
		SelDirE<="01";
		en_banco<= '1';
	   SelPC <= "10";
		wr_PC<= '1';
	when lw5=>
		mux_banco<="01";
		SelDirE<= "01";
		en_Banco<= '1';
	end case;
end process;

end behavorial;
		
		

		
		

		
		

		
	
		
	
			
			
			
