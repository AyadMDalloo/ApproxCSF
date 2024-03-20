----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:04 03/01/2016 
-- Design Name: 
-- Module Name:    Regsiter_FA - Behavioral 
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



entity Reg is
Generic(N: integer:=16);
    Port ( d   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rst,CE : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           q   : out STD_LOGIC_VECTOR (N-1 downto 0));
end Reg;

architecture rtl of Reg is

begin
    process (clk,rst)
    begin
       if (rst ='1') then
           q <= (others=>'0');
       elsif rising_edge(clk) then
		     if (CE='1') then
               q <= d;
			  end if;
       end if;
    end process;
end rtl;


