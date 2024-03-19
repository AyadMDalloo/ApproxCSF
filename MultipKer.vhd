----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:18 06/04/2022 
-- Design Name: 
-- Module Name:    MultipKer - RTL 
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


entity MultipKer is
Generic(N_Mulker:natural:=16);
    Port ( X1 : in  STD_LOGIC_VECTOR (N_Mulker-1 downto 0);
           X2 : in  STD_LOGIC_VECTOR (N_Mulker-1 downto 0);
           F : out  STD_LOGIC_VECTOR (2*N_Mulker-1 downto 0));
end MultipKer;

architecture RTL of MultipKer is
signal t_F : STD_LOGIC_VECTOR (2*N_Mulker-1 downto 0);
begin

t_F<=std_logic_vector(signed(X1)*signed(X2));
F<=t_F(2*N_Mulker-1) & t_F(2*N_Mulker-3 downto 0)& '0';
end RTL;

