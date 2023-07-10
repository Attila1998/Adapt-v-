function [sys,x0,str,ts] = online_1(t,xs,us,flag)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;  % Initialization
                
    %case 2
    %                 sys= mdlUpdate(t,xs,us);                % Update
    case 3
                    sys = mdlOutputs(t,xs,us);            % Calculate outputs
    case { 1, 2, 4, 9 }
          sys = [];                                      % Unused flags
    otherwise
           error(['Unhandled flag = ',num2str(flag)]);  % Error handling
end


%% Initialization
function [sys,x0,str,ts] = mdlInitializeSizes
               sizes = simsizes;
               sizes.NumContStates= 0;
               sizes.NumDiscStates= 0; 
               sizes.NumOutputs= 16;      
               sizes.NumInputs= 1;            
               sizes.DirFeedthrough=1;
               sizes.NumSampleTimes=1;
               sys = simsizes(sizes);
               x0 = []; 
               str = []; % No state ordering
               ts = [0.01 0]; % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us)
  
           sys=xs;

%% Output
function sys = mdlOutputs(t,xs,us)
           
           yref = us(1);
           xk = us(2:4);
           Omegav = us(5:16);
           Omegam = reshape(Omegav,4,3);
           Ad = Omegam(1:3,1:3);
           Bd = Omegam(4,:);
           P = dare

