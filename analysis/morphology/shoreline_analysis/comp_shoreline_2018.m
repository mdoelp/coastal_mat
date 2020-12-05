
%%
% infiles={'bournes_0.5m_NAVD_2010_shoreline.txt'};
% outfiles={'bournes_2010_shoreline_250cm.out'};
% infiles={'bournes_seawall.txt'};
% outfiles={'bournes_seawall_250cm.out'};

% addpath('D:\18-03_NorthShore\modeling\sedtrans\shorelines\lower')

% infiles={'nshore_NAVD_m_lower_shoreline_smooth.txt'};
clear
infiles={'D:\19-36_Tisbury\data\survey\shoreline\tisbury_south_navd_m_ma_island.txt'}; conv=0; %need to convert feet to meters
outfiles={'tisbury_shoreline_11062019.out'};

shorang=140; %baseline azimuth in compass degrees

x1 = 491500.5;
y1 = 50524.6;
jdim=100;     % j dimension size of stwave grid number of cells
dj=5;       % j grid cell size, meters
ang=degree_convert(shorang); %convert compass to cartisian degrees
angnorm=ang+90+180; %normal to baseline

for shr=1:length(infiles)
shor=load(infiles{shr}); if conv; shor=shor*.3048; end

% reverse the measured shoreline, if necessary
ii=0;
for i=length(shor):-1:1
    ii=ii+1;
    shor_temp(ii,:)=shor(i,:);
end
shor=shor_temp;
% CHECK THE DIRECTION OF THE SIGN BEFORE AND AFTER IM TO MAKE SURE CORRECT
% ORIENTATION

for j=1:jdim
    x(j)=x1+(j-1)*dj*cos(ang*pi/180);
    y(j)=y1+(j-1)*dj*sin(ang*pi/180);
    for i=1:length(shor) %calculate the distance from a line through the grid point
                         % (and perpendicular to shorang) to each point in shor
        dist(i)=(cos(ang*pi/180)*(shor(i,1)-x(j))+sin(ang*pi/180)*(shor(i,2)-y(j))); 
        %per page 40 of Multivariable Mathematics
    end    
    clear f
    f = find(abs(dist)==min(abs(dist))); %the smallest distance is the wanted one
    imin(j)= f(1);
    im=imin(j);
    if imin(j)==1 && dist(im)<0   %grid point is beyond the measured shoreline 
        grid_shor(j,1)=x(j);
        grid_shor(j,2)=y(j);
    elseif imin(j)==length(shor) && dist(im)>0 %grid point is beyond the measured shoreline
        grid_shor(j,1)=x(j);
        grid_shor(j,2)=y(j);
    elseif dist(im)>0
        %determine intersection of shoreline and wave grid row
        m1=tan(angnorm*pi/180); %find slope-intercept form of equation of each lines
        b1=y(j)-m1*x(j);
        if im ==1 
        	grid_shor(j,1)=shor(im,1);

        else
            if shor(im,1)~=shor(im-1,1)
            m2=(shor(im,2)-(shor(im-1,2)))/(shor(im,1)-(shor(im-1,1)));
            b2=shor(im,2)-m2*shor(im,1);
            grid_shor(j,1)=(b2-b1)/(m1-m2);
          
        else
            grid_shor(j,1)=shor(im,1);
            end
        end
        grid_shor(j,2)=grid_shor(j,1)*m1+b1;
    elseif dist(im)>0
        %determine intersection of shoreline and wave grid row
        m1=tan(angnorm*pi/180); %find slope-intercept form of equation of each lines
        b1=y(j)-m1*x(j);
        if shor(im+1,1)~=shor(im,1)
            m2=(shor(im+1,2)-(shor(im,2)))/(shor(im+1,1)-(shor(im,1)));
            b2=shor(im,2)-m2*shor(im,1);
            grid_shor(j,1)=(b2-b1)/(m1-m2);
        else
            grid_shor(j,1)=shor(im,1);
        end
        grid_shor(j,2)=grid_shor(j,1)*m1+b1;
    else
        grid_shor(j,1)=shor(im,1);
        grid_shor(j,2)=shor(im,2);
    end
    idist(j)=abs(cos(angnorm*pi/180)*(grid_shor(j,1)-x(j))+sin(angnorm*pi/180)*(grid_shor(j,2)-y(j)));
end

jstart=1;  
jfinish=jdim;  
skip=1;       % number of j-axis grid layers to skip (every other 'skip' row)
outj=1;
for j=jstart:skip:jfinish    
    outshor(outj)=idist(j); %the perpendicular distance between the wave grid x-axis and the shoreline for each grid row
    out_grid_shor(outj,1)=j; %wave grid alongshore index
    out_grid_shor(outj,2)=grid_shor(j,1);
    out_grid_shor(outj,3)=grid_shor(j,2);
    outj=outj+1;
end

%save shore_longbeach_south_2002.out outshor -ascii

fid=fopen(outfiles{shr},'w');

for i=1:length(outshor)
    fprintf(fid,'%i %10.2f %10.2f %10.2f\n',out_grid_shor(i,1), out_grid_shor(i,2), out_grid_shor(i,3), outshor(i));
end
%clear outshor grid_shor dist
fclose(fid)
%clear dist grid* out_* shor* outshore
end