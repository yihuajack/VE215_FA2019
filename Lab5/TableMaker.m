function TableMaker(freq,Vin,Vout,func,n,name)
    fid=fopen(['Table_' n '.tex'],'w+');
    R=982;C=1e-7;L=1e-3;
    for i=1:length(freq)
        f(i)=trans(freq{i});
    end
    TFM=Vout./Vin;
    ETFM=func(f,R,L,C);
    TFM_dB=20*log10(Vout./Vin);
    ETFM_dB=20*log10(func(f,R,L,C));
    fprintf(fid,'\\begin{table}[H]\n');
    fprintf(fid,'\t\\centering\n');
    fprintf(fid,'\t\\begin{tabular}{|l|l|l|l|l|l|l|}\n');
    fprintf(fid,'\t\\hline\n');
    fprintf(fid,'\tFrequency&\\makecell[l]{Input\\\\signal\\\\amplitude,\\\\Vppk}&\\makecell[l]{Output\\\\signal\\\\amplitude,\\\\Vppk}&\\makecell[l]{Transfer\\\\function\\\\magnitude}&\\makecell[l]{Expected\\\\transfer\\\\function\\\\magnitude}&\\makecell[l]{Transfer\\\\function\\\\magnitude,\\\\in dB}&\\makecell[l]{Expected\\\\transfer\\\\function\\\\magnitude,\\\\in dB}\\\\\n');
    fprintf(fid,'\t\\hline\n');
    for i=1:length(freq)
        if mod(Vout(i),1)==0
            sETFM_dB=num2str(ETFM_dB(i),'%#.4g');
            sETFM_dB=strrep(sETFM_dB,'e','$\times10^{');
            if contains(sETFM_dB,'e')
                sETFM_dB=strcat(sETFM_dB,'}$');
                sETFM_dB=strrep(sETFM_dB,'{-0','{-');
            end
            fprintf(fid,'\t%sHz&%.3f&%.1f&%.4f&%.4f&%#.4g&%s\\\\\n',freq{i},Vin(i),Vout(i),TFM(i),ETFM(i),TFM_dB(i),sETFM_dB);
        else
            fprintf(fid,'\t%sHz&%.3f&%s&%.4f&%.4f&%#.4g&%#.4g\\\\\n',freq{i},Vin(i),num2str(Vout(i)),TFM(i),ETFM(i),TFM_dB(i),ETFM_dB(i));
        end
        fprintf(fid,'\t\\hline\n');
    end
    fprintf(fid,'\t\\end{tabular}\n');
    fprintf(fid,'\t\\caption{Measurement data for %s.}\n',lower(name));
    fprintf(fid,'\\end{table}\n');
    fclose(fid);
end
function f=trans(freq)
%d=str2num(freq(isstrprop(freq,'digit')));
freq=strrep(freq,'M','000000');
freq=strrep(freq,'k','000');
f=str2num(freq);
end