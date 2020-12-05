

p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','sli_aerial.tif'); hold on

h = patch(d3dout.G.mesh_x_bnd*scl/1000,d3dout.G.mesh_y_bnd*scl/1000,d3dout.G.morph_tend/0.3048);


    set(h,'edgeColor','none'); % turn off triangle edges
    view(0,90);
    c=colorbar;
    cmap = cmocean('-deep');
    colormap(cmap);
        clim([-45 5])
        ll = get(c,'Label');
    titleString = 'elevation, ft NAVD';
    set(ll ,'String',titleString);

% xlim([274.900 275.900])
% ylim([800.720 801.420])
%     set(gcf,'position',[40 568 851 420])
    grid on
    axis equal
%         title('Scenario A')
hold on
set(gcf,'position',[40 87 1803 901])
    xlabel('FL east state plane, ft/1000')
    ylabel('')