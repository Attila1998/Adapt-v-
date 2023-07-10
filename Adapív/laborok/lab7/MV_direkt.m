% ========================================================
% DIREKT - KOZVETLEN ADAPTIV MV SZABALYOZO - pelda program
% ========================================================

 clear all; close all; clc;
 % Sapientia EMTE Marosvasarhely 
 % Gyorgy Katalin egyetemi adjunktus
 % Adaptiv szabalyozasok ( laborgyakorlat) direkt valtozata
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Direkt adaptiv MV szabalyozo algotitmus tesztelese
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % y(k)=1.5*y(k-1)-0.54*y(k-2)+2*u(k-1)-1.8*u(k-2)+e(k)
 % n=2 m=2; nu=1;
 % F - fokszama nu-1 =0  F=1;
 % G - fokszama 2=1    G=[g0 g1] 
 %  R=G fokszama 1                     2 ertek y-ra (R-et szoroz)
 %  S= B*F fokszama m+nu-1=1+1-1 =1    2 ertek u-ra (S-et szoroz)
 %----> tehat a becsult parameter vektor 4 elemu kell legyen 
 % Szabalyozo keplete
 % S(q^-1)*u(k)=-R(q^-1)*y(k)+yref(k);
 % 
 %folyamat A(q^-1)*y(k)=B(q^-1)*u(k-nu)+la*C(q^-1)*e(k)
  Ar=[1.5 -0.54];  Br=[2 -1.8];Cr=1; la=1;  %megj az igazi A=[1 -Ar]!!!
 % inicializalas a menteshez
 ym=[];  % mert kimenet
 um=[];  % mert bemenet
 % inicializalas a folyamat szimulaciohoz
 y=[0 0];u=[0 0];  % ez lesz felhasznalva a folyamat szimulacional 
                   %[y(k-1) y(k-2)] [u(k-1) u(k-2)]
                   % az algortmus vegez ezeket mindig aktualizalni kell  
  % Inicializalas on-line l.k.n.m
 P=eye(4)*100;            %kezdeti szoras matrix   
 thest=[0.8 -0.3 1 -1]'; % kezdeti parameter vektor

 thestm=thest;              % a becsult parameter vektor elmentese
 disper=sum(abs(diag(P)));  % a becslo szorasanak elmentese  
 stdy=[];                   % a kimenet szorasanak az elmentese
 iter=800;                   % iteracio szam
 %%
 %% Szimulalo+Becslo+szabalyozo algoritmus
 %%
 for k = 1:iter
       %%
       % referencia erteket a cikulson belul hozom letre es kozben valtoztatom 
       %%
       yref(k)=4;
       if k>25
           yref(k)=-3;
       end
       if k>150
           yref(k)=10;
       end
       if k>600
           yref(k)=yref(k-1)-0.1;
       end
       %
       %% folyamat SZIMULACIO (a kimenet erteke a szamitott u es egy normal eloszlasu zaj jelenleteben) 
       %%
       e=0.1*randn(1);
       % itt megvaltoztatom a Br polinom egyik erteket (ez fontos az
       % adaptacio szempontjabol!!!)
       if k>400
           Br=[4.4 -1.2];
       end
       yi=Ar*y(1:2)'+Br*u(1:2)'+la*Cr*e;      % ezt a rendszert "fekete dobozkent" kezelem
                                              % az itt szereplo parametereket nem
                                              % hasznalhatom a szabalyozo parametereinek a kiszamitasahoz
                                              % csakis az u es y mereseket
       %
       % a szabalyozo parametereinek direkt BECSLESE 
       %%
       x=[y(1) y(2) u(1) u(2)];                % a meres vektor (lasd fi)
       Epss=yi-x*thest;                        % becslesi hiba
       K=(P*x')/(1+x*P*x');                    % becslo erositese
       P=(P-K*x*P);                            % a szoras matrix aktualizalasa   
       thest=thest+K*Epss;                     % a becsult parameter vektor
       R=thest(1:2)'; S=thest(3:4)';           % a szabalyozo parametereinek a szetvalasztasa 
       %R=[r0 r1] S=[s0 s1];
       % szabalyozo jel kiszamitas
       %% u(k)=(-s1*u(k-1) -r0*y(k)-r1*y(k-1)+yref(k))/s0
       uk=(-S(2)*u(1)-R*[yi y(1)]'+yref(k))/S(1); % itt mar figyelembe veszem a most mert kimenetet
       % aktualizalas
       %%
       u=[uk u(1)]; y=[yi y(1)];                % aktualizalas az u es y vektoroknak 
       %                                        % amit a folyamamt szimulacional hasznalok fel
       % Mentesek a grafikonok elkeszitesehez
       %%
       ym=[ym yi];                              % a zajos folyamat kimenet elmentese
       um=[um uk];                              % a szabalyozo jel mentese
       stdy=[stdy std(ym-yref)];                % lepesrol lepesre szamolom a kimenet szorasat
       disper=[disper sum(abs(diag(P)))];       % a becslo szorasanak mentese   
       thestm=[thestm thest];                   % a becsult parameter vektoroknak a mentese
      
 end
 
 %% Grafikus abrazolasok
 %%
 figure(1);
 subplot(211);
 plot(1:k,yref,'r.',1:k,ym,'Linewidth',2);legend('y-eloirt','y-folyamat');title('A rendszer kimenete');grid;
 xlabel('Lepes szam [k]'); ylabel('y[k] es yref[k]');
 subplot(212);
 plot(1:k,um,'Linewidth',2);title('Szabalyozojel');grid;
 xlabel('Lepes szam [k]'); ylabel('u[k]');
 figure(2);
 subplot(311);
 plot(1:k,stdy,'Linewidth',2);title('A kimenet szorasa a referenciahoz viszonyitva');grid;
 xlabel('Lepes szam [k]'); ylabel('std(y[k])');
 subplot(312);
 plot(1:k+1,disper,'Linewidth',2);title('A szabalyozo becsult parameterek szorasa');grid;
 xlabel('Lepes szam [k]'); ylabel('tr(P)');
 subplot(313);
 plot(1:k+1,thestm','Linewidth',2);title('A szabalyozo becsult parameterei');grid;
 xlabel('Lepes szam [k]'); ylabel('tetak');

 
 
 
 
 
      