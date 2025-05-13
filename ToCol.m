function [ y ] = ToCol( x )
%This function transerf any vector into a column
[Row_number, Column_number]=size(x);
if Column_number>Row_number
    y=x.';
else
    y=x;
end;
[~, Column_number]=size(y);
if Column_number>1
    error('Something wrong with model data. I see that it a matrix, not a vector =(');
end;

end

