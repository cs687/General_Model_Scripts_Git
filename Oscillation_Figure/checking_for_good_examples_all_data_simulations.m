in_path='C:\Users\cs687\Documents\MATLAB\General_Model_Figures\Oscillation_Figure\Sim_Data';

name='-D_20.0-tau_3.0-v0_0.01-n_2.0-nu_0.05';
cond_to_do={'1.5','4.5','10.0','60.0'};

close all;

do_now=1:length(cond_to_do);

for i=do_now
    a=load([in_path,'\S_',cond_to_do{i},name,'.mat']);
    traces=squeeze(a.traces(:,1,2:end));
   
    figure('Units','normalized','Position',[0,0,1,1]);
    sgtitle([cond_to_do{i}]);

        for j=1:size(traces,2)
            subplot(5,2,j)
            plot(traces(370:end,j),'Linewidth',1);
            %xline(350);
            % axis([0,5770/60,0,6000])
        end

end


