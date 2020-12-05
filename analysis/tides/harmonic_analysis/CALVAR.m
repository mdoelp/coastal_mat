% This program calculates the variance of time series
% based on the square of the standard deviation
% It is formatted to operate on time series produced
% by harmonic analysis of Delaware River tide data
% (total signal, predicted signal, and residual signal)

for i=2:4
  stdev(i)=std(tmsfile(:,i));
  variance(i)=stdev(i)^2;
end
fprintf('total variance is: %4.3f',variance(2))
fprintf('\n predicted variance is: %4.3f',variance(3))
fprintf('\n residual variance is: %4.3f',variance(4))
percent=(variance(4)/variance(2))*100;
fprintf('\n percent of total: %3.1f',percent)
fprintf('\n\n')
