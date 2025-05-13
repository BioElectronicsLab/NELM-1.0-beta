function Plot_Pars_Evo( Channels, Ch, Par_N )
%Procedure for plotting evolution of the parameters
if ~isfield(Channels(Ch), 'Best_CI')
    Channels(Ch).Best_CI=[];
end;

if isempty(Channels(Ch).Best_CI)
    plot(Channels(Ch).Best(:,Par_N));
else
    Channels(Ch).Best_CI=[Channels(Ch).Best_CI zeros(length(Channels(Ch).Best(:,1)),2)];
    errorbar(Channels(Ch).Best(:,Par_N),Channels(Ch).Best_CI(:,Par_N),'s-' );
end;


end

