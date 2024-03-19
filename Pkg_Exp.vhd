--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Math_real.all;
--library arith_lib;
--use arith_lib.arith_lib.all;






package Pkg_Exp is

constant N:integer :=16;
constant Nint:Integer:=6;
constant Nsign: Integer:=1;
constant Nfrac: Integer:=N-Nint-Nsign;
constant Nz:Integer:=2;
constant NplusMinus: Integer :=Nint-1;

---- Difference sizes of inputs of Multiplier
constant N1: Integer:=2*Nint+1;---X1
constant N2: Integer:=N+2; ---X2

---------input increment
constant Ninc: Integer:=N+1;
----------Down ---LUT
constant mem:Integer :=integer(2.0**5);
type memory is array(Integer range<>) of std_logic_vector(N-1 downto 0);
constant M:integer:=integer(LOG2(real(N)));
---------------------------------------------------
function to_stringR ( X: real;N : integer; Nint :integer) return string;
function frac2bin(X:real;N:Integer;Nint:Integer) return std_logic_vector;
function bin2frac(X:std_logic_vector;N:Integer;Nint:Integer) return real;
function to_string ( a: std_logic_vector) return string;
function Gen_LUT(mem: integer) return memory;

function get_Hlvl(No:integer;Nio:integer;Nin:integer) return integer ;
function get_Llvl(No:integer;Nfo:integer;Nfn:integer) return integer;

COMPONENT Incx
	Generic (Nx:integer);
    Port ( a : in  STD_LOGIC_VECTOR (Nx-1 downto 0);
             H : out  STD_LOGIC_VECTOR (Nx-1 downto 0));
	END COMPONENT;

COMPONENT MultipKer
	Generic(N_Mulker:Integer:=N);
    Port ( X1 : in  STD_LOGIC_VECTOR (N_Mulker-1 downto 0);
           X2 : in  STD_LOGIC_VECTOR (N_Mulker-1 downto 0);
           F : out  STD_LOGIC_VECTOR (2*N_Mulker-1 downto 0));
	END COMPONENT;
COMPONENT MultiDiffSz
	Generic(N1 :Integer; N2:Integer);
    Port ( X1 : in  STD_LOGIC_VECTOR (N1-1 downto 0);
           X2 : in  STD_LOGIC_VECTOR (N2-1 downto 0);
           F : out  STD_LOGIC_VECTOR (N1+N2-1 downto 0));
	END COMPONENT;
COMPONENT AdderKer
	Generic(N_adKer:Integer:=16);
    Port ( R1 : in  STD_LOGIC_VECTOR (N_adKer-1 downto 0);
           R2 : in  STD_LOGIC_VECTOR (N_adKer-1 downto 0);
           F : out  STD_LOGIC_VECTOR (N_adKer-1 downto 0));

	END COMPONENT;
--COMPONENT IncC
--	generic (width : positive := 16;  	-- word width
--	   speed : speedType := fast);  -- performance parameter
--
--  port (A : in std_logic_vector(width-1 downto 0);  -- operand
--        CI : in std_logic;  		-- carry in
--	Z : out std_logic_vector(width-1 downto 0);  -- result
--        CO : out std_logic);  		-- carry out
--
--	END COMPONENT;
	
COMPONENT Sub_ker
	Generic(N_Sub:Integer:=16);
    Port ( A : in  STD_LOGIC_VECTOR (N_Sub-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N_Sub-1 downto 0);
           S : out  STD_LOGIC_VECTOR (N_Sub-1 downto 0));
	END COMPONENT;	
	
COMPONENT DeMux 
generic (N: integer; M:Integer);
    Port ( sel : in  STD_LOGIC_VECTOR (M-1 downto 0);
           F : out  STD_LOGIC_VECTOR (N-1 downto 0));
end COMPONENT;	
	
