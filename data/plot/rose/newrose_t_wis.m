
%% Wave Period Setup

% Define directional bins
x=0:22.5:349;
xbin=x*(pi/180);

% Define magnitude bins
hbar1=3.5;hbar2=4;hbar3=5;hbar4=6;hbar5=7;

% Input color bar title
sartitle={'period (sec)'};

hgt=height;
lhgt=length(hgt);
dir=(direct)*(pi/180);

      a1=find(hgt <= hbar1 & hgt > 0);
      a2=find(hgt <= hbar2 & hgt > 0);
      a3=find(hgt <= hbar3 & hgt > 0);
      a4=find(hgt <= hbar4 & hgt > 0);
      a5=find(hgt <= hbar5 & hgt > 0);
      a6=find(hgt <= 90. & hgt > 0);   %data file uses 99.0 as an error value  
      
      d1=dir(a1);
      d2=dir(a2);
      d3=dir(a3);
      d4=dir(a4);
      d5=dir(a5);
      d6=dir(a6);
%      clear a* hgt dir;


%% Generate plots for the various wave period roses.


subplot(1,2,2)
      h=rosewave(d6,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      clear h g
      [t6,r6,nn(:,6)]=rosewave(d6,xbin,lhgt);
      x6=r6.*cos(t6);
      y6=r6.*sin(t6);
      fill(x6,y6,[0 0 0])
      axis('square')
      set(gca,'Visible','off')
      hold on
      [t5,r5,nn(:,5)]=rosewave(d5,xbin,lhgt);
      %nn
      x5=r5.*cos(t5);
      y5=r5.*sin(t5);
      fill(x5,y5,[.25 .25 .25])
      axis('square')
      set(gca,'Visible','off')
      hold on
      h=rosewave(d5,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      clear h g
      [t4,r4,nn(:,4)]=rosewave(d4,xbin,lhgt);
      %nn
      x4=r4.*cos(t4);
      y4=r4.*sin(t4);
      fill(x4,y4,[.47 .47 .47])
      axis('square')
      set(gca,'Visible','off')
      hold on
      h=rosewave(d4,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      clear h g
      [t3,r3,nn(:,3)]=rosewave(d3,xbin,lhgt);
      %nn
      x3=r3.*cos(t3);
      y3=r3.*sin(t3);
      fill(x3,y3,[.73 .73 .73])
      axis('square')
      set(gca,'Visible','off')
      hold on
      h=rosewave(d3,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
      clear h g
      [t2,r2,nn(:,2)]=rosewave(d2,xbin,lhgt);
      %nn
      x2=r2.*cos(t2);
      y2=r2.*sin(t2);
      fill(x2,y2,[.85 .85 .85])
      axis('square')
      set(gca,'Visible','off')
      hold on
      h=rosewave(d2,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      axis('square')
      set(gca,'Visible','off')
      hold on
      clear h g
      [t1,r1,nn(:,1)]=rosewave(d1,xbin,lhgt);
      nn
      x1=r1.*cos(t1);
      y1=r1.*sin(t1);
      fill(x1,y1,[1 1 1])
      axis('square')
      set(gca,'Visible','off')
      hold on
      h=rosewave(d1,xbin,lhgt);
      g=get(h,'Parent');
      set(g,'View',[0 270])
      set(g,'CameraUpVector',[1 0 0])
      set(h,'Color',[0 0 0])
      hold on
  simp=[0 0 0;1 1 1;.85 .85 .85;.73 .73 .73;.47 .47 .47;.25 .25 .25;0 0 0];
  tmax(2)=0;
  tmax(1)=6;
  axes('position',[ 0.5471 0.2691 0.0128 0.4976])
  for q=1:7
    yy(q,1)=tmax(1)+(1/6)*(q-1)*(tmax(2)-tmax(1));
    yy(q,2)=yy(q,1);
    ys(q)=yy(q);
  end
  xs(1)=0;
  xs(2)=0.5;
  colormap(simp)
  pcolor(xs,ys,yy)
  axis([0 0.5 tmax(2) tmax(1)]) 
  text(3.4091,4.4258,'Percent Occurrence')
  %text(6.5,9.0,'Current Rose for Little Bay');
  set(gca,'XTick',[])
  set(gca,'YTick',[.5 1.5 2.5 3.5 4.5 5.5])
  set(gca,'YTickLabel',{'0-3.5';'3.5-4';'4-5';'5-6';'6-7';'7 +   '},'FontSize',8)   	% corresponds to Hbins

  title(sartitle,'FontSize',8)
%clear d1 d2 d3 d4 d5 d6 lhgt  

mm(:,1)=nn(:,1);
for i=2:6
   mm(:,i)=nn(:,i)-nn(:,i-1);
end
