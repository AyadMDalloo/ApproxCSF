----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:09 06/17/2022 
-- Design Name: 
-- Module Name:    Sub_ker - RTL 
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


entity Sub_ker is
Generic(N_Sub:natural:=16);
    Port ( A : in  STD_LOGIC_VECTOR (N_Sub-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N_Sub-1 downto 0);
           S : out  STD_LOGIC_VECTOR (N_Sub-1 downto 0));
end Sub_ker;

architecture RTL of Sub_ker is

begin
S<=std_logic_vector(signed(A)-signed(B));

end RTL;

