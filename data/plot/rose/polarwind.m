function hpol = polarwind(theta,rho,line_style,lhgt)

%POLAR  Polar coordinate plot.
%   POLAR(THETA, RHO) makes a plot using polar coordinates of
%   the angle THETA, in radians, versus the radius RHO.
%   POLAR(THETA,RHO,S) uses the linestyle specified in string S.
%   See PLOT for a description of legal linestyles.
%
%   See also PLOT, LOGLOG, SEMILOGX, SEMILOGY.

%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 5.13 $  $Date: 1996/09/03 15:42:01 $

if nargin < 1
    error('Requires 2 or 3 input arguments.')
elseif nargin == 2 
    if isstr(rho)
        line_style = rho;
        rho = theta;
        [mr,nr] = size(rho);
        if mr == 1
            theta = 1:nr;
        else
            th = (1:mr)';
            theta = th(:,ones(1,nr));
        end
    else
        line_style = 'auto';
    end
elseif nargin == 1
    line_style = 'auto';
    rho = theta;
    [mr,nr] = size(rho);
    if mr == 1
        theta = 1:nr;
    else
        th = (1:mr)';
        theta = th(:,ones(1,nr));
    end
end
if isstr(theta) | isstr(rho)
    error('Input arguments must be numeric.');
end
if ~isequal(size(theta),size(rho))
    error('THETA and RHO must be the same size.');
end

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
    hold on;
    maxrho = max(abs(rho(:)));
    hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
    axis image; v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);
% check radial limits and ticks
rmin = 0; rmax = v(4); rticks = max(ticks-1,2);  

%  JDW CHANGE to set the %occurrence radii constant from one data set to the next
mradii=18;		%outside radius is set to 15%
rmax=mradii/100*(lhgt);		

	if rticks > 10   % see if we can reduce the number
        if rem(rticks,2) == 0
            rticks = rticks/2;
        elseif rem(rticks,3) == 0
            rticks = rticks/3;
        end
    end
rticks=3;   
% define a circle
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if ~isstr(get(cax,'color')),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(gca,'color'));
    end
% draw radial circles
c82 = cos(82*pi/180);	% 82 used to be 148 JDW
s82 = sin(82*pi/180);
    rinc = (rmax-rmin)/rticks;
    j=0;
    for i=(rmin+rinc):rinc:rmax
        j=j+1;
        hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',0.5);
 % take out labeling of radii       
        text((i+rinc/5)*c82,(-(i*.5*(.75/j))-i+rinc/2)*s82,-.1, ...
            ['  ' num2str(round(i/lhgt*100))],'verticalalignment','bottom')
    end
    set(hhh,'linestyle','-') % Make outer circle solid
    fprintf('rmax is %8.4f',rmax)
    fprintf('\tlhgt is %8.4f\n',lhgt)
% plot spokes
    th = (1:8)*2*pi/16;
    cst = cos(th); snt = sin(th);
    cs = [-cst; cst];
    sn = [-snt; snt];
    plot(rmax*cs,rmax*sn,ls,'color',tc,'linewidth',.5)

% annotate spokes in degrees
	adir={'NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW','N'};
    rt = 1.1*rmax;
    for i = 1:length(th)
        text(rt*cst(i),rt*snt(i),adir{i},'horizontalalignment','center')
 %       if i == length(th)
 %           loc = 'N';
 %       else
 %           loc = int2str(180+i*30);
 %       end
        text(-rt*cst(i),-rt*snt(i),adir{i+8},'horizontalalignment','center')
    end

% set view to 2-D
    view(2);
% set axis limits
    axis(rmax*[-1 1 -1.15 1.15]);
end

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hpol = q;
end
if ~hold_state
    axis image; axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')


