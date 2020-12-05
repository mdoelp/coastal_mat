%
%  This program loads a tide elevation file and
% chops it into an appropriate segment for calculation
% of tidal constituents
%
% For valid comparison of constituent values between 2 data sets,
% Make sure file segments have:
%	1.  The same start time
%	2.  The same number of points
%	3.  The same end time
%	4.  The same units  
%
%  Output of this program is tidal elevation, z, 
%  and is used as the input variable to LESCO23.M and 
%  later, to EDGARD23.M

data = load(infile);
time=data(:,1);
elevation=data(:,2);

%  jj=julian day 87 to jd 120

startime=datenum(sdate);%25-May-2005 00:00:01
endtime=datenum(edate);

% Segmentize
%
jj=find(time>=startime & time<=endtime);
jj=[1:length(data(:,1))];
N=length(jj);
z=elevation(jj); 

days_of_data=time(N)-time(1)
%days_of_data=time(length(data))-time(1)

% sample_interval_minutes=(time(N)-time(N-1))*24*60
sample_interval_minutes=dt






