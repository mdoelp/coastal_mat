function [confile_modl,tmsfile_modl,confile_meas,tmsfile_meas,tide_mean_delta,rms_error,rsquared]=compare_model_tides(modelrun,plot_station,spinup,plotit)

d3dprefix='C:\Users\mdoel\Desktop\working\19_27\sli_calibration\'; %prefix of directory with model otput
d3dsufix='\FlowFM\output\FlowFM_his.nc'; %sufix of model output directory
mapfile=[d3dprefix modelrun d3dsufix];
% mapfile = 'C:\Users\mdoel\Desktop\working\sli_calibration\Project5.dsproj_data\FlowFM\output\FlowFM_his.nc'

tide_directory='D:\19-27_StLucie\data\tides\SLI_tides_2019_NAVDft_adjusted\';
%tide_file_id={'SFP1','SFP2','M1','PL','SEBR','WC','RB','SLLD','SEOB','JBC','S2'}; %station ids

[d3dtide,stationids]=read_obs_point_tide(mapfile);

d3did=find(strcmp(stationids, plot_station));

if ~isempty(d3did)
    
    if strcmp(plot_station,'N2');
        plot_station='S2';
    end
    tfile=[tide_directory '\' plot_station '_pressure_tide_2019_deployment_final_adjusted.dat'];
    td=load(tfile);
    
    bb=find(isnan(td(:,3)));
    if length(bb)>0
        gap=1;
        ig=0; 
        ibb=1;        
        while gap
            ig=ig+1; %gap counter
            g1(ig)=bb(ibb); %the index of the start of the data gap
            igcount=0; %keeps track of the number of contiguous time steps within the gap 
            if ibb+igcount+1<length(bb)
                while (bb(ibb+igcount+1)-g1(ig))/(igcount+1)==1 && bb(ibb+igcount+1) < bb(end) %search for end of gap (search for series of abutting NaNs)
                    igcount=igcount+1;
                end
                if bb(ibb+igcount)+1==bb(end) %the very last nan of the whole record, in a multi-nan series
                    igcount=igcount+1;
                end                    
            elseif length(bb)>1
                igcount=igcount+1; %case where single nan remaining for last multi-nan gap of the whole record  
            end %if only signle one nan gap in whole record, value of igcount remains 0 
            ibb=ibb+igcount+1;
            g2(ig)=g1(ig)+igcount;
            if ibb>length(bb)
                gap=0; %no more gaps to consider
            end
        end
        %interpolate tide data to fill in gaps
        for i=1:ig
            for ii=g1(i):g2(i)
                td(ii,3)=(td(ii,1)-td(g1(i)-1,1))/(td(g2(i)+1,1)-td(g1(i)-1,1))*(td(g2(i)+1,3)-td(g1(i)-1,3))+td(g1(i)-1,3);
            end
        end
    end
    
    clear g1 g2;
    
    itd=find(td(:,1)>=d3dtide(1,1)+spinup/24 & td(:,1)<=d3dtide(end,1)); %spinup is the time in hours to ignor at the beginning of the model run
    itm=find(d3dtide(:,1)>=d3dtide(1,1)+spinup/24); 
    
    meantide_meas=mean(td(itd,3));
    meantide_modl=mean(d3dtide(itm,d3did+1))/.3048;
    tide_mean_delta=meantide_modl-meantide_meas;
    
    [confile_meas,tmsfile_meas]=Go_tide_4(td(itd,1),td(itd,3)); %output all stats in feet (d3d output in meters)
    [confile_modl,tmsfile_modl]=Go_tide_4(d3dtide(itm,1),d3dtide(itm,d3did+1)/.3048);
        
    [rms_error,rsquared]=rsquared_v2_tides(d3dtide(itm,d3did+1)/.3048,td(itd,3));
    
    if plotit
        figure
        hold on
        plot(d3dtide(itm,1),d3dtide(itm,d3did+1)/.3048,'k','linewidth',1);
        ttl=['model run ' modelrun '; gauge station ' plot_station];
        title(ttl, 'Interpreter', 'none');
        datetick('x','keeplimits');
       
        plot(td(itd,1),td(itd,3)+tide_mean_delta,'b','linewidth',1);
        grid
        box on
        
        legend('model','measured')
    end
    
else
    fprintf('station %s is not found in model %s\n',plot_station,modelrun);
    fprintf('available staion ids:\n')
    for i=1:length(stationids)
        fprintf('   %s\n',stationids{i});
    end
end

