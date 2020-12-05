
% clear

%% Start and end dates
sdate=datenum('08-Nov-2003 00:10:00')
newstart = datenum('08-Nov-2003 10:00');
newend = datenum('30-Nov-2003 14:00','dd-mmm-yyyy HH:MM');

tdelt = 1/144 % timestep of 10 minutes (1/144)
timevec = [newstart:tdelt:newend]; % time vector includes chosen window with interval

% timeint=find(timevec>=newstart & timevec<=newend);
% N=length(timeint);

tshift = (newstart - sdate)*24; % Shift in time from start in hours
dt = (newend-newstart)*24; % Time window in hours


t=[tshift:tdelt*24:tshift+dt]; % Convert to hours for harmonic analysis



%% Find Constituents
freq1 = [28.9841042 ; 30.0; 28.4397295; 15.0410686; 57.9682084; 13.9430356;...
    86.9523127;44.0251729;60.0;57.4238337;28.5125831;90.0;27.9682084;27.8953548;...
    16.139101; 29.455626; 15; 14.496694; 15.5854435; 0.5443747; 0.0821373; 0.0410686; 1.0158958; 1.0980331; 13.471515;...
    13.398661; 29.958933; 30.041067; 12.8542861; 14.958931; 31.015896; 43.47616; 29.528479;...
    42.92714; 30.082138; 115.93642; 58.984104];

freq2 = [freq1(4);freq1(1);freq1(5);freq1(7);freq1(2);freq1(3);freq1(6);freq1(9);...
    freq1(12);freq1(36);freq1(8);freq1(10);freq1(37);freq1(23);freq1(14);freq1(15);freq1(18);freq1(19);...
    freq1(26);freq1(29);freq1(33);freq1(31)];
% amp3 = [amp2(4);amp2(1);amp2(5);amp2(7);amp2(2);amp2(3);amp2(6);amp2(9);...
%     amp2(12);amp2(36);amp2(8);amp2(10);amp2(37);amp2(23);amp2(14);amp2(15);amp2(18);amp2(19);...
%     amp2(26);amp2(29);amp2(33);amp2(31)];
% phase3 = [phase2(4);phase2(1);phase2(5);phase2(7);phase2(2);phase2(3);phase2(6);phase2(9);...
%     phase2(12);phase2(36);phase2(8);phase2(10);phase2(37);phase2(23);phase2(14);phase2(15);phase2(18);phase2(19);...
%     phase2(26);phase2(29);phase2(33);phase2(31)];

fr = freq1/360;
f=2*pi*[fr(4);fr(1);fr(5);fr(7);fr(2);fr(3);fr(6);fr(9);fr(12);fr(36);fr(8);fr(10);fr(37);fr(23);
fr(14);fr(14);fr(15);fr(18);fr(19);fr(26);fr(29);fr(33);fr(31)];

amp = boston_ap(:,1);
amp2 = amp
amp2(2,1) = amp(2,1)*.7278;
phase = boston_ap(:,2);
phase2 = phase
phase2(2,1) = phase(2,1)-0.5058592491



equ = [2.86; 26.40; 52.8; 79.20; 0.0; 35.62; 36.67; 0.0; 0.0; 105.6; 29.26;...
    62.02; 26.4; 333.6; 44.84; 150.45; 42.71; 349.73; 36.67; 45.89; 202.15; 333.60];
% run_harmonic
[hprime] = constituents(amp2,phase2,equ,f,t);


%% Plot Results

figure(2)
plot(timevec,hprime'); % Convert back to matlab time in days

data(:,1) = t./24+newstart
data(:,2) = hprime'

% save datafile datafile
save data.con data -ascii -double
