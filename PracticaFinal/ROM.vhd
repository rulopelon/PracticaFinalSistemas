-- ICAI-RiSC-16 code.
-- Archivo fuente: Micro.asm.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
  port(
    clk: in std_logic; -- La ROM es s�ncrona
    en_pc: in std_logic; -- Y tiene un enable
    dir: in std_logic_vector(15 downto 0); -- Bus de direcciones
    dat: out std_logic_vector(15 downto 0) ); -- Salida de datos
end ROM;

architecture Behavioural of ROM is
  -- Se declara un tipo de datos para albergar la memoria de programa 
  type mem_t is array (0 to 63) of std_logic_vector(15 downto 0);
  signal memoria : mem_t:= (-- Se crea la se�al memoria con el contenido
                            -- del programa.
    16#0000# => X"23bf", -- 	 addi r7, r0,63
    16#0001# => X"2083", -- 	 addi r1, r0, 3
    16#0002# => X"2103", -- 	 addi r2, r0, 3
    16#0003# => X"0530", -- 	 add  r3, r1, r2
    16#0004# => X"2204", -- 	 addi r4, r0, 4
    16#0005# => X"2282", -- 	 addi r5, r0, 2
    16#0006# => X"12c0", -- 	 add  r4, r4, r5
    16#0007# => X"0510", -- 	 add  r1,r1,r2
    16#0008# => X"ce01", -- 	 beq r3,r4,SI
    16#0009# => X"0ca1", -- 	 sub r2,r3,r1
    16#000a# => X"1612", --      SI: mul r1,r5,r4 	 
    16#000b# => X"6400",
    16#000c# => X"248e", --   	 la r1, funcion
    16#000d# => X"e700", -- 	 jalr r1,r6
    16#000e# => X"3fff", -- funcion: addi r7, r7, -1
    16#000f# => X"9f00", -- 	 sw r6, r7,0
    16#0010# => X"2304", -- 	 addi r6,r0,4
    16#0011# => X"09e2", --          mul r6,r2,r3
    16#0012# => X"0f10", -- 	 add r1, r3,r6
    16#0013# => X"bf00", -- 	 lw r6,r7,0
    16#0014# => X"f800", -- 	 jalr r6, r0
    16#0015# => X"0000",
    16#0016# => X"0000",
    16#0017# => X"0000",
    16#0018# => X"0000",
    16#0019# => X"0000",
    16#001a# => X"0000",
    16#001b# => X"0000",
    16#001c# => X"0000",
    16#001d# => X"0000",
    16#001e# => X"0000",
    16#001f# => X"0000",
    16#0020# => X"0000",
    16#0021# => X"0000",
    16#0022# => X"0000",
    16#0023# => X"0000",
    16#0024# => X"0000",
    16#0025# => X"0000",
    16#0026# => X"0000",
    16#0027# => X"0000",
    16#0028# => X"0000",
    16#0029# => X"0000",
    16#002a# => X"0000",
    16#002b# => X"0000",
    16#002c# => X"0000",
    16#002d# => X"0000",
    16#002e# => X"0000",
    16#002f# => X"0000",
    16#0030# => X"0000",
    16#0031# => X"0000",
    16#0032# => X"0000",
    16#0033# => X"0000",
    16#0034# => X"0000",
    16#0035# => X"0000",
    16#0036# => X"0000",
    16#0037# => X"0000",
    16#0038# => X"0000",
    16#0039# => X"0000",
    16#003a# => X"0000",
    16#003b# => X"0000",
    16#003c# => X"0000",
    16#003d# => X"0000",
    16#003e# => X"0000", -- 	 add r0, r0, r0
    others => X"0000"); -- Para las posiciones sin inicializar
  begin
    mem_rom: process(clk)
    begin
      if clk'event and clk = '1' then
        if en_pc = '1' then          dat <= memoria(to_integer(unsigned(dir)));
        end if;
      end if;
    end process mem_rom;
  end architecture Behavioural;
