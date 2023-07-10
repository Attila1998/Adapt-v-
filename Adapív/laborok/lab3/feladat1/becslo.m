function [sys,x0,str,ts] = becslo(t,xs,us,flag)
%% Main
switch flag,
    case 0
                   [sys,x0,str,ts] = mdlInitializeSizes;  % Initialization
                
    case 2
                    sys= mdlUpdate(t,xs,us);                % Update
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
               sizes.NumDiscStates= 28; 
               sizes.NumOutputs= 12;      
               sizes.NumInputs= 7;            
               sizes.DirFeedthrough=1;
               sizes.NumSampleTimes=1;
               sys = simsizes(sizes);
               
               teta0=randn(4,3);
               P0=10*eye(4);
               
               x0 = [teta0(:) ; P0(:)]; 
               str = []; % No state ordering
               ts = [0.01 0]; % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us)
%             xk=us(1:3);
%             xlast=us(4:6);
%             ulast=us(7);
            xk=us(2:4);
            xlast=us(5:7);
            ulast=us(1);
            
            tetav=xs(1:12);
            teta=reshape(tetav,4,3);
            Pv=xs(13:28);
            P=reshape(Pv,4,4);
            fi=[xlast ;ulast];
            yb=fi'*teta;
            e=xk'-yb;
            K=(P*fi)/(1+fi'*P*fi);
            P=(eye(4)-K*fi')*P
            teta=teta+K*e;
            
%             tetav=teta(:);
%             xs(1:12)=tetav;
%             Pv=P(:);
%             xs(13:28)=Pv;
%            sys=xs;
            sys(1:12)=teta(:);
            sys(13:28)=P(:);

%% Output
function sys = mdlOutputs(t,xs,us)
            tetav=xs(1:12);
            sys=tetav;
            
            
           