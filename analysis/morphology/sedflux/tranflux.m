function [Q] = tranflux(Q)
% Calculates flux along chosen transect


% Inputs
%         Q.dt  % Timestep
%         Q.duration_s % Duration of simulation period
%         Q.vert % Set vertices
%         Q.angle % Cartesian angle of transect        
%         Q.qxcomp % Total x component transport 
%         Q.qycomp % Total y component transport
%         Q.qxtran & Q.qytran % Interpolate transport to transect vertices

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute Total Transport

   
        Q.Qtotal = (Q.qxcomp + Q.qycomp); % Total Flux Across Transect (m3/s)
    
        
        % Find directions


            for k = 1:size(Q.qvec_ang,1);
                for j = 1:size(Q.qvec_ang,2)
                    if Q.qvec_ang(k,j) < 0; Q.qvec_ang(k,j) = Q.qvec_ang(k,j)+360; end;
                end
            end

            [Q.ts, Q.ts2] = dirdefine(Q.angle, Q.qvec_ang)
            
            Q.Q=abs(Q.Qtotal).*Q.ts; % Define as positive (right) or negative (left) per second (m^3/s)
        
        % Q Statistics
        
            % Right directed

            Q.Qright=sum(Q.Q.*(Q.Q>0)); % Right transport accross transect at each timestep 
            Q.Qright_sum=sum(Q.Qright)*Q.dt; % Right transport during simulation (m^3 - simulation (s))

            % Left directed

            Q.Qleft=sum(Q.Q.*(Q.Q<0)); % Left transport across transect at each timestep
            Q.Qleft_sum=sum(Q.Qleft)*Q.dt; % Left transport during simulation (m^3 - simulation (s))
            
            % Net

            Q.Qnet = Q.Qleft + Q.Qright; % Net transport across transect at each timestep
            Q.Qnet_sum = sum(Q.Qnet)*Q.dt; % Cumulative transport during simulation (m^3 - simulation (s))
            Q.Qgross = abs(Q.Qright_sum)+abs(Q.Qleft_sum); % (m^3 - simulation (s))


    
end



