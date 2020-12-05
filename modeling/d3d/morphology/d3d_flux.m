
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes

% This program takes in a D3D mapfile for sediment transport and finds the
% flux across specified transects. It then plots flux







if exist('d3dout.TT.sedfrac','var') == 0
    d3dout.TT.sedfrac{sf}.transportx = d3dout.TT.transportx;
    d3dout.TT.sedfrac{sf}.transporty = d3dout.TT.transporty;
else
end

for tr = pick_transects %1:length(pts_tran)/2
    
    trnum = num2str(tr,'Transect%1.0f'); % Transect Number

    d3dout.transect.(trnum){length(d3dout.TT.sedfrac)+1}.net = 0;

    for sf = 1:length(d3dout.TT.sedfrac)
        
        
        clear Q D vert ptx pty d numpts 
        

        % Setup Directories

            mkdir([outdir,'\transects\',trnum])
            cd([outdir,'\transects\',trnum])

        % Transect

            ptx = pts_tran((tr*2)-1:tr*2,1); % x coordinates of points
            pty = pts_tran((tr*2)-1:tr*2,2); % y coordinates of points

            d = sqrt((ptx(2)-ptx(1))^2+((pty(2)-pty(1))^2)); % distance
            numpts = round(d/dx); % number of points along transect

        % Setup Q

            Q.dt = d3dout.time.dt; % Timestep
            Q.duration_s = d3dout.time.duration_s; % Duration of simulation period
            Q.vert = [linspace(ptx(1), ptx(2), numpts+2)' linspace(pty(1), pty(2), numpts+2)']; % Set vertices
            Q.angle = atan2d((pty(2)-pty(1)),(ptx(2)-ptx(1))); % Cartesian angle of transect        
                posdir = Q.angle - 90; % Cartesian angle of the positive direction (Right directed positive transport)
                negdir = Q.angle + 90; 


        % Interpolation to Vertices

            for j = 1:length(d3dout.TT.sedfrac{1}.transportx{:,1});

                    Q.qxtran(:,j) = griddata(d3dout.transvar.X,d3dout.transvar.Y, d3dout.TT.sedfrac{sf}.transportx{j,:},Q.vert(:,1),Q.vert(:,2)); % Interpolated Transport per unit distance(m3/s/m)in x direction
                    Q.qytran(:,j) = griddata(d3dout.transvar.X,d3dout.transvar.Y, d3dout.TT.sedfrac{sf}.transporty{j,:},Q.vert(:,1),Q.vert(:,2)); % Interpolated Transport per unit distance(m3/s/m) in y direction

            end        

            Q.qvec_ang = atan2d(Q.qytran,Q.qxtran); % Cartesian angle of net transport

            % MIGHT NEED TO CHANGE TO qvec_ang
            
            Q.Dx = sind(Q.angle).*dx;
            Q.Dy = cosd(Q.angle).*dx;

            Q.qxcomp = Q.qxtran*Q.Dx; % Total x component transport (m3/s)
            Q.qycomp = Q.qytran*Q.Dy; % Total y component transport (m3/s)  

        % Run

            [Q] = sedflux(Q);
            
            d3dout.transect.(trnum){sf} = Q;
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    %% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        fprintf('Total right directed (positive): %8.1f cu yd/yr\n',Q.Qright_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
        fprintf('Total left directed (negative): %8.1f cu yd/yr\n',Q.Qleft_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
        fprintf('Total net transport: %8.1f cu yd/yr\n',Q.Qnet_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
        fprintf('Gross transport: %8.1f cu yd/yr\n',Q.Qgross*31536000/d3dout.time.duration_s); % (m^3/yr)

        Q.a_right = Q.Qright_sum*31536000/Q.duration_s; % (m^3/yr)
        Q.a_left = Q.Qleft_sum*31536000/Q.duration_s; % (m^3/yr)
        Q.a_net = Q.Qnet_sum*31536000/Q.duration_s; % (m^3/yr)
        Q.a_gross = Q.Qgross*31536000/Q.duration_s; % (m^3/yr)
        %     tr_flux.prchange = pr_change;    

        fprintf('Transect cartesian heading: %8.1f\n',Q.angle); % change to compass heading!!!

        save(['Q_',sfrac{sf},'.mat'],'Q','-v7.3')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
        % Figure 1 - Transport PDF

            p_d3d_trans_rate
            export_fig([trnum,'_sedflux_',sfrac{sf},'.jpg'],'-r300','-nocrop');savefig([trnum,'_sedflux_',sfrac{sf},'.fig']); close  

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
        % Figure 2 - Cummulative Transport

            p_d3d_cum_flux
            export_fig([trnum,'_annualized_',sfrac{sf},'.jpg'],'-r300','-nocrop');savefig([trnum,'_annualized_',sfrac{sf},'.fig']); close

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        % Figure 3 - Transect Location

%             p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','inlet.tif'); hold on
%             p_tr_loc
%             export_fig([trnum,'_location.jpg'],'-r300','-nocrop');savefig([trnum,'_location']); close all


    end
    
    for sf = 1:length(d3dout.TT.sedfrac)
        
             d3dout.transect.(trnum){length(d3dout.TT.sedfrac)+1}.net = d3dout.transect.(trnum){length(d3dout.TT.sedfrac)+1}.net+d3dout.transect.(trnum){sf}.Qnet_sum;

    end
        
    
    
    
%     d3d_flux_combine_fig
    
    
    
end

cd(['F:\projects\19_27\modeling\delft3d\',type,grd,mname,project])
save('d3dout', 'd3dout', '-v7.3')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Transect

d3d_flux_transect




                                                         




