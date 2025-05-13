function [Y, Jacobian] = M_R_CPE(f, par, model_options )
% Series R-CPE circuit. Diffusion, rough, non-ideal
% electrochemical electrodes,
%complex distributed systems
%(e.g. tissues).

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
Pars_N=3;

% Setting the indices of non-negative parameters
non_negative_pars=[1  2  3];


% Switching to info-mode
if nargin<=1
    Y.version='LEVM_like';
    Y.Elements_names(1)={'A'};
    Y.Elements_names(2)={'R'};
    Y.Elements_names(3)={'W'};

    non_fix_pars_idx=lin_set_difference(fix_pars,Pars_N);
    Y.non_fix_pars_idx=non_fix_pars_idx;
    Y.Elements_names= Y.Elements_names(non_fix_pars_idx);
    Y.Elements_Num=length(non_fix_pars_idx);

    a=zeros(1,Pars_N); a(non_negative_pars)=1; a=a(non_fix_pars_idx);
    Y.non_negative_pars=find(a==1);

    Y.AM_compatible=true;
    Y.GM_compatible=true;
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
    [~, idx]=max(imag(Y)); w_max=2*pi*f(idx);
    if (idx==1)||(idx==length(f))
        warning('Possibly, AM method goes out of range! Try to use geometric method (GM)');               
        info.message='Possibly, AM method goes out of range!  Try to use geometric method (GM)';
    end;
    ReY=real(Y(idx)); ImY=imag(Y(idx));
    R=1/(2*ReY);
    alpha=4/pi*atan(2*R*ImY);
    W=1/(R*w_max^alpha);
    Y=[alpha R W];
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
if ~isfield(model_options,'get_GM_solution')
    model_options.get_GM_solution=false;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Geometric solution for arc approximation                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if model_options.get_GM_solution
    info.message='Ok!';
    Y=par;
    Y=Y(:);
    [P, R] = Get_Circle_Center_C_LMS(Y);                                   %Getting the center and radius of the admittance locus
    alpha=1+2/pi*angle(P);                                                  %Using obvious geometric calculations
    R=1/(2*real(P));                                                       
    inv_w_in_alpha=1./(2*pi*f*i).^alpha;                                   %LMS approach for the pseudo-capacitance calculations
    Z=1./Y; RHS=Z-R;
    W=real(inv_w_in_alpha'*inv_w_in_alpha)/real(inv_w_in_alpha'*RHS);
    Y=[alpha R W];
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

% Parsing parameters vector into single parametrs
iw=2*pi*f*1i;
A=par(1);
R=par(2);
W=par(3);

% Immittance calculations
Y = 1./(R + 1./(W.*(f.*pi.*2i).^A));

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
                Jacobian = log(f.*pi.*2i)./(W.*(R + 1./(W.*(f.*pi.*2i).^A)).^2.*(f.*pi.*2i).^A);
            case 2
                Jacobian = -1./(R + 1./(W.*(f.*pi.*2i).^A)).^2;
            case 3
                Jacobian = 1./(W.^2.*(R + 1./(W.*(f.*pi.*2i).^A)).^2.*(f.*pi.*2i).^A);
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
    function [P, R] = Get_Circle_Center_C_LMS(Y)
        [Rows, Cols]=size(Y);
        if Rows<Cols
            Y=Y.';
        end;
        DY=diff(Y);
        RHS=diff(abs(Y).^2)/2;

        Q=[real(DY) imag(DY)];
        sol=(Q'*Q)^-1*Q'*RHS;
        P=sol(1)+1i*sol(2);
        R=mean(abs(P-Y));
    end


end