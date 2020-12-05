
Q.angle = 30;
ii = 3;
% load('F:\projects\19_27\modeling\delft3d\integrated\grid_02\model_03\Project1\d3dout')
ncfile = '\\Wahoo\e\19_27\modeling\integrated\grid_02\model_04\Project1.dsproj_data\Integrated_Model_output\dflowfm\output\FlowFM_map.nc';
dx = 1;

% G = dflowfm.readNet(ncfile); %read grid 

%% Compute Transport

xtran = d3dout.TT.sedfrac{ii}.transportx{:,:};
ytran = d3dout.TT.sedfrac{ii}.transporty{:,:};

ts = zeros(size(xtran));
Q.qvec_ang = atan2d(ytran, xtran);


            ts = ones(size(Q.qvec_ang,1),size(Q.qvec_ang,2))*-1;
            
                    % Initialize ts, where ts=1 for flood flow
                    if mod(Q.angle,360)> mod(Q.angle+90,360) && mod(Q.angle,360)> mod(Q.angle-90,360) % Transect angle between 270 and 360

                        for k = 1:size(Q.qvec_ang,1);
                            for j = 1:size(Q.qvec_ang,2)
                                if mod(Q.qvec_ang(k,j),360)<mod(Q.angle-90,360) & mod(Q.qvec_ang(k,j),360)>mod(Q.angle+90,360);
                                ts(k,j) = ts(k,j)*-1;
                                else
                                end
                            end
                        end
                        
                    % Transect angle between 0 and 90    
                    elseif mod(Q.angle,360)< mod(Q.angle+90,360) && mod(Q.angle,360)< mod(Q.angle-90,360)
                        for k = 1:size(Q.qvec_ang,1);
                            for j = 1:size(Q.qvec_ang,2)
                                if mod(Q.qvec_ang(k,j),360)>mod(Q.angle+90,360) & mod(Q.qvec_ang(k,j),360)<mod(Q.angle-90,360);
                                ts(k,j) = ts(k,j)*-1;
                                else
                                end
                            end
                        end
                        
                    % Transect angle between 90 and 270
                    else 
                        for k = 1:size(Q.qvec_ang,1);
                            for j = 1:size(Q.qvec_ang,2)
                                if mod(Q.qvec_ang(k,j),360)>mod(Q.angle+90,360) | mod(Q.qvec_ang(k,j),360)<mod(Q.angle-90,360);
                                ts(k,j) = ts(k,j)*-1;
                                else
                                end
                            end
                        end
                    end
    

        Q.Dx = sind(Q.angle).*dx;
        Q.Dy = cosd(Q.angle).*dx;
        
        Q.qxcomp = xtran*Q.Dx; % Total x component transport (m3/s)
        Q.qycomp = ytran*Q.Dy; % Total y component transport (m3/s)    

        Q.Qtotal = (Q.qxcomp + Q.qycomp)*3600; % Total Flux Across Transect (m3/s)
        Q.Q=abs(Q.Qtotal).*ts;

        sumq = sum(Q.Q)*24*60*60*365/(156*3600);
                


%% Plot

p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','inlet.tif'); hold on
dflowfm.plotMap(G,sumq); %plot_color contour map (from openearth tools, shich needs to be in the matlab path)
% dflowfm.plotMap(G,sum(Q.qycomp)); %plot_color contour map (from openearth tools, shich needs to be in the matlab path)

caxis([-2000 2000])
colormap(bluewhitered)

box on;
grid;
set(gca,'layer','top');


                
                
                