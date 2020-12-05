
clear; clc;



%% INPUTS


% buoy_ID = '42040';
% URL = 'https://www.ndbc.noaa.gov/data/5day2/42040_5day.txt';

% buoy_ID = '42012';
% URL = 'https://www.ndbc.noaa.gov/data/5day2/42012_5day.txt';

% buoy_ID = 'BURL1';
% URL = 'https://www.ndbc.noaa.gov/data/5day2/BURL1_5day.txt';

% buoy_ID = 'KGUL';
% URL = 'https://www.ndbc.noaa.gov/data/realtime2/KGUL.txt';

buoy_ID = '44013';
URL = 'https://www.ndbc.noaa.gov/data/realtime2/44013.txt';

% buoy_ID = 'CAPL1';
% URL = 'https://www.ndbc.noaa.gov/data/realtime2/CAPL1.txt';

% buoy_ID = 'KEIR';
% URL = 'https://www.ndbc.noaa.gov/data/realtime2/KEIR.txt';

% buoy_ID = '42001';
% URL = 'https://www.ndbc.noaa.gov/data/5day2/42001_5day.txt';


% buoy_ID = '42035';
% URL = 'https://www.ndbc.noaa.gov/data/5day2/42035_5day.txt';




data_length = days(2);
right_buffer = minutes(60);

%
% DO NOT EDIT BEYOND THIS POINT
%


%% Read data

str = urlread(URL);
formatSpec = [repmat('%s ',1,15), repmat('%*s ',1,4)];
data = textscan(str, formatSpec, 'headerlines', 2);


%% Parse data

INFMT = 'yyyymmddHHMM';

% Initialize variables
date = NaT(1,length(data{1}));
WindDir = nan(size(date));
WindSpeed = nan(size(date));
WindGust = nan(size(date));
Hs = nan(size(date));
Tp = nan(size(date));
WaveDir = nan(size(date));
Pressure = nan(size(date));

for i = 1:length(data{1})
    
  % Date
    if ~strcmp('MM',data{1}{i}) && ~strcmp('MM',data{2}{i}) && ~strcmp('MM',data{3}{i}) && ~strcmp('MM',data{4}{i}) && ~strcmp('MM',data{5}{i})
        tmp = datenum([data{1}{i}, data{2}{i}, data{3}{i}, data{4}{i}, data{5}{i}],INFMT);
        date(i) = datetime(tmp, 'ConvertFrom', 'datenum');
    end
    
  % Wind
    if ~strcmp('MM',data{6}{i})
        WindDir(i) = str2num(data{6}{i});
    end
    if ~strcmp('MM',data{7}{i})
        WindSpeed(i) = 2.23694*str2num(data{7}{i});
    end
    if ~strcmp('MM',data{8}{i})
        WindGust(i) = 2.23694*str2num(data{8}{i});
    end
    
  % Wave Height
    if ~strcmp('MM',data{9}{i})
        Hs(i) = 3.28084*str2num(data{9}{i});
    end
  % Wave Period
    if ~strcmp('MM',data{10}{i})
        Tp(i) = str2num(data{10}{i});
    end
  % Wave Direction
    if ~strcmp('MM',data{12}{i})
        WaveDir(i) = str2num(data{12}{i});
    end
  
  % Pressure
    if ~strcmp('MM',data{13}{i})
        Pressure(i) = str2num(data{13}{i});
    end
    
end

date.TimeZone = 'UTC';
Hs_valued = Hs(~isnan(Hs));
Tp_valued = Tp(~isnan(Tp));
WaveDir_valued = WaveDir(~isnan(WaveDir));


%% Plot

set(0, 'defaultaxesfontname','Gill Sans MT');


% Hurricane classification colors
td = [0 1 1];
ts = [0 1 0.4];
h1 = [1 1 0];
h2 = [1 0.75 0];
h3 = [1 0 0];
h4 = [1 0 1];
h5 = [1 0.8 1];


% X-Axes limits
xmin = date(1) - data_length;
% xmin = date(end);
xmax = date(1) + right_buffer;




% Plot
figure(1);clf;
set(gcf,'position',[63          48        1177         630])

  s(1)=subaxis(3,2,1,'mt',0.04,'mb',0.07,'pl',0.03,'mr',0.025,'ml',0.025);hold on;
% % %   s(1)=subplot(3,2,1);hold on;
    plot(date, Pressure, '.k');
      title(['Met Data from Station ' buoy_ID]);
      ylabel('Pressure (hPa)');
      grid on;
      set(s(1),'xlim',[xmin xmax]);
  
  s(2)=subaxis(3,2,3);hold on;
% % %   s(2)=subplot(3,2,3);hold on;
    p1=plot(date, WindSpeed, '.k');
    p2=plot(date, WindGust, 'dk','markersize',3,'markeredgecolor',[0.15 0.15 0.15],'markerfacecolor','w');
      leg = legend('1-min Sustained','Gust');
        set(leg,'orientation','horizontal','position',[0.2958    0.6442    0.1795    0.0291]);
        box(leg,'off');
      ylabel('Wind Speed (mph)');
      grid on;
      if ~isnan(max(WindGust))
        ylim([0 1.15*max(WindGust)])
      elseif isnan(max(WindGust)) && ~isnan(max(WindSpeed))
        ylim([0 1.15*max(WindSpeed)])
      else
        ylim([0 215])
      end
      set(s(2),'xlim',[xmin xmax],'layer','top');
  % Storm classification areas
    p_h5 = area([xmin, xmax],[215 215],155);
      set(p_h5,'facecolor',h5,'edgecolor','none','handlevisibility','off');
    p_h4 = area([xmin, xmax],[155 155],130);
      set(p_h4,'facecolor',h4,'edgecolor','none','handlevisibility','off');
    p_h3 = area([xmin, xmax],[130 130],110);
      set(p_h3,'facecolor',h3,'edgecolor','none','handlevisibility','off');
    p_h2 = area([xmin, xmax],[110 110],95);
      set(p_h2,'facecolor',h2,'edgecolor','none','handlevisibility','off');
    p_h1 = area([xmin, xmax],[95 95],74);
      set(p_h1,'facecolor',h1,'edgecolor','none','handlevisibility','off');
    p_ts = area([xmin, xmax],[74 74],39);
      set(p_ts,'facecolor',ts,'edgecolor','none','handlevisibility','off');
    p_td = area([xmin, xmax],[39 39],0);
      set(p_td,'facecolor',td,'edgecolor','none','handlevisibility','off');
  % Storm classification areas
    uistack(p1,'top');
    uistack(p2,'top');
      

  s(3)=subaxis(3,2,5);hold on;
