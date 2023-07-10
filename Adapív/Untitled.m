clc;
clear all;
close all;

m = menu ('Valtozat','Adaptacio nelkul','Adaptacioval');

k1 = 0;
k2 = 0;
s = tf('s');
Hp = 2/(5*s-9);                           % folyamat
Ts = 0.01;
t=0:Ts:50;
Hpz = c2d(Hp, Ts)
Hm = 1/(1*s+1);                           % referencia modell
Hmz = c2d(Hm,Ts)
[num,den] = tfdata(Hpz,'v')
[num1,den1] = tfdata(Hmz,'v')
yp = [0 0 0];
ym = [0 0 0];
e=[];
u = [0 0 0];
u = ones(size(t));
yref = square(t);
% teta=0;
% teta_id1=100;
% teta0 = 50;
teta = 0.5;
% teta_tomb = teta0;
for i=3:length(t)
    %Folyamat szimulacio
    yp(i) = -den(2)*yp(i-1) + num(2)*u(i-2);
    
    %Modell szimulacio
    ym(i) = -den1(2)*ym(i-1) + num1(2)*yref(i-2);
    
%     if m==1
%         teta = teta_id1;
%     else 
%         teta = teta0;
%     end
    %Szabalyzo
    %u(i) = teta*(yref(i)-yp(i));
    u(i) = -k1*yref(i)+k2*yp(i);
    
    %Adaptiv szabalyzo
    e(i) = ym(i) - yp(i);
    k1=k1-teta*yref(i)*e(i);
    k2=k2+teta*yp(i)*e(i);
%     if teta0<1
%         teta0=1;
%     elseif teta0>120
%         teta0=120;
%     end
%     teta_tomb = [teta_tomb teta0];
    k1_tomb = [k1_tomb teta0];
    k2_tomb = [k2_tomb teta0];
end
plot(t,yp,'r',t,ym,'.k',t,yref,'b');
legend('Yp','Ym','Yref');
 figure(2);
 plot(k1_tomb);title('k1 tömb');
 figure(3);
 plot(k2_tomb); title('k2 tömb');
% figure;
% plot(t,e);                                                          % hiba
% title("hiba");