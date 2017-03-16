function Val=Valence_sig(alpha_F3,alpha_F4,beta_F3,beta_F4,ws,hs)
%w in secs
%h in secs

%data=ALLEEG(1,2).data(1,:);
len=length(alpha_F3);%lenght of EEG sample
sr=128;%eeg sample rate hz
w=floor(ws*sr);%window size
h=floor(hs*sr);%hop size
FDlen=floor((len-w)/h)+1;%calculate leght of the FD vecctor

%% Arrousal F3
pin=1;%point in 
pout=w;%point out
Ar_F3=zeros(4,FDlen);%create empty vector of arousal values, pin and pout and pmid
for i=1:FDlen;%for each sliding window do
    a=alpha_F3(pin:pout);%get alpha band data
    a2=log(1+mean(a.^2));%calculate logaritmic power 
    b=beta_F3(pin:pout);%get beta band data
    b2=log(1+mean(b.^2));%calclulate FD with higuchi algorithm
    Ar_F3(1,i)=b2/a2;%calculate beta/alpha and assign to correspondign position in the vector
    pin=pin+h;%advance window by hop size(not overlap!!!)
    pout=pout+h;
end

%% Arrousal F4
pin=1;%point in 
pout=w;%point out
Ar_F4=zeros(4,FDlen);%create empty vector of arousal values, pin and pout and pmid
for i=1:FDlen;%for each sliding window do
    a=alpha_F4(pin:pout);%get alpha band data
    a2=log(1+mean(a.^2));%calculate logaritmic power 
    b=beta_F4(pin:pout);%get beta band data
    b2=log(1+mean(b.^2));%calclulate FD with higuchi algorithm
    Ar_F4(1,i)=b2/a2;%calculate beta/alpha and assign to correspondign position in the vector
    pin=pin+h;%advance window by hop size(not overlap!!!)
    pout=pout+h;
end

%% Valence calculation
Val=Ar_F3-Ar_F4;

end


