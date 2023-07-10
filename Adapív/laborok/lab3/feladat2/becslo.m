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
               sizes.NumDiscStates= 24; 
               sizes.NumOutputs= 8;      
               sizes.NumInputs= 6;            
               sizes.DirFeedthrough=1;
               sizes.NumSampleTimes=1;
               sys = simsizes(sizes);
               
               teta0=randn(4,2);
               P0=5*eye(4);
               
               x0 = [teta0(:) ; P0(:)]; 
               str = [];                    % No state ordering
               ts = [0.01 0];               % Inherited sample time
%% end
%% Update
function  sys = mdlUpdate(t,xs,us)
%             xk=us(1:2);
%             xlast=us(3:4);
%             ulast=us(5:6);
            ulast=us(1:2);
            xk=us(3:4);
            xlast=us(5:6);
            
            tetav=xs(1:8);
            teta=reshape(tetav,4,2);
            Pv=xs(9:24);
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
            sys(1:8)=teta(:);
            sys(9:24)=P(:);

%% Output
function sys = mdlOutputs(t,xs,us)
            tetav=xs(1:8);
            sys=tetav
            
            
           