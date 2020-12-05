

        % Plot;
%         p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','inlet.tif'); hold on

            plot(Q.vert(:,1), Q.vert(:,2),'r', 'Linewidth', 2); % plot transect vertices
        set(gcf,'position',[214 238 1026 740]);

        title([trnum, ' - ',num2str(Q.Qnet_sum*31536000/d3dout.time.duration_s,'Total net transport: %8.1f cu yd/yr\n')])
        grid on
        axis equal;
        