function [sys,x0,str,ts] = BecsloIO(t,x,u,flag)


% Generate a continuous linear system:

switch flag,
            case 0
            [sys,x0,str,ts]=mdlInitializeSizes(); % Initialization
            case 2
            sys = Update(t,x,u); % Calculate derivatives
            case 3
            sys = mdlOutputs(t,x,u); % Calculate outputs
            case { 1, 4, 9 } % Unused flags
            sys = [];
            otherwise
            error(['Unhandled flag = ',num2str(flag)]); % Error handling
end
% end csfunc



%==============================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the
% S-function.
%==============================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes()
%
% call simsizes for a sizes structure, fill it in and convert it
% to a sizes array.
%
sizes = simsizes;
sizes.NumContStates = 0;
sizes.NumDiscStates = 21;
sizes.NumOutputs = 6;
sizes.NumInputs = 5;
sizes.DirFeedthrough = 1; % Matrix D is nonempty.
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
%
% initialize the initial conditions
%
Teta = randn(4,1);
P0 = 100*eye(4);
x0 = [Teta; P0(:); 0];
%
% str is an empty matrix

%
str = [];
%
% Initialize the array of sample times; in this example the sample
% time is continuous, so set ts to 0 and its offset to 0.
%
ts = [0.5 0];
% end mdlInitializeSizes
%
%==============================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%==============================================================

function sys = Update(t,x,u)

%=============================================================
% Bemenetek kiolvasas
%=============================================================
uk_1 = u(1);
uk_2 = u(2);
yk = u(3);
yk_1 = u(4);
yk_2 = u(5);
%=============================================================
% Allapotok aktualizalasa
%=============================================================
Teta = x(1:4);
Pv = x(5:20);
P = reshape(Pv,4,4)
%=============================================================
% Becslo algorimus
%=============================================================
Fii = [-yk_1 -yk_2 uk_1 uk_2]'
Epsz = yk - Fii'*Teta
K = P*Fii/(1+Fii'*P*Fii)
P = (eye(4)-K*Fii')*P
Teta = Teta+K*Epsz
%=============================================================
% Allapotok visszaalitasa
%=============================================================
x(1:4) = Teta;
x(5:20) = P(:);
x(21) = Epsz;
sys = x;


function sys = mdlOutputs(t,x,u)
%y(1)=x(1);
%y(2)=x(2);
%y(3)=x(1)+x(2);
% y=C*x+D*u;
% sys=y;
% end mdlOutputs
Teta = x(1:4);
Pv = x(5:20);
P = reshape(Pv,4,4);
Ptr = trace(P);
Epsz = x(21);
sys = [Teta; Epsz; Ptr];
