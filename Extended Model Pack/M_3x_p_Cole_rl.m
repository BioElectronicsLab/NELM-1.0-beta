function [Y, Jacobian] = M_3x_p_Cole_rl(f, par, model_options )
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
Pars_N=11;

% Setting the indices of non-negative parameters 
non_negative_pars=[11  10   9   7   6   5   4   3   2   1];


% Switching to info-mode 
if nargin<=1
	Y.version='LEVM_like';
	Y.Elements_names(1)={'L'};
	Y.Elements_names(2)={'R1'};
	Y.Elements_names(3)={'R2'};
	Y.Elements_names(4)={'R3'};
	Y.Elements_names(5)={'a1'};
	Y.Elements_names(6)={'a2'};
	Y.Elements_names(7)={'a3'};
	Y.Elements_names(8)={'dT'};
	Y.Elements_names(9)={'t1'};
	Y.Elements_names(10)={'t2'};
	Y.Elements_names(11)={'t3'};

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
L=par(1);
R1=par(2);
R2=par(3);
R3=par(4);
a1=par(5);
a2=par(6);
a3=par(7);
dT=par(8);
t1=par(9);
t2=par(10);
t3=par(11);

% Immittance calculations
Y = exp(dT.*iw)./(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))));

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
				 Jacobian = -(iw.*exp(dT.*iw))./(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2;
			 case 2 
				 Jacobian = -exp(dT.*iw)./(R1.^2.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t1).^a1 + 1).*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 3 
				 Jacobian = -exp(dT.*iw)./(R2.^2.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t2).^a2 + 1).*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 4 
				 Jacobian = -exp(dT.*iw)./(R3.^2.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t3).^a3 + 1).*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 5 
				 Jacobian = (exp(dT.*iw).*log(iw.*t1))./(R1.*(iw.*t1).^a1.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t1).^a1 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 6 
				 Jacobian = (exp(dT.*iw).*log(iw.*t2))./(R2.*(iw.*t2).^a2.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t2).^a2 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 7 
				 Jacobian = (exp(dT.*iw).*log(iw.*t3))./(R3.*(iw.*t3).^a3.*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t3).^a3 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 8 
				 Jacobian = (iw.*exp(dT.*iw))./(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))));
			 case 9 
				 Jacobian = (a1.*iw.*exp(dT.*iw))./(R1.*(iw.*t1).^(a1 + 1).*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t1).^a1 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 10 
				 Jacobian = (a2.*iw.*exp(dT.*iw))./(R2.*(iw.*t2).^(a2 + 1).*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t2).^a2 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
			 case 11 
				 Jacobian = (a3.*iw.*exp(dT.*iw))./(R3.*(iw.*t3).^(a3 + 1).*(L.*iw + 1./(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1)))).^2.*(1./(iw.*t3).^a3 + 1).^2.*(1./(R1.*(1./(iw.*t1).^a1 + 1)) + 1./(R2.*(1./(iw.*t2).^a2 + 1)) + 1./(R3.*(1./(iw.*t3).^a3 + 1))).^2);
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