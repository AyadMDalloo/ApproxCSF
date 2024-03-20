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
           F : out  STD_LOGIC_VECTOR (N-1 downto 0));
end DeMux;

architecture RTL of DeMux is

begin
	process(sel)
	variable t_F1 :std_logic_vector(N-1 downto 0);
	variable idx  : STD_LOGIC_VECTOR (M-1 downto 0);
	begin
	 t_F1:=(others=>'0');
	 idx:= sel; -----N-to_integer(unsigned(sel));
	 t_F1(to_integer(unsigned(idx))):='1';
	 F<= t_F1(N-1 downto 0);
		
   end process;
end RTL;

