function [ roots ] = NumRawSolve( y, type)
% This function is used in removing spectral outliers during AF method
s=[ diff(sign(y))/2;0];
if type==0
    roots=find(abs(s)==1);
else
    roots=find(s==type);
end;
end

