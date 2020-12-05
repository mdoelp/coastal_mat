


    
    fig1 = figure;
        set(gcf,'position',[406 189 1191 738]);
        ax = gca

        % Plot;
        	plot(d3dout.time.t(1:length(Q.Qnet)),Q.Qnet*1.30795,'k','linewidth',1); hold on;
        % Labels;
            title([trnum,' - ',sfrac{sf}])
            xlabel('Simulation Day')
            ylabel('Transport (yd^3/s)')
%             legend
        % Axes
            % Limits
        % Ticks
                datetick('x','keeplimits','keepticks');
            grid on
            box on
        
           str2 = {num2str(Q.Qright_sum*31536000/Q.duration_s,'Right (+): %8.1f cu yd/yr\n');...
               num2str(Q.Qleft_sum*31536000/Q.duration_s,'Left (-): %8.1f cu yd/yr\n');...
               num2str(Q.Qnet_sum*31536000/Q.duration_s,'Net: %8.1f cu yd/yr\n');...
               num2str(Q.Qgross,'Gross: %8.1f cu yd/yr\n')};
               
                ha=label_axes(ax, str2(1), 'northwest');
                ha=label_axes(ax, str2(2), 'southwest');
                ha=label_axes(ax, str2(3), 'northeast');
                ha=label_axes(ax, str2(4), 'southeast');
