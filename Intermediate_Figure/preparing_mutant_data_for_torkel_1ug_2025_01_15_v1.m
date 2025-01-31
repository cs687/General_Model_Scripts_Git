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
last_frame=210;%289
plot_what='MY';

len_thresh_on=1;
MR_thresh_on=1;

kill=1;
conditions_to_skip=[4,1;1,5;2,6;1,8;3,8];

p = mfilename('fullpath');
f=strfind(p,'\');
% f_path=p(1:f(end-1));


data_path_main='C:\Users\cs687\Documents\SLPC23_save\OneDrive - University Of Cambridge\General _sigma_paper\Mutant_data\';

% data_path=[p(1:f(end-1)),'Data\'];
%input strains 
%data_path_main=[p(1:f(end-1))];
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
%load data
% if exist('all_1ug_data.mat')
%     load('all_1ug_data.mat');
% else
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
% end


if plot_single_trace2==1;

    %for i=1:2
    %for i=2;
    i=2;
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    ind=-4;
    strain_done=1;
    start_pos=1;
    for strain_now=1:length(strains); 
        rep=1;
        for day_now=1:length(data_day);
            %Cheking content
            if isempty(all_data{day_now,strain_now})
                continue;
            end

            %loading data
            MY_now=all_data{day_now,strain_now}.MY-200;
            %removing cells which do not make it the end
            goodones=~isnan(MY_now(last_frame,:));
            MY_now=MY_now(1:last_frame,goodones);

            %cleaning data
            %gr_now=all_data{day_now,strain_now}.elong_rate;
            wid_now=all_data{day_now,strain_now}.wid;
            MR_now=all_data{day_now,strain_now}.MR;
            len_now=all_data{day_now,strain_now}.len;
    
           
            %gr_now=gr_now(1:last_frame,goodones);
            wid_now=wid_now(1:last_frame,goodones);
            MR_now=MR_now(1:last_frame,goodones);
            len_now=len_now(1:last_frame,goodones);
            
    
    
            if MR_thresh_on==1;
                MR_now_pre=MR_now(30:last_frame,:);
                thresh=mean(MR_now_pre(:))+3*std(MR_now_pre(:));
                good_MR=max(MR_now(30:last_frame,:))<thresh;
                MY_now=MY_now(:,good_MR);
                len_now=len_now(:,good_MR);
                wid_now=wid_now(:,good_MR);
                MR_now=MR_now(:,good_MR);
            end
            
            if len_thresh_on==1;
                all=diff(len_now); 
                thresh_up=mean(all(:))+3*std(all(:));
                thresh_down=mean(all(:))-3*std(all(:));
                good_len=min(all)>thresh_down;
                MY_now=MY_now(:,good_len);
                len_now=len_now(:,good_len);
                wid_now=wid_now(:,good_len);
                MR_now=MR_now(:,good_len);
    
            end

            %saving data
            MY=MY_now-200;
            if len_thresh_on==1||MR_thresh_on==1;
                save(['1ug\cleaned\',strains{strain_now},'_1ug_rep_',num2str(rep)],'MY');
            else
                save(['1ug\uncleaned\',strains{strain_now},'_1ug_rep_',num2str(rep)],'MY');
            end
            rep=rep+1;

            %setting up plot
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

            %plotting
            subplot(5,5,ind)
            plot(MY_now);
            
            %annotating plot
            n_s=sum(~isnan(MY_now(1,:)));
            n_l=sum(~isnan(MY_now(last_frame,:)));
            
            a=axis;
            text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
            text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
            text(a(2)*0.05,a(4)*0.4,['day: ',num2str(day_now)],'FontSize',9);
            text(a(2)*0.05,a(4)*0.2,['strain: ',num2str(strain_now)],'FontSize',9);

            %adding legend to plott
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

