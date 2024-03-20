----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:12:17 06/28/2022 
-- Design Name: 
-- Module Name:    Incx - RTL 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Incx is
Generic (Nx:integer:=16);
    Port ( a : in  STD_LOGIC_VECTOR (Nx-1 downto 0);
             H : out  STD_LOGIC_VECTOR (Nx-1 downto 0));
end Incx;

architecture RTL of Incx is
--signal t_b:std_logic_vector(Nx-1 downto 0);
begin
--t_b<=(0=>'1',others=>'0');

H<=std_logic_vector(to_signed(to_integer(signed(a))+1,Nx));

end RTL;

