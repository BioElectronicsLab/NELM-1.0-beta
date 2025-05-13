function [ names ] = Prepare_files_list(path, file_mask, sort_type )
% This function prepares a list of files that are going to be processed
files=dir([path '\' file_mask]);                                           %Getting files that correspond to the file mask
if length(files)==0                                                        %Setting warning in case of absense of chosen file type  
    disp('It seems folder'); disp(path);
    disp(['have no ' file_mask '-files. Please, select another folder']);
    names=[];
    return;
end;
files([files.isdir])=[];                                                   %Preparing directory
switch sort_type                                                           %Sorting files depeding on chosen way
    case 'mask'                                                            %If type 'mask' has been chosen, then the files are sorted 
     left_right=strsplit(file_mask,'*');                                   %by numbers that follows the mask
     if length(files)==0
         names=-1;
         return;
     end;
     for j=1:length(files)
      s=files(j).name;
      s=strrep(s,left_right{1},'');
      s=strrep(s,left_right{2},'');      
      Only_Numbers(j)=str2num(s);
     end;
      [~, idx]=sort(Only_Numbers);
      files=files(idx);
      names={files.name}';
    case 'date'                                                            %If type 'date' has been chosen, then the files are sorted
        [~, idx]=sort([files.datenum]);                                    %by the time there were created
        files=files(idx);
        names={files.name}';
    otherwise
    error('unknown sorting type')    
end;

end

