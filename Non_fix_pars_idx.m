function [ idx ] = Non_fix_pars_idx( Channel, WA )
% Routine for obtaining indices of non-negative parameters of the approximating
% model.
if WA
 Y_=Channel.WA_Model(Channel.WA_Model_Options);    
 if ~isempty(Channel.WA_Model_Options.fix_pars) 
  idx=lin_set_difference(Channel.WA_Model_Options.fix_pars(1,:),...
                                                          Y_.Elements_Num);
 else
  idx=1:Y_.Elements_Num;
 end;
else
 Y_=Channel.Model(Channel.Model_Options);    
 if ~isempty(Channel.Model_Options.fix_pars) 
  idx=lin_set_difference(Channel.Model_Options.fix_pars(1,:),...
                                                          Y_.Elements_Num);
 else
  idx=1:Y_.Elements_Num;
 end;    
end;    

end

