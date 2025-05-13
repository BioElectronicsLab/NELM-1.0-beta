function [] = Make_Model(Y_input, frequency_name, model_name, any_sign_pars, misc)
% Y_input -- admitance of the model
% frequency_name -- name of the used frequency 
% model name -- name of future file as string
% any_sign_pars -- names of symvar that can be any sign
% Example
% syms R L C W alpha tau iw;
% Y=exp(iw*tau)/(R+iw*L+1/(iw*C));
% Model_Constructor_new_Jacobian(Y, iw, 'M_RLC_rl', [tau])
vector_var = symvar(Y_input);
if find(vector_var == frequency_name)~=0 
    vector_var=[vector_var(1:find(vector_var == frequency_name)-1) vector_var((find(vector_var == frequency_name)+1):length(vector_var))];
end
Pars_N = length(vector_var);
if isnan(any_sign_pars)==0
    non_negative_pars = [];
    [~, size_neg]=size(any_sign_pars);
    for i=1:Pars_N
        sum=0;
        for j=1:size_neg
            if find(vector_var(i) == any_sign_pars(j)) == 1
               sum=sum+1; 
            end
        end
        if sum == 0
            non_negative_pars= [find(vector_var == vector_var(i)) non_negative_pars];
        end
    end
else
    non_negative_pars = 1:1:Pars_N;
end
function_name = strcat(model_name,'.m');


fileID = fopen(function_name,'w');
fprintf(fileID,'%s%s%s\n','function [Y, Jacobian] = ',model_name, '(f, par, model_options )');
fprintf(fileID,'%% Description \n\n');

fprintf(fileID,'%% Making coding more intuitive \n');
fprintf(fileID, 'if nargin<=1 \n');
fprintf(fileID, '\t model_options=f; \n');
fprintf(fileID, 'end  \n\n');

fprintf(fileID, '%% Fool_proof for fix_pars field \n');
fprintf(fileID, 'if isfield(model_options,''fix_pars'')\n');
fprintf(fileID, '\t fix_pars=model_options.fix_pars;\n');
fprintf(fileID, 'else \n');
fprintf(fileID, '\t fix_pars=[];\n');
fprintf(fileID, 'end\n\n');

fprintf(fileID, '%% Setting total scheme parameters number \n');
fprintf(fileID,'%s%s;\n\n','Pars_N=',num2str(length(vector_var)));
fprintf(fileID, '%% Setting the indices of non-negative parameters \n');
fprintf(fileID,'%s%s%s;\n','non_negative_pars=[', num2str(non_negative_pars), ']');
fprintf(fileID,'\n\n');

fprintf(fileID, '%% Switching to info-mode \n');
fprintf(fileID,'if nargin<=1\n');
fprintf(fileID,'\tY.version=''LEVM_like'';\n');
for i=1:1:Pars_N
    fprintf(fileID,'\t%s%s%s%s%s%s%s\n','Y.Elements_names(', num2str(i),')={','''' , string(vector_var(i)),'''', '};');
end 
fprintf(fileID, '\n');

fprintf(fileID, '\t non_fix_pars_idx=lin_set_difference(fix_pars,Pars_N); \n');
fprintf(fileID, '\t Y.non_fix_pars_idx=non_fix_pars_idx; \n');
fprintf(fileID, '\t Y.Elements_names= Y.Elements_names(non_fix_pars_idx); \n');
fprintf(fileID, '\t Y.Elements_Num=length(non_fix_pars_idx); \n \n');

fprintf(fileID, '\t a=zeros(1,Pars_N); a(non_negative_pars)=1; a=a(non_fix_pars_idx); \n');
fprintf(fileID, '\t Y.non_negative_pars=find(a==1);\n \n');

