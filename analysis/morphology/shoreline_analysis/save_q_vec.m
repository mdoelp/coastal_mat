function save_q_vec(ex)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Title
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   XX/XX/XXXX
%-----------------------------------------------------

% NOTES

% 

%% Working


% Load the transport information

load('sm_net'); %Potential

q = sm_net;

% Load Shoreline Info
sdat=load('D:\18-03_NorthShore\modeling\sedtrans\exodus\shorelines\nshore_2015_lower.out');

%

linelength=40; %line length in meters

dx=5;
xsrt=1; %
xend=2242;
azimuth = 79.4; %angle of y-axis


xj=sdat(xsrt:10:xend,2);
yj=sdat(xsrt:10:xend,3);

load('norm') % Normal Angle to shore section
ang=norm+azimuth;


q=q*1.307951; %convert to yrd3/yr from m3/yr


maxq=25000; %max from cockle cove
skip=7;
vang=30; %vector arrow lines angle
vecfac=0.3; %vector head length factor

%%

for i=1:length(xj)
    xdelta=-(linelength*cos((ang(i))*pi/180)/2*abs(q(i))/maxq);
    ydelta= (linelength*sin((ang(i))*pi/180)/2*abs(q(i))/maxq);
    xdelta_v1=-(vecfac*linelength*cos((ang(i)+vang)*pi/180)/2*abs(q(i))/maxq); %the next four lines make the vector head
    ydelta_v1= (vecfac*linelength*sin((ang(i)+vang)*pi/180)/2*abs(q(i))/maxq);
    xdelta_v2=-(vecfac*linelength*cos((ang(i)-vang)*pi/180)/2*abs(q(i))/maxq);
    ydelta_v2= (vecfac*linelength*sin((ang(i)-vang)*pi/180)/2*abs(q(i))/maxq);
    %
    if q(i)<0
                x1=xj(i)+xdelta; y1=yj(i)+ydelta;
                xv1=xj(i)+xdelta_v1; yv1=yj(i)+ydelta_v1;
                xv2=xj(i)+xdelta_v2; yv2=yj(i)+ydelta_v2;
                
 
    else %q(i)<0
                x1=xj(i)-xdelta; y1=yj(i)-ydelta;
                xv1=xj(i)-xdelta_v1; yv1=yj(i)-ydelta_v1;
                xv2=xj(i)-xdelta_v2; yv2=yj(i)-ydelta_v2;
   
    end
%    plot([x1 x2],[y1 y2],'r')
    
    x1t(i)=x1; y1t(i)=y1;
    xv1t(i)=xv1; yv1t(i)=yv1;
    xv2t(i)=xv2; yv2t(i)=yv2;
end

fid=fopen('q_transects_vectors_100m.csv','w');
fprintf(fid,'ID, easting, northing, q\n');
iline=0;
for i=1:skip:length(x1t)
    if ~isnan(q(i))
        iline=iline+1;
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, xj(i), yj(i), abs(q(i)));
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, x1t(i), y1t(i), abs(q(i)));
%        iline=iline+1;
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, xj(i), yj(i), abs(q(i)));
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, xv1t(i), yv1t(i), abs(q(i)));
%        iline=iline+1;
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, xj(i), yj(i), abs(q(i)));
            fprintf(fid,'%i, %10.2f, %10.2f, %8.0f\n',iline, xv2t(i), yv2t(i), abs(q(i)));
    end
end

fclose(fid);

fid=fopen('shoreline_points_vector_100m.csv','w');
fprintf(fid,'ID, easting, northing, q, line\n');
iline=0;
for i=1:skip:length(xj)
    iline=iline+1;
        fprintf(fid,'1, %10.2f, %10.2f, %8.0f, %i\n', xj(i), yj(i), abs(q(i)), iline); %print 3 times to do a join in arc
    iline=iline+1;
        fprintf(fid,'1, %10.2f, %10.2f, %8.0f, %i\n', xj(i), yj(i), abs(q(i)), iline);
    iline=iline+1;
        fprintf(fid,'1, %10.2f, %10.2f, %8.0f, %i\n', xj(i), yj(i), abs(q(i)), iline);
end    
fclose(fid);





%% Outputs

%% DIRECTORY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% End of Program %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

