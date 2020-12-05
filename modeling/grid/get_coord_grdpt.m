
%%


% Directory

    aerial_dir = 'D:\19-27_StLucie\modeling\gis\worldfiles\'
    aerial_name = 'sli_aerial.tif';
    sc = 1 %0.3048*1000;
   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p_aerial(aerial_dir,aerial_name,sc); hold on; zoom on; pause; zoom off;
    [cellpt] = ginput(length(gauges)); close
    pts = [x, y];
    
    cellx = cellpt(:,1);
    celly = cellpt(:,2);
          
            cellx(1) = [928141.5/3.28084];
            celly(1) = [1031685.5/3.28084];



    for j = 1:length(gauges);
            [k(j),dist] = dsearchn(pts,[cellx(j) celly(j)]);
    end
    
    