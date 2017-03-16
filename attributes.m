function atrib=attributes(s,t)
%This function uses the field names of a structure and convert them in to a
%cell array with the attribute list following the arff format. Input
%paramenters are structures (s and t). The code merges attributes form the
%two structures.
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


header=fieldnames(s);
if isfield(s,'nar')%this is to add 3 narmour class descriptors to the header
    id=find(strcmp('nar',header));%find nar position on header vector
    headend=['nar1' 'nar2' 'nar3' header(id+1:end)']';    
    header=[header(1:id-1);headend];
end

%atributes
atrib=cell(numel(header),1);

for i=1:numel(header)
    switch header{i}%if narmour filed exists
        case 'nar1'
        tp='P R D ID IP VP IR VR SA SB NA';
        atrib(i)=space_cat(['@ATTRIBUTE',header(i),'{',tp,'}']);%write atributes for nar1
        case 'nar2'
        atrib(i)=space_cat(['@ATTRIBUTE',header(i),'{',tp,'}']);%write atributes for nar1
        case 'nar3'
        atrib(i)=space_cat(['@ATTRIBUTE',header(i),'{',tp,'}']);%write atributes for nar1
        otherwise
            array_class=class(s.(header{i}));
            switch array_class
                case 'double'
                    tp='numeric';
                    atrib(i)=space_cat(['@ATTRIBUTE',header(i),tp]);
                case 'cell' 
                    if i==47
                        asd=2;
                    end
                    [tp,~,~]=unique([s.(header{i})(:);t.(header{i})(:)]);
                    atrib(i)=space_cat(['@ATTRIBUTE',header(i),'{',tp','}']);
                case 'char'
                    [tp,~,~]=unique([s.(header{i})(:);t.(header{i})(:)]);
                    
            end
    end
end
atrib=cellstr(atrib);
end

function B=space_cat(A)
B=[];
for i=1:numel(A)
    if i<numel(A)%if not the last
        B=strcat(B, A{i}, {' '});%concatenate with a space
    else
        B=strcat(B, A{i});%concatenate last element
    end
end
end
    
