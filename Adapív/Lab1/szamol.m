function [sys,x0,str,ts] = szamol(t,xs,us,flag,a)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;  % Initialization
                
    %case 2
    %                 sys= mdlUpdate(t,xs,us);                % Update
    case 3
                    sys = mdlOutputs(t,xs,us,a);            % Calculate outputs
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
               sizes.NumOutputs= 2;      
               sizes.NumInputs= 3;            
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
function sys = mdlOutputs(t,xs,us,a)
           
         %  sys1 = a*us;
           sys1 = u1*5
           sys2 = u2 + u3
