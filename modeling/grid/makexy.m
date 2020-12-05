function makexys(data,outfile,start,done,presteps,convdat)

%This file converts a standard Brancker TDR file into a
% file formatted specifically for SMS/RMA2 entry.  
% infile = file name to read (expects time in column 1, and elevation in column 4)
% outfile = file name to write to
% satrt = start data and time in the form 03-May-1971 08:00:00
% done = end date and time in the same form
%presteps is the number of steps prior to the first point in the 
%	tide record required for model ramp up, the elevation points are
%	calculated based on the slope of the line starting at high tide 
%	and running for 4 hours
% data = load(infile);

t=data(:,1);

startime=datenum(start);
endtime=datenum(done);
   
j=find(t>=startime & t<=endtime);
hours=(t(j)-startime)*24;
h=data(j,2); 	%elevation in feet referenced to NGVD
   
%need to throw on some initial values at the beginning to start at the right elevation
% if nargin > 4
%    inc = hours(2)-hours(1);
%  	hours = hours+(presteps*inc);
% 	addtime = 0:inc:hours(1)-inc;
% 	time = [addtime';hours];
% 	slope = mean(diff(h(1:24)));
%    for jj = 1:presteps-1
%       drop(1) = h(1)+(presteps*slope*-1);
%       drop(jj+1) = h(1)+((presteps-jj)*slope*-1);
%    end
% 	wel = [drop';h];
% else
%    time = hours/24+startime;
   time = hours;

%    wel = h;
% end

plot(time,h)
grid on

numpts = length(time);
% write data to a formatted file
fid=fopen(outfile,'w')
fprintf(fid,['XY1 1 ' num2str(numpts) ' 0 0 0 0 tide\n']);
for kk = 1:numpts
   fprintf(fid,'%6.4f\t%4.2f\n',time(kk),h(kk)+convdat);
end

fclose(fid)
