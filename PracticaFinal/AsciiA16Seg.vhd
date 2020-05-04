-- Decodificador para un display alfanumérico de 16 segmentos.
-- Se codifica la tabla de conversión ASCII a 16 segmentos + punto decimal
-- Mediante una memoria ROM.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity AsciiA16Seg is
  port (
    clk : in  std_logic;
    e   : in  std_logic_vector(7 downto 0);    -- Entrada en ASCII
    s   : out std_logic_vector(16 downto 0));  -- Salida (16 segmentos)
                                               -- el bit 0 es el segmento A
end AsciiA16Seg;

architecture behavioural of AsciiA16Seg is
  type mem_t is array (0 to 255) of std_logic_vector(16 downto 0);
  signal memoria : mem_t := (
    16#01# => X"FFFF"&'1',              -- Todos encendidos
    16#20# => X"0000"&'0',              -- Espacio
    16#21# => X"3000"&'1',              -- !
    16#22# => X"2040"&'0',              -- "
    16#23# => X"0355"&'0',              -- #
    16#24# => X"DD55"&'0',              -- $
    16#25# => X"9977"&'0',              -- %
    16#26# => X"8EC9"&'0',              -- &
    16#27# => X"0040"&'0',              -- '
    16#28# => X"0028"&'0',              -- (
    16#29# => X"0082"&'0',              -- )
    16#2A# => X"00FF"&'0',              -- *
    16#2B# => X"0055"&'0',              -- +
    16#2C# => X"0002"&'0',              -- , ¡Ojo, he puesto la coma abajo al
                                        -- reves de la tabla!
    16#2D# => X"0011"&'0',              -- -
    16#2E# => X"0000"&'1',              -- .
    16#2F# => X"0022"&'0',              -- /

    16#30# => X"FF22"&'0',              -- 0
    16#31# => X"3020"&'0',              -- 1
    16#32# => X"EE11"&'0',              -- 2
    16#33# => X"FC10"&'0',              -- 3
    16#34# => X"3111"&'0',              -- 4
    16#35# => X"DD11"&'0',              -- 5
    16#36# => X"9F11"&'0',              -- 6
	 16#37# => X"F018"&'0',              -- 7
	 16#38# => X"FF18"&'0',              -- 8
    16#39# => X"F118"&'0',              -- 9
    -- A rellenar por el alumno.
    16#3D# => X"0C11"&'0',              -- =
    16#3E# => X"0092"&'0',              -- >
    16#3F# => X"E014"&'1',              -- ?

    16#40# => X"EF30"&'0',              -- @
    -- A rellenar por el alumno.
	 16#41# => X"7989"&'0',             -- A
    16#42# => X"FC54"&'0',              -- B
    16#43# => X"CF00"&'0',              -- C
    16#44# => X"FC44"&'0',              -- D
    16#45# => X"CF01"&'0',              -- E
    16#46# => X"C301"&'0',              -- F
    16#47# => X"DF10"&'0',              -- G
    16#48# => X"3311"&'0',              -- H
    16#49# => X"CC44"&'0',              -- I 
    16#4A# => X"3E00"&'0',              -- J
    16#4B# => X"0329"&'0',              -- K
    16#4C# => X"0F00"&'0',              -- L
    16#4D# => X"33A0"&'0',              -- M
    16#4E# => X"3388"&'0',              -- N
    16#4F# => X"FF00"&'0',              -- O

    16#50# => X"E311"&'0',              -- P
    16#51# => X"FF08"&'0',              -- Q
    16#52# => X"E319"&'0',              -- R
    16#53# => X"DD11"&'0',              -- S
    16#54# => X"C044"&'0',              -- T
    16#55# => X"3F00"&'0',              -- U
    16#56# => X"0322"&'0',              -- V
    16#57# => X"330A"&'0',              -- W
    16#58# => X"00AA"&'0',              -- X
    16#59# => X"2115"&'0',              -- Y
    16#5A# => X"CC22"&'0',              -- Z
    16#5B# => X"4844"&'0',              -- [
    16#5C# => X"0088"&'0',              -- \
    16#5D# => X"8444"&'0',              -- ]
    16#5E# => X"000A"&'0',              -- ^
    16#5F# => X"0C00"&'0',              -- _

    16#60# => X"0080"&'0',              -- `
    16#61# => X"0E05"&'0',              -- a (He cambiado un segmento)
    16#62# => X"0705"&'0',              -- b
    16#63# => X"0601"&'0',              -- c
    16#64# => X"0645"&'0',              -- d
    16#65# => X"0E03"&'0',              -- e
    16#66# => X"4055"&'0',              -- f
    16#67# => X"8545"&'0',              -- g
    16#68# => X"0305"&'0',              -- h
    16#69# => X"0004"&'0',              -- i
    16#6A# => X"0644"&'0',              -- j
    16#6B# => X"006C"&'0',              -- k
    16#6C# => X"0844"&'0',              -- l (He añadido un segmento abajo)
    16#6D# => X"1215"&'0',              -- m
    16#6E# => X"0205"&'0',              -- n
    16#6F# => X"0605"&'0',              -- o

    16#70# => X"8341"&'0',              -- p
    16#71# => X"8145"&'0',              -- q
    16#72# => X"0201"&'0',              -- r
    16#73# => X"8505"&'0',              -- s
    16#74# => X"0055"&'0',              -- t
    16#75# => X"0604"&'0',              -- u
    16#76# => X"0202"&'0',              -- v
    16#77# => X"120A"&'0',              -- w
    16#78# => X"00AA"&'0',              -- x
    16#79# => X"00A4"&'0',              -- y
    16#7A# => X"0403"&'0',              -- z
    16#7B# => X"4845"&'0',              -- {
    16#7C# => X"0300"&'0',              -- |
    16#7D# => X"8454"&'0',              -- }
    16#7E# => X"01A0"&'0',              -- ~ (He añadido un segmento)
    16#7F# => X"0000"&'0',              -- DEL (se deja en blanco)
    
    others => X"0000"&'0');             -- El resto de códigos dejan el display
                                        -- apagado.
  
  signal s_i : std_logic_vector(16 downto 0);
  
begin  -- behavioural

  mem_rom : process(clk)
  begin
    if clk'event and clk = '1' then
      s_i <= memoria(to_integer(unsigned(e)));
    end if;
  end process mem_rom;

  -- La tabla en la memoria ROM se ha generado con el segmento A en el bit
  -- más significativo, pero en el circuito el segmento A está en el bit menos
  -- significativo, por lo que es necesario darle la vuelta a los bits:
  s(0)  <= s_i(16);
  s(1)  <= s_i(15);
  s(2)  <= s_i(14);
  s(3)  <= s_i(13);
  s(4)  <= s_i(12);
  s(5)  <= s_i(11);
  s(6)  <= s_i(10);
  s(7)  <= s_i(9);
  s(8)  <= s_i(8);
  s(9)  <= s_i(7);
  s(10) <= s_i(6);
  s(11) <= s_i(5);
  s(12) <= s_i(4);
  s(13) <= s_i(3);
  s(14) <= s_i(2);
  s(15) <= s_i(1);
  s(16) <= s_i(0);
  
end behavioural;