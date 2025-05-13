function [ Result, info, flag, Time, Misc ] = NELM_Func(name, exp_num, Stat_exp_num,...
                                                   x0, Get_Spectrum_Func,...
                                                   Get_Time_Domain_Data, ...
                                                  Model, Model_Options,  W_type,options,Misc)
%Function for fitting immittance spectra to a theoretical equivalent
%scheme using the CNLS method
%Version 1.0 beta


% name              -- path to the folder that contains data files to be processed
% exp_num           -- sequence number of the data-file to be processed
% Stat_Exp_num      -- statistical experiment number
% R0                -- feedback resistance in Ohms (for Op-Amp ammeter based measurements)
% x0                -- starting point of the approximation
% Get_Spectrum_Func -- function for loading the spectrum from a data-file
% Model             -- pointer to the function that calculates the admittance of the equivalent circuit
% W_type            -- weighting type 
% options           -- minimization process options that are passed to the numerical optimization solver 
% Mics              -- additional structure for storing additional spectral processing results                                      



R0=options.R0;
Misc.x0=x0;
if isfield(options,'Frequency_Range')
 Freq_res=options.Frequency_Range.Freq_res;                                %Setting the resolution of the spectra as the inverse of the data collection time (for time-domain impedance spectroscopy)
 Freq_lim=options.Frequency_Range.Freq_lim;                                %Setting the upper frequency limit
 S=options.Frequency_Range.S;                                              %Setting the index (!) of the frequency, which corresponds to the lower limit of the spectrum frequency range used for CNLS. 
else
 Freq_res=2;                                                               %Stub initialization of the Frequency_Range field with default values
 Freq_lim=40000;                                                           
 S=10;                                                                     
end;

%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%      Begin         %
%%%%%%%%%%%%%%%%%%%%%%
 if isfield(options, 'Use_Normalization')                                  %Caution: Not fully tested on fixed-parameter models. Under construction
  if options.Use_Normalization
   Data_Normalization_Vector=options.Data_Normalization_Vector;
   Data=Data*diag(Data_Normalization_Vector);
   P_=model(model_options);
   if ~isempty(Model_Options.fix_pars)
    x0_(lin_set_difference(Model_Options.fix_pars(1,:),P_.Elements_Num))=x0;
    x0_(Model_Options.fix_pars(1,:))=Model_Options.fix_pars(2,:);
    x0_(P_.non_negative_pars)=abs(x0_(P_.non_negative_pars));
    Pars_Normalization_vector=options.Calc_Pars_Normalization_Vector(x0_);
    x0_=x0_*diag(Pars_Normalization_vector);
    x0=x0_(lin_set_difference(Model_Options.fix_pars(1,:),P_.Elements_Num));
   else
    x0(P_.non_negative_pars)=abs(x0(P_.non_negative_pars));
    Pars_Normalization_vector=options.Calc_Pars_Normalization_Vector(x0);
    x0=x0*diag(Pars_Normalization_vector);
   end;    
   clear P_;
  end;
 else
  options.Use_Normalization=false;
 end;
%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%        End         %
%%%%%%%%%%%%%%%%%%%%%%
 
disp(['Worker ' num2str(Stat_exp_num) ' is starting calculations']);
if ~isfield(options,'method')                                                 
 [x, Res, flag, info]=fminsearch(@Resudial_gpu,x0,options);                %If options.method does not defined, then looking for the minimum residual using the Nelder-Mead method
