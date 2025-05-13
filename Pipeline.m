function [S] = Pipeline(s)
% This function makes a transition from syms evalution to MatLab pipeline
% code
s=strrep(s,'*','.*');
s=strrep(s,'/','./');
S=strrep(s,'^','.^');
end