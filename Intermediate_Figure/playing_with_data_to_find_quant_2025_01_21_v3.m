function playing_with_data_to_find_quant_2025_01_21_v3
%function to find a good metric to compare experimental data with
%simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;

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

% Calculating Simulation
[m_sim,s_sim,time_all_sim,time_plot_sim]=calculating_mean_and_time_to_activation(all_data,time_switch,D,S);

%plotting data
ind=1;
figure(1);
set(gcf,'units','normalized','outerposition',[0 0 1 1],'color','w'); 
for cond_now=1:length(S)
    for strain_now=1:length(D)
        subplot(length(S),length(D),ind);
        plot(all_data{strain_now,cond_now});
        hold on;
        yline(m_sim(strain_now,cond_now),'--');
        yline(m_sim(strain_now,cond_now)*0.5);
        xline(time_plot_sim(strain_now,cond_now)+250);
        title(['S: ',D{strain_now},' D: ',S{cond_now}]);
        ind=ind+1;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experimental Data
% Loading, Plotting and Calculating
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_switch_exp=101;

%Data path input
data_path_exp='C:\Users\cs687\Documents\MATLAB\General_Model_Scripts_Git\Intermediate_Figure\range\cleaned\';

%Information on the Data
condition={'01','05','1'};
strains={'JLB327','JLB82'};
t_names= {'10xrsiV +sigV','15xrsiV +sigV'};
%%axis_y_max=
all_data_exp=cell(2,3,8);
num_repeat=zeros(length(strains),length(condition));

%loading data
for strain_now=1:length(strains)
    for cond_now=1:length(condition)
        D_files=dir([data_path_exp,strains{strain_now},' ',condition{cond_now},'ug_rep*']);
        num_repeat(strain_now,cond_now)=length(D_files);
        for rep_now=1:length(D_files)
            in_data=load([data_path_exp,strains{strain_now},' ',condition{cond_now},'ug_rep_',num2str(rep_now),'.mat']);
            all_data_exp{strain_now,cond_now,rep_now}=in_data.MY;
        end
    end
end

[m_exp,s_exp,time_all_exp,time_plot_exp]=calculating_mean_and_time_to_activation_exp(all_data_exp,time_switch_exp,strains,condition,num_repeat);


%plotting data
ind_cond=0;
figure(3);
max_cond=6;
set(gcf,'units','normalized','outerposition',[0 0 1 1],'color','w'); 
for strain_now=1:length(strains)
    for cond_now=1:length(condition)
        ind_cond=ind_cond+1;
        for rep_now=1:num_repeat(strain_now,cond_now)
            %Setting correct subplot index

            ind=ind_cond+(rep_now-1)*max_cond;
            subplot(5,6,ind);

            plot(all_data_exp{strain_now,cond_now,rep_now});
            hold on;
            yline(m_exp(strain_now,cond_now,rep_now),'--');
            yline(m_exp(strain_now,cond_now,rep_now)*0.5);
            xline(time_plot_exp(strain_now,cond_now,rep_now)+101);
            title([strains{strain_now},' ',condition{cond_now},' R:',num2str(rep_now)]);
            ind=ind_cond+(rep_now-1)*max_cond;
        end
    end
end

%%%%%%%%%%%%%%%%%%%
% Plotting all data
%%%%%%%%%%%%%%%%
figure;
subplot(2,2,1);
errorbar([6,10,15],m_sim(1,:),s_sim(1,:));
hold on; 
errorbar([6,10,15],m_sim(2,:),s_sim(2,:));
legend(D);
xlabel('S');
ylabel('Mean Activation');
title('Mean activation at end simulations');

subplot(2,2,2);
errorbar([0.1,0.5,1],nanmean(m_exp(1,:,:),3),nanstd(m_exp(1,:,:),0,3));
hold on; 
errorbar([0.1,0.5,1],nanmean(m_exp(2,:,:),3),nanstd(m_exp(2,:,:),0,3));
legend(t_names);
xlabel('Lysozyme [ug/ml]');
ylabel('Mean Activation');
title('Mean activation at end experiments');
axis([0,1.1,0,1200])

subplot(2,2,3);
plot([6,10,15;6,10,15]',time_plot_sim');
legend(D);
xlabel('S');
ylabel('Time to activation');
title('Median Time to activate simulations')

