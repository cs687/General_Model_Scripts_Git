in_path='F:\Users\christian.schwall\Documents\General_Model\exp_data\Oscillation_Data';

days={'2023-03-30','2023-04-05', '2023-04-14','2023-04-21','2023-05-09'};

%cond_to_do={'JLB259_3uM','JLB259_4uM','JLB259_5uM','JLB259_6uM'};
cond_to_do={'JLB259_4uM'};
close all;

do_now=1:length(cond_to_do);
% for i=flip(do_now)
for d=1:length(days)
    for i=do_now
        a=load([in_path,'\',days{d},'\',cond_to_do{i},'.mat']);
        MY_now=a.MY;
        goodones=~isnan(MY_now(578,:));
        MY_now=MY_now(:,goodones);
        figure('Units','normalized','Position',[0,0,1,1]);
        sgtitle([days{d},' ',cond_to_do{i}]);
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
end

