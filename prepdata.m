function data_out = prepdata(intervals,Arrs,Vals)
% This code was developed by Sergio Giraldo at the Music and Machine
% Learning Lab of the Music Technology Group of the Pompeu Fabra
% University, (Barcelona, Spain). If you make use of this code please cite
% to the following publications:
%
% Ramirez R, Palencia-�??Lefler M, Giraldo S and Vamvakousis Z (2015). 
% Musical neurofeedback for treating depression in elderly people. Front. 
% Neurosci. 9:354. doi: 10.3389/fnins.2015.00354
%
% Giraldo, S., Ramirez, R. (2016). A machine learning approach to 
% ornamentation modeling and synthesis in jazz guitar. Journal of 
% Mathematics and Music, doi: 10.1080/17459737.2016.1207814.
%
% Sergio Giraldo 2016 MTG.

k=1;
data_out.sec = [];
data_out.arr = [];
data_out.val = [];
meanArrVal = input('print mean and standar deviation in Arff file?[y:n]:','s');
switch meanArrVal
    case 'y'
        flag = 1;
    otherwise 
        flag = 0;
end

if flag
    data_out.arrMean = [];
    data_out.arrStd = [];
    data_out.valMean = [];
    data_out.valStd = [];
end
data_out.class = {};

for i=1:2:length(intervals.s)
    T1=intervals.s(i);
    T2=intervals.s(i+1);   
    data_out.sec = [data_out.sec,T1:T2];
    data_out.arr = [data_out.arr,Arrs(T1:T2)];
    data_out.val = [data_out.val,Vals(T1:T2)];
    for j=k:k+length(T1:T2)-1
        if flag
            data_out.arrMean(j) = intervals.arrMean((i+1)/2);
            data_out.arrStd(j) = intervals.arrStd((i+1)/2);
            data_out.valMean(j) = intervals.valMean((i+1)/2);
            data_out.valStd(j) = intervals.valStd((i+1)/2);          
        end
        data_out.class{j} = intervals.class{(i+1)/2};
        
    end
    k=k+length(T1:T2);
end
end