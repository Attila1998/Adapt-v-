function [sys,x0,str,ts] = becslo(t,xs,us,flag)
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
               sizes.NumDiscStates= 6; 
               sizes.NumOutputs= 1;      
               sizes.NumInputs= 11;            
               sizes.DirFeedthrough=1;
               sizes.NumSampleTimes=1;
               sys = simsizes(sizes);
               x0=[];
               str = []; % No state ordering
               ts = [0.01 0]; % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us)

%% Output
function sys = mdlOutputs(t,xs,us)
            ref=us(1:3);
            y=us(4:5);
            A=[1 us(6:7)];
            B=us(8:9);
            C=us(10:11);
            [F,G]=efge(A,C,1);
            FB=conv(F,B);
            BF=conv(B,F);
            U=(1/BF(1))*(-BF(2)*u(i-1)+C(1)*ref(i)+C(2)*ref(i-1)+C(3)*ref(i-2)-G(1)*y(i)-G(2)*y(i-1));
            tetav=xs(1:12);
            sys=tetav;
            
            
           