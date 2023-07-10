function [F,G]=efge(A,C,mu)
% Általános használati formája :
%
%                   [F,G]=efge(A,C,mu);
%
% Eme függvény vissztéríti a rendszer F,G vektorokat ( F,G polinomok
% együtthatóit)!
% 
%
% Függvény paraméterei : - 1. Az "A" polinom együtthatói
%                        - 2. A "C" polinom együtthatói
%                        - 3. A rendszer holtideje (mü)
%
%
% Készítette : Tolvaly J. Zsolt (Automatizálás IV.)

if nargin<3
    error('Keves parameter','');
end
if nargin>3
    error('Tul sok parameter','');
end
if nargout~=2
    error('nem megfelelo kimenet szam','');
end
if (A(1)~=1)
     error('01 - Az "A" polinom elsõ eleme nem egyenlõ 1-el!!!', '');
end

if (mu<=0)
     error('02 - A holtidõ nem lehet kisebb 1 mintavételnél!!!', '');
end

n=size(A);
n=n(2)-1;

a=n+(mu-1);
dimF=mu;

b=mu+(n-1);
dimG=n;

d=dimF+dimG; % Egyenletrendszer matrixanak dimenzioja

F=zeros(1,dimF);
G=zeros(1,dimG);

E=zeros(d,d);
L=zeros(1,d);
B=zeros(d,1);
m=size(C);
for(i=1:m(2))
    B(i)=C(i);
end


%egyenletrendszer matrixanak felirasa
s=1;
for(i=1:d)
    for(j=1:dimF)
       if((i-j>=0)&(i-j<=dimF+(dimG-dimF)))
            E(i,j)=A(i-j+1);
        end
    end
    if((s>=mu+1))
        E(i,dimF+s-mu)=1;
    end
    s=s+1;
end


% egyenletrendszer megoldasa
if (det(E)==0)
     error('03 - Az egyenletnek nincs megoldása, valahol hiba történt!', '');
end

for(i=1:d)
    R=E;
    R(:,i)=B;
    L(i)=det(R)/det(E);
end;

% F kimentese

for(i=1:dimF)
    F(i)=L(i);
end

% G kimentese

for(i=1:dimG)
    G(i)=L(dimF+i);
end