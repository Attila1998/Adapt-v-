function [sys,x0,str,ts] = online_1(t,xs,us,flag,c,d)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;                    % Initialization
    case 2
                    sys= mdlUpdate(t,xs,us,c,d);                             % Update
    case 3
                    sys = mdlOutputs(t,xs,us);                        % Calculate outputs
    case { 1, 2, 4, 9 }
          sys = [];                                                     % Unused flags
    otherwise
           error(['Unhandled flag = ',num2str(flag)]);                  % Error handling
end


%% Initialization
function [sys,x0,str,ts] = mdlInitializeSizes
               sizes = simsizes;
               sizes.NumContStates= 0;
               sizes.NumDiscStates= 2; 
               sizes.NumOutputs= 1;      
               sizes.NumInputs= 1;            
               sizes.DirFeedthrough=1;
               sizes.NumSampleTimes=1;
               sys = simsizes(sizes);
               x0 = [0;0]; 
               str = []; % No state ordering
               ts = [0.01 0]; % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us,c,d)
           sys(1)=-0.6*xs(1)-c*us;
           sys(2)=0.02*xs(1)-0.8*xs(2)+d*us*xs(1);
%% Output
function sys = mdlOutputs(t,xs,us)
           sys=xs(1)+2*xs(2);
%            sys(1) =3*us(1)-4*us(2);
%            sys(2) =3*us(1)*us(2)-0.3*us(3)^2;

