----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:52 06/16/2022 
-- Design Name: 
-- Module Name:    MultiDiffSz - RTL 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MultiDiffSz is
Generic(N1 :integer:=16; N2:integer:=16);
    Port ( X1 : in  STD_LOGIC_VECTOR (N1-1 downto 0);
           X2 : in  STD_LOGIC_VECTOR (N2-1 downto 0);
           F : out  STD_LOGIC_VECTOR (N1+N2-1 downto 0));
end MultiDiffSz;

architecture RTL of MultiDiffSz is
signal t_F : STD_LOGIC_VECTOR (N1+N2-1 downto 0);
begin

t_F<=std_logic_vector(signed(X1)*signed(X2));
F<=t_F(N1+N2-1) & t_F(N1+N2-3 downto 0)& '0';

end RTL;

