function [ Best Best_CI Mean CI ] = Get_full_pars_from_Channel( Channel )
%This function is getting full parameters from channels, merging non-fixed 
% and fixed ones 
Model=Channel.Model;
Model_Options=Channel.Model_Options;
Info=Model(Model_Options);

[row_count, ~]=size(Model_Options.fix_pars);                               % If fix_pars field equivalent to just a row, then there are no fixed parameters
if row_count<=1
   Best    = Channel.Best; 
   Mean    = Channel.Mean; 
   CI      = Channel.CI;  
   Best_CI = Channel.Best_CI;
   return;
end;

if isfield(Info, 'version')
  if strcmp(Info.version, 'LEVM_like')  
  non_fix_pars_idx=Info.non_fix_pars_idx;  
  else
   error(['Unknown version in Info.version=' Info.version ', where Info=Model(Model_Options)']);
  end;
else
  non_fix_pars_idx=Non_fix_pars_idx(Channel, false);     
end;   
   extra_Best = Channel.Best(:,end-1:end);
   extra_Mean = Channel.Mean(:,end-1:end);
   extra_CI   = Channel.CI(:,end-1:end);   
   Best       = [non_fix_pars_idx; Channel.Best(:,1:end-2)] ; 
   Mean       = [non_fix_pars_idx; Channel.Mean(:,1:end-2)]; 
   CI         = [non_fix_pars_idx; Channel.CI(:,1:end-2)]; 
   Best_CI    = [non_fix_pars_idx; Channel.Best_CI];
   fix= [Model_Options.fix_pars(1,:);
         ones(length(Channel.Best(:,1)),... 
         length(Model_Options.fix_pars(1,:)))*...
         diag(Model_Options.fix_pars(2,:))]; 
   Best    = [Get_full_pars(Best, fix) extra_Best];
   Best_CI = [Get_full_pars(Best_CI, fix)];
   Mean    = [Get_full_pars(Mean, fix) extra_Mean];
   CI      = [Get_full_pars(CI, fix) extra_CI];
end

