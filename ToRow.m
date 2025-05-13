function [ y ] = ToRow( x )
%This function transerf any vector into a row
[Row_number, Column_number]=size(x);
if Column_number<Row_number
    y=x.';
else
    y=x;
end;

end

