function data_out = preparedata(intervals)
k=1;
data_out.sec = [];
data_out.arr = [];
data_out.val = [];
data_out.class = {};
for i=1:2:length(intervals.s)
    T1=intervals.s(i);
    T2=intervals.s(i+1);   
    data_out.sec = [data_out.sec,T1:T2];
    data_out.arr = [data_out.arr,Arrs(T1:T2)];
    data_out.val = [data_out.val,Vals(T1:T2)];
    for j=k:k+length(T1:T2)-1
        data_out.class{j} = intervals.class{(i+1)/2};
    end
    k=k+length(T1:T2);
end
end