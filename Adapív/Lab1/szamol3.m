function [sys,x0,str,ts] = szamol3(t,xs,us,flag,c,d)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;  % Initialization
                
    case 2
                    sys= mdlUpdate(t,xs,us,c,d);                % Update
    case 3
                    sys = mdlOutputs(t,xs,us);            % Calculate outputs
    case { 1,  4, 9 }
          sys = [];                                      % Unused flags
    otherwise
           error(['Unhandled flag = ',num2str(flag)]);  % Error handling
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
               x0 = [0,0]; 
               str = []; % No state ordering
               ts = [0.01 0]; % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us,c,d)
  
            sys(1) = -0,6*xs(1)-C*u(1)
            sys(2) = 0.02*xs(1)-0,8*xs(2)+ D*u*xs(1);
            %sys=xs;

%% Output
function sys = mdlOutputs(t,xs,us)
           
          sys = xs(1)+2*xs(2);
          
