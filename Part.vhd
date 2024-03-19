----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:47:59 09/12/2022 
-- Design Name: 
-- Module Name:    Part1 - RTL 
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
use work.Pkg_Exp.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Part is
Generic (Nc:integer:=16;Nd:integer:=6);
    Port ( zi : in  STD_LOGIC_VECTOR (Nc-1 downto 0);---s4.11
           Ni : in  STD_LOGIC_VECTOR (Nd-1 downto 0);--s10.0
           clk,rst : in  STD_LOGIC;
           zo : out  STD_LOGIC_VECTOR (Nc-1 downto 0);
           No : out  STD_LOGIC_VECTOR (Nd-1 downto 0));
end Part;

architecture RTL of Part is


begin
U_Regz: Reg Generic Map(N=>Nc) PORT MAP(
		d => zi,
		rst => rst,
		CE => '1',
		clk => clk,
		q =>zo
	);

U_RegN: Reg Generic Map(N=>Nd) PORT MAP(
		d => Ni,
		rst => rst,
		CE => '1',
		clk => clk,
		q => No
	);
	

end RTL;

