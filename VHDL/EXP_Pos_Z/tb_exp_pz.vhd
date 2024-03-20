--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:16:35 09/07/2022
-- Design Name:   
-- Module Name:   H:/codes/VHDL/Library Cordic/exp_pZ/tb_exp_pz.vhd
-- Project Name:  exp_pZ
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: exp_pz
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
 
ENTITY tb_exp_pz IS
END tb_exp_pz;
 
ARCHITECTURE behavior OF tb_exp_pz IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT exp_pz
    PORT(
         z : IN  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
        
         exp : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal z : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
 

 	--Outputs
   signal exp : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant D: time := 10 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: exp_pz PORT MAP (
          z => z,
          clk => clk,
          rst => rst,
         
          exp => exp
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
   file inA : text open read_mode is "A.txt";
	file outB : text open write_mode is "OUT.txt";
	variable Lin,Lout : line;
	variable Ka,Kb,c : integer;
	variable T: real;
	variable Rs:std_logic_vector(N-1 downto 0);
	begin		
	     rst<='1';c:=0;
        wait for D; 
		  rst<='0';
        while not endfile(inA) loop --till the end of file is reached continue.
              c:=c+1;
				  readline (inA,Lin);
				  read(Lin,Ka); 
				  assert false report "  in = " & integer'image(Ka) severity warning; 
				  T:=real(Ka)/1000.0;
				  Rs:=frac2bin(T,N,Nint-2);
				  assert false report "  inf= " & to_stringR(bin2frac(Rs,N,Nint-2),N,Nint-2) severity warning; 
				  z<=Rs;
				  wait for D;
				  if (c>=4) then 
				    	  assert false report "  exp= " & to_stringR(bin2frac(exp,2*N,N+1),2*N,N+1) severity warning; 
						  Kb := integer(bin2frac(exp,2*N,N+1)*10.0**4);
						  WRITE(Lout,Kb);
						  WRITELINE(outB, Lout);
				  end if;
		  end loop; 
		  wait for D;
                 assert false report "  exp= " & to_stringR(bin2frac(exp,2*N,N+1),2*N,N+1) severity warning; 
		  Kb := integer(bin2frac(exp,2*N,N+1)*10.0**4);
		  WRITE(Lout,Kb);
		  WRITELINE(outB, Lout);
		  
		  wait for D;
					  assert false report "  exp= " & to_stringR(bin2frac(exp,2*N,N+1),2*N,N+1) severity warning; 
		  Kb := integer(bin2frac(exp,2*N,N+1)*10.0**4);
		  WRITE(Lout,Kb);
		  WRITELINE(outB, Lout);
		 
			wait for D;
					  assert false report "  exp= " & to_stringR(bin2frac(exp,2*N,N+1),2*N,N+1) severity warning; 
		  Kb := integer(bin2frac(exp,2*N,N+1)*10.0**4);
		  WRITE(Lout,Kb);
		  WRITELINE(outB, Lout);
			wait for D;
					  assert false report "  exp= " & to_stringR(bin2frac(exp,2*N,N+1),2*N,N+1) severity warning; 
		  Kb := integer(bin2frac(exp,2*N,N+1)*10.0**4);
		  WRITE(Lout,Kb);
		  WRITELINE(outB, Lout);
      wait;
   end process;

END;
