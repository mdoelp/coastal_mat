% program lesco
% run 'lesco' in combination with 'edgard' to perform the harmonic
% analysis
sizz=size(z);
N=sizz(1);   % no. of data points
fprintf(' the number of points in the TDR analysis is')
N
delt=sample_interval_minutes/60  % delta t in hours 
I=ones(1,N);
t=delt*[-(N-1)/2:(N-1)/2];
f=2*pi*[.04178;.08051;.1610;.24153;.08333;.079;.03873;.16667;.2500;.32205;.12229;.15951;.16384;.00282;
.07749;.04483;.04027;.043293;.03722;.03571;.08202;.086155];
%freq. of components of interest
% in cycles per hour
k=22;     % no. of components of interest

for i=1:k
 for j=1:k
  S(i,j)=sum(cos(f(i)*t).*cos(f(j)*t));
  D(i,j)=sum(sin(f(i)*t).*sin(f(j)*t));
 end
end

invS=inv(S);
invD=inv(D);
