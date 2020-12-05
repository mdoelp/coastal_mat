function [hprime] = constituents(amp,phase,equ,f,t)
%harmonics Run harmonics

K1=amp(1)*cos(f(1)*t+equ(1)-phase(1));
M2=amp(2)*cos(f(2)*t+equ(2)-phase(2));
M4=amp(3)*cos(f(3)*t+equ(3)-phase(3));
M6=amp(4)*cos(f(4)*t+equ(4)-phase(4));
S2=amp(5)*cos(f(5)*t+equ(5)-phase(5));
N2=amp(6)*cos(f(6)*t+equ(6)-phase(6));
O1=amp(7)*cos(f(7)*t+equ(7)-phase(7));
S4=amp(8)*cos(f(8)*t+equ(8)-phase(8));
S6=amp(9)*cos(f(9)*t+equ(9)-phase(9));
M8=amp(10)*cos(f(10)*t+equ(10)-phase(10));
MK3=amp(11)*cos(f(11)*t+equ(11)-phase(11));
MN4=amp(12)*cos(f(12)*t+equ(12)-phase(12));
MS4=amp(13)*cos(f(13)*t+equ(13)-phase(13));
MSF=amp(14)*cos(f(14)*t+equ(14)-phase(14));
twoN2=amp(15)*cos(f(15)*t+equ(15)-phase(15));
OO1=amp(16)*cos(f(16)*t+equ(16)-phase(16));
M1=amp(17)*cos(f(17)*t+equ(17)-phase(17));
J1=amp(18)*cos(f(18)*t+equ(18)-phase(18));
Q1=amp(19)*cos(f(19)*t+equ(19)-phase(19));
twoQ2=amp(20)*cos(f(20)*t+equ(20)-phase(20));
L2=amp(21)*cos(f(21)*t+equ(21)-phase(21));
twoSM2=amp(22)*cos(f(22)*t+equ(22)-phase(22));
hprime1=K1+M2+M4+M6+S2+N2+O1+S4+S6+M8+MK3+MN4+MS4+MSF;
hprime2=twoN2+OO1+M1+J1+Q1+twoQ2+L2+twoSM2;
hprime=hprime1+hprime2;

end

