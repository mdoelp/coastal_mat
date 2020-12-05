
%% Plot D3D FM Transect

% Inputs

    dt = 1; % time interval (days) that you are interested in 

    pt1 = [ptx(1) pty(1)]; % first point interested in (can also choose with ginput feature)
    pt2 = [ptx(2) pty(2)]; % second point interested in (can also choose with ginput feature)
    
    s = 1; % transect sample spacing (in units of pts)
    morphscale = 3.28084; % units (1 = meters; 3.28084 = ft)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Plotting
clear Z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time

    T.datenum = nc_cf_time(ncfile); %read time of output
    times = [T.datenum(1) T.datenum(end)]; 
    timestep=find(T.datenum==times(end));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transect sampling points

    % run_plot_aerial_sli
    % [pt1 pt2] = ginput; % select two points)

    d = norm(pt1 - pt2); % distance between two points
    numpts = round(d/s);
    transpt = [linspace(ptx(1), ptx(2), numpts+2)' linspace(pty(1), pty(2), numpts+2)'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data

    ct = 0;

%     dt = 0.65/(length(times)-1);
%     r = 0.8:-dt:0.15;
%     g = 0.85:-dt:0.2;
%     b = 0.97:-dt:0.32;
    
	r = 0.6:-.3:0.3;
    g = 0.65:-.3:0.35;
    b = 0.67:-.3:0.37;

    for i = 1:length(times);

        ct = ct+1;
        timestep=find(T.datenum==times(i));

        Z(:,ct) = griddata(d3dout.grd.xface,d3dout.grd.yface,d3dout.TT.bedlevel{ct,:},transpt(:,1),transpt(:,2)); 

        plot((0:length(Z)-1)*morphscale, Z(:,i)*morphscale,'Color', [r(i) g(i) b(i)],'Linestyle','-','Linewidth', 2,'DisplayName',sprintf('Timestep = %s',datestr(T.datenum(timestep))));     hold on

    end
    
        thick= griddata(d3dout.grd.xface,d3dout.grd.yface,d3dout.TT.sedthick{1,:},transpt(:,1),transpt(:,2)); 
        plot((0:length(Z)-1)*morphscale, Z(:,1)*morphscale - thick*morphscale,'r--','Linewidth',1.5,'DisplayName','Non-Erodible')

    grid on
    set(gcf,'position',[186 175 1509 601])
    xlabel('Cross-shore Position Along Transect (ft)')
    ylabel('Elevation NAVD (ft)')
    %     xlim([0 length(bi)*morphscale+100])
    legend()

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate net erosion/accresion

    pr_change = trapz(Z(:,end)) - trapz(Z(:,1));

    if pr_change >= 0 

            fprintf('Net Accretion: %8.1f m3/m\n',pr_change);
    else

            fprintf('Net Erosion: %8.1f m3/m\n',pr_change);

    end

