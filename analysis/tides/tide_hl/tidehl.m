function [tideinfo,thigh,high,tlow,low] = tidehl(fname,timevec,datavec,stime,etime,timeint,tideadjust)


%   timeint supplied in minutes!

%% Load Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If loading with a file, ensure header and correct column accounted for

if isempty(fname)==0
    loaddata=load(fname);
    tidedata(:,1) = loaddata(2:end,1)
    tidedata(:,2) = loaddata(2:end,2)+tideadjust
else
    tidedata(:,1) = timevec
    tidedata(:,2) = datavec+tideadjust
end

c = find((tidedata(:,1))>=datenum(stime) & (tidedata(:,1))<=datenum(etime)); % Time interval of interest
tide=tidedata(c,:);

%% Find MLLW and MHHW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=1;
for j=1:fix(length(tide(:,2))/timeint);
   mll(j)=10; % set to arbitrary start level
   mhh(j)=-10;
for i=1:144  %there are 144 TDR records in a 24 hour period
   wl = tide(k,2);
   if wl < mll(j)
      mll(j) = wl;
   end
   if wl > mhh(j);
      mhh(j) = wl;
   end
   k=k+1;
end
end
mllw = mean(mll);
mhhw = mean(mhh);

%% Find Highs and Lows %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

j=1;
k=1;
maxtid=-10;
mintid=10;
pass=1;
step=15;
mark=step+1;
tideleft=1;

tsum=sum(tide(1:37,2)-tide(1,2))
if tsum<0
    pass=2;
    ii=find(tide(1:100,2)==max(tide(1:50,2))); % Specifies the dimension to search
      high(j)=tide(ii,2);
      thigh(j)=tide(ii,1);
      j=j+1;
      pass=2;
      i=ii;
else
    pass=1;
    ii=find(tide(1:100,2)==min(tide(1:50,2)));
      low(k,:)=tide(ii,2);
      tlow(k,:)=tide(ii,1);
      k=k+1;
      pass=1;
      i=ii;
end

%for i=ii:length(tidedata(:,4))-step
while tideleft
   if tide(i,2) > maxtid
      maxtid = tide(i,2);
   end
   if tide(i,2) < mintid
      mintid = tide(i,2);
   end
   
   if pass==1 %looking for high tide
       temptide=tide(i:i+100,:);
       ii=find(temptide(:,2)==max(temptide(:,2))); 
      high(j)=temptide(ii(1),2);
      thigh(j)=temptide(ii(1),1);
      j=j+1;
      pass=2;
      i=i+ii(1)-1;
  else  %looking for low tide
      temptide=tide(i:i+100,:);
      ii=find(temptide(:,2)==min(temptide(:,2)));
      low(k)=temptide(ii(1),2);
      tlow(k)=temptide(ii(1),1);
      k=k+1;
      pass=1;
      i=i+ii(1)-1;
  end
   if i+100>length(tide(:,1))
       tideleft=0;
   end
end %end while tideleft

%% Export Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mlw = mean(low);
mhw = mean(high);
mtl=(mhw+mlw)/2;
fprintf('Max Tide:\t%f\n',maxtid)
fprintf('MHHW:\t\t%f\n',mhhw)
fprintf('MHW:\t\t%f\n',mhw)
fprintf('MTL:\t\t%f\n',(mhw+mlw)/2)
fprintf('MLW:\t\t%f\n',mlw)
fprintf('MLLW:\t\t%f\n',mllw)
fprintf('Min Tide:\t%f\n',mintid)

tideinfo.maxrange = maxtid - mintid
tideinfo.maxtid = maxtid
tideinfo.mhhw = mhhw
tideinfo.mhw = mhw
tideinfo.mtl = mhw+mlw
tideinfo.mlw = mlw
tideinfo.mllw = mllw
tideinfo.mintid = mintid

figure;plot(tlow,low,'r^');hold;plot(thigh,high,'ko');plot(tide(:,1),tide(:,2))
datetick('x',6,'keepticks','keeplimits')


end

