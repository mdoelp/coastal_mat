
%%


height(:,1)=vdepav/.3048; %convert to ft/s
direct(:,1)=ddepav;
 
%load test.ph3
%height(:,1)=test(:,2);
%direct(:,1)=180-test(:,4);

dd=find(direct(:,1)>349); 
direct(dd,1)=0; 

%load w44010.dat %reconstruct wave reccord    (au2055.ph3 for wavetran waves)
%height_tmp(:,1)=w44010(:,8); %convert (m/s) to mph
%direct_tmp(:,1)= w44010(:,11); % (180-au2055b(:,4)); for wavtran waves;  
%guddir=find(direct_tmp(:,1)<=360);
%height(:,1)=height_tmp(guddir,1);
%direct(:,1)=direct_tmp(guddir,1);
%dd=find(direct(:,1)>345); 
%direct(dd,1)=direct(dd,1)-360;   			 %if angles are within last half-sector, then set them to 
									 % zero to make sure they are included in the plot
%  Only problem remaining is titles and color bar labels 
%  must still be changed manually when
%  switching between wind/wave data or different data types....

% Load in data set(s)
% Seperate the data and detemine statistical breakdown by
% direction and wave height.

% Define directional bins
x=0:22.5:349;
xbin=x*(pi/180);
% Define magnitude bins
hbar1=0.49;hbar2=0.99;hbar3=1.49;

% Input color bar title
sartitle={'ft/sec'};

hgt=height;
lhgt=length(hgt);
dir=(direct)*(pi/180);

      a1=find(hgt <= hbar1 & hgt > 0);
      a2=find(hgt <= hbar2 & hgt > 0);
      a3=find(hgt <= hbar3 & hgt > 0);
      a4=find(hgt <= 90. & hgt > 0);   %data file uses 99.0 as an error value  
      
      d1=dir(a1);
      d2=dir(a2);
      d3=dir(a3);
      d4=dir(a4);
%      clear a* hgt dir;

% Generate plots for the various wave roses.


% figure
%set(gcf,'Position',[59 130 934  331])
      h=rose2(d4,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      clear h g
      [t4,r4,nn(:,4)]=rose2(d4,xbin,lhgt);
      %nn;
      x4=r4.*cos(t4);
      y4=r4.*sin(t4);
      fill(x4,y4,[.47 .47 .47])
      axis('square')
      set(gca,'Visible','off')
      hold on
      
      h=rose2(d3,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      [t3,r3,nn(:,3)]=rose2(d3,xbin,lhgt);
      x3=r3.*cos(t3);
      y3=r3.*sin(t3);
      fill(x3,y3,[.73 .73 .73])
      axis('square')
      set(gca,'Visible','off')
      hold on
      clear h g
      
      h=rose2(d2,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      axis('square')
      set(gca,'Visible','off')
      hold on
      [t2,r2,nn(:,2)]=rose2(d2,xbin,lhgt);
      x2=r2.*cos(t2);
      y2=r2.*sin(t2);
      fill(x2,y2,[.85 .85 .85])
      axis('square')
      set(gca,'Visible','off')
      hold on
      clear h g
      
      h=rose2(d1,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      axis('square')
      set(gca,'Visible','off')
      [t1,r1,nn(:,1)]=rose2(d1,xbin,lhgt);
      x1=r1.*cos(t1);
      y1=r1.*sin(t1);
      fill(x1,y1,[1 1 1])
      axis('square')
      set(gca,'Visible','off')
      hold on

  simp=[0 0 0;1 1 1;.85 .85 .85;.73 .73 .73;.47 .47 .47];
  tmax(2)=0;
  tmax(1)=4;
  axes('position',[0.0964 0.2738 0.0128 0.4976])
  for q=1:5
    yy(q,1)=tmax(1)+(1/4)*(q-1)*(tmax(2)-tmax(1));
    yy(q,2)=yy(q,1);
    ys(q)=yy(q);
  end
  xs(1)=0;
  xs(2)=0.5;
  colormap(simp)
  pcolor(xs,ys,yy)
  axis([0 0.5 tmax(2) tmax(1)]) 
  text(1.3939,4.4258,'Percent Occurrence')
  %text(6.5,9.0,'Current Rose for Little Bay');
  set(gca,'XTick',[])
  set(gca,'YTick',[.5 1.5 2.5 3.5])
  set(gca,'YTickLabel',{'0.0-0.5';'0.5-1.0';'1.0-1.5';'1.5 +   '},'FontSize',8)   	% corresponds to Hbins

  title(sartitle,'FontSize',8)
%clear d1 d2 d3 d4 d5 d6 lhgt  

mm(:,1)=nn(:,1);
for i=2:4
   mm(:,i)=nn(:,i)-nn(:,i-1);
end
