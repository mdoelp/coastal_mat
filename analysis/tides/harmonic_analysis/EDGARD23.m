tides='K1  M2  M4  M6  S2  N2  O1  S4  S6  M8  MK3 MN4 MS4 MSF ';
tides2='2N2 OO1 M1  J1  Q1  2Q1 L2  2SM2';
ht=z(1:N);  % input timeseries as z
%meanu=sum(ht)/N;
%hu=ht-meanu;
%ed=input(' Edit points beyond 3*(standard deviation)? (y/n) [y]: ','s');
%if isempty(ed)
%ed='y';
%end
ed='n'
if ed == 'y',
% edit points that are more than three standard
% deviations from the mean and set them to the mean
  for into=1:2,
    meanu=sum(ht)/N;
    hu=ht-meanu;
    pp=std(ht);
    pep=find(abs(hu)>3*pp);
    pnp=0;
    if isempty(pep),
      pnp=1;
    end
    mmm=size(pep);
    if pnp ~=1,
      ht(pep)=ones(mmm)*meanu;
    end
  end
else
  meanu=sum(ht)/N;
end
hu=ht-meanu;


% plot the tide curve
for jjj=1:N,
  ab(jjj)=(jjj-1)*delt;
end
plot(ab,hu)
xlabel('time (hours)')
ylabel('water surface (feet)')
title('Tide Curve for the Data Set')
for i=1:k
  s(i)=sum(hu.*cos(f(i)*t'));
  d(i)=sum(hu.*sin(f(i)*t'));
end

% Solve matrix equations for least squares complex amplitudes

Aprime=invS*s';
Bprime=invD*d';

% Determine real amplitude and phase from complex values:

delt
N
tides;
amp=(sqrt(Aprime.^2+Bprime.^2))';
phase=(atan2(Bprime,Aprime))';
amp=amp'
phase=phase';

% Reproduce time series from least squares prediction:

K1=amp(1)*cos(f(1)*t-phase(1));
M2=amp(2)*cos(f(2)*t-phase(2));
M4=amp(3)*cos(f(3)*t-phase(3));
M6=amp(4)*cos(f(4)*t-phase(4));
S2=amp(5)*cos(f(5)*t-phase(5));
N2=amp(6)*cos(f(6)*t-phase(6));
O1=amp(7)*cos(f(7)*t-phase(7));
S4=amp(8)*cos(f(8)*t-phase(8));
S6=amp(9)*cos(f(9)*t-phase(9));
M8=amp(10)*cos(f(10)*t-phase(10));
MK3=amp(11)*cos(f(11)*t-phase(11));
MN4=amp(12)*cos(f(12)*t-phase(12));
MS4=amp(13)*cos(f(13)*t-phase(13));
MSF=amp(14)*cos(f(14)*t-phase(14));
twoN2=amp(15)*cos(f(15)*t-phase(15));
OO1=amp(16)*cos(f(16)*t-phase(16));
M1=amp(17)*cos(f(17)*t-phase(17));
J1=amp(18)*cos(f(18)*t-phase(18));
Q1=amp(19)*cos(f(19)*t-phase(19));
twoQ2=amp(20)*cos(f(20)*t-phase(20));
L2=amp(21)*cos(f(21)*t-phase(21));
twoSM2=amp(22)*cos(f(22)*t-phase(22));
hprime1=K1+M2+M4+M6+S2+N2+O1+S4+S6+M8+MK3+MN4+MS4+MSF;
hprime2=twoN2+OO1+M1+J1+Q1+twoQ2+L2+twoSM2;
hprime=hprime1+hprime2;
mnresid=sum((hu-hprime'))/N;
hprime=hprime+mnresid+meanu;

% TEST HERE:  calculate energy of each signal
var_m2=std(M2)^2
var_m4=std(M4)^2

%save uncorrected phases
uncphase=phase;

% correct the phases so they begin at time = 0

t=delt*(0:(N-1));

for i=1:k
  s(i)=sum(hu.*cos(f(i)*t'));
  d(i)=sum(hu.*sin(f(i)*t'));
end
% Solve matrix equations for least squares complex amplitudes

Aprime=invS*s';
Bprime=invD*d';
phase=(atan2(Bprime,Aprime))';
phase=phase'

% Determine tidal parameters:

M4ratio=amp(3)/amp(2)
M4relphase=(180/pi)*(2*phase(2)-phase(3));
if M4relphase <0,
   M4relphase=M4relphase+360;
elseif M4relphase > 360,
   M4relphase=M4relphase-360;
end
M4relphase=M4relphase
 