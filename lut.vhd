-------------------------------------------------------------------------------
--
-- Title       : LUT
-- Design      : DDFS
-- Author      : Iacopo
-- Company     : Electronics_Projects
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\Iacopo\Desktop\progetti Electronics\DDFS\DDFS\src\LUT.vhd
-- Generated   : Wed Nov 13 15:19:01 2019
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
--{entity {LUT} architecture {LUT}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity LUT is  
	generic(
		M_DATA : integer
	);
	port(
		 address : in STD_LOGIC_VECTOR(N_ADD-1 downto 0);
		 data : out STD_LOGIC_VECTOR(M_DATA-1 downto 0)
	     );
end LUT;

--}} End of automatically maintained section

architecture LUT_beh of LUT is	  
	
   		type lut_t is array(0 to 4) of std_logic_vector(M_DATA-1 downto 0) ;
	    
		constant lut : lut_t := ("00000000",
					 "00000001",
					 "00000010",
					 "00000011",
					 "00000100");

		 	
		begin
	 	data<=lut(TO_INTEGER(unsigned(address)));
		
end LUT_beh;
