function Ar=Arousal_sig(Adata,Bdata,ws,hs)
%w in secs
%h in secs

%data=ALLEEG(1,2).data(1,:);
len=length(Adata);%lenght of EEG sample
sr=128;%eeg sample rate hz
w=floor(ws*sr);%window size
h=floor(hs*sr);%hop size
pin=1;%point in 
pout=w;%point out
FDlen=floor((len-w)/h)+1;%calculate leght of the FD vecctor
Ar=zeros(4,FDlen);%create empty vector of arousal values, pin and pout and pmid
for i=1:FDlen;%for each sliding window do
    a=Adata(pin:pout);%get alpha band data
    a2=log(1+mean(a.^2));%calculate logaritmic power 
    b=Bdata(pin:pout);%get beta band data
    b2=log(1+mean(b.^2));%calclulate FD with higuchi algorithm
    Ar(1,i)=b2/a2;%calculate beta/alpha and assign to correspondign position in the vector
    Ar(2,i)=pin;
    Ar(3,i)=pout;
    Ar(4,i)=round((pout-pin)/2)+pin;
    pin=pin+h;%advance window by hop size(not overlap!!!)
    pout=pout+h;
end

