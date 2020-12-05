function [d3dout] = d3dparse(ncfile, outdir, varin, fmodel)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parse D3D Data Into Structure
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   09/02/2020
%-----------------------------------------------------

% NOTES

% 
%% Structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup time structure

    timeunits=ncreadatt(ncfile,'time','units');
    timebase=datenum(timeunits([14:end])); %matlab datenum of model time base
    d3dout.time.t=ncread(ncfile, 'time', [fmodel(1)], [fmodel(2)], [1])/3600/24+timebase; %save timestep time as matlab datenum
    d3dout.time.tstep=ncread(ncfile, 'timestep', [fmodel(1)], [fmodel(2)], [1]); 

% Setup grid structure

    d3dout.G = dflowfm.readNet(ncfile);
        d3dout.G.mesh_x = ncread(ncfile,'mesh2d_face_x',[1],[Inf]);  %Characteristic x and y coordinate of mesh face
        d3dout.G.mesh_y = ncread(ncfile,'mesh2d_face_y',[1],[Inf]); 
        d3dout.G.mesh_x_bnd = ncread(ncfile,'mesh2d_face_x_bnd',[1 1],[3 Inf]); %mesh cell boundary nodes(triangulation)
        d3dout.G.mesh_y_bnd = ncread(ncfile,'mesh2d_face_y_bnd',[1 1],[3 Inf]);
        d3dout.G.morph_t0 = ncread(ncfile,'mesh2d_mor_bl',[1 1],[Inf 1]);
        d3dout.G.morph_tend = ncread(ncfile,'mesh2d_mor_bl',[1 length(d3dout.time.t)],[Inf 1]);
    
% Setup variable structure

    for i = 1:length(varin)/5

        clear temp1 temp2

        if length(varin{i*5-2}) >= 2 % If time included
            temp1 = ncread(ncfile,varin{i*5-4},varin{i*5-2},varin{i*5-1},varin{i*5});

            if length(varin{i*5-2}) >= 3 % If sediment transport with fraction

                if size(temp1,2) == 1
                    temp2(:,:) = temp1(:,1,:);

                    d3dout.TT.(varin{i*5-3}) = array2timetable(temp2(:,:)', 'RowTimes',datetime(datevec(d3dout.time.t)));

                else
                    for j = 1:size(temp1,2)
                        temp2(:,:) = temp1(:,j,:);

                        d3dout.TT.sedfrac{j}.(varin{i*5-3}) = array2timetable(temp2(:,:)', 'RowTimes',datetime(datevec(d3dout.time.t)));
                    end

                end


            else

                d3dout.TT.(varin{i*5-3}) = array2timetable(temp1(:,:)', 'RowTimes',datetime(datevec(d3dout.time.t)));

            end


        else % Grid or time

            d3dout.grd.(varin{i*5-3}) = ncread(ncfile,varin{i*5-4},varin{i*5-2},varin{i*5-1},varin{i*5});

        end


    end


%% Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(outdir);
save('d3dout', 'd3dout', '-v7.3')


end


%% To Do


% ***This section is incomplete - Would manually find the necessary fields

% varexist = nc_info(ncfile);
% data = struct2cell(varexist.Dataset);
% datamat = data(1,:);
% 
% ct = 0;
% for i = 1:length(varin)
%    
%     if sum(ismember(datamat,varin{i})) >= 1;
%         
%         clear f temp
%         f =  find(ismember(datamat,varin{i}) == 1);
% 
%         ct = ct+1;
%         varfields{ct,1}= varin{i};
%         temp = data(5,f);
%         
%         for j = length(temp)
%             
%             
%             
%             var1 = [];
%             var2 = []
%             
%         end
%         
%         varfields{ct,2} = var1;
%         varfields{ct,3} = var2;
%         
%     else
%     end
% 
%     
% end