fprintf(fileID, '\t return;\n');
fprintf(fileID,'end\n');
fprintf(fileID,'\n\n');
fprintf(fileID, '%% Calculation mode without analytical Jacobian; \n');
fprintf(fileID, '%% Reconstructing full parameters vector from input parameters vector and \n');
fprintf(fileID, '%% model_options.fix_pars\n');
fprintf(fileID,'if nargin>=3&&~isempty(fix_pars)\n');
fprintf(fileID,'\t non_fix_pars_idx=lin_set_difference(fix_pars(1,:),Pars_N);\n');
fprintf(fileID,'\t Par(non_fix_pars_idx)=par;\n');
fprintf(fileID,'\t Par(fix_pars(1,:))=fix_pars(2,:);\n');
fprintf(fileID,'\t par=Par;\n');
fprintf(fileID,'end\n');
fprintf(fileID,'\n\n');
fprintf(fileID,'if isempty(fix_pars)\n');
fprintf(fileID,'\t non_fix_pars_idx=1:Pars_N;\n');
fprintf(fileID,'end\n');
fprintf(fileID, '%% Setting absolute values for non-negative parameters\n');
fprintf(fileID, 'par(non_negative_pars)=abs(par(non_negative_pars));\n\n');
fprintf(fileID, '%% Parsing parameters vector into single parameters\n');
fprintf(fileID,'iw=2*pi*f*1i;\n');
for i=1:1:Pars_N
    fprintf(fileID,'%s%s%s%s\n',  string(vector_var(i)), '=par(',num2str(i),');');
end 
fprintf(fileID, '\n');
fprintf(fileID, '%% Immittance calculations\n');
fprintf(fileID,'%s%s;\n\n', 'Y = ', Pipeline(string(Y_input)));
fprintf(fileID, '%% Get the analytical jacobian\n');
fprintf(fileID, 'if isfield(model_options,''get_J'')\n');
fprintf(fileID, '\t if model_options.get_J\n');
fprintf(fileID, '\t\t Jacobian=[];\n ');
fprintf(fileID, '\t\t for j=non_fix_pars_idx\n ');
fprintf(fileID, '\t\t\t Jacobian=[Jacobian ToCol(Jacobian_func(j))];\n ');
fprintf(fileID, '\t\t end\n ');
fprintf(fileID, '\t else\n ');
fprintf(fileID, '\t\t Jacobian=[];\n ');
fprintf(fileID, '\t end\n ');
fprintf(fileID, 'else\n ');
fprintf(fileID, '\t Jacobian=[];\n ');
fprintf(fileID, 'end\n\n ');
fprintf(fileID, '\t function Jacobian=Jacobian_func(n) \n');
fprintf(fileID, '\t\t switch n\n');
for i=1:1:Pars_N
    fprintf(fileID,'\t\t\t case %1s \n', num2str(i)  );
    if isnan(str2double(Pipeline(string(simplify(diff(Y_input ,vector_var(i))))))) == 1
        fprintf(fileID,'\t\t\t\t %1s%1s%1s%1s\n',  'Jacobian = ', Pipeline(string(simplify(diff(Y_input ,vector_var(i))))), ';');
        fprintf(fileID, '\n');
    else
        fprintf(fileID,'\t\t\t\t %1s%1s%1s%1s%1s\n',  'Jacobian = ', Pipeline(string(simplify(diff(Y_input ,vector_var(i))))),'*ones(size(', string(frequency_name), '));');
        fprintf(fileID, '\n');
    end

end
fprintf(fileID, '\t\t otherwise\n');
fprintf(fileID, '\t\t\t error(''Bad parameter number while Jacobian calculating'');\n');           
fprintf(fileID, '\t\t end\n');
fprintf(fileID, '\t end\n');
fprintf(fileID, '\t function [ y ] = ToCol( x )\n');
fprintf(fileID, '\t\t  [Row_number, Column_number]=size(x);\n');
fprintf(fileID, '\t\t  if Column_number>Row_number \n');
fprintf(fileID, '\t\t\t  y=x.'';\n');
fprintf(fileID, '\t\t  else\n');
fprintf(fileID, '\t\t\t  y=x;\n');
fprintf(fileID, '\t\t end\n');
fprintf(fileID, '\t\t [~, Column_number]=size(y);\n');
fprintf(fileID, '\t\t if Column_number>1\n');
fprintf(fileID, '\t\t\t error(''Something wrong with model data. I see that it a matrix, not a vector =('');\n');
fprintf(fileID, '\t\t end\n');
fprintf(fileID, '\t end\n');
fprintf(fileID, 'end');
fclose(fileID);
end
