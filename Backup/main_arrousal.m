%% Sergio Giraldo 2015 MTG.
%% Run EEGlab
% To use, first add the path to your eeglab folder:
addpath('/Users/chechojazz/Dropbox/PHD/Libraries/eeglab13_6_5b')

%run eeglab
eeglab
% On the EEG GUI go to FILE->import data->Using EEGlab functions and
% plugins->from EDF/EDF GDF files (Biosig toolbox). Select the GDF file and
% name it.
fprintf('press any hey to continue');
pause();

% On the Workspace window form matlab the structure ALLEEG contains the data read from gdf file 

%% Extract chanels AF3 AF4 F3 and F4

Af3=ALLEEG.data(1,:);
Af4=ALLEEG.data(14,:);
F3=ALLEEG.data(3,:);
F4=ALLEEG.data(12,:);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% AROUSAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial filter

data=0.25*Af3+0.25*Af4+0.25*F3+0.25*F4;

% Data properties
len=length(data);%lenght of EEG sample
sr=128;%eeg sample rate hz

%% Band pass filter (Alpha): 
% IIR Butterworth filter of order 4 with 3?dB frequencies of 8 and 12 Hz. The sampling frequency is 128 Hz
d1 = fdesign.bandpass('N,F3dB1,F3dB2',4,8,12,128);
Alpha = design(d1,'butter');
alpha_data= filter(Alpha,data);

%% Band pass filter (Beta): 
% IIR Butterworth filter of order 4 with 3?dB frequencies of 12 and 30 Hz. The sampling frequency is 128 Hz
d2 = fdesign.bandpass('N,F3dB1,F3dB2',4,12,30,128);
Beta = design(d2,'butter');
beta_data= filter(Beta,data);

%% Epoch settings:
ws=4;%window in seconds
hs=1;%hop size in seconds
%        ws2=20;%historic window
w=floor(ws*sr);%in samples...
%w2=floor(ws2*sr);
h=floor(hs*sr);

%% Arousal calculations

%calculate arousal over all the signal w=seg, h=1seg...
Arr=Arousal_sig(alpha_data,beta_data,ws,hs);

%scale Arousal
Arrs=scale1_1(max(Arr(1,:)),min(Arr(1,:)),Arr(1,:));

%% Time Intervals

%[0:00, 0:20]   ->  [T1 , T2]
%[3:20, 6:40]   ->  [T3 , T4]
%[10:10, 12:30] ->  [T5 , T6]
%[18:35, 22:50] ->  [T7 , T8]
%[29:30, 35:30] ->  [T9 , T10]
%[35:45, 37:30] ->  [T11 , T12]

%to set time instants use the function min_sec(minute,second,h,sr)

T1=min_sec(0,0,h,sr);    T2=min_sec(0,20,h,sr);
T3=min_sec(3,20,h,sr);   T4=min_sec(6,40,h,sr);
T5=min_sec(10,10,h,sr);  T6=min_sec(12,30,h,sr);
T7=min_sec(18,35,h,sr);  T8=min_sec(22,50,h,sr);
T9=min_sec(29,30,h,sr);  T10=min_sec(35,30,h,sr);
T11=min_sec(35,45,h,sr); T12=min_sec(37,30,h,sr);

%function min_sec calculates the time instant in samples as seg*(sr/h)

flag=0;

%Check time intervals

if T2>length(Arrs)
    fprintf('Time interval 1 exceds the length of the GDF File\n')
    flag=1;
elseif T4>length(Arrs)
    fprintf('Time interval 2 exceds the length of the GDF File\n')
    flag=2;
    intervals=[T1 T2];
elseif T6>length(Arrs)
    fprintf('Time interval 3 exceds the length of the GDF File\n')
    flag=3;
    intervals=[T1 T2 T3 T4];
elseif T8>length(Arrs)
    fprintf('Time interval 4 exceds the length of the GDF File\n')
    flag=4;
    intervals=[T1 T2 T3 T4 T5 T6];
elseif T10>length(Arrs)
    fprintf('Time interval 5 exceds the length of the GDF File\n')
    flag=5;
    intervals=[T1 T2 T3 T4 T5 T6 T7 T8];
elseif T12>length(Arrs)
    fprintf('Time interval 6 exceds the length of the GDF File\n')
    flag=6;
    intervals=[T1 T2 T3 T4 T5 T6 T7 T8 T9 T10];
elseif T12<length(Arrs)
    intervals=[T1 T2 T3 T4 T5 T6 T7 T8 T9 T10];
    flag=7;
end





%% PLOTS

%% Arousal over all the signal and mean of each time slot
figure(2);

subplot(2,1,1)
plot([1:length(data)]/sr, data)
vline(intervals*(h/sr),'r');
title('EEG signal');
xlabel('Seconds');

subplot(2,1,2)
plot([1:length(Arrs)]*(h/sr),Arrs(1,:));
vline(intervals*(h/sr),'r');

%arrousal mean for each interval 
if flag>1 hline(mean(Arrs(T1:T2)),T1,T2,'r'); end
if flag>2 hline(mean(Arrs(T3:T4)),T3,T4,'b'); end
if flag>3 hline(mean(Arrs(T5:T6)),T5,T6,'c'); end
if flag>4 hline(mean(Arrs(T7:T8)),T7,T8,'m'); end
if flag>5 hline(mean(Arrs(T9:T10)),T9,T10,'g'); end
if flag>6 hline(mean(Arrs(T11:T12)),T11,T12,'w'); end

title('Normalized Arousal and Interval Average');
xlabel('Seconds');
ylabel('Arousal Normalized');
hold off;

%% Individual plots for each interval

% not done yet, but for now you can zoom over the previous image