COMPONENT Down 
Generic (N:natural:=N; Nint:natural:=Nint);
    Port ( Ni : in  STD_LOGIC_VECTOR (2*Nint downto 0);
           Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end COMPONENT;
COMPONENT Up
Port (     Ni : in  STD_LOGIC_VECTOR (2*Nint downto 0);
	        z  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           X : out  STD_LOGIC_VECTOR (N-1 downto 0));
end COMPONENT;	

COMPONENT Reg
	Generic(N: integer:=16);
    Port ( d   : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rst,CE : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           q   : out STD_LOGIC_VECTOR (N-1 downto 0));
	END COMPONENT;


COMPONENT Part
	Generic (Nc:integer:=16;Nd:integer:=6);
    Port ( zi : in  STD_LOGIC_VECTOR (Nc-1 downto 0);---s4.11
           Ni : in  STD_LOGIC_VECTOR (Nd-1 downto 0);--s10.0
           clk,rst : in  STD_LOGIC;
           zo : out  STD_LOGIC_VECTOR (Nc-1 downto 0);
           No : out  STD_LOGIC_VECTOR (Nd-1 downto 0));
	END COMPONENT;

end Pkg_Exp;

package body Pkg_Exp is

function bin2frac(X:std_logic_vector;N:Integer;Nint:Integer) return real is
variable a: real;
variable f: real;
variable s,Sum: real;
variable Nfrac: Integer:=N-Nint-1;
variable t_X:std_logic_vector(N-1 downto 0);
begin
t_X:=X;
	a:=0.0;
	f:=0.0;
	s:=1.0;
   
	if (t_X(N-1)='1') then
	s:=-1.0;
	t_X(N-2 downto 0):=not(t_X(N-2 downto 0));
	end if;

	for j in 0 to Nint-1 loop
		 if (t_X(N-2-j)='1') then
			  a:=a+2.0**(Nint-1-j);
		  end if;
--		 assert false report "  Cv = " & integer'image(integer(a)) severity warning;
	end loop;

	for j in -1 downto -Nfrac loop
		 if t_X(Nfrac+j)='1' then
			  f:=f+2.0**(j);
--			  assert false report "  Cv = " & integer'image(integer(f*1000.0)) severity warning;
		  end if;
	end loop;
Sum:=s*(a+f);

return Sum;


end function;


function frac2bin(X:real;N:Integer;Nint:Integer) return std_logic_vector is
variable R: integer;
variable F: real;
variable G: std_logic_vector(N-1 downto 0);
constant Nfrac: integer:=N-Nint-1;
begin

	R:=integer(floor(X*sign(X))); 
--	assert false report "  R = " & integer'image(R) severity warning;
	F:=X*sign(X)-real(R);
--	assert false report "  F = " & integer'image(integer(F*10000.0)) severity warning;
	if (sign(X)<0.0 )then
	    G(N-1):='1';
	else
	    G(N-1):='0';
		 
	end if;
	
	for j in Nint-1 downto 0 loop
--	 assert false report "  RR = " & integer'image(R) severity warning;
		 if R>=(2**j) then
			 G(N-2-(Nint-1-j)):='1';
--			 assert false report "  N = " & integer'image(N-2-(Nint-1-j)) severity warning; 
			 R:=R-2**j;
		 else
			 G(N-2-(Nint-1-j)):='0';
		 end if;
--		 assert false report "  N = " & integer'image(N-2-(Nint-1-j)) severity warning; 
--		 assert false report "  R = " & to_string(G(N-2 downto Nfrac) ) severity warning;
	end loop;
	for i in 1 to (Nfrac) loop
	
		 if F>=1.0/real(2**(i)) then
			 G(Nfrac-i):='1';
			 F:=F-1.0/real(2**(i));
		 else
			 G(Nfrac-i):='0'; 
		 end if;
--		 assert false report "  N = " & integer'image(Nfrac-i) severity warning; 
	end loop;
	if sign(X)<0.0 then
		for i in 0 to N-3 loop
		  if G(i)='1' then
				 G(N-2 downto i+1):=std_logic_vector(not unsigned(G(N-2 downto i+1)));
			 exit;
			end if;
		end loop;
	end if;

return G;
end function;	 
     
function to_string ( a: std_logic_vector) return string is
variable b : string (a'high+1 downto a'low+1) := (others => '0');
variable stri : integer := 1; 
begin
    for i in a'range loop
        if (a(i)='1') then
		      b(i+1) :='1';
        else
		      b(i+1 ):='0';
		  end if;
    end loop;
 return b;
end function;



function to_stringR ( X: real;N : integer; Nint :integer) return string is

variable R,B,bi: integer;

--variablC : char;
--Type String is array (positive range <>) of character;

constant NR : integer:= integer(ceil(real(Nint)/4.0));
constant NF : integer:=integer(ceil(real(N-Nint-1)/4.0)); 
variable Message: String(1 to NR+NF+5);
variable count:integer:=0;
begin
   count:=0;
--	 assert false report "  NR = " &  integer'image(NR) severity warning;
--	 assert false report "  NF = " &  integer'image(NF) severity warning;
	R:=integer(floor(X*sign(X))); 
--		assert false report "  R = " & integer'image(R) severity warning;
	B:=integer((X*sign(X)-real(R))*10.0**(NF));
--		assert false report "  B = " & integer'image(B) severity warning;
	if (sign(X)<0.0 )then
			 Message(1):='-';
	else
	       Message(1):=' ';
		 
	end if;

--	NR:=integer(ceil(real(Nint)/4.0));
--	NF:=integer(ceil(real(N-Nint-1)/4.0));
	if( R<=9) then
		Message(2 to 3):=' ' & integer'image(integer(R));
      Message(4):='.';
		 for i in 5 to NF+6 loop 
		   bi:= integer(floor((X*sign(X)-real(R))*10.0**(i-4)));
--			assert false report "  bi = " & integer'image(bi) severity warning;
		   if (bi=0)then
			   count:=count+1;
		   else
			  exit;
			end if;
		 end loop;
--		 assert false report "  count = " &  integer'image(count) severity warning;
         if count=0 then
			   Message(5 to NF+5):=integer'image(B);
			elsif count=1 then
			   Message(5 to NF+5):= '0' & integer'image(B);
			elsif count=2 then
			   Message(5 to NF+5):= "00" & integer'image(B); 
			 elsif count=3 then
			   Message(5 to NF+5):= "000" & integer'image(B); 
			 else            Message(5 to NF+5):= "0000" & integer'image(B);
			 end if;
		 
	else
		Message(2 to NR+1):=integer'image(integer(R));
		Message(NR+2):='.';
		 for i in NR+3 to NF+NR+5 loop 
		       bi:= integer((X*sign(X)-real(R))*10.0**(i-NR-2));
		   if (bi=0)then
			   count:=count+1;
		   else
			  exit;
			end if;
		 end loop;
         if count=0 then
			   Message(NR+3 to NF+NR+5):=integer'image(B);
			elsif count=1 then
			   Message(NR+3 to NF+NR+5):= '0' & integer'image(B);
			elsif count=2 then
			   Message(NR+3 to NF+NR+5):= "00" & integer'image(B); 
			 elsif count=3 then
			   Message(NR+3 to NF+NR+5):= "000" & integer'image(B); 
			 else            Message(NR+3 to NF+NR+5):= "0000" & integer'image(B);
			 end if;
		 
			
--		assert false report "  R = " & integer'image(4554) severity warning;	
	end if;
--	
--Message(2 to 3):=integer'image(integer(R));
	   
 

-- while i<=10 loop
  
return Message; 
end function;
-----------------LUT
--type memory is array(Integer range<>) of std_logic_vector(N-1 downto 0);
function Gen_LUT(mem: integer) return memory is
variable t_LUT:memory(0 to mem-1);
variable Rx:real;
begin
	for j in 0 to mem-1 loop
	   Rx:=(0.9785721)**j;
      t_LUT(j):=frac2bin(Rx,16,1);
   end loop;
	return t_LUT;
end function;

function get_Hlvl(No:integer;Nio:integer;Nin:integer) return integer is
variable d: integer;
begin
d:=Nio-Nin;
return No-2-d;
end function;

function get_Llvl(No:integer;Nfo:integer;Nfn:integer) return integer is
variable d: integer;
begin
d:=Nfo-Nfn;
return d;
end function;
end Pkg_Exp;
