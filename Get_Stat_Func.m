function [ E, CI ] = Get_Stat_Func( Result, p )
%This function is used to extract statistics from data
Result=Result.';
%Find the number of dimensions
[n m]=size(Result);
if n==1
    E=Result;
    CI=NaN*ones(1,m);
else    
%Finding the quantile of the Student's distribution
t=tinv((p+1)/2, n-1);
%Finding the sample mean
E=mean(Result);
%Finding the sample variance
D=std(Result);
%Calculating the confidence interval
CI=D/sqrt(n)*t;
Statistics=[E, CI];
end;
end

