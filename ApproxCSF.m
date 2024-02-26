function [expz,Error,X,Y,N,J,F1,F2,Zn,r,m,Nf]=ApproxCSF(z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==============================================================================
% PROJECT INFORMATION
% ==============================================================================
% Designer: Ayad Dalloo
% Project: PhD Research
% University: University of Technology
% Collaboration: Hill University and Brunel University London
% Description: This code models the implementation of the exponential function
% for negative inputs using an Approximate Composited-Stair Function approach.
% ==============================================================================
% Inputs
% z--input
% No. of Steps
Stp=32;
% Constants
C1=Stp/log(2); C2=log(2)/Stp;
%
S1=z*C1;
% integer
N=(fix(S1));
% Two segments SSF and CEF
%% Lower (SSF) branch
Nf=N/32;
% to address LUT J=Nf.fraction*32
J=sign(Nf)*(abs(Nf)-fix(abs(Nf)))*Stp;
% LUT %%%
F2=1/2^(J/Stp);
% To get on the integer of Nf, =Nf.integer
iNf=N-J;
m=fix(iNf/Stp); 
% output of demultiplexer 
F1=1/2^m;
% Y=1/2^(NN);
% output of SSF
Y=F1*F2;
%% Upper CEF branch
% Reconstructed Input Zn
Zn=N*C2;
%  sawtooth error r
r=z-Zn;
% output of CEF which corrected direction of sawtooth error
X=1-r;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exp(-z)
expz=Y*X;
%% ERROR =Exact_exp -Approximate_exp
Error=exp(-z)-expz;