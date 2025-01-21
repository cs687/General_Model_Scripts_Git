function playing_with_data_to_find_quant_2025_01_20_v2
%function to find a good metric to compare experimental data with
%simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%
% Simulation Data
% Loading, Plotting and Calculating
%%%%%%%%%%%%%%%%%%%%%%%%%%
%input data
in_path='C:\Users\cs687\Documents\MATLAB\General_Model_Scripts_Git\Intermediate_Figure\Simulations_range\';
S={'6.0','10.0','15.0'};
D={'15.0','30.0'};
time_switch=250;

%Setting array
all_data=cell(length(D),length(S));

%loading data
for strain_now=1:length(D)
    for cond_now=1:length(S)
        in_data=load([in_path,'S_',S{cond_now},'-D_',D{strain_now},'-tau_0.2-v0_0.01-n_2.0-nu_0.05.mat']);
        in_data=squeeze(in_data.traces(:,2,2:end));
        all_data{strain_now,cond_now}=in_data;
    end
end

%plotting data
ind=1;
 figure('units','normalized','outerposition',[0 0 1 1]); 
for cond_now=1:length(S)
    for strain_now=1:length(D)
        subplot(length(S),length(D),ind);
        plot(all_data{strain_now,cond_now});
        title(['S: ',D{strain_now},' D: ',S{cond_now}]);
        ind=ind+1;
    end
end

% Calculating Simulation
[m_sim,s_sim,time_all_sim,time_plot_sim]=calculating_mean_and_time_to_activation(all_data,time_switch,D,S);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experimental Data
% Loading, Plotting and Calculating
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_switch_exp=101;

%Data path input
data_path_main='C:\Users\cs687\Documents\MATLAB\General_Model_Scripts_Git\Intermediate_Figure\range\cleaned';

%Information on the Data
condition={'01','05','1'};
strains={'JLB327','JLB82'};
t_names= {'10xrsiV +sigV','15xrsiV +sigV'};
%%axis_y_max=
all_data_exp=cell(2,3,8);
num_repeat=zeros(length(strains),length(condition))

%loading data
for strain_now=1:length(strains)
    for cond_now=1:length(condition)
        D=dir([in_path,strains{strain_now},' ',condition{cond_now},'ug_rep*']);
        num_repeat(strain_now,cond_now)=length(D);
        for rep_now=1:length(D)
            in_data=load([in_path,strains{strain_now},' ',condition{cond_now},'ug_rep_',rep_now]);
            all_data_exp{strain_now,cond_now,rep_now}=in_data;
        end
    end
end

[m_exp,s_exp,time_all_exp,time_plot_exp]=calculating_mean_and_time_to_activation_exp(all_data,time_switch,strain,cond);

figure;
subplot(2,2,1);
errorbar([6,10,15],m_sim(1,:),s_sim(1,:));
hold on; 
errorbar([6,10,15],m_sim(2,:),s_sim(2,:));
legend(D);
xlabel('S');
ylabel('Mean Activation');
title('Mean activation Time Simulations');

subplot(2,2,2);
errorbar([0.1,0.5,1],nanmean(m_exp(1,:,:),3),s_exp(1,:));
hold on; 
errorbar([0.1,0.5,1],m_exp(2,:),s_exp(2,:));
legend(D);
xlabel('S');
ylabel('Mean Activation');
title('Mean activation Time Simulations');

subplot(2,1,2);
plot(time_plot_sim');
legend(D);
xlabel('S');
ylabel('Time to activation');

end


%%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%%%

function [m,s,time_all,time_plot]=calculating_mean_and_time_to_activation(all_data,time_switch,strain,cond)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate activation metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables
time_plot=zeros(length(strain),length(cond));
time_all=cell(length(strain),length(cond));
m=nan(length(strain),length(cond));
s=nan(length(strain),length(cond));

for strain_now=1:length(strain)
    for cond_now=1:length(cond)
        data_now=all_data{strain_now,cond_now};
        [m(strain_now,cond_now),s(strain_now,cond_now),time]=actual_caluclations(data_now,time_switch);
        %Mean time to activate
        time_plot(strain_now,cond_now)=nanmedian(time);
        time_all{strain_now,cond_now}=time;
    end
    
end
end

function [m,s,time_all,time_plot]=calculating_mean_and_time_to_activation_exp(all_data,time_switch,strain,cond)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate activation metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables
time_plot=zeros(length(strain),length(cond),max(num_rep));
time_all=cell(length(strain),length(cond),max(num_rep));
m=nan(length(strain),length(cond),max(num_rep));
s=nan(length(strain),length(cond),max(num_rep));

for strain_now=1:length(strain)
    for cond_now=1:length(cond)
        for rep_now=1:num_rep(strain_now,cond_now)
            data_now=all_data{strain_now,cond_now,rep_now};
            [m(strain_now,cond_now,rep_now),s(strain_now,cond_now,rep_now),time]=actual_caluclations(data_now,time_switch);
            %Mean time to activate
            time_plot(strain_now,cond_now,rep_now)=nanmedian(time);
            time_all{strain_now,cond_now,rep_now}=time;
        end
    end
    
end

end



function [m,s,time]=actual_caluclations(data_now,time_switch)

%Calculating mean activation
data_now_end=data_now(end,:);
m=mean(data_now_end);
s=std(data_now_end);

%calculating time to activate
cand=data_now>m*0.5;
time=nan(1,size(cand,2));

%Loop over data
for i=1:size(cand,2)

    f_all=find(cand(:,i));
    title(num2str(i));
    if ~isempty(f_all)&&f_all(1)<time_switch
        time(i)=nan;
    elseif ~isempty(f_all)
        time(i)=f_all(1)-time_switch;
    else
        time(i)=size(data_now,1);
    end

end
end

 