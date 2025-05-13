function [Y, Jacobian] = M_Gerisher_rl(f, par, model_options )
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
Pars_N=5;

% Setting the indices of non-negative parameters 
non_negative_pars=[5  3  2  1];


% Switching to info-mode 
if nargin<=1
	Y.version='LEVM_like';
	Y.Elements_names(1)={'L'};
	Y.Elements_names(2)={'R'};
	Y.Elements_names(3)={'alpha'};
	Y.Elements_names(4)={'dT'};
	Y.Elements_names(5)={'tau'};

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
R=par(2);
alpha=par(3);
dT=par(4);
tau=par(5);

% Immittance calculations
Y = exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1)));

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
				 Jacobian = -(dT.*iw.^2.*exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1))))./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1)).^2;
			 case 2 
				 Jacobian = -(dT.*iw.*exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1))).*((1./(iw.*tau) + 1).^alpha + 1))./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1)).^2;
			 case 3 
				 Jacobian = -(R.*dT.*iw.*exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1))).*log(1./(iw.*tau) + 1).*(1./(iw.*tau) + 1).^alpha)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1)).^2;
			 case 4 
				 Jacobian = (iw.*exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1))))./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1));
			 case 5 
				 Jacobian = (R.*alpha.*dT.*exp((dT.*iw)./(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1))).*(1./(iw.*tau) + 1).^(alpha - 1))./(tau.^2.*(L.*iw + R.*((1./(iw.*tau) + 1).^alpha + 1)).^2);
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