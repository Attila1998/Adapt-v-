clc;
clear all;
close all;

m = menu ('Valtozat','Adaptacio nelkul','Adaptacioval');

km=8;
kp=12;

s = tf('s');
Hp = 1/(s+3);                           % folyamat
Ts = 0.05;
t=0:Ts:50;
Hpz = c2d(Hp, Ts);
Hm = 1/(s+3);                           % referencia modell
Hmz = c2d(Hm,Ts);
[num,den] = tfdata(Hpz,'v');
[num1,den1] = tfdata(Hmz,'v');
yp = [0 0];
ym = [0 0];
e=[];
u = [0 0];
%u = ones(size(t));
yref = square(t);
teta_id = km/kp;
teta0 = 0;
gamma = 1;
teta0_tomb = teta0;
for i=2:length(t)
    if i>length(t)/2                                        % valtozik az egyik parameter
        kp=20;
    end
    %Folyamat szimulacio
    yp(i) = -den(2)*yp(i-1) + kp*num(2)*u(i-1);
    
    %Modell szimulacio
    ym(i) = -den1(2)*ym(i-1) + km*num1(2)*yref(i-1);
    
    if m==1
        teta = teta_id;
    else 
        teta = teta0;
    end
    %Szabalyzo
    u(i) = teta*yref(i);
    
    %Adaptiv szabalyzo
    e(i) = ym(i) - yp(i);
    teta0 = teta0 + (Ts*gamma*ym(i)*e(i));                                          % integraljuk a teta derivaltjat
    
    teta0_tomb = [teta0_tomb teta0];
end
plot(t,yp,'r',t,ym,'.k',t,yref,'b');
legend('Yp','Ym','Yref');
figure(2);
plot(t,u);title('Szabalyzo jel');
figure(3);
plot(teta0_tomb); title('Teta valtozasa');
figure;
plot(t,e);                                                          % hiba
title("hiba");