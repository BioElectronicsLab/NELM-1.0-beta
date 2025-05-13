% This code clear structure channels in case if approximation of this
% experiment did not happen previously
if new
 for j=1:Ch_Num
      Channels(j).WA_Best=[];
      Channels(j).WA_Mean=[];
      Channels(j).WA_CI=[];
      Channels(j).Best=[]; 
      Channels(j).Best_CI=[];
      Channels(j).Mean=[]; 
      Channels(j).CI=[]; 
      Channels(j).infos_Best=[];
      Channels(j).Time=[];
      Channels(j).exp_nums=[];
      Channels(j).Misc=[];
      Channels(j).Y_exp=[];                                                %For debug
      Channels(j).Y_m=[];                                                  %For debug 
 end;
end;