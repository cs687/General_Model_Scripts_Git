function [m,s,time_all,time_plot]=calculating_mean_and_time_to_activation_2025_01_20_v1(all_data,time_switch,strain,cond)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate activation metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables
time_plot=zeros(length(strain),length(cond));
time_all=cell(length(strain),length(cond));

for strain_now=1:length(strain)
    for cond_now=1:length(cond)
        %Calculating mean activation
        data_now=all_data{strain_now,cond_now}(end,:);
        m(strain_now,cond_now)=mean(data_now);
        s(strain_now,cond_now)=std(data_now);

        %calculating time to activate
        cand=all_data{strain_now,cond_now}>m(strain_now,cond_now)*0.5;
        time=nan(1,size(cand,2));

        %Loop over data
        for i=1:size(cand,2)

            f_all=find(cand(:,i));
            title(num2str(i));
            if ~isempty(f_all)&&f_all(1)<time_switch
                time(i)=nan;
            elseif ~isempty(f_all)
                time(i)=f_all(1)-250;
            else
                time(i)=size(data_now,1);
            end

        end

        %Mean time to activate
        time_plot(strain_now,cond_now)=nanmedian(time);
        time_all{strain_now,cond_now}=time;
    end
    
end

end