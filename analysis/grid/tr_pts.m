
% Takes a transect from points selected on an aerial and finds vertices
     
    if isempty(pts_tran)

        p_aerial('D:\19-27_StLucie\modeling\gis\worldfiles','inlet.tif')

        zoom on; pause(); % you can zoom with your mouse and when your image is okay, you press any key
        zoom off; % to escape the zoom mode
    
        fprintf('Select points, with the first being onshore\n')
        fprintf('Positive transport is directed right when facing offshore\n')


        [ptx, pty] = ginput(2); % Select points, with the first being onshore      
        
    else
        
        ptx = pts_tran((ii*2)-1:ii*2,1); % x coordinates of points
        pty = pts_tran((ii*2)-1:ii*2,2); % y coordinates of points

    end
    close


        

    