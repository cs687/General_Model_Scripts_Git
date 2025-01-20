function playing_with_data_to_find_quant_2025_01_20_v1
%function to find a good metric to compare experimental data with
%simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%input data
in_path='C:\Users\cs687\Documents\MATLAB\General_Model_Scripts_Git\Intermediate_Figure\Simulations_range\';
S={'6.0','10.0','15.0'};
D={'15.0','30.0'};

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

% metric
figure; 

for strain_now=1:length(D)
    for cond_now=1:length(S)
% for strain_now=1
%     for cond_now=3
        %figure('units','normalized','outerposition',[0 0 1 1]); 
        
        %Calculating mean activation
        data_now=all_data{strain_now,cond_now}(end,:);
        m(strain_now,cond_now)=mean(data_now);
        s(strain_now,cond_now)=std(data_now);

        %calculating time to activate
        cand=all_data{strain_now,cond_now}>m(strain_now,cond_now)*0.5;
        for i=1:size(cand,2)
            % subplot(10,10,i);
            % plot(all_data{strain_now,cond_now}(:,i));
            % yline(m(strain_now,cond_now)*0.5);
            f_all=find(cand(:,i));
            title(num2str(i));
            if ~isempty(f_all)&&f_all(1)<250
                time(i)=nan;
            elseif ~isempty(f_all)
                time(i)=f_all(1)-250;
            else
                time(i)=size(data_now,1);
            end
            % xline(time(i));
        end

        %Mean time to activate
        time_plot(strain_now,cond_now)=nanmedian(time);
        time_all{strain_now,cond_now}=time;
        %time_plot_s(strain_now,cond_now)=std(time);
        %sgtitle(['S: ',D{strain_now},' D: ',S{cond_now}]);
    end
    
end
figure;
subplot(2,1,1);
errorbar([6,10,15],m(1,:),s(1,:));
hold on; 
errorbar([6,10,15],m(2,:),s(2,:));

subplot(2,1,2);
plot(time_plot');

        