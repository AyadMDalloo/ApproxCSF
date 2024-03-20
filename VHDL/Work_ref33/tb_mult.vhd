--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:44:50 08/08/2022
-- Design Name:   
-- Module Name:   H:/Current Work/Library Cordic/ipcore/tb_mult.vhd
-- Project Name:  ipcore
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MultipKer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Math_real.all;
use work.Pkg_Exp.all;  
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_mult IS
END tb_mult;
 
ARCHITECTURE behavior OF tb_mult IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MultipKer
    PORT(
         X1 : IN  std_logic_vector(15 downto 0);
         X2 : IN  std_logic_vector(15 downto 0);
         F : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal X1 : std_logic_vector(15 downto 0) := (others => '0');
   signal X2 : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal F : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant D_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MultipKer PORT MAP (
          X1 => X1,
          X2 => X2,
          F => F
        );

-- 
 

   -- Stimulus process
   stim_proc: process
   begin		
	 X1<=frac2bin(1.0059,N,2);
	 X2<=frac2bin(0.012,N,2);
      -- hold reset state for 100 ns.
      wait for D_period*10;
assert false report " F= " & to_stringR(bin2frac(F,2*N,4),2*N,4) severity warning; 
      -- insert stimulus here 

      wait;
   end process;

END;
