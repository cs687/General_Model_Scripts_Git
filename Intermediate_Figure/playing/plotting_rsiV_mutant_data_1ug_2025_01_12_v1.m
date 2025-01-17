function plotting_rsiV_mutant_data_2024_10_29_v1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%What to plotswitch_frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
plot_mean=0;
plot_mean_individual=1;
plot_single_trace=0;
plot_single_trace2=1;
plot_mean_mean=0;
plot_mean_mean_zoom=0;
plot_10xV=0;
plot_all_data=0;
plot_all_single=0;
plot_all_data_part=0;
plot_hetero_cum=1;
plot_hetero_hist=0;
plot_mean_fraction=1;
plot_single_trace_15x=0;
plot_single_trace_15x_single=0;

plot_mean_fraction_2=1;

export_data=0;

switch_frame=[101,101,102,101,101];
adjust_switch=1;
adjust_to=101;
last_frame=250;%289
plot_what='MY';

kill=1;
conditions_to_skip=[4,1;1,5;2,6;1,8;3,8];

p = mfilename('fullpath');
f=strfind(p,'\');
% f_path=p(1:f(end-1));

% data_path=[p(1:f(end-1)),'Data\'];
%input strains 
data_path_main=[p(1:f(end-1))];
data_day={'2024-03-11','2024-03-19','2024-03-22','2024-04-03_1','2024-04-03_2'};
%strains={'JLB130','JLB212','JLB288','JLB293','JLB297','JLB325','JLB324','JLB327','JLB21','JLB82'};
strains={'JLB130','JLB212','JLB288','JLB293','JLB297','JLB325','JLB324','JLB327','JLB82'};
% t_names= {'WT','1xrsiV amyE','3xrsiV amyE','5xrsiV amyE','8xrsiV (5xrsiV amyE & 3xrsiV lacA)','10xsigV',...
%     '15xrsiV','10xrsiV +sigV','15xrsiV +sigV (2-1)','15xrsiV +sigV (8-2)'};
t_names= {'WT','1xrsiV amyE','3xrsiV amyE','5xrsiV amyE','8xrsiV (5xrsiV amyE & 3xrsiV lacA)','10xsigV',...
    '15xrsiV','10xrsiV +sigV','15xrsiV +sigV'};
cmap=distinguishable_colors(10);
repeat_line={'-','--',':','-.','-'};

%load data
for day_now=1:length(data_day);
    for strain_now=1:length(strains);
        D=dir([data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_*']);
        if isempty(D);
            continue;
        end
        if kill==1;
            if ~isempty(find(conditions_to_skip(:,1)==day_now&conditions_to_skip(:,2)==strain_now))
                continue;
            end
        end

        if ~isempty(D)
            disp([data_path_main,data_day{day_now},'\Data\',D(1).name]);
            if adjust_switch==0
                
                all_data{day_now,strain_now}=load([data_path_main,data_day{day_now},'\Data\',D(1).name]);
            else
                data_temp=load([data_path_main,data_day{day_now},'\Data\',D(1).name]);
                MY_temp=data_temp.MY;
                MY_temp2=nan(size(MY_temp));
                adjust=switch_frame(day_now)-adjust_to;
                MY_temp2(1:(289-adjust),:)=MY_temp((1+adjust):289,:);
                data_temp.MY=MY_temp2;
                all_data{day_now,strain_now}=data_temp;
            end
        else
            disp([data_path_main,data_day{day_now},'\Data\',strains{strain_now}])
        end
    end
end


% % data_main_path='C:\Users\christian.schwall\OneDrive - University Of Cambridge\General _sigma_paper\Mutant_data';
% % data_path=[data_main_path,'\2024-02-28','\Data\'];
% data_path=[data_path_main,data_day{1},'\Data\'];
% D=dir([data_path,'JLB*']);
% D=D([1,2,4:9,3,10]);
% c={'r','g','b','m','k','r--','g--','b--','m--','k--'};


% %close all;
% 
% %GEtting title names
% t_name={D.name};
% t_name2=cellfun(@(a) strrep(a,'_',' '),t_name,'UniformOutput',false);
% t_name3=cellfun(@(a) a(1:end-4),t_name2,'UniformOutput',false);
% 
% for i=1:length(t_name3)
%     t_now=t_name3{i};
%     if contains(t_now,'JLB130')
%         t_name3{i}=strrep(t_now,'JLB130','WT');
%     elseif contains(t_now,'JLB212')
%         t_name3{i}=strrep(t_now,'JLB212','1xrsiV amyE');
%     elseif contains(t_now,'JLB288')
%         t_name3{i}=strrep(t_now,'JLB288','3xrsiV amyE');
%     elseif contains(t_now,'JLB293')
%         t_name3{i}=strrep(t_now,'JLB293','5xrsiV amyE');
%     elseif contains(t_now,'JLB296')
%         t_name3{i}=strrep(t_now,'JLB296','5xrsiV lacA');
%     elseif contains(t_now,'JLB297')
%         t_name3{i}=strrep(t_now,'JLB297','8x (5xrsiV amyE & 3xrsiV lacA)'); 
%     elseif contains(t_now,'JLB324')
%         t_name3{i}=strrep(t_now,'JLB324','10xsigV'); 
%     elseif contains(t_now,'JLB325')
%         t_name3{i}=strrep(t_now,'JLB325','15xsigV'); 
%     elseif contains(t_now,'JLB327')
%         t_name3{i}=strrep(t_now,'JLB327','10xsigV +sigV'); 
%     elseif contains(t_now,'JLB21_')
%         t_name3{i}=strrep(t_now,'JLB21','15xrsiv +sigV1 (2-1)');
%     elseif contains(t_now,'JLB82')
%         t_name3{i}=strrep(t_now,'JLB82','15xrsiv +sigV2 (8-2)');
% 
%     end
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Mean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_mean==1;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    % do_now=[1,7:10]
    %do_now=[1,7,8];
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            hold on;
            if isempty(all_data{day_now,strain_now})
                continue;
            end
            plot(nanmean(all_data{day_now,strain_now}.MY,2),'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
        end;
    end

    
    box on;
    set(gca,'Linewidth',2,'FontWeight','bold')
%     legend(t_name3(do_now));
    legend(t_names);
    xlabel('frames');
    ylabel('MY');
    title('Mean Fluorescence');
    box on;
    %saveas(gcf,[data_path_main,'\Figures\mean_all.png']);
    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_all2.png'],'Resolution',1200);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting mean by condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_mean_individual==1;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    % do_now=[1,7:10]
    %do_now=[1,7,8];
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            subplot(5,2,strain_now);
            if day_now==1
                title(t_names{strain_now});
                xlabel('Frames');
                ylabel(plot_what);
                box on;
                if strcmp(plot_what,'MY');
                    axis([0,250,0,2500]);%MY;
                elseif strcmp(plot_what,'MR');
                    axis([0,250,0,1000]);
                elseif strcmp(plot_what,'elong_rate')
                    axis([0,250,0.2,1]);%Elong
                end
                
            end
            hold on;
            if isempty(all_data{day_now,strain_now})
                continue;
            end
            %plot(nanmean(all_data{day_now,strain_now}.MY,2),'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
            %plot(nanmean(all_data{day_now,strain_now}.elong_rate,2),'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
            plot(nanmean(all_data{day_now,strain_now}.(plot_what),2),'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
            %if day_now==length(data_day)

        end
    end
    sgtitle(strrep(plot_what,'_',' '));
    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_individual.png'],'Resolution',1200);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting mean by day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_mean_mean==1;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    % do_now=[1,7:10]
    %do_now=[1,7,8];
    m=nan(length(data_day),last_frame,length(strains));
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            %subplot(5,2,strain_now)
            hold on;
            m(day_now,:,strain_now)=nanmean(all_data{day_now,strain_now}.MY(1:last_frame,:),2);
        end
    end

    %Plotting
    for strain_now=1:length(strains);
        hold on;
        shadedErrorBar(1:last_frame,mean(m(:,:,strain_now),1,'omitnan'),std(m(:,:,strain_now),1,'omitnan'),{'markerfacecolor',cmap(strain_now,:)},1);
        %shadedErrorBar(1:last_frame,mean(m(:,:,strain_now),1,'omitnan'),std(m(:,:,strain_now),1,'omitnan'));
    end
    box on;
    set(gca,'Linewidth',2,'FontWeight','bold')
%     legend(t_name3(do_now));
%     legend(t_names);
    xlabel('frames');
    ylabel('MY');
    title('Mean Fluorescence');
    h=get(gca,'children');
    legend(flip([h(1:4:end)]),t_names,'location','northwest');
    sgtitle('Mean by day');
    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_mean.png'],'Resolution',1200);
    end
end

%%%%%%%%%%%%%%%%5
% Mean by day zoom
%%%%%%%%%%%%%%%%%%%
if plot_mean_mean_zoom==1;
       
    figure('units','normalized','outerposition',[0 0 1 1]);
    % do_now=[1,7:10]
    %do_now=[1,7,8];
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            subplot(5,2,strain_now)
            hold on;
            plot(nanmean(all_data{day_now,strain_now}.MY-200,2),'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
            
            if day_now==length(data_day)
                title(t_names{strain_now});
                xlabel('frames');
                ylabel('MY');
                box on;
                axis([90 110 0 200]);
            end
        end
    end
    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_individual_zoom.png'],'Resolution',1200);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Checking 10x rsiV psigV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_10xV==1;
       
    figure('units','normalized','outerposition',[0 0 1 1]);
        for day_now=1:length(data_day);
            for strain_now=8
                MY_now=all_data{day_now,strain_now}.MY;

                goodones=~isnan(MY_now(last_frame,:));
                MY_now=MY_now(1:last_frame,goodones);

                subplot(3,1,day_now)
                plot(MY_now);
                axis([0,250,0,5000])

                ylabel('MY');
                xlabel('Frames');
                if day_now==1
                    sgtitle(t_names{strain_now});
                end
                title(data_day{day_now});
   
    
            end
        end
        if export_data==1
            exportgraphics(gcf,[data_path_main,'\Figures\10xV.png'],'Resolution',1200);
        end

        %Plotting histogram in last frame
        figure('units','normalized','outerposition',[0 0 1 1]);
        for day_now=1:length(data_day);
            for strain_now=8
                MY_now=all_data{day_now,strain_now}.MY;

                goodones=~isnan(MY_now(last_frame,:));
                MY_now=MY_now(last_frame,goodones);

                subplot(3,1,day_now)
                histogram(MY_now,[0:100:3000],'Normalization','probability');

                axis([0,3000,0,0.6])

                ylabel('MY');
                xlabel('Frames');
                if day_now==1
                    sgtitle(t_names{strain_now});
                end
                title(data_day{day_now});
    
            end
        end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting single trace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_single_trace==1;
    zoom_in=0;
    
    for i=1:2
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        ind=1;
        for day_now=1:length(data_day);
            for strain_now=1:length(strains);
                if isempty(all_data{day_now,strain_now})
                    continue;
                end
                MY_now=all_data{day_now,strain_now}.MY;
                if i>1
                    goodones=~isnan(MY_now(last_frame,:));
                    MY_now=MY_now(1:last_frame,goodones);
                end
                subplot(6,5,ind)
                plot(MY_now);
                if zoom_in==0
                    axis([0,290,0,5000]);
                elseif zoom_in==1;
                    axis([90,110,0,1000]);
                end
                n_s=sum(~isnan(MY_now(1,:)));
                n_l=sum(~isnan(MY_now(last_frame,:)));
                
                a=axis;
                text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
                text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
                if i==1
                    n_e=sum(~isnan(MY_now(289,:)));
                    text(a(2)*0.05,a(4)*0.4,['#end: ',num2str(n_e)],'FontSize',9);
                end
                
                if mod(ind,5)==1;
                    ylabel([data_day{day_now},' MY']);
                end
                if ind>25
                    xlabel('Frames');
                end
                if ind<6
                    title(t_names{strain_now});
                elseif ind>15&&ind<21
                    title(t_names{strain_now});
                end
    
                if strain_now==5
                    ind=ind+11;
                elseif strain_now==10
                    ind=ind-14;
                else
                    ind=ind+1;
                end
    
    
    %             if day_now==length(data_day)
    %                 title(t_names{strain_now});
    %                 xlabel('frames');
    %                 ylabel('MY');
    %                 box on;
    %                 axis([0,250,0,2500])
    %             end
            end
        end
        if export_data==1&&i==1
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_all.png'],'Resolution',1200);
        elseif export_data==1&&i==2
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_goodones.png'],'Resolution',1200);
        end
        if i==1
            sgtitle('All Data');
        else
            sgtitle(['Data survive ', num2str(last_frame)]);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting single trace more data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_single_trace2==1;
    zoom_in=0;
    
    for i=1:2
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        ind=-4;
        strain_done=1;
        start_pos=1;
        for strain_now=1:length(strains);
            for day_now=1:length(data_day);

                if strain_now==6&&day_now==1
                    figure; 
                    ind=1;
                    start_pos=1;
                    strain_done=strain_done+1;
                elseif strain_now>strain_done
                    ind=start_pos+1;
                    strain_done=strain_done+1;
                    start_pos=start_pos+1;
                else
                    ind=ind+5;
                end

                if isempty(all_data{day_now,strain_now})
                    continue;
                end
                MY_now=all_data{day_now,strain_now}.MY;
                if i>1
                    goodones=~isnan(MY_now(last_frame,:));
                    MY_now=MY_now(1:last_frame,goodones);
                end
                subplot(5,5,ind)
                plot(MY_now);
                if zoom_in==0
                    axis([0,290,0,5000]);
                elseif zoom_in==1;
                    axis([90,110,0,1000]);
                end
                n_s=sum(~isnan(MY_now(1,:)));
                n_l=sum(~isnan(MY_now(last_frame,:)));
                
                a=axis;
                text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
                text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
                text(a(2)*0.05,a(4)*0.4,['day: ',num2str(day_now)],'FontSize',9);
                text(a(2)*0.05,a(4)*0.2,['strain: ',num2str(strain_now)],'FontSize',9);
                if i==1
                    n_e=sum(~isnan(MY_now(289,:)));
                    text(a(2)*0.05,a(4)*0.4,['#end: ',num2str(n_e)],'FontSize',9);
                end
                
                if mod(ind,5)==1;
                    ylabel([data_day{day_now},' MY']);
                end
                if ind>25
                    xlabel('Frames');
                end
                if ind<6
                    title(t_names{strain_now});
                elseif ind>15&&ind<21
                    title(t_names{strain_now});
                end
    

    
    
    %             if day_now==length(data_day)
    %                 title(t_names{strain_now});
    %                 xlabel('frames');
    %                 ylabel('MY');
    %                 box on;
    %                 axis([0,250,0,2500])
    %             end
            end
        end
        if export_data==1&&i==1
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_all.png'],'Resolution',1200);
        elseif export_data==1&&i==2
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_goodones.png'],'Resolution',1200);
        end
        if i==1
            sgtitle('All Data');
        else
            sgtitle(['Data survive ', num2str(last_frame)]);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_all_data==1;

    figure; 
    for i=1:length(D); 
        a=load([data_path,D(i).name]);
        hold on; 
        subplot(5,2,i)
        data_all=a.MY-200;
        goodones=~isnan(data_all(289,:));
        plot(data_all(:,goodones));
    
        xlabel('frames');
        ylabel('MY');
        title(t_name3{i});
        axis([0,300,0,5000]);
        xline(103);
        %plotting off
        data_all=a.MY-200;
        data_part=data_all(1:switch_frame,:);
        m=nanmean(data_part(:));
        s=nanmean(data_part(:));
        thresh=m+3*s;
        yline(thresh);
    
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single Cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_all_single==1;
    for i=1:length(D); 
        figure; 
        a=load([data_path,D(i).name]);
        data_all=a.MY-200;
        goodones=~isnan(data_all(289,:));
        data_all_1=data_all(:,goodones);
    
        if size(data_all_1,2)>64
            do_trace_now=64;
        else
            do_trace_now=size(data_all_1,2);
        end
    
        for k=1:do_trace_now;
            subplot(8,8,k);
            plot(data_all_1(:,k));
            
            if mod(i,8)==1
                ylabel('MY');
            end
            if i>56
                xlabel('frames');
            end
            xline(103,'r');
        end
    
        sgtitle(t_name3{i});
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All data WT and 8x only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_all_data_part==1;
    
    figure; 
    ind=1;
    for i=[1,10]
        a=load([data_path,D(i).name]);
        hold on; 
        subplot(1,2,ind)
        ind=ind+1;
        data_all=a.MY-200;
        goodones=~isnan(data_all(289,:));
        plot(data_all(:,goodones));
    
        xlabel('frames');
        ylabel('MY');
        title(t_name3{i});
        axis([0,300,0,1000]);
        xline(103);
        %plotting off
        data_all=a.MY-200;
        data_part=data_all(1:switch_frame,:);
        m=nanmean(data_part(:));
        s=nanmean(data_part(:));
        thresh=m+3*s;
        %yline(thresh);
    
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Turn on dynamics cummulative plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_hetero_cum==1;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            subplot(5,2,strain_now);
            if day_now==1
                title(t_names{strain_now});
                xlabel('frames');
                ylabel('Fraction');
                box on;
                axis([0,150,0,1])
            end
            if isempty(all_data{day_now,strain_now});
                continue;
            end
            data_all=all_data{day_now,strain_now}.MY-200;
            data_part=data_all(1:switch_frame(day_now),:);
            if strain_now==1
                m=nanmean(data_part(:));
                s=nanmean(data_part(:));
                thresh=m+3*s;
            end
            
            data_part_on=data_all(switch_frame(day_now):last_frame,:);
            goodones=~isnan(data_part_on(end,:));
            data_part_on2=data_part_on(:,goodones);
            on_temp=sum(data_part_on2>thresh,2)/sum(goodones);


            hold on;
            plot(on_temp,'color',cmap(strain_now,:),'LineStyle', repeat_line{day_now});
%             if day_now==1
%                 title(t_names{strain_now});
%                 xlabel('frames');
%                 ylabel('Fraction');
%                 box on;
%                 axis([0,150,0,1])
%             end
             sgtitle('Cumulative Activation');
        end
    end
    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_individual.png'],'Resolution',1200);
    end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%turn histogram  activation times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_hetero_hist==1;
    
    figure; 
    %do_now=[1,7:10];
    for i=1:length(D); 
    %for i=do_now
    
        a=load([data_path,D(i).name]);
        %plotting off
        data_all=a.MY-200;
        data_part=data_all(1:switch_frame,:);
        m=nanmean(data_part(:));
        s=nanmean(data_part(:));
        thresh=m+3*s;
    
        data_part_on=data_all(switch_frame:last_frame,:);
        goodones=~isnan(data_part_on(end,:));
        data_part_on2=data_part_on(:,goodones);
        data_temp=data_part_on2>thresh;
        
        on=ones(size(data_temp,2),1)*last_frame;
        for j=1:size(data_temp,2)
            data_min=min(find(data_temp(:,j)));
            if ~isempty(data_min)
                on(j)=min(find(data_temp(:,j)));
            end
        end
        %on_temp=sum(data_part_on2>thresh,2)/sum(goodones);
        subplot(5,2,i);
        histogram(on,[0:10:300],'normalization','probability');
    %     plot(on_temp,c{i},'Linewidth',2);
        set(gca,'Linewidth',2,'FontWeight','bold');
        xlabel('Frames after Switch');
        ylabel('Fraction on');
        a=axis;
        axis([0,a(2),0,0.8])
        title(t_name3{i});
        box on;
    
    end
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting mean activity and fraction of activation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_mean_fraction==1;
    thresh_std_time=3;
    %Calculating threshhold
    thresh_all=nan(1,length(strains));
    for strain_now=1:length(strains)
    % for strain_now=1
        ind=1;
        thresh_temp=nan(1,length(data_day));
        for day_now=1:length(data_day);
            if isempty(all_data{day_now,strain_now});
                continue;
            end

            data_all=all_data{day_now,strain_now}.MY-200;
            data_part=data_all(1:switch_frame(day_now),:);

            m=nanmean(data_part(:));
            s=nanmean(data_part(:));
            thresh_temp(ind)=m+thresh_std_time*s;
            ind=ind+1;
        end
        thresh_all(strain_now)=nanmean(thresh_temp);
    end
    m_data=nan(length(data_day),length(strains));
    n1=nan(length(data_day),length(strains));
    %s_data=nan(length(data_day),length(strains));
    %thresh=mean(thresh)
    %thresh=mean(thresh_temp);
    
    figure('units','normalized','outerposition',[0 0 1 1],'Color','w');
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            %subplot(5,2,strain_now)
            if isempty(all_data{day_now,strain_now});
                continue;
            end

            data_all=all_data{day_now,strain_now}.MY-200;
            data_part=data_all(1:switch_frame(day_now),:);
%             if strain_now==1
%                 m=nanmean(data_part(:));
%                 s=nanmean(data_part(:));
%                 thresh=m+3*s;
%             end
            
            data_part_on=data_all(switch_frame(day_now):last_frame,:);
            goodones=~isnan(data_part_on(end,:));
            data_part_on2=data_part_on(:,goodones);

            data_temp=data_part_on2>thresh_all(strain_now);
            
            on=ones(size(data_temp,2),1)*last_frame;
            for j=1:size(data_temp,2)
                data_min=min(find(data_temp(:,j)));
                if ~isempty(data_min)
                    on(j)=min(find(data_temp(:,j)));
                end
            end
            n=histcounts(on,[0:10:300],'normalization','probability');
            n1(day_now,strain_now)=n(1);

            data_temp=data_all(last_frame-50:last_frame,:);
            m_data(day_now,strain_now)=nanmean(data_temp(:));


        end
    end

    plot_now=[1:7];
    plot_now=[1:10];
    plot_now=[1:length(m_data)];
    %plot_now=[1:length(m_data)-1];
    %plot_now=[1,7,8,10];
    %Plotting steady state
    subplot(2,1,1);
    data_x=[0,1,3,5,8,10,15,16,17,18];

    %correcting for outliers
    %10x second repeat
    %m_data(2,6)=nan;

    m_data_plot=mean(m_data,1,'omitnan');
    s_data_plot=std(m_data,'omitnan');
    n_plot=sum(~isnan(m_data));
    errorbar([0:8],m_data_plot(plot_now)/m_data_plot(1),s_data_plot(plot_now)/[m_data_plot(1)],'-x','Linewidth',4);
    a=axis;
    %axis([0,15,0,3000]);
    if length(plot_now)==7
        axis([0,15,0,1.2]);
        set(gca,'XTick',[0:1:15]);
    elseif length(plot_now)==9
        axis([0,8,0,1.2]);
        set(gca,'XTick',[0:8]);
        %labelx=get(gca,'XTicklabel');
        labelx={'WT','1x','3x','5x','8x','10x','15x','10x+V','15x+V'};
        set(gca,'XTickLabel',labelx)
    end

    
    grid on;
    title('Steady State Expression');
    xlabel('Copies rsiV');
    ylabel('MY(au)');
    set(gca,'Linewidth',3,'FontWeight','bold','FontSize',20);
    set(gcf,'color','w');
    
    %Plotting Fraction
    subplot(2,1,2);

    %correcting for outliers
    %10x second repeat
    %n1(2,6)=nan;

    n1_m_plot=mean(n1,1,'omitnan');
    n1_s_plot=std(n1,1,'omitnan');

    errorbar([0:8],n1_m_plot(plot_now),n1_s_plot(plot_now),'-x','Linewidth',3);
    a=axis;
   if length(plot_now)==7
        axis([0,15,0,1.2]);
        set(gca,'XTick',[0:1:15]);
    elseif length(plot_now)==9
        axis([0,8,0,1.2]);
        set(gca,'XTick',[0:8]);
        %labelx=get(gca,'XTicklabel');
        labelx={'WT','1x','3x','5x','8x','10x','15x','10x+V','15x+V'};
        set(gca,'XTickLabel',labelx)
   end
    grid on;
    title('Fraction larger than m+3*s before stress');
    xlabel('Copies rsiV');
    ylabel('MY(au)');
    set(gca,'Linewidth',3,'FontWeight','bold','FontSize',20);


    if export_data==1
        exportgraphics(gcf,[data_path_main,'\Figures\mean_individual.png'],'Resolution',1200);
    end


    %Plotting MY vs fraction
    figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8]);
    plot(n1_m_plot(plot_now),m_data_plot(plot_now)/m_data_plot(1),'x');
    names_scatter=cellfun(@(a) ['\leftarrow' a],t_names,'UniformOutput',false);
    text(n1_m_plot(plot_now),m_data_plot(plot_now)/m_data_plot(1),names_scatter);
    xlabel('Fraction [au]')
    ylabel('MY [au]');
    title('MY last frame vs fraction activation');

    %Plotting only rsiV mutants
    figure('units','normalized','outerposition',[0.05 0.05 0.9 0.9],'Color','w');
    % x=n1_m_plot(plot_now(1:end-2));
    % y=m_data_plot(plot_now(1:end-2))/m_data_plot(1);

    y=n1_m_plot(plot_now(1:end-2));
    x=m_data_plot(plot_now(1:end-2))/m_data_plot(1);
    
    plot(x,y,'x','Linewidth',3,'MarkerSize',20);
    names_scatter=cellfun(@(a) ['\leftarrow' a],t_names,'UniformOutput',false);
    text(x,y,names_scatter(1:end-2),'Fontsize',16);


    % plot(n1_m_plot(plot_now(1:end-2)),m_data_plot(plot_now(1:end-2))/m_data_plot(1),'x','Linewidth',3,'MarkerSize',20);
    % names_scatter=cellfun(@(a) ['\leftarrow' a],t_names,'UniformOutput',false);
    % text(n1_m_plot(plot_now(1:end-2)),m_data_plot(plot_now(1:end-2))/m_data_plot(1),names_scatter(1:end-2),'Fontsize',16);
    %fitting
    linearCoefficients = polyfit(x, y, 1);          % Coefficients
    yfit = polyval(linearCoefficients, x);          % Estimated  Regression Line
    SStot = sum((y-mean(y)).^2);                    % Total Sum-Of-Squares
    SSres = sum((y-yfit).^2);                       % Residual Sum-Of-Squares
    Rsq = 1-SSres/SStot;                            % R^2
    hold on;
    plot(x,yfit,'-r','LineWidth',3);
    set(gca,'Linewidth',3,'FontSize',20,'Fontweight','bold');
    axis([0,1,0,1]);
    a=axis;
    text(a(2)*0.1,a(4)*0.8,['R^2: ',num2str(round(Rsq,2))],'Fontsize',20);


    %plotting Rest
    hold on;
    x2=n1_m_plot(plot_now(end-1:end));
    y2=m_data_plot(plot_now(end-1:end))/m_data_plot(1);

    y2=n1_m_plot(plot_now(end-1:end));
    x2=m_data_plot(plot_now(end-1:end))/m_data_plot(1);

    plot(x2,y2,'x','Linewidth',3,'MarkerSize',20);
    names_scatter=cellfun(@(a) ['\leftarrow' a],t_names,'UniformOutput',false);
    text(x2,y2,names_scatter(end-1:end),'Fontsize',16);
    
    % plot(n1_m_plot(plot_now(end-1:end)),m_data_plot(plot_now(end-1:end))/m_data_plot(1),'x','Linewidth',3,'MarkerSize',20);
    % names_scatter=cellfun(@(a) ['\leftarrow' a],t_names,'UniformOutput',false);
    % text(n1_m_plot(plot_now(end-1:end)),m_data_plot(plot_now(end-1:end))/m_data_plot(1),names_scatter(end-1:end),'Fontsize',16);

    %making figure pretty
    % xlabel('Fraction [au]')
    % ylabel('MY [au]');
    ylabel('Fraction [au]')
    xlabel('MY [au]');
    title(['MY last frame vs fraction activation (mean expression before stress + ',num2str(thresh_std_time),'*std)'],'FontSize',25);
   
    %plotting singel cell selection:
    figure('units','normalized','outerposition',[0.05 0.05 0.9 0.3],'Color','w');
    do_now=[3,1,2,4,4,3,3];
    strain_now=[1,2,3,4,5,6,7];
    t_name={'WT','1xrsiV','3xrsiV','5xrsiV','8xrsiV','10xrsiV','15xrsiV'};
    ind=1;
    for i=strain_now
        subplot(1,7,ind);
        plot(all_data{do_now(i),i}.MY);
        axis([0,230,0,5000]);
        xlabel('Frames');
        if ind==1
            ylabel('MY');
        end
        
        box on;
        title(t_name{ind})
        set(gca,'Linewidth',2,'FontWeight','bold','FontSize',12);
        ind=ind+1;
    end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting mean activity and fraction of activation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_mean_fraction_2==1;
    ind=1;
    %Calculating threshhold
    for day_now=1:length(data_day);
        for strain_now=1
            if isempty(all_data{day_now,strain_now});
                continue;
            end

            data_all=all_data{day_now,strain_now}.MY-200;
            data_part=data_all(1:switch_frame(day_now),:);

            m=nanmean(data_part(:));
            s=nanmean(data_part(:));
            thresh_temp(ind)=m+3*s;
            ind=ind+1;
        end
    end
    m_data=nan(length(data_day),length(strains));
    n1=nan(length(data_day),length(strains));
    %s_data=nan(length(data_day),length(strains));
    thresh=mean(thresh);
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    for day_now=1:length(data_day);
        for strain_now=1:length(strains);
            %subplot(5,2,strain_now)
            if isempty(all_data{day_now,strain_now});
                continue;
            end

            data_all=all_data{day_now,strain_now}.MY-200;
            data_part=data_all(1:switch_frame(day_now),:);
%             if strain_now==1
%                 m=nanmean(data_part(:));
%                 s=nanmean(data_part(:));
%                 thresh=m+3*s;
%             end
            
            data_part_on=data_all(switch_frame(day_now):last_frame,:);
            goodones=~isnan(data_part_on(end,:));
            data_part_on2=data_part_on(:,goodones);

            data_temp=data_part_on2>thresh;
            
            on=ones(size(data_temp,2),1)*last_frame;
            for j=1:size(data_temp,2)
                data_min=min(find(data_temp(:,j)));
                if ~isempty(data_min)
                    on(j)=min(find(data_temp(:,j)));
                end
            end
            n=histcounts(on,[0:10:300],'normalization','probability');
            n1(day_now,strain_now)=n(1);

            data_temp=data_all(last_frame-50:last_frame,:);
            m_data(day_now,strain_now)=nanmean(data_temp(:));


        end
    end

    plot_now=[1:7];
    plot_now=[1:10];
    plot_now=[1:length(m_data)];
    %plot_now=[1,7,8,10];
    %Plotting steady state
    %subplot(2,1,1);
    data_x=[0,1,3,5,8,10,15,16,17,18];

    %correcting for outliers
    %10x second repeat
    %m_data(2,6)=nan;


    m_data_plot=mean(m_data,1,'omitnan');
    s_data_plot=std(m_data,'omitnan');
    n_plot=sum(~isnan(m_data));
    errorbar([0:8],m_data_plot(plot_now)/m_data_plot(1),s_data_plot(plot_now)/[m_data_plot(1)],'-x','Linewidth',4);
    a=axis;
    %axis([0,15,0,3000]);
    if length(plot_now)==7
        axis([0,15,0,1.2]);
        set(gca,'XTick',[0:1:15]);
    elseif length(plot_now)==9
        axis([0,8,0,1.2]);
        set(gca,'XTick',[0:8]);
        %labelx=get(gca,'XTicklabel');
        labelx={'WT','1x','3x','5x','8x','10x','15x','10x+V','15x+V'};
        set(gca,'XTickLabel',labelx)
    end


    grid on;
    title('Steady State Expression');
    xlabel('Copies rsiV');
    ylabel('MY(au)');
    set(gca,'Linewidth',2,'FontWeight','bold','FontSize',20);
    set(gcf,'color','w')
    
   

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting 15x rsiV sigV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_single_trace_15x==1;
    zoom_in=1;
    
    %CV=nan(3,2);

    for i=1
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        ind=1;
        for day_now=1:length(data_day);
            for strain_now=9:10
                MY_now=all_data{day_now,strain_now}.MY;
                if i>1
                    goodones=~isnan(MY_now(last_frame,:));
                    MY_now=MY_now(1:last_frame,goodones);
                end
                subplot(3,2,ind)
                plot(MY_now-200);

                if zoom_in==0
                    axis([0,290,0,5000]);
                elseif zoom_in==1;
                    axis([90,150,0,100]);
                end
                n_s=sum(~isnan(MY_now(1,:)));
                n_l=sum(~isnan(MY_now(last_frame,:)));
                

                    xline(101);

                
%                 a=axis;
%                 text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
%                 text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
%                 if i==1
%                     n_e=sum(~isnan(MY_now(289,:)));
%                     text(a(2)*0.05,a(4)*0.4,['#end: ',num2str(n_e)],'FontSize',9);
%                 end
                

                    ylabel([data_day{day_now},' MY']);


                    xlabel('Frames');

                if ind<3
                    title(t_names{strain_now});
                end
                ind=ind+1;
    
    
    
    %             if day_now==length(data_day)
    %                 title(t_names{strain_now});
    %                 xlabel('frames');
    %                 ylabel('MY');
    %                 box on;
    %                 axis([0,250,0,2500])
    %             end
            end
        end
        if export_data==1&&i==1
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_all.png'],'Resolution',1200);
        elseif export_data==1&&i==2
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_goodones.png'],'Resolution',1200);
        end

%        figure; 
%         if i==1
%             sgtitle('All Data');
%         else
%             sgtitle(['Data survive ', num2str(last_frame)]);
%         end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting 15x rsiV sigV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_single_trace_15x_single==1;
    
    
    %CV=nan(3,2);

    for i=1
        ind=1;
        for day_now=1:length(data_day);
            for strain_now=[1,9:10];
                figure('units','normalized','outerposition',[0 0 1 1]);
                ind=1;
                MY_now=all_data{day_now,strain_now}.MY;

                    goodones=~isnan(MY_now(last_frame,:));
                    MY_now=MY_now(1:289,goodones);
                end
                subplot(8,8,ind)
                for cell=1:64
                    subplot(8,8,cell)
                    plot(MY_now(101:289,cell)-200);
                    if mod(ind,8)==1;
                        ylabel(['MY']);
                    end
                    if ind>56
                        xlabel('Frames');
                    end
                end

                sgtitle([data_day{day_now},' ', strains{strain_now}]);

                
%                 a=axis;
%                 text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
%                 text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
%                 if i==1
%                     n_e=sum(~isnan(MY_now(289,:)));
%                     text(a(2)*0.05,a(4)*0.4,['#end: ',num2str(n_e)],'FontSize',9);
%                 end
                

                    ylabel([data_day{day_now},' MY']);


                    xlabel('Frames');

                if ind<3
                    title(t_names{strain_now});
                end
                ind=ind+1;
    
    
    
    %             if day_now==length(data_day)
    %                 title(t_names{strain_now});
    %                 xlabel('frames');
    %                 ylabel('MY');
    %                 box on;
    %                 axis([0,250,0,2500])
    %             end
            end
        end
        if export_data==1&&i==1
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_all.png'],'Resolution',1200);
        elseif export_data==1&&i==2
            exportgraphics(gcf,[data_path_main,'\Figures\all_single_cell_goodones.png'],'Resolution',1200);
        end

%         figure; 
%         if i==1
%             sgtitle('All Data');
%         else
%             sgtitle(['Data survive ', num2str(last_frame)]);
%         end
    end
end
