function [amp, phase] = harmonics(infile,outfile,sdate,edate, dt)
%harmonics Run harmonics

startime=datenum(sdate);%25-May-2005 00:00:01
endtime=datenum(edate);
PREPTIDE
LESCO23
EDGARD23
OUTCONST
CALVAR

confile %list the constituents 
save([outfile,'.con'],'confile','-ascii','-double')
save([outfile,'.tms'],'tmsfile','-ascii','-double')
display(outfile)

end

