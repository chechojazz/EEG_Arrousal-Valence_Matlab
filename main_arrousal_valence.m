
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

%% Run EEGlab
% To use, first add the path to your eeglab folder:
addpath('/Users/chechojazz/Dropbox/PHD/Libraries/eeglab13_6_5b')

%run eeglab
flag3=0;
while flag3==0
    run_eeg = input('Run EEG-Lab?[y:n]:','s');
    switch run_eeg
        case 'y'
            fprintf('On the EEG GUI go to: \n->FILE\n->import data\n->Using EEGlab functions and plugins\n->from EDF/EDF GDF files (Biosig toolbox)\nSelect the GDF file and name it.\nAfter finishing return to the MATLAB command window and press any key to continue\n');
            eeglab
            fprintf('press any hey to continue\n');
            pause();
            flag3=1;
        case 'n'
            flag3=1;
        otherwise
            fprintf('Error: wrong input. Please answer y or n\n');
    end
end
% On the EEG GUI go to FILE->import data->Using EEGlab functions and
% plugins->from EDF/EDF GDF files (Biosig toolbox). Select the GDF file and
% name it.

fprintf('press any hey to continue\n');
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
alpha_F3= filter(Alpha,F3);
alpha_F4= filter(Alpha,F4);

%% Band pass filter (Beta): 
% IIR Butterworth filter of order 4 with 3?dB frequencies of 12 and 30 Hz. The sampling frequency is 128 Hz
d2 = fdesign.bandpass('N,F3dB1,F3dB2',4,12,30,128);
Beta = design(d2,'butter');
beta_data= filter(Beta,data);
beta_F3= filter(Beta,F3);
beta_F4= filter(Beta,F4);

%% Epoch settings:
ws_in = input('input window size (secs) of the epochs (default 4secs):');
hs_in = input('input hop size (secs) of the epochs (default 1secs):');

if isempty(ws_in)
    ws=4;%window in seconds
else
    ws=ws_in;
end
if isempty(hs_in)
    hs=1;%window in seconds
else
    hs=hs_in;
end
%        ws2=20;%historic window
w=floor(ws*sr);%in samples...
%w2=floor(ws2*sr);
h=floor(hs*sr);

%% Arousal calculations

%calculate arousal over all the signal w=seg, h=1seg...
Arr=Arousal_sig(alpha_data,beta_data,ws,hs);

%scale Arousal
Arrs=scale1_1(max(Arr(1,:)),min(Arr(1,:)),Arr(1,:));


%% Valence calculations

%calculate valence over all the signal w=seg, h=1seg...
Val=Valence_sig(alpha_F3,alpha_F4,beta_F3,beta_F4,ws,hs);

%scale Valence
Vals=scale1_1(max(Val(1,:)),min(Val(1,:)),Val(1,:));
%% Time Intervals

%[0:00, 0:20]   ->  [T1 , T2]
%[3:20, 6:40]   ->  [T3 , T4]
%[10:10, 12:30] ->  [T5 , T6]
%[18:35, 22:50] ->  [T7 , T8]
%[29:30, 35:30] ->  [T9 , T10]
%[35:45, 37:30] ->  [T11 , T12]

%to set time instants use the function min_sec(minute,second,h,sr)

intervals=ask_intervals(len,h,sr);


%Check time intervals

% if T2>length(Arrs)
%     fprintf('Time interval 1 exceds the length of the GDF File\n')
%     flag=1;
% elseif T4>length(Arrs)
%     fprintf('Time interval 2 exceds the length of the GDF File\n')
%     flag=2;
%     intervals=[T1 T2];
% elseif T6>length(Arrs)
%     fprintf('Time interval 3 exceds the length of the GDF File\n')
%     flag=3;
%     intervals=[T1 T2 T3 T4];
% elseif T8>length(Arrs)
%     fprintf('Time interval 4 exceds the length of the GDF File\n')
%     flag=4;
%     intervals=[T1 T2 T3 T4 T5 T6];
% elseif T10>length(Arrs)
%     fprintf('Time interval 5 exceds the length of the GDF File\n')
%     flag=5;
%     intervals=[T1 T2 T3 T4 T5 T6 T7 T8];
% elseif T12>length(Arrs)
%     fprintf('Time interval 6 exceds the length of the GDF File\n')
%     flag=6;
%     intervals=[T1 T2 T3 T4 T5 T6 T7 T8 T9 T10];
% elseif T12<length(Arrs)
%     intervals=[T1 T2 T3 T4 T5 T6 T7 T8 T9 T10];
%     flag=7;
% end





%% PLOTS

%% Arousal over all the signal and mean of each time slot
figure(1);

subplot(3,1,1)
plot([1:length(data)]/sr, data)
vline(intervals.s*(h/sr),'r');
title('EEG signal');
xlabel('Seconds');

subplot(3,1,2)
plot([1:length(Arrs)]*(h/sr),Arrs(1,:));
vline(intervals.s*(h/sr),'r');

%arrousal mean for each interval 
for i=1:2:length(intervals.s)
    T1=intervals.s(i);
    T2=intervals.s(i+1);
    hline(mean(Arrs(T1:T2)),T1,T2,'r');
end
title('Normalized Arousal and Interval Average');
xlabel('Seconds');
ylabel('Arousal Normalized');
hold off;

%% Valence over all the signal and mean of each time slot


subplot(3,1,3)
plot([1:length(Vals)]*(h/sr),Vals(1,:));
vline(intervals.s*(h/sr),'r');

%valence mean for each interval 
for i=1:2:length(intervals.s)
    T1=intervals.s(i);
    T2=intervals.s(i+1);
    hline(mean(Vals(T1:T2)),T1,T2,'r');
end

title('Normalized Valence and Interval Average');
xlabel('Seconds');
ylabel('Valence Normalized');

%% Write arrf file 

% prepare data in a structure
data_out=prepdata(intervals, Arrs,Vals);
attrib=attributes(data_out,data_out);
filename = input('Please type output file name (use .arff extension):','s');
arff_write([pwd,'/',filename],data_out, 'train',attrib,filename)
fprintf('Success!!!');
