function intervals = ask_intervals(data_len,h,sr)
% This code was developed by Sergio Giraldo at the Music and Machine
% Learning Lab of the Music Technology Group of the Pompeu Fabra
% University, (Barcelona, Spain). If you make use of this code please cite
% to the following publications:
%
% Ramirez R, Palencia-­??Lefler M, Giraldo S and Vamvakousis Z (2015). 
% Musical neurofeedback for treating depression in elderly people. Front. 
% Neurosci. 9:354. doi: 10.3389/fnins.2015.00354
%
% Sergio Giraldo 2016 MTG.

flag=0;
i=1;
k=1;
intervals.s=0;
while flag==0 
    fprintf('The length of the signal is : %s\n', secs2hms(data_len/sr));
    try
        
    t_interval = input('Please introduce a time interval in the following format:\n [[mm,ss];[mm,ss]]:');

    catch
        
    fprintf('Error: wrong format input.\n');
    
    end%try-catch
    
    if or(size(t_interval,1)~=2, size(t_interval,2)~=2)
        fprintf('fprintf: wrong format input.\n');
        t_interval=[];
    else
    if sum(sum(rem(t_interval,1)))~=0
        fprintf('Error: use integers only for time format.\n');
        t_interval=[];
    else
    if or(t_interval(1,2)>=60,t_interval(2,2)>=60)
        fprintf('Error: seconds at given interval should not exceed 60.\n');
        t_interval=[];
    else
        %function min_sec calculates the time instant in samples as seg*(sr/h)
        for k=1:size(t_interval,1) 
            interv_s(k)=min_sec(t_interval(k,1),t_interval(k,2),h,sr);    
        end

    if min(diff([intervals.s,interv_s]))<=0
        fprintf('Error: time intervals are overlapping or not cosecutive.\n');
        t_interval=[];
    else
        if interv_s(end) > data_len
            fprintf('Error: time interval esceeds signal length.\n');
            t_interval=[];
        else
            if size(intervals.s,2)==1
                intervals.s = interv_s;
            else
                intervals.s = [intervals.s,interv_s];
            end
        
        intervals.class{i} = input('Please type the class of the time interval:','s');
        
        %% add more intervals
        flag2=0;
        while flag2==0
        add_interval = input('Add another interval?[y:n]:','s');  
        switch add_interval
            case 'n'
                flag=1;
                flag2=1;
            case 'y'
                i=i+1;
                flag2=1;
            otherwise
                fprintf('Error: Wrong input: please answer y or n\n')
        end
        end
        
    end
    end
    end
    end
    end

end
end
