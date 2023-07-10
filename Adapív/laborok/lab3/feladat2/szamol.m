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
               sizes.NumOutputs= 2;      
               sizes.NumInputs= 11;            
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
%            disp(us)
           yref=us(1)
           xc=us(2:3)
           tetav=us(4:11)
           tetam=reshape(tetav,4,2)            % vector to matrix
           Ad=tetam(1:2,1:2)'                  % restauration of the Ad matrix
           Bd=tetam(3:4,:)'                      % restauration of the Bd matrix
           
           R=20*eye(2);                         % bemeneteket sulyoz      R=eye(m)
           Q=50*eye(1);                         % Q=size(p)
           Cd=[1 -1]; 
           
        Pc=dare(Ad,Bd,Cd'*Q*Cd,R);
        K1=-((R+Bd'*Pc*Bd)^(-1))*(Bd'*Pc*Ad);                                               % fb
        K2=((R+Bd'*Pc*Bd)^(-1))*Bd'*((eye(2)-Ad-Bd*K1)'^(-1))*Cd'*Q ;                       % ff
        uc=K1*xc+K2*yref; 
           sys=uc;
           

