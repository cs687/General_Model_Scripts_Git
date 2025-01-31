function preparing_mutant_data_1ug_use_2025_01_16_v2(varargin)
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

%%%%%%%%%%%%%%%%%%%%
%Preparing stuff
%%%%%%%%%%%%%%%%%%%%
if isempty(varargin)
    plot_reload=1;
else
    plot_reload=varargin{2};
end

close all;

%Path with data
p = mfilename('fullpath');
f=strfind(p,'\');
path_for_saving=p(1:f(end));
data_path_main='C:\Users\cs687\Documents\SLPC23_save\OneDrive - University Of Cambridge\General _sigma_paper\Mutant_data\';

%Options
adjust_switch=1;
len_thresh_on=0;
MR_thresh_on=1;
MY_smooth_tresh_on=1;

%Switching parameters
switch_frame=[101,101,102,101,101];
adjust_to=101;
last_frame=221;%210

%Removing bad experiments
kill=1;
conditions_to_skip=[4,1;1,5;2,6;1,8;3,8];

%Data Specs
data_day={'2024-03-11','2024-03-19','2024-03-22','2024-04-03_1','2024-04-03_2'};
strains={'JLB130','JLB212','JLB288','JLB293','JLB297','JLB325','JLB324','JLB327','JLB82'};
t_names= {'WT','1xrsiV amyE','3xrsiV amyE','5xrsiV amyE','8xrsiV (5xrsiV amyE & 3xrsiV lacA)','10xsigV',...
    '15xrsiV','10xrsiV +sigV','15xrsiV +sigV'};

%%%%%%%%%%%%%%%%%%%
%Loading Data
%%%%%%%%%%%%%%%%%%%
for day_now=1:length(data_day);
    for strain_now=1:length(strains);
        %Checking if condition exists
        D=dir([data_path_main,data_day{day_now},'\Data\',strains{strain_now},'_*']);
        if isempty(D);
            continue;
        end
        %Skipp condition if it has a problem
        if kill==1;
            if ~isempty(find(conditions_to_skip(:,1)==day_now&conditions_to_skip(:,2)==strain_now))
                continue;
            end
        end
        
        %Adjusting for different switiching time points
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


%%%%%%%%%%%%%%%%
% Cleaning Data
%%%%%%%%%%%%%%%%

%Setting Figure
figure('units','normalized','outerposition',[0 0 1 1]);
big_title='MY clean';

%Setting indexes
ind=-4;
strain_done=1;
start_pos=1;

%Looping over data
for strain_now=1:length(strains); 
    rep=1;
    for day_now=1:length(data_day);

        %%%%%%%%%%%%%%%%Filtering good cells out%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Checking content
        if isempty(all_data{day_now,strain_now})
            continue;
        end

        %loading data
        MY_now=all_data{day_now,strain_now}.MY-200;

        %Removing cells which do not make it the end
        goodones=~isnan(MY_now(last_frame,:));
        MY_now=MY_now(1:last_frame,goodones);
        
        %Removing weird growing cells for 10xrsiV first repeat
        if day_now==1&&strain_now==6
            MY_now=MY_now(:,1:95);
        end


        % Loading Mean RFP data
        MR_now=all_data{day_now,strain_now}.MR;
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
            save([path_for_saving,'1ug\cleaned\',strains{strain_now},'_1ug_rep_',num2str(rep)],'MY');
        else
            save([path_for_saving,'1ug\uncleaned\',strains{strain_now},'_1ug_rep_',num2str(rep)],'MY');
        end

        %updating index
        rep=rep+1;

        
        %%%%%%%%%%%%%%%%%%%%%%%%%Plottting the clean data%%%%%%%%%%%%%%%%%

        [ind,strain_done,start_pos]=plotting_data_now(MY_now,data_day,day_now,t_names,strain_now,start_pos,strain_done,ind,last_frame,big_title);

    end
end

sgtitle(big_title);


%%%%%%%%%%%%
% Checking Data
%%%%%%%%%%%%
if plot_reload==1
    %Checking which data to laod
    if MY_smooth_tresh_on==1||MR_thresh_on==1;
        check_path=[path_for_saving,'1ug\cleaned\'];
    else
        check_path=[path_for_saving,'1ug\uncleaned\'];
    end
    
    %Setting parameters
    ind=-4;
    strain_done=1;
    start_pos=1;
    figure('units','normalized','outerposition',[0 0 1 1]); 
    
    %Looping of over files
    for strain_now=1:length(strains); 
        rep=1;
        for day_now=1:length(data_day);
    
            %Checking if file exists
            data_file_now=[check_path,strains{strain_now},'_1ug_rep_',num2str(rep),'.mat'];
            if ~exist(data_file_now)
                continue;
            end
    
            %Loading data
            in_data=load(data_file_now);
    
            %plotting data
            [ind,strain_done,start_pos]=plotting_data_now(in_data.MY,data_day,day_now,t_names,strain_now,start_pos,strain_done,ind,last_frame,[big_title,' Reload']);
            
            %updating index
            rep=rep+1;
        end
    end
    sgtitle([big_title,' Reload']);
end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ind,strain_done,start_pos]=plotting_data_now(MY_now,data_day,day_now,t_names,strain_now,start_pos,strain_done,ind,last_frame,big_title)
% This function plots the loaded data in subplots. It is used to visuallize
% the clean data and to check the saved data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%setting up plot
if strain_now==6&&day_now==1
    sgtitle(big_title);
    figure('units','normalized','outerposition',[0 0 1 1]); 
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
subplot(5,5,ind);
plot(MY_now);

%annotating plot
n_s=sum(~isnan(MY_now(1,:)));
n_l=sum(~isnan(MY_now(last_frame,:)));

a=axis;
text(a(2)*0.05,a(4)*0.8,['#start: ',num2str(n_s)],'FontSize',9);
text(a(2)*0.05,a(4)*0.6,['#last: ',num2str(n_l)],'FontSize',9);
text(a(2)*0.05,a(4)*0.4,['day: ',num2str(day_now)],'FontSize',9);
text(a(2)*0.05,a(4)*0.2,['strain: ',num2str(strain_now)],'FontSize',9);

%adding legend to plot
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



