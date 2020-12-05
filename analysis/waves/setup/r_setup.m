
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Wave Setup
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   11/29/2020
%-----------------------------------------------------

% NOTES

% Calculates wave setup at a point or transect

%% Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directory

    % Wave Data

        type = 'wave\';
        grd = 'grid_03\';
        mname = 'model_01\';
        project = 'Project3';

        fname = 'wavm-Waves.nc'
        fdir = ['\\Wahoo\e\19_27\modeling\',type,grd,mname,project];
        ncfile = [fdir,'.dsproj_data\Waves_output\',fname];

        % indir = ;
        outdir = ['F:\projects\19_27\modeling\delft3d\',type,grd,mname,project,'\solutions\wavesetup\'];
        mkdir(outdir);

        %load(['F:\projects\19_27\modeling\delft3d\',type,grd,mname,project,'\d3dout'])

    % Bed Data

        type2 = 'xbeach\';
        grd2 = 'grid_03\';
        mname2 = 'model_01\';
        project2 = 'run3';

        fname2 = '\xboutput.nc'
        fdir2 = ['\\Wahoo\e\19_27\modeling\',type2,grd2,mname2,project2];
        ncfile2 = [fdir2,fname2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables

    x = ncread(ncfile,'x');
    y = ncread(ncfile,'y');
    bedtemp = ncread(ncfile2,'zb'); bed = bedtemp(:,:,1);
    wsetup = ncread(ncfile,'setup');
    depth = ncread(ncfile,'depth');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Transect Locations
    
    cross_vert = size(wsetup,1);
    tr_bb = [30; 65; 100; 140; 170];
    
        for i = 1:length(tr_bb)
            plot(depth(:,tr_bb(i),1)); zoom on; pause; zoom off;
            cr_bb_temp(i,:) = ginput(1); close all
            cr_bb(i) = round(cr_bb_temp(1))
        end
        
        cr_bb = [140;130;138;129;85];
        
        
%     tr_s = [220; 225; 230; 235];
%         tr_s = [220; 225; 230; 235];

    tstep = 200;
    
    bed_tran = 70;
    
    
    
    % Create your own transects
    
%         p_aerial(aerial_dir,aerial_name,sc); hold on;
%         for i = 1:length(tr_bb)
%         plot(x(cr_bb(i),tr_bb(i)),y(cr_bb(i),tr_bb(i)),'o')
%         offpt(i,:) = ginput(1);close
%         end
%     
        offpt = [284279.3,317350.0;284494.9,316725.3;284741.4,316083.7;285141.9,315847.3;285234.4,315475.8]
        
        
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Vertices and Distances
    
        for i = 1:length(tr_bb)
            
%             vertx(:,i) = [x(1:cross_vert,tr_bb(i))];
%             verty(:,i) = [y(1:cross_vert,tr_bb(i))];

%             vertd(:,i) = zeros(length(1:cross_vert)+1,1); % Set distances = 0 initially

            vertx(:,i) = linspace(x(cr_bb(i),tr_bb(i)),offpt(i,1),100);
            verty(:,i) = linspace(y(cr_bb(i),tr_bb(i)),offpt(i,2),100);

            for j = 1:length(vertx(:,i))-1

                vertd(j+1,i) = norm([vertx(j+1,i) verty(j+1,i)]-[vertx(j,i) verty(j,i)]);

            end

            vertd(1,i) = vertd(2,i);
            vertd(end,i) = vertd(end-1,i);

            vertd_pt(:,i) = zeros(length(1:length(vertx(i))),1); % Distance assigned to each point

            for j = 1:length(vertd(:,i))-1

                vertd_pt(j,i) = (vertd(j,i)+vertd(j+1,i))/2;

            end    
            vdpt(:,i) = [0; cumsum(vertd_pt(2:end,i))];
        end
    
    
%% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 - Wave Setup Transect

close all

tstep = 450;

%     fig1 = figure;
        set(gcf,'position',[406 189 1191 738]);
        ax = get(gca);
        s{1} = subaxis(1,1,1);

        % Plot;
        
            dt = 0.65/(length(tr_bb)-1);
    r = 0.8:-dt:0.15;
    g = 0.85:-dt:0.2;
    b = 0.97:-dt:0.32;
        
            %plot(flip(bed(:,bed_tran))); hold on
%                 plot(depth(:,trnum(:,i))); hold on

%             yyaxis right
%             plot(wsetup(cross_vert,trnum1,tstep),'Displayname','Model'); 
            for i = 1:length(tr_bb)
                            plot((-1*vdpt(1:cr_bb(i),i)+vdpt(cr_bb(i),i))/.3048,wsetup(1:cr_bb(i),tr_bb(i),tstep)/.3048,'Color', [r(i) g(i) b(i)],'Linewidth',2,'Displayname',['TR: ',num2str(tr_bb(i))]);hold on; 
            end
            
        % Axes
            % Limits
                xlim([0 1500])
%                 ylim([min(wl(:)) max(wl(:))])
        % Ticks
                %s{1}.XTick = t1:12/24:t2;
                %s{1}.XTickLabels = [t1:12/24:t2];
%                 datetick('x','mm/dd HH:MM','keeplimits','keepticks');
            grid on
            box on


        % Labels;
            %title('X')
            xlabel('Cross Shore Position')
            ylabel('Wave Setup Elevation, feet NAVD')
            legend

            
    fname = 'setup_tran'; export_fig([outdir,fname,'.jpg'],'-r300');savefig([outdir,fname]); close
   
   p_aerial(aerial_dir,aerial_name,sc); hold on; 
       for i = 1:length(tr_bb)
                            plot(vertx(1:cr_bb(i),i),verty(1:cr_bb(i),i),'Color', [r(i) g(i) b(i)],'Linewidth',2,'Displayname',['TR: ',num2str(tr_bb(i))]);hold on; 
            end
                            fname = 'setup_cross_loc'; mkdir(outdir); export_fig([outdir,fname,'.jpg'],'-r300');savefig([outdir,fname]); close


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Figure 2 - Wave Setup Alongshore

    % Get Transect Vertices
    
        p_aerial(aerial_dir,aerial_name,sc); hold on; zoom on; pause; zoom off;
        %[vertbb] = ginput(2);close
        vertbb = [283266.797925368,316389.693603953;284022.801198644,314552.838770878];
        tr_pts
        
        
    % Interpolate Results to Vertices
        
        vertbbpts = [linspace([vertbb(1,1)],[vertbb(2,1)])' linspace([vertbb(1,2)],[vertbb(2,2)])'];
        interp_setup = griddata(x,y,wsetup(:,:,tstep),vertbbpts(:,1),vertbbpts(:,2));

        for i = 1:length(vertbbpts)-1
            
            d(i) = norm([vertbbpts(i+1,1) vertbbpts(i+1,2)]-[vertbbpts(i,1) vertbbpts(i,2)]);
            
        end

        d = [0 cumsum(d)];

    fig2 = figure;
set(gcf,'position',[406 545 1245 382])
ax = get(gca);

        % Plot;
            plot(d/.3048,interp_setup/.3048,'Displayname','Wave Setup','Linewidth',2); 

        % Axes
        % Ticks
            grid on
            box on


        % Labels;
            xlabel('Distance Along Transect')
            ylabel('Wave Setup (feet)')
            legend
            
            fname = 'setup_along'; mkdir(outdir); export_fig([outdir,fname,'.jpg'],'-r300');savefig([outdir,fname]); close


    p_aerial(aerial_dir,aerial_name,sc); hold on; 
    plot(vertbbpts(:,1),vertbbpts(:,2),'y.')
                fname = 'setup_along_loc'; mkdir(outdir); export_fig([outdir,fname,'.jpg'],'-r300');savefig([outdir,fname]); close

    

            
