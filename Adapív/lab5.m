clc;
close all;
clear all;

%% folyamat parameterek
b1 = 0.104;
b0 = 0.0883;
a1 = -1.4138;
a0 = 0.6065;

%% eroirt ref modell parameterek
bm1=0.09833 ;
bm0= 0.07778;
bm=bm1+bm0;
am1=- 1.32 ;
am0= 0.4966;

Ts=0.5;
t=0:Ts:50;
ref=5*square(t*0.25);

y=[0 0];
ym=[0 0];
u=ref;
% szabalyzo parametereknek a szamitasa
r0=1;
t1=bm/b1;
s0=(am0-a0)/b1;
s1=(am1-a1)/b1;



for i=3:length(t)
    % folyamat kimenete
    y(i)=-a1*y(i-1)-a0*y(i-2)+b1*u(i-1)+b0*u(i-2);
     
    % szabalyozo jel szamitas
    u(i)=-r0*u(i-1)+t1*ref(i)-s1*y(i)-s0*y(i-1);            
    
    % referencia modell kimenetenek a szamitasa
    ym(i)=-am1*ym(i-1)-am0*ym(i-2)+bm1*ref(i-1)+bm0*ref(i-2);
    
end

figure;
plot(t,y);

figure;
plot(t,ym);