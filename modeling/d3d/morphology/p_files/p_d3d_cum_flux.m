    annualized_t = (d3dout.time.t-d3dout.time.t(1))*(31536000/d3dout.time.duration_s);
    trapz(Q.Qtotal);
    f = cumsum(Q.Qnet*1.30795)*(31536000/d3dout.time.duration_s); % Annualized Cumulative transport (yd3/duration)

    fig1 = figure;
        set(gcf,'position',[430 219 860 635])
        ax = gca
        % Plot;
            plot(d3dout.time.t(1:length(Q.Qnet)),f)
        % Labels;
            title([trnum,' - ',sfrac{sf}])
            xlabel('Day of Year')
            ylabel('Annualized Transport (yd^3/s)')
        % Axes
            % Limits
%                 xlim([t1 t2])
%                 ylim([min(wl(:)) max(wl(:))])
        % Ticks
%                 s{1}.XTick = t1:12/24:t2;
%                 s{1}.XTickLabels = [t1:12/24:t2];
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