else
    switch options.method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%       Raw data for Cell-Index approach                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        % Raw data for Cell-Index approach
        case 'Raw'
            [x, Time, f, W, V_os]=Get_Spectrum_Func( name, exp_num, options );
            if isfield(Model_Options, 'Selected_Points') 
             x=x(Model_Options.Selected_Points);                                            
            end;
            Res=0;
            flag=1; 
            info.iterations=0;
            info.funcCount=0;
            info.algorithm='Raw data as is';
            info.message='Ok!';
            V_os=0; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%          Artificial Intelligence Adaptive Filtering Approach            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'AF'
            if isempty(Get_Time_Domain_Data)
                error('Selected file type does not support time-domain calculations');
            end;
            if iscell(name)
             [J,V, Time, f0, V_os,E] =Get_Time_Domain_Data(char(name{exp_num}),exp_num);
            else                
             [J,V, Time, f0, V_os,E] =Get_Time_Domain_Data(name,exp_num);
            end;           
            f=Freq_res*S:Freq_res:Freq_lim; 
            if ~isfield(options,'eliminate_spectrum_outliers')
                options.eliminate_spectrum_outliers=0;
            end;
            if options.eliminate_spectrum_outliers~=0                      %Eliminate outliers (experimental)
                [J V f idx]=Remove_Spectral_Outliers_for_imitance(J, V, f,...
                                      options.eliminate_spectrum_outliers);
                x = AF_get_w( V, J, Model_Options )';
                Y=Get_Spectrum_Func( name, exp_num, options );
                Y(idx)=[];
            else
                Y=Get_Spectrum_Func( name, exp_num, options );
                Model_Options.Y_exp=Y;
                Model_Options.f=f;
                Model_Options.Noise_Level=x0(end);
                x = AF_get_w( V, J,  Model_Options )';   
                x=[x f0];                                                                %Saving actual sampling rate at the end of the weight coefficients vector for compatibility with different file types.
            end;
            
            Res=Residual_LMS(f, Y, Model, Model_Options, W_type, x,options);
            flag=1; 
            info.iterations=0;
            info.funcCount=0;
            info.algorithm='Adaptive filtering old';
            info.message='Ok!';
            V_os=0; 
            if options.export_to_ascii==true
                [Y, W]=Model(f, x, Model_Options);
                Y=Y.'; W=W.';
                output=[f' real(Y) imag(Y) W];
                if iscell(name)
                    s=char(name{exp_num});
                else
                    s=name;
                end;
                for idx=length(s):-1:1
                    if s(idx)=='.'
                        break;
                    end;
                end;
                save([s(1:idx-1) '_AF.dat'],'output','-ascii');
            end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%              Classical Nelder-Mead search                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'Nelder-Mead'
            if ~isfield(options,'eliminate_spectrum_outliers')
                options.eliminate_spectrum_outliers=0;
            end;
            if options.eliminate_spectrum_outliers~=0
                warning('Nelder-Mead with reduced spectrum is used!');
                if iscell(name)
                    [Par data]=I2txt(char(name{exp_num}),250000,false,exp_num);
                else
                    [Par data]=I2txt(name,250000,false,exp_num);
                end;
                f=Freq_res*S:Freq_res:Freq_lim;
                V=data(:,4);
                J=data(:,1);
                [~, ~, f, idx]=Remove_Spectral_Outliers_for_imitance(J, V, f, options.eliminate_spectrum_outliers);
                [Y, Time, ~, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
                Y(idx)=[];
            else
                [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            end;
            options.W=W;
            Target=@(x)(Residual_LMS(f, Y, Model, Model_Options, W_type, x,options));
            [x, Res, flag, info]=fminsearch(Target,x0,options);            %Searching for the minimum residual using the Nelder-Mead method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Classical Levenberg-Marquardt search                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'Levenberg-Marquardt' 
            options_=optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt');
            options_.TolFun=options.TolFun;                                                     
            options_.TolX=options.TolX;
            options_.Display=options.Display;  
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Target=@(x)(Residual_LMS(f, Y, Model, Model_Options, W_type, x,options));
            [x,Res,~,flag,info] = lsqnonlin(Target,x0,[],[],options_);     %Searching for the minimum residual using the Levenberg-Marquardt method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Alternative Trust region search                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
         case 'Trust_Region' 
            options_=optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective');
            options_.TolFun=options.TolFun;                                                     
            options_.TolX=options.TolX;
            options_.Display=options.Display;  
            options.mean_error = false;
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options);
            Target=@(x)(Residual_LMS(f, Y, Model, Model_Options, W_type, x,options));            
            [x,Res,~,flag,info] = lsqnonlin(Target,x0,[],[],options_);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Hybrid of the Nelder-Mead and Levenberg-Marquardt          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
        case 'NMLM'  
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Target=@(x)(Residual_LMS(f, Y, Model, Model_Options, W_type, x));             
            [x, Res, flag, info]=fminsearch(Target,x0,options);            %Searching for the minimum residual using the Nelder-Mead method
            options_=optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt');
            options_.TolFun=options.TolFun;                                                    
            options_.TolX=options.TolX;
            options_.Display=options.Display;           
            [x,Res,~,flag,info] = lsqnonlin(Target,x,[],[],options_);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Hybrid of the Nelder-Mead with damped Gauss-Newton search          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        case 'NMGN'
         [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );   
         [ x, Res, flag, info ] = NMGN(x0, f, Y, Model,Model_Options, ...
                                                           options,'unit');                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Hybrid of the Nelder-Mead with damped steepest descent search      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'NMSD'
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            [ x, Res, flag, info ] = NMSD(x0, f, Y, Model,Model_Options,....
                                                          options, W_type);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Hybrid of the Nelder-Mead and coordinate descent search            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'NMCD'
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Info=Model(Model_Options);
            pars=[[Info.non_fix_pars_idx;x0] Model_Options.fix_pars];      %Reconstructing full parameters vector
            [~, idx]=sort(pars(1,:));
            pars=pars(2,idx);
            if ~isfield(options,'CD_laps')                                 %Fool_proof
                options.CD_laps=10;
                warning('Field options.CD_laps is absent. Setting it to options.CD_laps=10');
            end;
            options.MaxIter     = round(options.MaxIter/options.CD_laps);
            options.MaxFunEvals = round(options.MaxFunEvals/options.CD_laps);
            for lap=1:options.CD_laps
                for j=Info.non_fix_pars_idx
                    fix_idx=1:length(pars);                                %Prepearing new fix_pars vector
                    fix_idx(j)=[];
                    fix_pars=pars;
                    fix_pars(j)=[];
                    Model_Options.fix_pars=[fix_idx;fix_pars];
                    x0=pars(j);                                            %Get only one varyable for minimum searching
                    Target=@(x)(Residual_LMS(f, Y, Model, Model_Options,...
                        W_type, x,options));
                    [x, Res, flag, info]=fminsearch(Target,x0,options);
                    pars(j)=x;                                             %Update pars vector
                end;
            end;
            x=pars(Info.non_fix_pars_idx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Nelder-Mead with jumping out method                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
        case 'NM_Shake'
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Target=@(x)(Residual_LMS(f, Y, Model, Model_Options, W_type, x,options));
            [x, Res, flag, info]=fminsearch(Target,x0,options);            %Searching for the minimum residual using the Nelder-Mead method
            x=x.*(1+0.1*(rand(size(x))-0.5));
            [x, Res, flag, info]=fminsearch(Target,x,options);             %Searching again for the minimum residual using the Nelder-Mead method   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Nelder-Mead with homotopy stabilization                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'Y_Homotopy'
         if Model_Options.Is_Warming_Up
          [x, Res, flag, info]=fminsearch(@Resudial_gpu,x0,options);              
         else   
          [Y_p, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num-2, options);
          x=x0;
          for t_=options.Homotopy_Steps
             Y_H=t_*Y+(1-t_)*Y_p;   
             Data(:,2)=real(Y_H);
             Data(:,3)=imag(Y_H);          
             [x, Res, flag, info]=fminsearch(@Resudial_gpu,x,options);  
          end;
         end; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%                Algebraic methods from                                   %
% Stupin, D. D., Kuzina, E. A., Abelit, et. al (2021).                    % 
% Bioimpedance spectroscopy: basics and applications.                     %
% ACS Biomaterials Science & Engineering, 7(6), 1962-1986.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TODO foll proof
        case 'AM'
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Info=Model(Model_Options);
            if ~isfield(Info,'AM_compatible')
              error(['Sorry, for model ''' func2str(Model)...
                  ''' algeraic solution does not exist or this model does not supported']);
            end;
            Model_Options.get_AM_solution=true;
            [x, info]=Model(f, Y, Model_Options);
            Model_Options.get_AM_solution=false;            
            Res=Residual_LMS(f, Y, Model, Model_Options, W_type, x,options);
            if info.message=='Ok!'
                flag=1;
            else
                flag=0;
            end;
            V_os=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%                    Geometric methods                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TODO foll proof
        case 'GM'
            [Y, Time, f, W, V_os] = Get_Spectrum_Func( name, exp_num, options );
            Info=Model(Model_Options);
            if ~isfield(Info,'GM_compatible') 
              error(['Sorry, for model ''' func2str(Model)...
                  ''' geometric solution does not exist or this model does not supported']);
            end;
            Model_Options.get_GM_solution=true;
            [x, info]=Model(f, Y, Model_Options);
            Model_Options.get_GM_solution=false;            
            Res=Residual_LMS(f, Y, Model, Model_Options, W_type, x,options);
            if info.message=='Ok!'
                flag=1;
            else
                flag=0;
            end;
            V_os=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%      Begin         %
%%%%%%%%%%%%%%%%%%%%%%  
        case 'Linear approximant'
        % Direct solving grad=0 equation. Experimental                     
        case 'Nelder-Mead_Grad_Minimization'
                % TODO Fill the correct code
        % Nelder-Mead with normalization feature                        
        case 'NM_Normalization'
       % TODO Fill the correct code
        % Nelder-Mead and damped Gauss-Newton with normalization feature   
        case 'NMGN_Normalization' 
            % TODO Fill the correct code
         % Hybrid Nelder-Mead with geometric approach
%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%        End         %
%%%%%%%%%%%%%%%%%%%%%%          
        otherwise
            error('Unknown method...');
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%      Begin         %
%%%%%%%%%%%%%%%%%%%%%%
if options.Use_Normalization
 Res=Res*options.Res_Normalization;                                                             
 Data_Normalization_Vector=options.Data_Normalization_Vector;
 Data=Data*diag(1./Data_Normalization_Vector);
 P_=model(model_options);
 if ~isempty(Model_Options.fix_pars)
  y(lin_set_difference(Model_Options.fix_pars(1,:),P_.Elements_Num))=x;
  y(Model_Options.fix_pars(1,:))=Model_Options.fix_pars(2,:);
  y(P_.non_negative_pars)=abs(y(P_.non_negative_pars));
  Pars_Normalization_vector=options.Calc_Pars_Normalization_Vector(y);
  y=y*diag(1./Pars_Normalization_vector);
  x=y(lin_set_difference(Model_Options.fix_pars(1,:),P_.Elements_Num));
 else
  x(P_.non_negative_pars)=abs(x(P_.non_negative_pars));
  Pars_Normalization_vector=options.Calc_Pars_Normalization_Vector(x);
  x=x*diag(1./Pars_Normalization_vector);
 end; 

 clear P_;
end;
%%%%%%%%%%%%%%%%%%%%%%
% Under construction %
%        End         %
%%%%%%%%%%%%%%%%%%%%%%


   
sigma=sqrt(Res);                                                           %Writing down the approximation error
                                                                           
x(end+1)=sigma;
Result=x;                                                                  %Writing the result into the output variable
Misc.Vos=V_os;                                                             %Saving offset voltage to Misc structure 
end

