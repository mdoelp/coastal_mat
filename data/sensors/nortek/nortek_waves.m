function nortek_waves(fname,hv); 

% Parse out nortek data



%fname='SOUTH_1';
%fname is the nortek raw data file name w/o extention
fdir='D:\19-27_StLucie\data\wave\adcp\nortek_datafiles\'; %data file directory 

puvfile=[fdir '\' fname '.wad']; %nortek raw PUV data file 
datfile=[fdir '\' fname '.whd']; %nortek wave ensemble info file

ntkpuv=load(puvfile); 
ntkdat=load(datfile);

sm=ntkdat(1,8); %number of samples per wave ensemble
dt=1;               %sec, wave sample interval
hp=ntkdat(1,9);     %m, wave velocity cell position above pressure sensor
%hv=1;         %m, pressure port distance above bottom

lf=.035;      %Hz - low frequency cutoff
maxfac=200;   %   - maximum value of factor scaling pressure to waves
minspec=0.1;  %m^2/Hz - minimum spectral level for computing
              %         direction and spreading
Ndir=0;       %deg - direction offset (includes compass error and 
              %      misalignment of cable probe relative to case
              % the offset for the Aquadopp Profiler is 0

parms=[lf maxfac minspec Ndir];

vt=datenum(ntkdat(:,3),ntkdat(:,1),ntkdat(:,2),ntkdat(:,4),ntkdat(:,5),ntkdat(:,6)); %time at beginning of the ensemble

%predimension PUV variables
vp(sm,length(ntkdat(:,1)))=0; %pressure in m
vu(sm,length(ntkdat(:,1)))=0; %east velocity component in m/sec
vv(sm,length(ntkdat(:,1)))=0; %north velocity component in m/sec

for i=1:length(ntkdat(:,1))-1 %sort ensemble data for processing 
    vp(:,i)=ntkpuv((i-1)*sm+1:i*sm,3);
    vu(:,i)=ntkpuv((i-1)*sm+1:i*sm,6);
    vv(:,i)=ntkpuv((i-1)*sm+1:i*sm,7);
end


[Su,Sp,Dir,Spread,F,dF] = wds(vu,vv,vp,dt,100,hp,hv,parms);

plotwds(vt,Su,Sp,Dir,Spread,F);

[Hs,peakF,peakDir,peakSpread] = hs(Su,Sp,Dir,Spread,F,dF);

ploths(vt(1:length(peakDir)),Hs(1:length(peakDir)),peakF(1:length(peakDir)),peakDir(1:length(peakDir)),peakSpread(1:length(peakDir)));

outfname=[fname '.out'];
fout=fopen(outfname,'w');
fprintf(fout,'%%time, hs(m), Tp, theta peak, peak spread\n');
for i=1:length(1:length(peakDir))
    fprintf(fout,'%14.6f %8.2f %8.2f %8.2f %8.2f\n',vt(i),Hs(i),peakF(i),peakDir(i),peakSpread(i));
end
fclose('all');


