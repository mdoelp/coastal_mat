 

%% Assign Data

wind = ST63070_v03(:,10);
winddir = ST63070_v03(:,16);


%% Setup Rose

options.anglenorth =0
options.angleeast = 90
options.cmap = 'invgray',
options.ndirections = 16
options.maxfrequency = 10
options.freqlabelangle = [0 22.5 45 67.5 90 112.5 135 157.5 180 202.5 225 247.5 270 290.5 312.5 335]
options.Labels = {'N','NNE','NE','ENE' 'E','ESE','SE','SSE',...
                    'S','SSW', 'SW','WSW', 'W', 'WNW', 'NW', 'NNW'}
                options.freqlabelangle = 45
                option.nspeeds = 4

                options.speedround = 5
                options.vwinds = [0 2 4 6 8 20]

%% Run

% [figure_handle,count,speeds,directions,Table] = WindRose(ST63070_v03(:,16),ST63070_v03(:,10),options);
WindRose(winddir,wind,'AngleEAST',90,'AngleNORTH',0)