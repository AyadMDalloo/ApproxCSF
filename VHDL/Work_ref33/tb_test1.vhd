--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:24:02 08/06/2022
-- Design Name:   
-- Module Name:   H:/codes/VHDL/Library Cordic/ipcore/tb_test1.vhd
-- Project Name:  ipcore
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Exp_z_org
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

USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_test1 IS
END tb_test1;
 
ARCHITECTURE behavior OF tb_test1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Exp_z_org
    PORT(
         z : IN  std_logic_vector(15 downto 0);
--			Ni   : out   std_logic_vector(2*Nint downto 0);
--			r    : out   std_logic_vector(N-1 downto 0);
--			mo    : out   std_logic_vector(2*Nint downto 0);
--			j    : out   std_logic_vector(4 downto 0);
--			Zn ,F1,F2 ,r2 : out  std_logic_vector(N-1 downto 0);
--	      X,Y : out   STD_LOGIC_VECTOR (N-1 downto 0);
         rfd :out std_logic;
         clk ,ce: IN  std_logic;
         rst : IN  std_logic;
			QF  : out   STD_LOGIC_VECTOR (N-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal z: std_logic_vector(15 downto 0) := (others => '0');
	
   signal clk : std_logic := '0';
   signal rst,ce : std_logic := '0';

 	--Outputs
   signal QF : std_logic_vector(15 downto 0);
--   signal Ni: std_logic_vector(2*Nint downto 0);
--	signal r: std_logic_vector(N-1 downto 0);
--	signal mo: std_logic_vector(2*Nint downto 0);
--	signal j: std_logic_vector(4 downto 0);
--	signal Zn ,F1,F2 ,r2 :  std_logic_vector(N-1 downto 0);
--	signal X,Y :  STD_LOGIC_VECTOR (N-1 downto 0);   

   -- Clock period definitions
   constant clk_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Exp_z_org PORT MAP (
          z => z,
--			 Ni=>Ni,
--			 r=>r,
--			 mo=>mo,
--			 j=>j,
--			 Zn=>Zn,
--			 F1=>F1,
--			 F2=>F2,
--			 r2=>r2,
--			 X=>X,
--			 Y=>Y,
          QF=>QF,
			 ce=>ce,
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	variable zc :std_logic_vector(N-1 downto 0);
	
	file inA : text open read_mode is "A.txt";
	file outB : text open write_mode is "OUT.txt";
	variable Lin,Lout : line;
	variable Ka,Kb,c : integer;
	variable T: real;
	variable Rs:std_logic_vector(N-1 downto 0);
   begin		
      -- hold reset state for 100 ns.
    rst<='1';c:=0;
	 wait for clk_period;
    rst<='0';
--	 zc:=frac2bin(2.265,N,Nint);
--	  assert false report "  z= " & to_stringR(bin2frac(zc,N,Nint),N,Nint) severity warning; 
--	 z<=zc;
--	   wait for clk_period*7;
--	 assert false report " N= " & to_stringR(bin2frac(Ni,2*Nint+1,2*Nint),2*Nint+1,2*Nint) severity warning; 
--    assert false report "  Zn= " & to_stringR(bin2frac(Zn,N,Nint),N,Nint) severity warning; 
--	 assert false report "  r= " & to_stringR(bin2frac(r,N,1),N,1) severity warning; 
--	 assert false report "  m= " & to_stringR(bin2frac(mo,2*Nint+1,2*Nint),2*Nint,2*Nint) severity warning; 
--	  assert false report "  j= " & to_stringR(bin2frac('0' & j,6,5),6,5) severity warning; 
--	  assert false report "  F1= " & to_stringR(bin2frac(F1,N,1),N,1) severity warning; 
--	  assert false report "  F2= " & to_stringR(bin2frac(F2,N,1),N,1) severity warning;
--	  assert false report "  X= " & to_stringR(bin2frac(X,N,1),N,1) severity warning; 
--	 	assert false report "  Y= " & to_stringR(bin2frac(Y,N,1),N,1) severity warning; 
--		
--		
--ce<='1';
--wait for clk_period*37;
--	  assert false report "  QF= " & to_stringR(bin2frac(QF,N,1),N,1) severity warning;

	
	
     while not endfile(inA) loop --till the end of file is reached continue.
       c:=c+1;
		     readline (inA,Lin);
			  read(Lin,Ka); 
--             assert false report "  in = " & integer'image(Ka) severity warning; 
				 T:=real(Ka)/1000.0;
				 Rs:=frac2bin(T,N,Nint);
--				 assert false report "  inf= " & to_stringR(bin2frac(Rs,N,Nint),N,Nint) severity warning; 
			    z<=Rs;
			     wait for clk_period;
				  ce<='1';
           if (c>=44) then
--				  assert false report "  exp= " & to_stringR(bin2frac(QF,N,1),N,1) severity warning; 
				  Kb := integer(bin2frac(QF,N,1)*10.0**4);
				  WRITE(Lout,Kb);
				  WRITELINE(outB, Lout);
				end if;
		end loop; 
		     for i in 1 to 44 loop
			    wait for clk_period;
--				  assert false report "  exp= " & to_stringR(bin2frac(QF,N,1),N,1) severity warning; 
				  Kb := integer(bin2frac(QF,N,1)*10.0**4);
				  WRITE(Lout,Kb);
				  WRITELINE(outB, Lout);
				end loop;
		      
		
      wait;
   end process;

END;
