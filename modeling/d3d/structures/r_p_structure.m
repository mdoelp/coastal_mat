

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup

% NC File Solution

    type = 'integrated';
    grd = 'grid_02';
    mname = 'model_01';
    project = 'Project6';
    
    % Change directory to ncfile location to find pli files
	fdir = ['\\Wahoo\e\19_27\modeling\',type,'\',grd,'\',mname,'\',project,'.dsproj_data\FlowFM\input\']; cd(fdir);

% List pli files

    fileList = dir('*.pli');

% Find X and Y locations of all pli files

    for i = 1:size(fileList,1)

        clear tk
        d3dpli{i}.name = fileList(i).name;

        tk = tekal('open',d3dpli{i}.name,'loaddata');

        for j = 1:size(tk.Field,2)

            d3dpli{i}.pt{j}(:,1) = tk.Field(j).Data(:,1);
            d3dpli{i}.pt{j}(:,2) = tk.Field(j).Data(:,2);

        end


    end

structs = [9]; % Pick out the pli files you are interested in
unit = 1000*0.3048

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots

% close all
% p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on
% plot(x,y,'.','Color',[0.9290, 0.6940, 0.1250])


for i = structs
    for j = 1:length(d3dpli{i}.pt);
        
    xpts = d3dpli{i}.pt{j}(:,1);
    ypts = d3dpli{i}.pt{j}(:,2);
    z = 1000*ones(length(xpts));

%     plot3(xpts/unit, ypts/unit,z,'k','Linewidth',2); hold on
    plot(xpts/unit, ypts/unit,'k','Linewidth',2); hold on

    end
end



	% Labels;
		title('Wave Model Grid Nodes')
		xlabel('Easting (Florida East State Plane - m)')
		ylabel('Northing (Florida East State Plane - m)')

	% Axes
		% Limits
% 			xlim([281959.256673316,286059.433036052])
% 			ylim([314188.769433379,316830.787617690])
	% Ticks
        axis equal
		grid on
		box on

%         export_fig('sli_wave_grid.jpg','-r300','-nocrop'); savefig('sli_wave_grid.fig'); close all
