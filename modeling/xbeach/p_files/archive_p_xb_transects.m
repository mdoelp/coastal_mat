

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Template
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   02/18/2020
%-----------------------------------------------------

% NOTES

% 

%% Variables

xb = xb_read_output('xboutput.nc');
[zb, DIMS] = xs_get(xb,'zb','DIMS');
[H, DIMS2] = xs_get(xb,'H','DIMS');
xgr = xs_get(DIMS,'x');

%% Inputs
figure


%% Plotting

tr_numbers = [1:10:size(zb,1)] %size(zb,1)]           % Transects to plot
l = length(tr_numbers);                             % Number of transects to plot

color1 = [0.960784316062927 0.976470589637756 0.992156863212585];
color2 = [0.152941182255745 0.227450981736183 0.372549027204514];

r = [color2(1):(color1(1)-color2(1))/size(zb,1):color1(1)];
g = [color2(2):(color1(2)-color2(2))/size(zb,1):color1(2)];
b = [color2(3):(color1(3)-color2(3))/size(zb,1):color1(3)];



for i = tr_numbers;
    
plot1 = plot((300+xgr)/0.3048,zb(i,:)/0.3048,'LineWidth',2,'DisplayName',['Day ',num2str(i)],'Color',[r(i) g(i) b(i)]);             % Plot transects   
hold on

end
grid on

legend
xlabel('Position')






