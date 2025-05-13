%This piece of code checks if approximation of this data was made
%prevuiously, and suggests to download it
if ~isempty(dir(strcat(path,'_CNLS_Stat.mat')))||...
        ~isempty(dir(strcat(path,'\CNLS_Stat_AutoSave.mat')))
  ChkSum_=~isempty(dir(strcat(path,'_CNLS_Stat.mat')))-...
        ~isempty(dir(strcat(path,'\CNLS_Stat_AutoSave.mat')));
  switch ChkSum_
      case 1
       answer_ = questdlg('I have found resent CNLS fit for this experiment. Do you want to load it and continue it''s processing? ', ...
       'Tada! You are lucky!', ...
	   'Yes','No','No');  
       if strcmp(answer_,'Yes')
           load(strcat(path,'_CNLS_Stat.mat'));
           new=false;
       end;
      case 0
       answer_ = questdlg('I have found resent CNLS fit and AutoSave for this experiment. Do you want to load them and continue processing? ', ...
       'Tada! You are lucky!', ...
	   'Yes, load CNLS-fit','Yes, load AutoSave','No','No');  
       if strcmp(answer_,'Yes, load CNLS-fit')
           warning('Look at Check_for... line 19. Name was changed')           
           load(strcat(path,'_CNLS_Stat_Daniil_25.02.24.mat'));
           new=false;
       elseif strcmp(answer_,'Yes, load AutoSave')
           load(strcat(path,'\CNLS_Stat_AutoSave.mat'));
           new=false;           
       end;          
      case -1
       answer_ = questdlg('I have found resent CNLS AutoSave for this experiment. Do you want to load it and continue processing? ', ...
       'Tada! You are lucky!', ...
	   'Yes','No','No');  
       if strcmp(answer_,'Yes')
           load(strcat(path,'\CNLS_Stat_AutoSave.mat'));
           new=false;
       end;          
  end;
end;
clear answer_ ChkSum_;