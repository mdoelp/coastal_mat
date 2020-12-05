
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Template
%                                                       Matthew Doelp
%                                                       mbdoelp@gmail.com

clear all, close all
%-----------------------------------------------------
%-----------------------------------------------------

%% DIRECTORY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdir = 'D:\18-02_NBH\REPORT\Figures\Temporal Dependency'
fdir1 = 'D:\18-02_NBH\MODEL\TIDES\newport_predicted_2018\DATA';
fdir2 = 'D:\18-02_NBH\MODEL\CURRENT\modeled_august2018';


%% DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(fdir1)
[N T R] = xlsread('08aug');
cd(fdir2)
[N2 T2 R2] = xlsread('entrance_pt_current_aug2018');
cd(fdir)

%% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Figure 1
% 
% fig1 = figure(1)
% set(gcf,'position',[680 218 726 760])
% 
%     % Plot 1: 
%     
%     s1 = subaxis(3,1,1)
%         plot(N2(:,1)/24+737273,N(:,2))
%         grid on
%         ylabel('Elevation NAVD (ft)')
%         datetick('x',1,'keepticks','keeplimits')
% 
%     % Plot 2:
%     
%     s2 = subaxis(3,1,2)
%         plot(N2(:,1)/24+737273,N2(:,2))
%         grid on
%         ylabel('Knots')
%         datetick('x',1,'keepticks','keeplimits')
% 
%     % Plot 3:
%     s3 = subaxis(3,1,3)
%         plot(N2(:,1)/24+737273,N(:,2))
%         hold on
%         figure
%         
        
        
%%
        
%         
%    [hAx,hLine1,hLine2] =  plotyy(N2(:,1)/24+737273,N(:,2),N2(:,1)/24+737273,N2(:,2))        
%         grid on
%         ylabel('Knots')
% hAx(1).YLabel.String = 'Velocity (Knots)';
% hAx(2).YLabel.String = 'Water Elevation NAVD (ft)'
% hAx(1).YLabel.FontSize =20
% hAx(2).YLabel.FontSize = 20
% hAx(1).XLabel.FontSize = 20
% 
% hAx(1).YTick = [-3 -2 -1 0 1 2 3];
% hAx(2).YTick = [-3 -2 -1 0 1 2 3];
% set(hAx(2),'ycolor','k') 
% set(hAx(1),'ycolor','k')
% % hLine2.Color = [0 0 0]
% hLine1.LineWidth = 1
% hLine2.LineWidth = 1
% 
% a =[737284.283150300 3.05502069899338; 737284.381396228 2.65107488583456]
% b =[737283.464041455,-3.20683205792630;737283.573948348,-2.46822920716270]
% strline(b(1,1),b(1,1),-4,4,2)
% strline(b(2,1),b(2,1),-4,4,2)
% 
% strline(a(1,1),a(1,1),-4,4,2)
% strline(a(2,1),a(2,1),-4,4,2)
% hAx(2).YLabel.String = 'Water Elevation NAVD (ft)'
% 
% datetick('x','dd-mmm HH:MM','keepticks','keeplimits')
% 
% L =legend( 'Water Elevation','Velocity','Spring Low Tide','Spring High Tide', 'Max Ebb Velocity', 'Max Flood Velocity')
% L.FontSize = 18


%%
        
% Figure 2

[tideinfo,thigh,high,tlow,low] = tidehl([],linspace(737273,737304,7440),N(:,2),737273,737304,240,0)
savefig('tide_HL')
% save('tideHL','thigh', 'high','tlow', 'low')
clf

clear tideinfo thigh high tlow low

% Figure 3

[tideinfo,thigh,high,tlow,low] = tidehl([],linspace(737273,737304,7440),N2(:,2),737273,737304,240,0)
savefig('current_HL')
% save('currentHL','thigh', 'high','tlow', 'low')

% clf

%%

% 2nd high tide corresponds with 1st low velociy
load('tideHL')
load('currentHL2')

tdif1(:,1) = (tlow2(1:57)' - thigh(2:58)').*24
tdif2(:,1) = (thigh2(2:58)' - tlow(2:58)').*24

springebbtdif = (tlow2(21) - thigh(22))*24
neapebbtdif = (tlow2(39) - thigh(40))*24
springfloodtdif = (thigh2(22) - tlow(22))*24
neapfloodtdif = (thigh2(40) - tlow(40))*24
midebbtdif = (tlow2(15) - thigh(16))*24
midfloodtdif = (thigh2(16) - tlow(16))*24


plot(low2(1:57)*0.592484,high(2:58),'.')
hold on
plot(high2(2:58)*0.592484,low(2:58),'.')
xlabel('Current Magnitude (knots)')
ylabel('Water Elevation NAVD (ft)')

P = polyfit([low2(1:57)*0.592484 high2(2:58)*0.592484],[high(2:58) low(2:58)],1)
f = polyval(P,[low2(1:57)*0.592484 high2(2:58)*0.592484]);
plot([low2(1:57)*0.592484 high2(2:58)*0.592484]*-1,[high(2:58) low(2:58)],'o')
plot([low2(1:57)*0.592484 high2(2:58)*0.592484],f,'-')
legend('data','linear fit')

%%

plot(tdif1(:,1), high(1:57),'.')


%%

P1 = rand(2,1) ;
P2 = rand(2,1) ;
% line(P1,P2)
plot([P1(1) P2(1)],[P1(2) P2(2)],'b','linewidth',5)
%% Extend line 
m = (f(1)-f(end))/(min(low2(1:57))*0.592484 - max(high2(2:58))*0.592484) ;  % slope of line 
N = 100 ; 
x = linspace(f(end),f(1),N) ;  % specify your x limits 
y = P(2)+P(1)*[-4:4] ;  % y = y1+m*(x-x1) ;

hold on
plot([-4:4] ,y,'.r')

%% Need To Plot the component of the line as dotted extension

Pext = [-1.41263326924406,-0.100912922992328]


x1ext = [max(high2(2:58))*0.592484:0.1:5];
y1ext = Pext(2)+Pext(1)*x1ext ;  % y = y1+m*(x-x1) ;
x2ext = [-5:.1:min(low2(1:57))*0.592484];
y2ext = Pext(2)+Pext(1)*x2ext ;  % y = y1+m*(x-x1) ;

% Flood plot

plot([low2(1:57)*0.592484 high2(2:58)*0.592484],[high(2:58) low(2:58)]+2,'ko')
hold on
plot([low2(1:57)*0.592484 high2(2:58)*0.592484],f+2,'-k')
plot(x1ext,y1ext+2,'--b')

% Ebb Plot

plot([low2(1:57)*0.592484 high2(2:58)*0.592484]*-1,[high(2:58) low(2:58)]+2,'ko')
hold on
plot([low2(1:57)*0.592484 high2(2:58)*0.592484]*-1,f+2,'-k')
plot(x2ext*-1,y2ext+2,'--b')

% Labels

rsquare([high(2:58) low(2:58)],f)
leg = legend('Modeled Current', 'Best Fit', 'Trendline Extension')
leg.FontSize = 18
xlabel('Ebb Current Velocity (Knots)')
ylabel('High Slack Water Elevation MLLW (ft)')
box on
xlim([0 3])
ylim([2 6.5])
axis equal
grid on