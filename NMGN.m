function [ x, Res, flag, info ] = NMGN(x0, f, Y_exp, model, model_options, options, W_type)
%Function for the CNLS processing using the Nelder-Mead method at first, and
%damped Gauss-Newton method at second.
tol=options.GN_tol;
Y_exp=Y_exp(:);
Target=@(x)(Residual_LMS(f, Y_exp, model, model_options, W_type, x,options));
if options.Use_NM
    [x, Res, flag, info]=fminsearch(Target,x0,options);
    info.algorithm= 'Nelder-Mead+Gauss-Newton';
else
    x=x0;
end;
if options.NMGN_Display
    Y_m=model(f,x,model_options);
    Plot_immittance_multi_data(f, Y_exp, Y_m, options);
    disp('Nelder-Mead stage complete! Press any key');
    disp(['Residual before Gauss-Newton search ',num2str(Target(x))]);
    pause;
end;

finding=true;
Xs=[];
tic;
time_out=false;
while finding
    if toc/60>2                                                            %Stoping optimization after 2 minutes time-out
        time_out=true;
        break;
    end;
    Xs=[Xs; x];
    model_options.get_J = true;
    [Y_m, Jacobian]=model(f,x,model_options);
    if ~all(~isnan(Jacobian(:)))
        break;
    end;
    Y_m=Y_m(:);
    %May be Jacobial should be converted to column-type
    
%Beautiful mathematics! All derivatives of immittance can be expressed through
%derivatives of admittance 
    switch options.data_type
        case 'Y'                                                           %Tested, ok
            F=Y_m-Y_exp;
            b=real(Jacobian'*F);
            Q=real(Jacobian'*Jacobian);
        case 'abs_Y'                                                       %Tested, ok
            F=abs(Y_m)-abs(Y_exp);
            inv_abs_Y=1./abs(Y_m);
            Jacobian=real(Jacobian)+imag(Jacobian);
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*inv_abs_Y;
            end;
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;            
        case 'real_Y'                                                      %Under test
            F=real(Y_m)-real(Y_exp);
            Jacobian=real(Jacobian);
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;    
        case 'imag_Y'                                                      %Under test
            F=imag(Y_m)-imag(Y_exp);
            Jacobian=imag(Jacobian);
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;  
        case 'angle_Y'                                                     %Under test
            F=angle(Y_m)-angle(Y_exp);
            inv_abs_Y2=1./abs(Y_m).^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=( imag(Jacobian(:,j)).*real(Y_m)-...
                                real(Jacobian(:,j)).*imag(Y_m))...
                                          .*inv_abs_Y2;
            end;
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;            
        case 'Z'                                                           %Tested, ok
            F=1./Y_m-1./Y_exp;
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
            b=real(Jacobian'*F);
            Q=real(Jacobian'*Jacobian);

        case 'abs_Z'                                                       %Tested, ok
            F=abs(1./Y_m)-abs(1./Y_exp);
            neg_inv_abs_Y3=-1./abs(Y_m).^3;
            Jacobian=real(Jacobian)+imag(Jacobian);
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_abs_Y3;
            end;
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;
        case 'real_Z'                                                      %Under test
            F=real(1./Y_m)-real(1./Y_exp);
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
            Jacobian=real(Jacobian);
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian; 
        case 'imag_Z'                                                      %Under test
            F=imag(1./Y_m)-imag(1./Y_exp);
            neg_inv_Y2=-1./Y_m.^2;
            for j=1:length(Jacobian(1,:))
                Jacobian(:,j)=Jacobian(:,j).*neg_inv_Y2;
            end;
            Jacobian=imag(Jacobian);
            b=Jacobian'*F;
            Q=Jacobian'*Jacobian;             
        otherwise
            error('Unknown data type in Residual_LMS in misc structure.')
    end;
    Solver='svd';
    switch Solver
        case 'direct'
            compass=(Q^-1*b).';
        case 'svd'
            [U,S,V]=svd(Q,'econ');
            S=diag(S);
            b=U'*b;
            for j=1:length(S)
                % if abs(S(j))>tol
                compass(j)=b(j)/S(j);
                % else
                %     compass(j)=0;
                % end;
            end;
            compass=(V*compass.').';
    end;

  %  lambda=options.lambda_0;
    % while lambda>tol
    %     x_buf=x;
    %     x=x-lambda*compass;
    %     if Target(x)>=Target(x_buf)
    %         x=x_buf;
    %         lambda=lambda/2;
    %         if options.NMGN_Display
    %             lambda
    %         end;
    %         finding=false;
    %     else
    %         finding=true;
    %         Res=Target(x);
    %         lambda=options.lambda_0;
    %         if options.NMGN_Display
    %             switch options.data_type
    %                 case 'Y'
    %                     plot(Y_exp,'sg'); hold on; plot(Y_m,'sr'); hold off;
    %                 case 'Z'
    %                     plot(1./Y_exp,'sg'); hold on; plot(1./Y_m,'sr'); hold off;
    %                 case 'abs_Y'
    %                     plot(f, abs(Y_exp),'sg'); hold on; plot(f, abs(Y_m),'sr'); hold off;
    %                 case 'abs_Z'
    %                     plot(f, abs(1./Y_exp),'sg'); hold on; plot(f, abs(1./Y_m),'sr'); hold off;
    %             end;
    %             drawnow;
    %         end;
    %         break;
    %     end;
    % end;
    E=@(lambda)(Target(x-lambda*compass));
    lambda_step=options.lambda_0/2;
    lambda_left=0;
    lambda_right=options.lambda_0;
    lambda_width=(lambda_right-lambda_left);
    while lambda_width>1e-6
     E_left=E(lambda_left);
     E_right=E(lambda_right);
     if E_left<=E_right
       lambda_right=(lambda_right+lambda_left)/2;
     else
       lambda_left=(lambda_right+lambda_left)/2;         
     end;
     lambda_width=(lambda_right-lambda_left);
    end;

    if E_left<=E_right
        rel_diff=max(abs(lambda_left*compass./x));
        x=x-lambda_left*compass;
    else
        rel_diff=max(abs(lambda_right*compass./x));        
        x=x-lambda_right*compass;  
    end;
    if rel_diff<=tol
        finding=false;
    end;
    if options.NMGN_Display
      Plot_immittance_multi_data(f, Y_exp, Y_m, options);
    end;

end;
% if lambda<=tol
%     x=x_buf;
% end;
% if ~all(~isnan(Jacobian(:)))
%     break;
% end;
if options.NMGN_Display
    Grad=real(Jacobian'*F);
    disp(['Residual after Gauss-Newton search ',num2str(Target(x))]);
    disp(['Final Jacobian rank is ' num2str(rank(Jacobian)) ', gradient norm is ' num2str(norm(Grad))]); pause;
end;
Res=Target(x);
if ~options.Use_NM
    flag=1;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Gauss-Newton with Nelder-Mead';

    info.message='Ok!';
end;
if time_out
    flag=0;
    info.iterations=0;
    info.funcCount=0;
    info.algorithm= 'Gauss-Newton with Nelder-Mead';

    info.message='Time out stop';
end;
end
%For future
%     [U,S,V]=svd(Q);
%     S=diag(S);
%     b=U'*b;
%     for j=1:length(S)
%         if abs(S(j))>tol
%             compass(j)=b(j)/S(j);
%         else
%             compass(j)=0;
%         end;
%     end;
%    compass=(V*compass.').';