subplot(2,2,4);
%cleaning
good_time=cell2mat(cellfun(@(a) sum(~isnan(a))/length(a)>0.5,time_all_exp,'UniformOutput',false));
time_plot_exp(~good_time)=nan;
errorbar([0.1,0.5,1;0.1,0.5,1]',nanmean(time_plot_exp,3)',nanstd(time_plot_exp,0,3)');
xlabel('Lysozyme [ug/ml]');
ylabel('Time to activation');
legend(t_names);
axis([0,1.1,0,14])
title('Median Time to activate experiment');

figure;
strain_line={'r','b'};
cond_line={'-','--','-.'};


%Cummulative plot simulations
for strain_now=1:length(D)
    ind=strain_now;
    for cond_now=1:length(S)
        %subplot(3,2,ind);
        hold on;
        try
        %cdfplot(time_all_sim{strain_now,cond_now});
        h=cdfplot(time_all_sim{strain_now,cond_now});
        h.LineStyle=cond_line{cond_now};
        h.Color=strain_line{strain_now};
        end
        %cdfplot(time_all_sim{strain_now,cond_now},[cond_line{cond_now},strain_line{strain_now}]);
        %xline(mode(time_all_sim{strain_now,cond_now}))
        ind=ind+2;
    end
end
axis([0,200,0,1]);

figure; 
%Cummulative plot experiments
for strain_now=1:length(strains)
    for cond_now=1:length(condition)
% for strain_now=2
%     for cond_now=1
        subplot(3,1,cond_now);
        for rep_now=1:num_repeat(strain_now,cond_now)
            hold on;
            try
                %cdfplot(time_all_sim{strain_now,cond_now});
                if sum(~isnan(time_all_exp{strain_now,cond_now,rep_now}))/length(time_all_exp{strain_now,cond_now,rep_now})>0.5
                    h=cdfplot(time_all_exp{strain_now,cond_now,rep_now});
                    h.LineStyle=cond_line{cond_now};
                    h.Color=strain_line{strain_now};
                end
            end

        end
        title(condition(cond_now));
        box on;
        yline(0.50);
        axis([0,40,0,1]);
        xlabel('Frames')
    end
end


% for strain_now=1:length(D)
%     ind=strain_now;
%     for cond_now=1:length(S)
%         subplot(3,2,ind);
%         histogram(time_all_sim{strain_now,cond_now},[0:2:150],'normalization','probability')
%         xline(mode(time_all_sim{strain_now,cond_now}))
%         ind=ind+2;
%     end
% end
end


%%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%%%

function [m,s,time_all,time_plot]=calculating_mean_and_time_to_activation(all_data,time_switch,strain,cond)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate activation metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables
time_plot=nan(length(strain),length(cond));
time_all=cell(length(strain),length(cond));
m=nan(length(strain),length(cond));
s=nan(length(strain),length(cond));

for strain_now=1:length(strain)
    for cond_now=1:length(cond)
        data_now=all_data{strain_now,cond_now};
        [m(strain_now,cond_now),s(strain_now,cond_now),time]=actual_caluclations(data_now,time_switch);
        %Mean time to activate
        time_plot(strain_now,cond_now)=nanmedian(time);
        %time_plot(strain_now,cond_now)=mode(time);
        time_all{strain_now,cond_now}=time;
    end
    
end
end

function [m,s,time_all,time_plot]=calculating_mean_and_time_to_activation_exp(all_data,time_switch,strain,cond,num_rep)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate activation metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables
time_plot=nan(length(strain),length(cond),max(num_rep(:)));
time_all=cell(length(strain),length(cond),max(num_rep(:)));
m=nan(length(strain),length(cond),max(num_rep(:)));
s=nan(length(strain),length(cond),max(num_rep(:)));

for strain_now=1:length(strain)
    for cond_now=1:length(cond)
        for rep_now=1:num_rep(strain_now,cond_now)
            data_now=all_data{strain_now,cond_now,rep_now};
            [m(strain_now,cond_now,rep_now),s(strain_now,cond_now,rep_now),time]=actual_caluclations(data_now,time_switch);
            %Mean time to activate
            time_plot(strain_now,cond_now,rep_now)=nanmedian(time);
            %time_plot(strain_now,cond_now,rep_now)=mode(time);
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

 