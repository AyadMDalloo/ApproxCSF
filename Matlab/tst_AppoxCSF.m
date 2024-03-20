clc
i=0;

for z=0:0.001:10
    i=i+1;
    [expz,Error,X,Y,N,J,F1,F2,Zn,r,m,Nf]=ApproxCSF(z);
    
    Errora(i)=Error;               %% Total Error  
    YY(i)=Y; XX(i)=X;              %% Outputs of SSF and CEF
    expc(i)=expz; expr(i)=exp(-z); %% Exact and Approximate Exp(-z)
    %%% other parameters
    Zna(i)=Zn;
    Na(i)=N; Ja(i)=J;  ma(i)=m; Nf(i)=Nf;
    F1a(i)=F1;  F2a(i)=F2;   
    ra(i)=r;  
end
  %% Draw figures
 zz=0:-0.001:-10;
% zz=z;
figure
plot(Errora); title('Error')
% figure
% plot(zz,XX,'r');title('XX,YY')
% hold on 
% plot(zz,YY)
% hold off  
% figure
% plot(ma) ;title('m')
% figure 
% plot(F1a);title('F1')
% figure
% plot(Na);title('N')
% figure
% plot(Ja);title('Ja')
% figure 
% plot(F2a);title('F2')
% figure
% plot(Zna);title('Zn')
% figure
% plot(ra) ;title('r')

