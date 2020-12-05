function [ttime, tide] = read_usgs_tide(varargin);
%function [time, atmpress] = read_ndbc(filename1, filename2...)
%This functions takes input filenames, reads in the data and
%concatenates the data files in the order given.
%The time and tide are saved in an ascii file, filename#_tide.txt 
% Make sure that header is removed from the data file and the error replace
% with numbers

ttime = [];
tide = [];
for ii = 1:length(varargin)
   fname = varargin{ii};
	if any(fname == '*')
		[theFile, thePath] = uigetfile('*.*', 'Select a File:');
		if ~any(theFile), return, end
		if thePath(length(thePath) ~= filesep)
			thePath = [thePath filesep];
		end
		fname = [thePath theFile];
	end

eval(['load ' fname ';'])
[PATH,NAME,EXT,VER] = fileparts(fname);
xname = [NAME];
eval(['data = ' xname ';'])
eval(['clear ' xname])
N=length(data);

% parcel data into separate variables
yyyy = data(:,1);
mm=data(:,2);
dd=data(:,3);
min=data(:,4); %times are in EDT, convert to EDT
%mn = data(:,5);

time = datenum(yyyy,mm,dd,00,min,00);

% get tide data
tid=data(:,5);

  for i=1:N
     if tid(i)==9999 | tid(i)==99
        tid(i)=NaN;
     end
  end
   
figure(1)
hold on
plot(time,tid,'r')
title('USGS Tide Record')
ylabel('feet NGVD 1929')
datetick('x',6)
grid on

%makes sure the file is in ascending order
[Ytime,I] = sort(time);
clear time, time=Ytime;
tid = tid(I);

%check for duplicate times
if ii > 1 & Ytime(1) < ttime(end)
   idgood = find(Ytime > ttime(end));
   clear time, time = Ytime(idgood);
   tid = tid(idgood);
end

ttime = [ttime;time];
tide = [tide;tid];
temp = [ttime tide]
clear time tid
end

aa=load('01100693_ght_octdec.txt');
temp=[temp;aa];
temp(:,2)=temp(:,2)-0.80052; % Correct the tide data from NGVD to NAVD


outfile = [NAME '_tide.txt'];
eval(['save ' outfile ' temp -ascii -double']);