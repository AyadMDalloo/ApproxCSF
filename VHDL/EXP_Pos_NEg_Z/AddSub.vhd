----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:34:51 07/16/2022 
-- Design Name: 
-- Module Name:    AddSub - RTL 
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
use work.Pkg_Exp.all;


entity AddSub is
Generic(N:natural:=16);
    Port ( A,B     : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Control : in  STD_LOGIC;
           F       : out  STD_LOGIC_VECTOR (N-1 downto 0));
end AddSub;

architecture RTL of AddSub is
signal t_Con,t_B: STD_LOGIC_VECTOR (N-1 downto 0);
begin

	t_Con<=(others=>Control);
	t_B<=t_Con Xor B;

	U_AdderLimit1: AdderLimit Generic Map (N=>N) PORT MAP(
			R1 => A ,
			R2 => t_B,
			ci => Control,
			F => F
		);

end RTL;

