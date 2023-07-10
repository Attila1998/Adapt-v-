function [sys,x0,str,ts] = RTS_sf(t,x,u,flag)

% Dispatch the flag. The switch function controls the calls to
% S-function routines at each simulation stage.
switch flag,
case 0
[sys,x0,str,ts] = mdlInitializeSizes; % Initialization
case 3
sys = mdlOutputs(t,x,u); % Calculate outputs
case { 1, 2, 4, 9 }
sys = []; % Unused flags
otherwise
error(['Unhandled flag = ',num2str(flag)]); % Error handling
end;


% End of function timestwo
%==============================================================
% Function mdlInitializeSizes initializes the states, sample
% times, state ordering strings (str), and sizes structure.
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes
% Call function simsizes to create the sizes structure.
sizes = simsizes;
% Load the sizes structure with the initialization information.
sizes.NumContStates= 0;
sizes.NumDiscStates= 0;
sizes.NumOutputs= 1;
sizes.NumInputs= 8; 
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
% Load the sys vector with the sizes information.
sys = simsizes(sizes);
%
x0 = []; % No continuous states
%
str = []; % No state ordering
%
ts = [0.5 0]; % Inherited sample time
% end of mdlInitializeSizes



%==============================================================
% Function mdlOutputs performs the calculations.
%==============================================================
function sys = mdlOutputs(t,x,u)

%% -- A mux-bol kiolvassuk a bemeneteket es leosztjuk
uk_1 = u(1);
yrefk_1 = u(2);
yk = u(3);
yk_1 = u(4);
a1 = u(5);
a0 = u(6);
b1 = u(7);
b0 = u(8);
bm1 = 0.1761;
am1 = -1.3205;
am0 = 0.4966;


%% -- Kiszamoljuk a parametereket
r1 = b0/b1;
r0 = 1;
t1 = bm1/b1;
s0 = (am1-a1)/b1;
s1 = (am0-a0)/b1;

%% -- Kiszamoljuk a kimenetet
uk = (1/r0)*(-r1*uk_1+t1*yrefk_1-s0*yk- s1*yk_1);
sys=uk;
% End of mdlOutputs.