function [Y, Jacobian] = M_RC_parallel(f, par, model_options )
% Description 

% Making coding more intuitive 
if nargin<=1 
	 model_options=f; 
end  

% Fool_proof for fix_pars field 
if isfield(model_options,'fix_pars')
	 fix_pars=model_options.fix_pars;
else 
	 fix_pars=[];
end

% Setting total scheme parameters number 
Pars_N=2;

% Setting the indices of non-negative parameters 
non_negative_pars=[1  2];


% Switching to info-mode 
if nargin<=1
	Y.version='LEVM_like';
	Y.Elements_names(1)={'C'};
	Y.Elements_names(2)={'R'};

	 non_fix_pars_idx=lin_set_difference(fix_pars,Pars_N); 
	 Y.non_fix_pars_idx=non_fix_pars_idx; 
	 Y.Elements_names= Y.Elements_names(non_fix_pars_idx); 
	 Y.Elements_Num=length(non_fix_pars_idx); 
 
	 a=zeros(1,Pars_N); a(non_negative_pars)=1; a=a(non_fix_pars_idx); 
	 Y.non_negative_pars=find(a==1);

     Y.AM_compatible=true; 
	 return;
end

if ~isfield(model_options,'get_AM_solution')
    model_options.get_AM_solution=false;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%                Algebraic methods from                                   %
% Stupin, D. D., Kuzina, E. A., Abelit, et. al (2021).                    % 
% Bioimpedance spectroscopy: basics and applications.                     %
% ACS Biomaterials Science & Engineering, 7(6), 1962-1986.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if model_options.get_AM_solution
    info.message='Ok!';
    Y=par;
    [~, idx]=min(imag(1./Y)); w_min=2*pi*f(idx);
    if (idx==1)||(idx==length(f))
        warning('Possibly, AM method goes out of range!');                 
        info.message='Possibly, AM method goes out of range!';
    end;
    ImZ=imag(1./Y(idx));
    R=-2*ImZ;
    C=-1/(ImZ*w_min)/2;
    Y=[C R];
    if ~all(sign(Y)+1)
        warning('Something goes wrong with signs...');                            
        info.message='Something goes wrong with signs...';
    end;  
    info.iterations=0;
    info.funcCount=0;
    info.algorithm='Algebraic method';
    Jacobian=info;
    return;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Calculation mode without analytical Jacobian; 
% Reconstructing full parameters vector from input parameters vector and 
% model_options.fix_pars
if nargin>=3&&~isempty(fix_pars)
	 non_fix_pars_idx=lin_set_difference(fix_pars(1,:),Pars_N);
	 Par(non_fix_pars_idx)=par;
	 Par(fix_pars(1,:))=fix_pars(2,:);
	 par=Par;
end


if isempty(fix_pars)
	 non_fix_pars_idx=1:Pars_N;
end
% Setting absolute values for non-negative parameters
par(non_negative_pars)=abs(par(non_negative_pars));

% Parsing parameters vector into single parameters
iw=2*pi*f*1i;
C=par(1);
R=par(2);

% Immittance calculations
Y = C.*iw + 1./R;

% Get the analytical jacobian
if isfield(model_options,'get_analytical_jacobian')
	 if model_options.get_analytical_jacobian
		 Jacobian=[];
 		 for j=non_fix_pars_idx
 			 Jacobian=[Jacobian ToCol(Jacobian_func(j))];
 		 end
 	 else
 		 Jacobian=[];
 	 end
 else
 	 Jacobian=[];
 end

 	 function Jacobian=Jacobian_func(n) 
		 switch n
			 case 1 
				 Jacobian = iw;
			 case 2 
				 Jacobian = -1./R.^2*ones(size(iw));
		 otherwise
			 error('Bad parameter number while Jacobian calculating');
		 end
	 end
	 function [ y ] = ToCol( x )
		  [Row_number, Column_number]=size(x);
		  if Column_number>Row_number 
			  y=x.';
		  else
			  y=x;
		 end
		 [~, Column_number]=size(y);
		 if Column_number>1
			 error('Something wrong with model data. I see that it a matrix, not a vector =(');
		 end
	 end
end