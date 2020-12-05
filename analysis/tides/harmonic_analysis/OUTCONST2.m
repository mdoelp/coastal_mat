function [outputArg1,outputArg2] = outconst(amp, phase, uncphase, f, pass)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Output Data
%                                                       Matthew Doelp
%                                                       mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%-----------------------------------------------------

% This program takes the tidal constituent
% output as calculated by PREPTIDE.M, LESCO.M,
% and EDGARD.M and reformats the output data
% into columns of data saved to a file


%% DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

period=(2*pi)*(f.^(-1));
phaze=phase*(360/(2*pi));

% Construct File

confile(:,1)=period;
confile(:,2)=amp;
confile(:,3)=phaze;
confile(:,4)=uncphase;


% fprintf('The tides are:')
% tides
% tides2
% fprintf('The constituents are (in columns):')
% confile

tmsfile(:,1)=time(jj);
tmsfile(:,2)=z-meanu;
residual=z-hprime';
tmsfile(:,3)=hprime';
tmsfile(:,4)=residual;



%% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if pass == 1
    
% Figure 1

fig1 = figure(1)
clf
figpos

    % Plot 1: 

    subplot(311),plot(tmsfile(:,1),tmsfile(:,2))
        grid on
        title('Original Series')
    
    % Plot 2:

    subplot(312),plot(tmsfile(:,1),tmsfile(:,3))
        grid on
        title('Predicted Tide')
    
    % Plot 3:

    subplot(313),plot(tmsfile(:,1),tmsfile(:,4))
        grid on
        title('Residual Tide')
    
else 
    
end

%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Save CONFILE (Constituents)and TMSFILE (time series)')


end