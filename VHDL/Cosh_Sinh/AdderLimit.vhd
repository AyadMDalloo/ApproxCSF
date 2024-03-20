----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:37:42 06/04/2022 
-- Design Name: 
-- Module Name:    AdderKer - RTL 
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


entity AdderLimit is
Generic(N:natural:=16);
    Port ( R1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           R2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  ci : in  std_logic;
           F : out  STD_LOGIC_VECTOR (N-1 downto 0));
end AdderLimit;

architecture RTL of AdderLimit is
signal t_ci :STD_LOGIC_VECTOR (N-1 downto 0);
begin
t_ci<=(0=>ci,others=>'0');
F<=std_logic_vector(signed(R1)+signed(R2)+signed(t_ci));

end RTL;

