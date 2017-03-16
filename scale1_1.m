function nor=scale1_1(max,min,val)
% This code was developed by Sergio Giraldo at the Music and Machine
% Learning Lab of the Music Technology Group of the Pompeu Fabra
% University, (Barcelona, Spain). If you make use of this code please cite
% to the following publications:
%
% Ramirez R, Palencia-­??Lefler M, Giraldo S and Vamvakousis Z (2015). 
% Musical neurofeedback for treating depression in elderly people. Front. 
% Neurosci. 9:354. doi: 10.3389/fnins.2015.00354
%
% Giraldo, S., Ramirez, R. (2016). A machine learning approach to 
% ornamentation modeling and synthesis in jazz guitar. Journal of 
% Mathematics and Music, doi: 10.1080/17459737.2016.1207814.
%
% Sergio Giraldo 2016 MTG.

nor=(2*(val-min)./(max-min))-1;

end