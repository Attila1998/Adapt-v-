% lab 4
%% Rendszer szimulacio

Ad = [ -0.6 0 0; 0.02 -0.8 0;0  0 0.3 ;] ;
Bd =  [ -2; 1; 2 ];
Cd = [ 1; 1; -1 ];
Dd = 0;

t = 0:0.01:10 ; 
N = length(t);
u = square(t);
R = 5;
Q = 21;

xk = [0; 0; 0;]

for i = 1:N-1
    xk(:,i+1) = Ad * xk(:,i) + Bd * u(i);
    %y(:,i+1) = Cd * xk(:,i);
    
    %szabalyzo
    Pc = dare(Ad,Bd,Cd.'*Q*Cd,R);
    P = Ad.'*P*Ad+Cd.'*Q*Cd*Ad.'*P*Bd+(R+Bd.'*P*Bd)^-1*Bd'*P*Ad;
    K1 = -(R+Bd.'*P*Bd)^-1*Bd.'*P*Ad;
    K2 = (R+Bd.'*P*Bd)^-1*Bd.'*((eye(3)*Ad*Bd*K1).')^-1*Cd*Q;
    u(:,i+1) = K1*x(:,i) +K2*u(:,i);
    
end

plot(t,xk);
%plot(t,y);