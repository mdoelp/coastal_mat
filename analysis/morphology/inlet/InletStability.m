close all;
clear variables;
clc;

gA = [289; 537]; % given inlet cross-section areas (ft2)
gP = [11733963; 12938650]; % given tidal prism volume (ft3)
T = 12.4*60*60; % tidal period (s)
a = 4.69*10^-4;
b = 0.85;

% maximum velocity average over cross-section
gVm = pi*gP./(T*gA);

figure('Color','w')
hold on;
plot(gA,gVm,'or');

eA = [10:10:700]';
eP = exp((1/b)*log(eA/a));
eVm = pi*eP./(T*eA);

plot(eA,eVm,'-b');

p = polyfit([0; gA],[0; gVm],2);

Vm = p(1,1)*eA.^2+p(1,2)*eA+p(1,3);

plot(eA,Vm);
ylim([0 ceil(max([gVm;eVm]))]);
xlabel('Area (ft^2)');
ylabel('Velocity (ft/s)');
box on;
grid on;




