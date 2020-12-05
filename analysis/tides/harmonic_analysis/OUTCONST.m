%
% This program takes the tidal constituent
% output as calculated by PREPTIDE.M, LESCO.M,
% and EDGARD.M and reformats the output data
% into columns of data saved to a file
%
period=(2*pi)*(f.^(-1));
confile(:,1)=period; 
confile(:,2)=amp;
phaze=phase*(360/(2*pi));
confile(:,3)=phaze;
confile(:,4)=uncphase;
fprintf('The tides are:')
tides
tides2
fprintf('The constituents are (in columns):')
confile
%
tmsfile(:,1)=time(jj); % Time
tmsfile(:,2)=z-meanu; % WSE of original time series
residual=z-hprime';
tmsfile(:,3)=hprime'; % Astronomical tide
tmsfile(:,4)=residual; % Residual signal

% plot out all stuff
figure(1)
clf
subplot(311),plot(tmsfile(:,1),tmsfile(:,2))
grid on
title('Original Series')
subplot(312),plot(tmsfile(:,1),tmsfile(:,3))
grid on
title('Predicted Tide')
subplot(313),plot(tmsfile(:,1),tmsfile(:,4))
grid on
title('Residual Tide')


fprintf('Save CONFILE (Constituents)and TMSFILE (time series)')

% Confile: Period, Amplitude, Phase, UN C Phase

phase_noaa = [phase(2); phase(5); phase(6); phase(1); phase(3); phase(7); phase(4); phase(11); phase(8); phase(12)];
phase_noaa(:,2) = phase_noaa(:,1)*60; % Minutes
phase_noaa(:,3) = phase_noaa(:,1);
phase_noaa(:,3) = phase_noaa(:,1)/360; % Minutes
amp_noaa = [amp(2); amp(5); amp(6); amp(1); amp(3); amp(7); amp(4); amp(11); amp(8); amp(12)];