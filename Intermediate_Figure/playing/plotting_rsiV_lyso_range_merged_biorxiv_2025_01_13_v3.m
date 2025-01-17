function plotting_rsiV_lyso_range_merged_biorxiv_2025_01_13_v3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%What to plotswitch_frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%close all;
plot_mean=0;
plot_mean_individual=0;
plot_mean_individual_strain=1;
plot_single_trace=0;
plot_single_trace2=0;
plot_mean_mean=0;
plot_mean_mean_zoom=0;
plot_10xV=0;
plot_all_data=0;
plot_all_single=1;%%%%%%%%%%%%%%%
plot_all_single_selected_presentation=1;
plot_all_data_part=0;
plot_hetero_cum=0;
plot_hetero_hist=0;
plot_mean_fraction=0;
plot_single_trace_15x=0;
plot_single_trace_15x_single=0;

export_data=0;

switch_frame=[101,101,102,101,101,...
    107,107,107,107,107,107,107];
adjust_switch=1;
adjust_to=101;
last_frame=221;%289
%last_frame=289;
max_cells_rep=40;
max_cells_short_gr=10;%10
plot_what='MY';
%plot_what='MR';
%plot_what='elong_rate';

kill=0;
conditions_to_skip=[4,1;1,5;2,6;1,8;3,8];

