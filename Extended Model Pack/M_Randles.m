function [Y, Jacobian] = M_Randles(f, par, model_options )
% Often used Randles circuit for electrochemical interfaces

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
Pars_N=5;

% Setting the indices of non-negative parameters 
non_negative_pars=[1  2  3  4  5];


% Switching to info-mode 
if nargin<=1
	Y.version='LEVM_like';
	Y.Elements_names(1)={'A'};
	Y.Elements_names(2)={'C'};
	Y.Elements_names(3)={'R'};
	Y.Elements_names(4)={'R1'};
	Y.Elements_names(5)={'W'};

	 non_fix_pars_idx=lin_set_difference(fix_pars,Pars_N); 
	 Y.non_fix_pars_idx=non_fix_pars_idx; 
	 Y.Elements_names= Y.Elements_names(non_fix_pars_idx); 
	 Y.Elements_Num=length(non_fix_pars_idx); 
 
	 a=zeros(1,Pars_N); a(non_negative_pars)=1; a=a(non_fix_pars_idx); 
	 Y.non_negative_pars=find(a==1);
 
	 return;
end


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
A=par(1);
C=par(2);
R=par(3);
R1=par(4);
W=par(5);

% Immittance calculations
Y = 1./(R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i));

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
				 Jacobian = log(f.*pi.*2i)./(W.*(R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i)).^2.*(R + 1./(W.*(f.*pi.*2i).^A)).^2.*(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i).^2.*(f.*pi.*2i).^A);
			 case 2 
				 Jacobian = (f.*pi.*2i)./((R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i)).^2.*(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i).^2);
			 case 3 
				 Jacobian = -1./((R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i)).^2.*(R + 1./(W.*(f.*pi.*2i).^A)).^2.*(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i).^2);
			 case 4 
				 Jacobian = -1./(R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i)).^2;
			 case 5 
				 Jacobian = 1./(W.^2.*(R1 + 1./(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i)).^2.*(R + 1./(W.*(f.*pi.*2i).^A)).^2.*(1./(R + 1./(W.*(f.*pi.*2i).^A)) + C.*f.*pi.*2i).^2.*(f.*pi.*2i).^A);
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