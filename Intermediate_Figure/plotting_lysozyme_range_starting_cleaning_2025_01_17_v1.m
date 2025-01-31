function plotting_lysozyme_range_starting_cleaning_2025_01_17_v1(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function cleans the experimantal data by removing sick cells and
% tracking errors. 
%
% Sick cells:
% Sick cells are identidied by RFP brightness. These cells
% have an maximal RFP value in their trace great than the mean RFP (of all time points and cells)+ 3 time the standard
% deviviation of the mean RFP (of all time points and cells). 
%
% Tracking errors:
% Tracking errors are identified by non smooth MY traces. I take the first derivative of the MY trace. 
% Tracking errors are charcaterized by large spikes in the derivative trace. Thus I thresh hold the MY first order 
% derivate with the mean of all time points and cells of this condition and day plus six time its standard deivation.
% Two thresh holds are calculated. One before the switch and one after. 
%
% Input:
% it works with no input and plots by default the reloaded data to check if
% saving worked alright
% other wise the input is 'do_plot', 0 e.g.
% preparing_mutant_data_1ug_use_2025_01_16_v2('do_plot', 0) this does not
% plot the reloaded data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Options
plot_reload=1;
good_traces_only=1;
MY_smooth_tresh_on=1;
MR_thresh_on=1;
adjust_switch=1;

%fixed parameters
last_frame=221;
max_cells_rep=40;
max_repeats=210;
kill_repeat=[3,1,5]

%Switching data input
switch_frame=[101,101,102,101,101,...
    107,107,107,107,107,107,107];
adjust_to=101;

%Data path output
p = mfilename('fullpath');
f=strfind(p,'\');
path_for_saving=[p(1:f(end))];

%Data path input
data_path_main='C:\Users\cs687\Documents\SLPC23_save\OneDrive - University Of Cambridge\General _sigma_paper\Lyso_range\';

%Information on the Data
data_day={'2024-03-11','2024-03-19','2024-03-22','2024-04-01','2024-04-02','2024-04-23','2024-05-21','2024-05-28','2024-05-30','2024-06-03','2024-06-10','2024-06-12'};
condition={'01','05','1'};
strains={'JLB130','JLB293','JLB327','JLB82'};
t_names= {'WT','5xrsiV','10xrsiV +sigV','15xrsiV +sigV'};
axis_y_max=[1500,3000,4000,500,1500,2500,1000,3000,3500,600,1000,2000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining Variables
all_data=cell(max_repeats,length(strains),length(condition));
all_data_names=cell(max_repeats,length(strains),length(condition));
num_loaded_cond=zeros(length(strains),length(condition));
ind_kill=0;

%Looping over Data
for day_now=1:length(data_day) %Day
        for strain_now=1:length(strains) %Strains
            for cond_now=1:length(condition) %Condtions ( 0.1, 0.5, 1 ug/ml Lysozyme)
                %Checking if data exists
                D=dir([data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_','*','_',condition{cond_now},'*']);
                if isempty(D);
                    continue;
                end
                
                if ~isempty(D)
                    for repeat_do=1:length(D)
                        disp([data_path_main,data_day{day_now},'\Data\',D(repeat_do).name]); 

                        %Setting Repeat index
                        
                        if sum([strain_now,cond_now,num_loaded_cond(strain_now,cond_now)+1;]==[3,1,5])==3&&ind_kill==0
                            ind_kill=1;
                            continue;
                        end
                        num_loaded_cond(strain_now,cond_now)=num_loaded_cond(strain_now,cond_now)+1;
                        rep_now=num_loaded_cond(strain_now,cond_now);

                        %Saving Name
                        %all_data_names{rep_now,strain_now,cond_now}={[' S:',strains{strain_now}(4:end),' R:',num2str(rep_now),' c:',condition{cond_now}]};
                        all_data_names{rep_now,strain_now,cond_now}={[' S:',t_names{strain_now},' R:',num2str(rep_now),' c:',condition{cond_now}]};

                        %Adjust for different start times.
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
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%setting variables.
cut_off=max_cells_rep;
num_loaded_good_now=zeros(length(strains),length(condition));
data_do_now=cell(10,length(strains),length(condition));
figure('units','normalized','outerposition',[0 0 1 1]); 

%Filtering out bad experiments (Experiments with less than 40 cells in
%the the last frame.
if good_traces_only==1
    for strain_now=1:length(strains)
        for cond_now=1:length(condition)
            for rep_now=1:num_loaded_cond(strain_now,cond_now);
                %getting current repeat
                data_in=all_data{rep_now,strain_now,cond_now};
                data_now=data_in.MY;
                
                %good cells are cells which make it to the last frame
                goodones=~isnan(data_now(last_frame,:));

                %Checking if there are more cells than the cut off in
                %the last frame
                if sum(goodones)>cut_off
                    %updating number of good repeats
                    num_loaded_good_now(strain_now,cond_now)=num_loaded_good_now(strain_now,cond_now)+1;
                    %saving data into new cell
                    data_do_now{num_loaded_good_now(strain_now,cond_now),strain_now,cond_now}=data_in;
                    %Updating names into new cell
                    all_data_names_now{num_loaded_good_now(strain_now,cond_now),strain_now,cond_now}=all_data_names{rep_now,strain_now,cond_now};
                else
                    %disp('shit');
                end
            end
        end
    end
else
    %In case we are not correcting for bad repeats just copy the names
    all_data_names_now=all_data_names;
end

%First checking max number of repeats to set the subplot matrix to the
%correct size
max_done_repeats=max(num_loaded_cond(:));
max_cond=length(strains)*length(condition);

ind_cond=0;
goodones=0;

%Correcting Variables depending on whether we are correcting for bad
%repeats or not
if good_traces_only==1
    all_data_now=data_do_now;
    num_loaded_cond_now=num_loaded_good_now;
    max_done_repeats_here=max(num_loaded_cond_now(:));
else
    all_data_now=all_data;
    num_loaded_cond_now=num_loaded_cond;
    max_done_repeats_here=max_done_repeats;
end


%Looping over conditions 
for strain_now=1:length(strains) % all strains
    for cond_now=1:length(condition) % conditions
        ind_cond=ind_cond+1;
        for rep_now=1:num_loaded_cond_now(strain_now,cond_now); % The current number of repeats
            %setting name of condition right now
            %t_name_now=[strain_now,'_',condition(cond_now),'ug_rep',rep_now];
            t_name_now=['S:',strains{strain_now},' C:',condition{cond_now},' R:',num2str(rep_now)];
            s_name_now=[strains{strain_now},' ',condition{cond_now},'ug_rep_',num2str(rep_now)];

            %Setting correct subplot index
            ind=ind_cond+(rep_now-1)*max_cond;

            %Getting data
            data_in=all_data_now{rep_now,strain_now,cond_now};
            MY_now=data_in.MY-200;
            MR_now=data_in.MR;

            %Removing cells which do not make it the end
            goodones=~isnan(MY_now(last_frame,:));
            MY_now=MY_now(1:last_frame,goodones);
            MR_now=MR_now(1:last_frame,goodones);
  
            %Removing tracking errors
            if MY_smooth_tresh_on==1;
                %Calculating threshhold for tracking errors
                MY_smooth_after=diff(MY_now(101:end,:));
                thresh_after=mean(MY_smooth_after(:))+6*std(MY_smooth_after(:));
    
                MY_smooth_before=diff(MY_now(1:101,:));
                thresh_before=mean(MY_smooth_before(:))+6*std(MY_smooth_before(:));
    
                %Combing the threshholds
                good_smooth_before=sum(MY_smooth_before>thresh_before)==0;
                good_smooth_after=sum(MY_smooth_after>thresh_after)==0;
                good_smooth=good_smooth_after&good_smooth_before;
                
                %Filtering the good cells out
                MY_now=MY_now(:,good_smooth);
                MR_now=MR_now(:,good_smooth);
            end
    
            %Removing sick cells
            if MR_thresh_on==1;
                MR_now_pre=MR_now(30:last_frame,:);
                thresh=mean(MR_now_pre(:))+3*std(MR_now_pre(:));
                good_MR=max(MR_now(30:last_frame,:))<thresh;
                MY_now=MY_now(:,good_MR);
                MR_now=MR_now(:,good_MR);
            end
            
            %saving data
            MY=MY_now;
            if MY_smooth_tresh_on==1||MR_thresh_on==1;
                save([path_for_saving,'range\cleaned\',s_name_now],'MY');
            else
                save([path_for_saving,'range\uncleaned\',s_name_now],'MY');
            end
            
            %Plotting
            plotting_data_now(MY_now,max_done_repeats_here,max_cond,ind,t_name_now,last_frame,ind_cond,axis_y_max);
        end
    end
end
set(gcf,'color','w');



%%%%%%%%%%%%
% Checking Data
%%%%%%%%%%%%
if plot_reload==1
    %Checking which data to laod
    if MY_smooth_tresh_on==1||MR_thresh_on==1;
        check_path=[path_for_saving,'range\cleaned\'];
    else
        check_path=[path_for_saving,'range\uncleaned\'];
    end
    
    %Setting parameters
    figure('units','normalized','outerposition',[0 0 1 1]); 
    ind_cond=0;
    
    %Looping of over files
    for strain_now=1:length(strains) % all strains
        for cond_now=1:length(condition) % conditions
            ind_cond=ind_cond+1;
            for rep_now=1:num_loaded_cond_now(strain_now,cond_now); % The current number of repeats
                %Setting title
                t_name_now=['S:',strains{strain_now},' C:',condition{cond_now},' R:',num2str(rep_now)];
                %Setting correct subplot index
                ind=ind_cond+(rep_now-1)*max_cond;

                %Checking if file exists
                data_file_now=[check_path,strains{strain_now},' ',condition{cond_now},'ug_rep_',num2str(rep_now),'.mat'];
                if ~exist(data_file_now)
                    continue;
                end
        
                %Loading data
                in_data=load(data_file_now);
                MY_now=in_data.MY;
        
                %plotting data
                plotting_data_now(MY_now,max_done_repeats_here,max_cond,ind,t_name_now,last_frame,ind_cond,axis_y_max);
                
            end
        end
    end
    %sgtitle([big_title,' Reload']);
end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotting_data_now(MY_now,max_done_repeats_here,max_cond,ind,t_name_now,last_frame,ind_cond,axis_y_max);
% This function plots the loaded data in subplots. It is used to visuallize
% the clean data and to check the saved data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plotting
subplot(max_done_repeats_here,max_cond,ind);
plot(MY_now);

axis([0,last_frame,0,axis_y_max(ind_cond)]);

%Setting title
%title(all_data_names_now{rep_now,strain_now,cond_now});
title(t_name_now);
goodones=~isnan(MY_now(last_frame,:));

text(0.1,0.8,['n: ',num2str(sum(goodones))],'Unit','normalize');

%Setting labels
if mod(ind,max_cond)==1
    ylabel('MY');
end
if ind>max_cond*max_done_repeats_here-max_cond
    xlabel('frames');
end
xline(107,'r');
end