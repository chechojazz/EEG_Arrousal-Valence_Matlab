function secs=min_sec(min,sec,h,sr)



secs=(min*60+sec)*(sr/h);

if secs==0
    secs=1;
end


end