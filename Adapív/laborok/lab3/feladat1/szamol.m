function [sys,x0,str,ts] = online_1(t,xs,us,flag)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;  % Initialization
                
%     case 2
%                     sys= mdlUpdate(t,xs,us);                % Update
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
               sizes.NumOutputs= 1;      
               sizes.NumInputs= 16;            
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
us
           yref=us(1);
           xc=us(2:4);
           tetav=us(5:16);
           tetam=reshape(tetav,4,3);
           Ad=tetam(1:3,1:3)';
           Bd=tetam(4,:)';
           
           R=20*eye(1);         % bemeneteket sulyoz
           Q=50*eye(1);
           Cd=[1 1 -1]; 
           
        Pc=dare(Ad,Bd,Cd'*Q*Cd,R);
        K1=-((R+Bd'*Pc*Bd)^(-1))*(Bd'*Pc*Ad);                                               % fb
        K2=((R+Bd'*Pc*Bd)^(-1))*Bd'*((eye(3)-Ad-Bd*K1)'^(-1))*Cd'*Q;                        % ff
        uc=K1*xc+K2*yref; 
           sys=uc;
           

