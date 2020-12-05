function depgen(fdir,fname,project,dx,dy, x0, y0, a, i, j, fout)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate .dep file
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   07/25/2018
%-----------------------------------------------------

% NOTES

% Original dep generation script written by Sean Kelley
% Ensure that the .txt file with lat, lon, and depths are derived from a 
% mesh so that the depths include the grid edges

%% INPUTS

% fdir = 
% fname = 
% project = 
% dx = 
% dy = 
% x0 = 
% y0 = 
% a = 
% i = 
% j = 
% fout = 

% depgen(fdir,fname,project,dx,dy, x0, y0, a, i, j, fout)
 
%% Outputs

% Nor, est, grd, and dep file

%% DIRECTORY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath(fdir));
scat=load(fname);

%% DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imax = i+1;
jmax = j+1;

grd(jmax,imax)=0;
est(jmax,imax)=0;
nor(jmax,imax)=0;

%% GRID %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=0; % the kounter of total grid points
for i=1:imax;
    for j=1:jmax
        if i==1 && j==1
            k=1;
        else
            di=(i-1)*dx; %distance to ith grid row along x axis
            dj=(j-1)*dy; %distance to jth grid row along y axis
            hyp=sqrt(di^2+dj^2); %hypotenuse
            ang_grd_rel=acosd(di/hyp); %angle grid reletive from origin
            ang_cartesian=grid_ang+ang_grd_rel;
            if ang_cartesian>360
                ang_cartesian=ang_cartesian-360;
            end
            x1=x_orig+cos(ang_cartesian*pi/180)*hyp;
            y1=y_orig+sin(ang_cartesian*pi/180)*hyp;
            xfind=find(dat(:,1)<x1+dx/4 & dat(:,1)>x1-dx/4); %narrow the search
            yfind=find(dat(xfind,2)<y1+dy/4 & dat(xfind,2)>y1-dy/4); %narrow the search further
            k=xfind(yfind); %this is the one
        end
        grd(j,i)=dat(k,3);
        est(j,i)=dat(k,1);
        nor(j,i)=dat(k,2);
        count=count+1;
        if fix(count/1000)*1000==count
            fprintf('line: %i\n',int32(count))
        end
    end
end

fid=fopen(fout,'w');
% grdrow=1;
% for j=jmax:-1:1
%     ii=1;
%     for i=1:imax
%         fprintf(fid,' %6.2f',grd(j,i)); % depths are positive in swan
%         ii=ii+1;
%         if ii>10 & i~=imax%reset ii to 1
%             ii=1;
%             fprintf(fid,'\n');
%         end
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);

%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save([project,'_nor'],nor)
save([project,'_est'],est)
save([project,'_grd'],grd)


end

