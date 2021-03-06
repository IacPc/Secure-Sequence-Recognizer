-------------------------------------------------------------------------------
--
-- Title       : RPCA
-- Design      : RPCA
-- Author      : Iacopo
-- Company     : Electronics_Projects
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Iacopo\Desktop\progetti Electronics\RCAdder\RPCA\src\RPCA.vhdl
-- Generated   : Sat Nov  2 16:15:48 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {RPCA} architecture {RPCA}}

library IEEE;
use IEEE.std_logic_1164.all;

entity RPCA is
	generic(Nbit : integer);
	port(
		a	: in  std_logic_vector(Nbit-1 downto 0);
		b	: in  std_logic_vector(Nbit-1 downto 0);
		cin	: in  std_logic;
		s	: out std_logic_vector(Nbit-1 downto 0);
		cout: out std_logic
	);
end RPCA;

architecture RPCA_beh of RPCA is
begin
	addition_proc: process(a,b,cin)
	variable c: std_logic;
	
	begin
		c:=cin;
		for i in 0 to Nbit-1 loop
			s(i) <= (a(i) xor b(i) xor c) ;
			c := (a(i) and b(i)) or ( c and( a(i) xor b(i) ) );
		end loop;	
	 	cout <= c;  
	end process;

end RPCA_beh ;
