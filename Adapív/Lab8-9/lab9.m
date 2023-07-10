clear all;
close all;
clc;

A = [1 -1.5 0.54];
B = [2 -1.8];
C = [1 0.2 -0.48];

nk = 1;
lambda = 3;
mk = nk;

t = 1:0.1:10;

% [F,G] = efge(A,C,nk)
% BF = conv(B,F);

y = [ 0 0 ];
u = 1*sin(t);
e = 0.001*randn(size(t));
yref = square(t);
teta = rand(4,1)*0.5+[A(1) A(2) B(1) B(2)]';
P = 10*eye(4);
lambda = 0.39;
yb(1) = 0;
yb(2) = 0;
for k = 3:length(t)
    y(k) = 1.5*y(k-1)-0.54*y(k-2)+2*u(k-1)-1.8*u(k-2)+3*(e(k)+0.2*e(k-1)-0.48*e(k-2));
    %% becslés
    fi = [-y(k-1) -y(k-2) u(k-1) u(k-2)]';
    yb = fi'*teta;
    eb = y(k)'-yb(k);
    K = (P*fi) / (lambda+fi'*P*fi);
    P = ((eye(4)-K*fi')*P)/lambda;
    teta = teta+K*eb;
    %%szabályzò paraméter  számìtás
    Ab = [1 teta(1) teta(2)];
    Bb = [ teta(3) teta(4)];
    [F,G] = efge(Ab,C,nk);
    FB = conv(F,Bb);
    %% szabályzò jel számìtás
    u(k) = 1/BF(1) * (-BF(2)*u(k-1)+C(1)*yref(k)+C(2)*yref(k-1)+C(3)*yref(k-2)-G(1)*y(k)-G(2)*y(k-1));
end

plot(t,y,'r',t,yref,'g');
grid on;