function Plotting_traces   
in_path='F:\Users\christian.schwall\Desktop\Oscillation_Data\2023-04-05\';

%conditions to check
%cond_to_do={'JLB259_0uM','JLB259_5uM','JLB259_5uM','JLB259_10uM'};
cond_to_do={'JLB259_0uM','JLB259_4uM','JLB259_5uM','JLB259_10uM'};
close all;

%Repeats to plot
%ind=[1,26,64,20];% multiple pulses; data from 2023.04.05; 'JLB259_0uM','JLB259_5uM','JLB259_5uM','JLB259_10uM'
ind=[1,7,64,20];% one pulse; data from 2023.04.05; 'JLB259_0uM','JLB259_4uM','JLB259_5uM','JLB259_10uM'

%setting up figure
what_is_it={'Off','Pulsing','Oscillation','On'};
figure('Position',[1239,249,550,850]);
t = tiledlayout(4,1,'TileSpacing','Compact','Padding','Compact');
do_now=1:length(cond_to_do);

for i=flip(do_now)
    %loading Data
    a=load([in_path,cond_to_do{i},'.mat']);
    %Filtering Data
    MY_now=a.MY;
    goodones=~isnan(MY_now(578,:));
    MY_now=MY_now(:,goodones);
    %Plotting Data
    nexttile;
    plot([0:10:5770]/60,MY_now(1:578,ind(i)),'Linewidth',4);
    %Making Figure nice
    set(gca,'Fontweight','bold')
    axis([0,5770/60,0,6000])
    if i==1
        xlabel('Time [h]');
    end
    ylabel('MY [au]');
    set(gca,'Linewidth',2,'FontSize',16,'FontWeight','bold');
    title(what_is_it{i},'FontSize',18,'FontWeight','bold')
end
set(gcf,'color','w');
saveas(gcf,'test.pdf');
