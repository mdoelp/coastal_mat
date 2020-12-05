%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  XBEACH Sediment Flux
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear, close all
%-----------------------------------------------------
%   11/06/2020
%-----------------------------------------------------

% NOTES

% Auxillary scripts:

%% Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for trnum = tr;
       
%         
%         % Find directions
% 
% 
%             for k = 1:size(Q.qvec_ang,1);
%                 for j = 1:size(Q.qvec_ang,2)
%                     if Q.qvec_ang(k,j) < 0; Q.qvec_ang(k,j) = Q.qvec_ang(k,j)+360; end;
%                 end
%             end
% 
%             [Q.ts, Q.ts2] = dirdefine(Q.angle, Q.qvec_ang)
%             
%             Q.Q=abs(Q.Qtotal).*Q.ts; % Define as positive (right) or negative (left) per second (m^3/s)
%         
%         % Q Statistics
%         
%             % Right directed
% 
%             Q.Qright=sum(Q.Q.*(Q.Q>0)); % Right transport accross transect at each timestep 
%             Q.Qright_sum=sum(Q.Qright)*Q.dt; % Right transport during simulation (m^3 - simulation (s))
% 
%             % Left directed
% 
%             Q.Qleft=sum(Q.Q.*(Q.Q<0)); % Left transport across transect at each timestep
%             Q.Qleft_sum=sum(Q.Qleft)*Q.dt; % Left transport during simulation (m^3 - simulation (s))
%             
%             % Net
% 
%             Q.Qnet = Q.Qleft + Q.Qright; % Net transport across transect at each timestep
%             Q.Qnet_sum = sum(Q.Qnet)*Q.dt; % Cumulative transport during simulation (m^3 - simulation (s))
%             Q.Qgross = abs(Q.Qright_sum)+abs(Q.Qleft_sum); % (m^3 - simulation (s))
% 

    
    % Vertices and Distances
    
        Q{trnum}.dt = 360
        Q{trnum}.duration_s = length(timer)*Q{trnum}.dt;
        Q{trnum}.angle = sh_ang;
        Q{trnum}.vert = [x(sed_rg,trnum) y(sed_rg,trnum)];

        Q{trnum}.vertd = zeros(length(sed_rg)+1,1); % Set distances = 0 initially
        
        for i = 1:length(Q{trnum}.vert)-1

            Q{trnum}.vertd(i+1) = norm([Q{trnum}.vert(i+1,1) Q{trnum}.vert(i+1,2)]-[Q{trnum}.vert(i,1) Q{trnum}.vert(i,2)]);

        end
        
        Q{trnum}.vertd(1) = Q{trnum}.vertd(2);
        Q{trnum}.vertd(end) = Q{trnum}.vertd(end-1);

        Q{trnum}.vertd_pt = zeros(length(sed_rg),1);
        
        for i = 1:length(Q{trnum}.vertd)-1

            Q{trnum}.vertd_pt(i) = (Q{trnum}.vertd(i)+Q{trnum}.vertd(i+1))/2;

        end

    % Find Transport


        Q{trnum}.xtran = squeeze(su(sed_rg,trnum,timer)); % x transport m2 per duration
        Q{trnum}.ytran = squeeze(sv(sed_rg,trnum,timer)); % y transport m2 per duration
                
        for j = 1:length(timer)
            for i = 1:length(Q{trnum}.vertd_pt)

                Q{trnum}.qxtran(i,j) = Q{trnum}.vertd_pt(i)*Q{trnum}.xtran(i,j);
                Q{trnum}.qytran(i,j) = Q{trnum}.vertd_pt(i)*Q{trnum}.ytran(i,j);

            end
        end
        
        Q{trnum}.qvec_ang = atan2d(Q{trnum}.qytran,Q{trnum}.qxtran); % Cartesian angle of net transport

        for k = 1:size(Q{trnum}.qvec_ang,1);
            for j = 1:size(Q{trnum}.qvec_ang,2)
                if Q{trnum}.qvec_ang(k,j) < 0; Q{trnum}.qvec_ang(k,j) = Q{trnum}.qvec_ang(k,j)+360; end;
            end
        end

        Q{trnum}.qxcomp = Q{trnum}.xtran*sind(Q{trnum}.angle); % alongshore x component m2 per duration
        Q{trnum}.qycomp = Q{trnum}.ytran*cosd(Q{trnum}.angle); % alongshore y component m2 per duration

    
    % Find component of transport at each point and direction for each timestep

        [ts, ts2] = dirdefine(Q{trnum}.angle, Q{trnum}.qvec_ang);
        [Q{trnum}] = tranflux(Q{trnum});

        
%         fprintf('Total right directed (positive): %8.1f cu yd/yr\n',Q.Qright_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
%         fprintf('Total left directed (negative): %8.1f cu yd/yr\n',Q.Qleft_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
%         fprintf('Total net transport: %8.1f cu yd/yr\n',Q.Qnet_sum*31536000/d3dout.time.duration_s); % (m^3/yr)
%         fprintf('Gross transport: %8.1f cu yd/yr\n',Q.Qgross*31536000/d3dout.time.duration_s); % (m^3/yr)

        Q{trnum}.a_right = 1.30795*Q{trnum}.Qright_sum*31536000/(Q{trnum}.duration_s*Q{trnum}.dt); % (m^3/yr)
        Q{trnum}.a_left = 1.30795*Q{trnum}.Qleft_sum*31536000/(Q{trnum}.duration_s*Q{trnum}.dt) % (m^3/yr)
        Q{trnum}.a_net = 1.30795*Q{trnum}.Qnet_sum*31536000/(Q{trnum}.duration_s*Q{trnum}.dt); % (m^3/yr)
        Q{trnum}.a_gross = 1.30795*Q{trnum}.Qgross*31536000/(Q{trnum}.duration_s*Q{trnum}.dt); % (m^3/yr)  
        
        
        
        s_tot(trnum) = Q{trnum}.a_net;
        
        
        
end



%% Archive



% ts = ones(length(sed_rg)-1,length(timer));
% s_comp = 0*ts;
% 
% for j = 1:length(timer)
%     for i = 1:length(sed_rg)-1
%         if negdir(1)+360 <= theta360(i,j)+360 && negdir(1)+360 <= theta360(i,j)+360 <= negdir(2)+360
%             ts(i,j) = -1;
%             
%             if theta360(i,j)>ndir
%             	s_comp(i,j) = s_t(i,j)*cosd(theta360(i,j)-ndir); % Quadrant 2
%             else        
%                 s_comp(i,j) = s_t(i,j)*cosd(ndir - theta360(i,j)); % Quadrant 1
%             end
%             
%         else
%             if theta360(i,j)>pdir
%             	s_comp(i,j) = s_t(i,j)*cosd(theta360(i,j)-pdir); % Quadrant 4
%             else        
%                 s_comp(i,j) = s_t(i,j)*cosd(pdir-theta360(i,j)); % Quadrant 3
%             end
% 
%         end
%        
%         s_q(i,j) = ts(i,j).*s_comp(i,j); % Transport at each point at each timestep
%         
%     end
%     
% end
    


