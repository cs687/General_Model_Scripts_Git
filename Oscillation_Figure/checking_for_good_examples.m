in_path='F:\Users\christian.schwall\Desktop\Oscillation_Data\2023-04-05\';

cond_to_do={'JLB259_0uM','JLB259_3uM','JLB259_4uM','JLB259_5uM','JLB259_10uM'};
close all;

ind=[1,26,64,20];
what_is_it={'Off','Pulsing','Oscillation','On'};
    figure;
    t = tiledlayout(4,1,'TileSpacing','Compact','Padding','Compact');
    do_now=1:length(cond_to_do);
% for i=flip(do_now)
for i=do_now
    a=load([in_path,cond_to_do{i},'.mat']);
    MY_now=a.MY;
    goodones=~isnan(MY_now(578,:));
    MY_now=MY_now(:,goodones);
    figure;
    try 
        for j=1:sum(goodones)
            subplot(9,9,j)
            plot([0:10:5770]/60,MY_now(1:578,j)-200,'Linewidth',1);
            axis([0,5770/60,0,6000])
        end
    catch 
        continue
    end
end

