function  Show_pars_in_console( Channels,N )
%This function shows the resulring parameters of approximation in console
Ch=1;
Info_m=Channels(Ch).Model(Channels(Ch).Model_Options);
for j=1:length(Info_m.Elements_names)
    s=Info_m.Elements_names{j};
    s(s==' ')='_';
    s(s==',')='';
    s(s=='\')='';
    Info_m.Elements_names{j}=s;
end;
ColNames=[Info_m.Elements_names, 'Res_S', 'Flag'];
RowNames={};
Array=[];
for Ch=1:length(Channels)
    if ~isempty(Channels(Ch).Best)
        RowNames=[RowNames,['Ch ' num2str(Ch)], ['CI ' num2str(Ch)] ];
        if N==Inf
            Array=[Array; Channels(Ch).Best(end,:); Channels(Ch).Best_CI(end,:) 0 0];
        else
            Array=[Array; Channels(Ch).Best(N,:); Channels(Ch).Best_CI(N,:) 0 0];
        end;
    end;
end;
if IsMatLab
    Table=array2table(Array,'VariableNames',ColNames,'RowName',RowNames);
    disp(' ');
    disp(Table);
else
    disp(Array);
end;


end