p = mfilename('fullpath');
f=strfind(p,'\');
% f_path=p(1:f(end-1));

% data_path=[p(1:f(end-1)),'Data\'];
%input strains 
data_path_main=[p(1:f(end-1))];
data_day={'2024-03-11','2024-03-19','2024-03-22','2024-04-01','2024-04-02','2024-04-23','2024-05-21','2024-05-28','2024-05-30','2024-06-03','2024-06-10','2024-06-12'};

max_repeats=21;
repeat_name={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21'};
condition={'01','05'};
condition={'01','05','1'};
%condition={'1'};
strains={'JLB130','JLB293','JLB327','JLB82'};
t_names= {'WT','5xrsiV amyE','10xrsiV +sigV','15xrsiV +sigV'};
axis_y_max=[1500,3000,4000,500,1500,2500,1000,3000,3500,600,1000,2000];

MR_thresh_on=1;
len_thresh_on=1;

cmap=distinguishable_colors(10);
repeat_line={'-','--',':','-.','-','--',':','-.','-','--',':','-.','-','--',':','-.','-','--',':','-.','-'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%all_data=cell(length(repeat_name),length(strains),length(condition));
all_data=cell(max_repeats,length(strains),length(condition));
all_data_names=cell(max_repeats,length(strains),length(condition));
num_loaded_cond=zeros(length(strains),length(condition));
if exist('all_range_data.mat');
    load("all_range_data.mat");
    load('all_range_data_names');
else
    for day_now=1:length(data_day)
        %for rep_now=1:length(repeat_name);
            for strain_now=1:length(strains);
                for cond_now=1:length(condition);
                    %D=dir([data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_',repeat_name{rep_now},'_',condition{cond_now},'*']);
                    D=dir([data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_','*','_',condition{cond_now},'*']);
                    if isempty(D);
                        continue;
                    end
                    
        
                    if ~isempty(D)
                        for repeat_do=1:length(D)
                            %disp([[data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_*']]);
                            
                            %displaying input
                            disp([data_path_main,data_day{day_now},'\Data\',D(repeat_do).name]); 
                            %Setting Repeat index
                            num_loaded_cond(strain_now,cond_now)=num_loaded_cond(strain_now,cond_now)+1;
                            rep_now=num_loaded_cond(strain_now,cond_now);
                            %Saving_name
                            %all_data_names{rep_now,strain_now,cond_now}={[data_day{day_now},': ',strrep(D(repeat_do).name(1:end-9),'_',' ')];[' S:',strains{strain_now}(4:end),' R:',num2str(rep_now),' c:',condition{cond_now}]};
                            all_data_names{rep_now,strain_now,cond_now}={[' S:',strains{strain_now}(4:end),' R:',num2str(rep_now),' c:',condition{cond_now}]};
                            if adjust_switch==0
                                all_data{rep_now,day_now,strain_now}=load([data_path_main,data_day{day_now},'\Data\',D(repeat_do).name]);
                            else
                                data_temp=load([data_path_main,data_day{day_now},'\Data\',D(repeat_do).name]);
                                MY_temp=data_temp.MY;
                                MY_temp2=nan(size(MY_temp));
                                adjust=switch_frame(day_now)-adjust_to;
                                MY_temp2(1:(289-adjust),:)=MY_temp((1+adjust):289,:);
                                data_temp.MY=MY_temp2;
                                all_data{rep_now,strain_now,cond_now}=data_temp;
                            end
                        end
                    else
                        disp([data_path_main,data_day{day_now},'\Data\',strains{strain_now}])
                    end
                end
            end
        %end
    end
end

%%%%%%%%%%%%%%%%%
% Plotting
%%%%%%%%%%%%%%%%%%

if plot_all_single_selected_presentation==1;
    strain_names={'WT','5xrsiV','10xrsiV+sigV','15xrsiV+sigV'};
    cond_name={'0.1 ug/ml','0.5 ug/ml','1.0 ug/ml'};
        %parameters
    good_traces_only=1;%plots only traces longer than cutoff
    %cut_off=40;
    cut_off=max_cells_rep;
    thresh_gr=0.3;
    num_loaded_good_now=zeros(length(strains),length(condition));
    data_do_now=cell(10,length(strains),length(condition));
    
    num_strain=1:4;
    num_cond=1:3;
    rep_now_all=[[11,11,3];[2,4,3];[6,4,4];[2,4,1]];

   
    if good_traces_only==1
        for strain_now=num_strain
            for cond_now=num_cond
                for rep_now=rep_now_all(strain_now,cond_now)
                    data_in=all_data{rep_now,strain_now,cond_now};
                    %data_now=data_in.MY;
                    data_now=data_in.(plot_what);

                    % %Checking that growth rate is good
                    % data_gr=data_in.elong_rate;
                    % mean_gr=nanmean(data_gr,2);
                    % fg=(mean_gr<thresh_gr);

                    goodones=~isnan(data_now(last_frame,:));
                    %if sum(goodones)>cut_off&&sum(fg)/sum(goodones)<max_cells_short_gr/50;
                    if sum(goodones)>cut_off
                        num_loaded_good_now(strain_now,cond_now)=num_loaded_good_now(strain_now,cond_now)+1;
                        data_do_now{num_loaded_good_now(strain_now,cond_now),strain_now,cond_now}=data_in;
                        all_data_names_now{num_loaded_good_now(strain_now,cond_now),strain_now,cond_now}=all_data_names{rep_now,strain_now,cond_now};
                    else
                        %disp('shit');
                    end
                end
            end
        end
    end

    %First checking max number of repeats
    max_done_repeats=max(num_loaded_cond(:));
    max_cond=length(strains)*length(condition);
    ind_cond=0;
    %keep_rep=0;
    goodones=0;

    if good_traces_only==1
        num_loaded_cond_now=num_loaded_good_now;
        all_data_now=data_do_now;
        max_done_repeats_here=max(num_loaded_cond_now(:));
    else
        all_data_now=all_data;
        num_loaded_cond_now=num_loaded_cond;
        max_done_repeats_here=max_done_repeats;
    end
    
    figure;
   ind=1;
   

   %Checking for outliers
   for cond_now=flip(1:length(condition))
       for strain_now=3:length(strains)
            ind_cond=ind_cond+1;
            for rep_now=1

                %Getting data
                data_in=all_data_now{rep_now,strain_now,cond_now};
                %data_now=data_in.MY;
                data_now=data_in.(plot_what);

                MY_now=data_in.MY;
                gr_now=data_in.elong_rate;
                wid_now=data_in.wid;
                MR_now=data_in.MR;
                len_now=data_in.len;
        


                %Cleaning data
                goodones=~isnan(data_now(last_frame,:));
                data_now=data_now(:,goodones);

                MY_now=MY_now(1:last_frame,goodones);
                gr_now=gr_now(1:last_frame,goodones);
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
                    data_now=data_now(:,good_MR);
                end
                
                if len_thresh_on==1;
                    all=diff(len_now); 
                    thresh_up=mean(all(:))+6*std(all(:));
                    thresh_down=mean(all(:))-6*std(all(:));
                    good_len=min(all)>thresh_down;
                    MY_now=MY_now(:,good_len);
                    len_now=len_now(:,good_len);
                    wid_now=wid_now(:,good_len);
                    MR_now=MR_now(:,good_len);
                    data_now=data_now(:,good_len);
                end

                subplot(3,2,ind);
                %axis([0 270 0 5000])
                plot(data_now-200,'LineWidth',2);
                axis([0 230 0 5000]);

                title([strain_names{strain_now},' ', cond_name{cond_now}]);

                %text(0.1,0.8,['n: ',num2str(sum(goodones))],'Unit','normalize');
                text(0.1,0.8,['n: ',num2str(size(data_now,2))],'Unit','normalize');
                
                %Setting labels
                %if mod(ind,4)==1
                    ylabel('MY');
                %end
                if ind>8
                    xlabel('Frames');
                end
                xline(101,'--r','LineWidth',2);
                ind=ind+1;
                set(gca,'Linewidth',2,'Fontweight','bold');
                %set(gca,'YtickMode','Manual');

                %save_data

                save_data=data_now(1:221,:)-200;
                save([strain_names{strain_now},'_',strrep(strrep(cond_name{cond_now},'/',''),' ','_'),'.mat'],'save_data');
                disp([strain_names{strain_now},'_',strrep(strrep(cond_name{cond_now},'/',''),' ','_'),'.mat']);


            end
        end
   end

    set(gcf,'color','w');

end

