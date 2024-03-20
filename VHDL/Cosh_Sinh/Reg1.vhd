----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:43:02 07/09/2022 
-- Design Name: 
-- Module Name:    Reg1 - RTL 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg1 is
    Port ( d : in  STD_LOGIC;
           clk,rst : in  STD_LOGIC;
           q : out  STD_LOGIC);
end Reg1;

architecture RTL of Reg1 is

begin
      process (clk,rst)
    begin
       if rising_edge(clk) then
			if (rst ='1') then
				q <= '0';
			else	  
				q <= d;
			end if;
		 end if;
    end process;

end RTL;

