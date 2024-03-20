----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:42 07/02/2022 
-- Design Name: 
-- Module Name:    DeMux - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Math_real.all;




entity DeMux is
generic (N: integer; M:integer);
    Port ( sel : in  STD_LOGIC_VECTOR (M-1 downto 0);
	        PN_Con : in std_logic;
           F : out  STD_LOGIC_VECTOR (N-1 downto 0));
end DeMux;

architecture RTL of DeMux is

begin
	process(sel,PN_Con)
	variable t_F1 :std_logic_vector(N-1 downto 0);
	variable idx  : STD_LOGIC_VECTOR (M-1 downto 0);
	begin
	 idx :=(others=>PN_Con);
	 t_F1:=(others=>'0');
	 idx:= idx xor sel; -----N-to_integer(unsigned(sel));
	 t_F1(to_integer(unsigned(idx))):='1';
	 if PN_Con='1' then
	    F<='0' & t_F1(N-1 downto 1);
	 else
	    F<= t_F1(N-1 downto 0) ;
	 end if;	
   end process;
end RTL;

