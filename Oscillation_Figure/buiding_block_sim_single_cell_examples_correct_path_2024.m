function buiding_block_sim_single_cell_examples_correct_path_2024   

in_path='C:\Users\cs687\Documents\MATLAB\General_Model_Figures\Oscillation_Figure\Sim_Data';

name='-D_20.0-tau_3.0-v0_0.01-n_2.0-nu_0.05';
cond_to_do={'1.5','4.5','10.0','60.0'};
close all;

%Repeats to plot
%ind=[1,26,64,20];% multiple pulses; data from 2023.04.05; 'JLB259_0uM','JLB259_5uM','JLB259_5uM','JLB259_10uM'
ind=[1,3,2,1];% one pulse; data from 2023.04.05; 'JLB259_0uM','JLB259_4uM','JLB259_5uM','JLB259_10uM'

%setting up figure
what_is_it={'Off','Pulsing','Oscillation','On'};
figure('Position',[1239,249,550,850]);
t = tiledlayout(4,1,'TileSpacing','Compact','Padding','Compact');
do_now=1:length(cond_to_do);
time=0:0.2:(1000*0.2-0.2);

for i=flip(do_now)
    %loading Data
    a=load([in_path,'\S_',cond_to_do{i},name,'.mat']);
    traces=squeeze(a.traces(:,1,2:end));
    %Plotting Data
    nexttile;
    plot(time,traces(370:1369,ind(i)),'Linewidth',4);
    %Making Figure nice
    set(gca,'Fontweight','bold')
    axis([0,200,0,1.1])
    if i==1
        xlabel('Time [au]');
    end
    ylabel('MS [au]');
    set(gca,'Linewidth',2,'FontSize',16,'FontWeight','bold');
    title(what_is_it{i},'FontSize',18,'FontWeight','bold')
end
set(gcf,'color','w');
saveas(gcf,'sim_example.pdf');




% for i=do_now
%     a=load([in_path,'\S_',cond_to_do{i},name,'.mat']);
%     traces=squeeze(a.traces(:,1,2:end));
% 
%     figure('Units','normalized','Position',[0,0,1,1]);
%     sgtitle([cond_to_do{i}]);
% 
%         for j=1:size(traces,2)
%             subplot(5,2,j)
%             plot(traces(370:end,j),'Linewidth',1);
%             %xline(350);
%             % axis([0,5770/60,0,6000])
%         end
% 
% end