% % %   s(3)=subplot(3,2,5);hold on;
    plot(date, WindDir, '.k');
      ylabel('Wind Direction (\circ)');
      grid on;
      ylim([0 360])
      set(gca,'ytick',[0 90 180 270 360],'yminortick','on');
      set(s(3),'xlim',[xmin xmax]);
  
  s(4)=subaxis(3,2,2);hold on;
% % %   s(4)=subplot(3,2,2);hold on;
    plot(date(~isnat(date)), Hs(~isnat(date)), 'ok','markerfacecolor','k','markersize',5);
      title(['Wave Data from Station ' buoy_ID]);
      ylabel('Sig. Wave Height (ft)')
      grid on;
      if ~isnan(max(Hs))
        ylim([0 1.1*max(Hs)])
      end
      set(s(4),'xlim',[xmin xmax]);
      
  s(5)=subaxis(3,2,4);hold on;
% % %   s(5)=subplot(3,2,4);hold on;
    plot(date(~isnat(date)), Tp(~isnat(date)), 'ok','markerfacecolor','k','markersize',5);
      ylabel('Peak Wave Period (s)');
      grid on;
      set(s(5),'xlim',[xmin xmax]);
    
  s(6)=subaxis(3,2,6);hold on;
% % %   s(6)=subplot(3,2,6);hold on;
    plot(date(~isnat(date)), WaveDir(~isnat(date)), 'ok','markerfacecolor','k','markersize',5);
      ylabel('Wave Direction \rm(\circ)');
      grid on;
      ylim([0 360])
      set(gca,'ytick',[0 90 180 270 360],'yminortick','on');
      set(s(6),'xlim',[xmin xmax]);
      
      
    set(s(1:2),'xticklabel',''); set(s(4:5),'xticklabel','');

    
linkaxes(s,'x');
fontsize(12);

if isempty(Hs_valued)
    Hs_valued = nan;
end
if isempty(Tp_valued)
    Tp_valued = nan;
end
if isempty(WaveDir_valued)
    WaveDir_valued = nan;
end


% Hurricane classification text labels
ylims=get(s(2),'ylim');
if ylims(2) >= 39
t_td = text(s(2), xmax, 39, '\bfTD ');
  set(t_td,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color','b');
end
if ylims(2) >= 74
t_ts = text(s(2), xmax, 74, '\bfTS ');
  set(t_ts,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[0.06 0.36 0]);
end
if ylims(2) >= 95
t_h1 = text(s(2), xmax, 95, '\bf1 ');
  set(t_h1,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[0.35 0.35 0]);
end
if ylims(2) >= 110
t_h2 = text(s(2), xmax, 110, '\bf2 ');
  set(t_h2,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[0.74 0.3 0]);
end
if ylims(2) >= 130
t_h3 = text(s(2), xmax, 130, '\bf3 ');
  set(t_h3,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[1 0.72 0.72]);
end
if ylims(2) >= 135
t_h4 = text(s(2), xmax, 155, '\bf4 ');
  set(t_h4,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[1 0.75 1]);
end
if ylims(2) >= 165
t_h5 = text(s(2), xmax, max([165 max(get(s(2),'ylim'))]), '\bf5 ');
  set(t_h5,'fontname','gill sans MT','verticalalignment','top','horizontalalignment','right','color',[0.5 0 0.5]);
end
set(s(2),'layer','top')


% Annotations: latest observations
a = label_axes(s(1),{['\bfLatest Pressure: ' num2str(Pressure(1),'%.1f') ' hPa']},'southwest');
  set(a,'color',[0 0 1])
b = label_axes(s(4),{['\bfLatest Wave Height: ' num2str(Hs_valued(1),'%.1f') ' ft']},'northwest');
  set(b,'color',[0 0 1])
c = label_axes(s(2),{['\bfLatest Sustained: ' num2str(WindSpeed(1),'%.1f') ' mph']},'northwest');
  set(c,'color',[0 0 0])
cc = label_axes(s(2),{['\bf        Latest Gust: ' num2str(WindGust(1),'%.1f') ' mph']},'northwest');
  set(cc,'color',[0 0 0])
  pos = get(cc,'position');
  set(cc,'position',[pos(1), pos(2)-0.04, pos(3), pos(4)]);
d = label_axes(s(5),{['\bfLatest Wave Period: ' num2str(Tp_valued(1),'%.0f') ' s']},'northwest');
  set(d,'color',[0 0 1])
e = label_axes(s(3),{['\bfLatest Wind Direction: ' num2str(WindDir(1),'%.0f') '\circ']},'northwest');
  set(e,'color',[0 0 1])
f = label_axes(s(6),{['\bfLatest Wave Direction: ' num2str(WaveDir_valued(1),'%.0f') '\circ']},'northwest');
  set(f,'color',[0 0 1])

  
  
% print(['figures/' buoy_ID],gcf,'-dpng','-r600')



