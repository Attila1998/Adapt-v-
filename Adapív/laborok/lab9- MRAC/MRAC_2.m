clc;
clear all;
close all;

m = menu ('Valtozat','Adaptacio nelkul','Adaptacioval');

bm=7;
bp=2;
am=9;
ap=2;

s = tf('s');
Hp = 1/(s+ap);                           % folyamat
Ts = 0.05;
t=0:Ts:50;
Hpz = c2d(Hp, Ts);
Hm = 1/(s+am);                           % referencia modell
Hmz = c2d(Hm,Ts);
[num,den] = tfdata(Hpz,'v')
[num1,den1] = tfdata(Hmz,'v')
yp = [0 0];
ym = [0 0];
e=[];
u = [0 0];
% u = ones(size(t));
yref = square(t);
teta_id1 = bm/bp;
teta_id2=(am-ap)/bp;
teta1 = 0;
teta2 = 0;
gamma = 5;
teta1_tomb = teta1;
teta2_tomb = teta2;
for i=2:length(t)
    if i>length(t)/2                                        % valtozik az egyik parameter
        bp=8;
    end
    %Folyamat szimulacio
    yp(i) = -den(2)*yp(i-1) + bp*num(2)*u(i-1);
    
    %Modell szimulacio
    ym(i) = -den1(2)*ym(i-1) + bm*num1(2)*yref(i-1);
    
    if m==1
        teta = [teta_id1 teta_id2];
    else 
        teta = [teta1 teta2];
    end
    %Szabalyzo
    u(i) = teta(1)*yref(i)-teta(2)*yp(i);
    
    %Adaptiv szabalyzo
    e(i) = ym(i) - yp(i);
    teta1 = teta1 + (Ts*gamma*ym(i)*e(i));
    teta2 = teta2 - (Ts*gamma*yp(i)*e(i));
    
    teta1_tomb = [teta1_tomb teta1];
    teta2_tomb = [teta2_tomb teta2];
end
% e=yp-ym;
plot(t,yp,'r',t,ym,'.k',t,yref,'b');
legend('Yp','Ym','Yref');
% figure(2);
% plot(t,u);title('Szabalyzo jel');
% figure(3);
% plot(teta0_tomb); title('Teta valtozasa');
figure;
plot(t,e);                                                          % hiba
title("hiba");