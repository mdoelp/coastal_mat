

%compares morph change of two *_map.nc files, that have slightly different
%number of active cells.  The two grids should have the same number of
%nodes and edges

    cmp=load('brown_to_blue_colormap.dat'); % load color map

    G1 = d3dout1.G;
    G2 = d3dout2.G;
    
%% Calculate differences between bathy

    %look for cells with same center coordinate to match cells of both grids
    %not all cells need to be in both grids, just save the ones that are
    cnt=0;
    for i=1:length(G1.morph_tend);
        aa=find(G2.mesh_x==G1.mesh_x(i));
        if length(aa)>1
            cnt=cnt+1;
            bb=find(G2.mesh_y(aa)==G1.mesh_y(i));
            mi(cnt)=aa(bb); %matched cell index
        elseif length(aa)==1;
            cnt=cnt+1;
            mi(cnt)=aa;
        end
        if length(aa)>0
            % save to structure of patches that are common to both meshes, calc
            % difference btween the two
            Gd.mesh_x(cnt)=G1.mesh_x(i);
            Gd.mesh_y(cnt)=G1.mesh_y(i);
            Gd.mesh_x_bnd(:,cnt)=G1.mesh_x_bnd(:,i);
            Gd.mesh_y_bnd(:,cnt)=G1.mesh_y_bnd(:,i);
            Gd.change_dif(cnt)=[G2.morph_tend(mi(cnt))-G2.morph_t0(mi(cnt))]-[G1.morph_tend(i)-G1.morph_t0(i)];   
            Gd.end_dif(cnt)=[G2.morph_tend(mi(cnt))-G1.morph_tend(i)];  
        end
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot figures

% Figure 1: Bathy change 1

    p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on
    h=patch(G1.mesh_x_bnd*scl/1000,G1.mesh_y_bnd*scl/1000,(G2.morph_tend-G2.morph_t0)/0.3048);
            set(h,'edgeColor','none'); % turn off triangle edges
            view(0,90);
            c=colorbar;
            colormap(cmp);
                clim([-.5 .5])
        % xlim([274.900 275.900])
        % ylim([800.720 801.420])
        %     set(gcf,'position',[40 568 851 420])
            grid on
            axis equal
        %         title('Scenario A')
        hold on
        set(gcf,'position',[40 87 1803 901])


%%
% Figure 2: Bathy change 2

    p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on

           title('Scenario 1 Bathymetric Change')
           xlabel('Longitude')
           ylabel('Latitude')
           grid on
           box on
           axis equal
    %        legend('')
        h=patch(G2.mesh_x_bnd*scl,G2.mesh_y_bnd*scl,(G2.morph_tend-G2.morph_t0)/0.9);
        set(h,'edgeColor','none'); % turn off triangle edges
        view(0,90);
        c=colorbar;
        colormap(cmp);
        set(gcf,'position',[40 59 851 420])


    
    
%%
% Figure 3: Difference in total change

    p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on

           title('Difference Between Bathymetric Change')
           xlabel('Longitude')
           ylabel('Latitude')
           grid on
           box on
           figpos
           axis equal
    %        legend('')
        h=patch(Gd.mesh_x_bnd*scl,Gd.mesh_y_bnd*scl,Gd.change_dif/1.2);
        set(h,'edgeColor','none'); % turn off triangle edges
        view(0,90);
        c=colorbar;
        colormap(cmp);
        set(gca,'layer','top')
        clim([-0.5 0.5])
        set(gcf,'position',[895 568 926 420])

%%  
% Figure 4: Difference between final time steps

    p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on

           title('Difference Between Final Bathymetries')
           xlabel('Longitude')
           ylabel('Latitude')
           grid on
           box on
           figpos
           axis equal
    %        legend('')

    % Gd.end_dif(Gd.end_dif <= 0.1 & Gd.end_dif >= -0.1) = 0;

        h=patch(Gd.mesh_x_bnd*scl,Gd.mesh_y_bnd*scl,Gd.end_dif);
        set(h,'edgeColor','none'); % turn off triangle edges
        view(0,90);
        c=colorbar;
        colormap(cmp);
        set(gca,'layer','top')
        clim([-0.1 0.1])
        set(gcf,'position',[895 60 925 420])

    



%% Archive

% Retrieve and parse necessary data from ncfiles

%     G1.time=ncinfo(ncfile1,'time');
%     G1.mesh_x = d3dout.grd.xface;  %Characteristic x and y coordinate of mesh face
%     G1.mesh_y = d3dout.grd.yface; 
%     G1.mesh_x_bnd=ncread(ncfile1,'mesh2d_face_x_bnd',[1 1],[3 Inf]); %mesh cell boundary nodes
%     G1.mesh_y_bnd=ncread(ncfile1,'mesh2d_face_y_bnd',[1 1],[3 Inf]);
%     G1.morph_t0 = d3dout.TT.bedlevel{1,:}; %ncread(ncfile1,'mesh2d_mor_bl',[1 1],[Inf 1]);
%     G1.morph_tend = d3dout.TT.bedlevel{end,:}; %ncread(ncfile1,'mesh2d_mor_bl',[1 G1.time.Size],[Inf 1]);
% 
%     G2.time=ncinfo(ncfile2,'time');
%     G2.mesh_x = d3dout.grd.xface; %Characteristic x and y coordinate of mesh face
%     G2.mesh_y = d3dout.grd.yface; 
%     G2.mesh_x_bnd=ncread(ncfile2,'mesh2d_face_x_bnd',[1 1],[3 Inf]); %mesh cell boundary nodes
%     G2.mesh_y_bnd=ncread(ncfile2,'mesh2d_face_y_bnd',[1 1],[3 Inf]);
%     G2.morph_t0 = d3dout.TT.bedlevel{1,:}; %ncread(ncfile1,'mesh2d_mor_bl',[1 1],[Inf 1]);
%     G2.morph_tend = d3dout.TT.bedlevel{end,:}; %ncread(ncfile1,'mesh2d_mor_bl',[1 G1.time.Size],[Inf 1]);
