%%%Matlab 2018a parser for Tree and Plot Location CSVs published and maintained by the FIA. This is a third party piece made by Erik Lyttek in 2022. Place file in local folder alongside the csvs to be checked.
%%%Loop Over State Abbreviations
x=["PA","NY","NJ","DE","CT"]
format long
%Define Center Point of data
    LAT=41.120440;
    LON=-74.711258;
opts=detectImportOptions(sprintf('%s_TREE.csv',x(1)));
opts = setvartype(opts,{'CN','PLT_CN','PREV_TRE_CN','PREVCOND','MORTYR','DECAYCD'},{'int64','int64','int64','int32','int32','int32'});

opts1=detectImportOptions(sprintf('%s_PLOT.csv',x(1)));
opts1 = setvartype(opts1,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');

for i=1:numel(x);
%Load Files from local folder
    A= readtable(sprintf('%s_TREE.csv',x(i)),opts);
    B= readtable(sprintf('%s_PLOT.csv',x(i)),opts1);
%Reduce File Size
    %Select Plots by unwanted Latitude and Longitude
        %Lat
        B1=B.LAT>=45 & B.LAT<=35;
        %Lon
        B2=B.LON>=-80 & B.LON<=-60;
        %Combine
        Bsel= B1 & B2;
        B(Bsel,:)=[];
        clearvars B1 B2 Bsel
    %Select Plots by Sample Years
        B1=B.INVYR<1984;
        B(B1,:)=[];
        clearvars B1
    %Print TPHA based on TPA measurements at each plot on Graph A Acre to HA==2.47105%This is untested as of yet
        A1=groupsummary(A,'PLT_CN','sum','TPA_UNADJ');
        A1.TPHA(:)=NaN;
        A1.TPHA(:)=A1.sum_TPA_UNADJ(:).*2.47105;
        A=join(A,A1,'keys','PLT_CN');
        clearvars A1
    %Select by Tree status (Live Vs. Standing Dead)
        A1=A.STANDING_DEAD_CD==0;
        A(A1,:)=[];
        clearvars A1
        A1=isnan(A.STANDING_DEAD_CD);
        A(A1,:)=[];
        clearvars A1
    %Select by Tree Species Group Code
        A1=A.SPGRPCD~=36;
        A(A1,:)=[];
        clearvars A1
%Join Tables
    %Set Control Variable or join
        B.Properties.VariableNames{1} = 'PLT_CN';
    %Join Tables. Joining the many table first (the tree file)
        V=join(A,B,'keys','PLT_CN');
        clearvars A B
    %Trim to Relevant Columns%ADJUST
        V1=[V(:,1:27),V(:,35:38),V(:,55:56),V(:,108:111),V(:,208:237)];
        clearvars V
%Join Table Processing
    %Create end null Column(s)
        V1.STAND(:)=NaN;
    %Tree Previously dead marker (1=yes, 0=no)
        ind=ismember(V1.PREV_TRE_CN, V1.CN);
        V1.STAND=ind(:);
    %Remove Samples that have not been resampled. Sampling is done on a 5 year timescale in recent years, but this may be different for other periods
        V2=V1.STAND==0 & V1.INVYR_A>=(max(V1.INVYR_A)-5);
        V1(V2,:)=[];
    %Save Dynamically
        file=sprintf('%sjoin1.mat',x(i));
        save(file)
        clearvars V1 V2 ind
end


%load and append tables from loop
    load(sprintf('%sjoin1.mat',x(1)));
    sample=V1;

    for i=2:numel(x);
        load(sprintf('%sjoin1.mat',x(i)));
        sample=[sample; V1];
    end
    clearvars V1 V2
%Create Brief Identifier. This section is highly inefficient and using a different method (such as a binary search tree) would be better for similar applications that have to be run more often.
    sample.MARKER1(:)=NaN;
    sample.MARKER2(:)=NaN;
    sample.MARKER3(:)=NaN;
    sample.MARKER1(:)=1:length(sample.MARKER1);
    for n=1:length(sample.MARKER1)
        for i=1:length(sample.MARKER1)
            if sample.PREV_TRE_CN(i)==sample.CN(n)&sample.PLOT_A(n)==sample.PLOT_A(i)
                sample.MARKER2(i)=sample.MARKER1(n);
            else
                sample.MARKER2(i)=sample.MARKER2(i);
            end
        end
    end
    resample = sample;
    resample1 = resample.STAND==0;
    resample(resample1,:)=[];
    for n=1:length(resample.MARKER2)
        for i=1:length(resample.MARKER2)
            if resample.PREV_TRE_CN(i)==resample.CN(n)&resample.PLOT_A(n)==resample.PLOT_A(i)
                resample.MARKER3(i)=resample.MARKER2(n);
            else
                resample.MARKER3(i)=resample.MARKER3(i);
            end
        end
    end
%Create Final Marker variable.
    sample1 = sample.STAND==1;
    sample(sample1,:)=[];
%Rank By absolute distance by user defined Center Point (line 6-7). Creates two Columns. One Includes distance for all records (DISTANCE), while the other only includes distance for the inital observation (DISTA)
        sz=size(sample.MARKER1);
        LATdif=zeros(sz);
        LONdif=zeros(sz);
        LATdif(:)=(sample.LAT(:)-LAT).^2;
        LONdif(:)=(sample.LON(:)-LON).^2;
        sample.DISTANCE(:)=NaN;
        sample.DISTANCE(:)=sqrt(LATdif(:)+LONdif(:));
        sample.DISTA(:)=sample.DISTANCE(:);
            clearvars LATdiff LONdiff sz
        resample.DISTANCE(:)=zeros;
        resample.DISTA(:)=zeros;
        sz=size(resample.MARKER1);
        LATdif=zeros(sz);
        LONdif=zeros(sz);
        LATdif(:)=(resample.LAT(:)-LAT).^2;
        LONdif(:)=(resample.LON(:)-LON).^2;
        resample.DISTANCE(:)=sqrt(LATdif(:)+LONdif(:));
            clearvars LAT LON LATdiff LONdiff sz
%This is honestly fine as an if else statement given that it is a simple mathematical statement through one column length. Rather than Column length squared.
    sample=[sample; resample];
    sample.MARKER(:)=NaN;
        for n=1:length(sample.MARKER)
            if sample.MARKER3(n)>0
                sample.MARKER(n)=sample.MARKER3(n);
            elseif sample.MARKER2(n)>0
                sample.MARKER(n)=sample.MARKER2(n);
            else
                sample.MARKER(n)=sample.MARKER1(n);
            end
        end
    clearvars resample1 sample1 n i
    resample.MARKER(:)=NaN;
        for n=1:length(resample.MARKER)
            if resample.MARKER3(n)>0
                resample.MARKER(n)=resample.MARKER3(n);
            elseif resample.MARKER2(n)>0
                resample.MARKER(n)=resample.MARKER2(n);
            else
                resample.MARKER(n)=resample.MARKER1(n);
            end
        end
    clearvars resample1 sample1 n i
%Clear STATUSCD==3 OR AGENTCD==80. This removes any samples retroactively if they were previously sampled and harvested sometime after first record keeping exercise. Switched from salvcd as this indicates ability to be salvaged, not actual salvage.
    ind= sample.STATUSCD==3 | sample.AGENTCD==80;
    sample1=ind(:).*sample.MARKER;
    Bcd = sample1(sample1~=0);
    ind = ismember(sample.MARKER,Bcd);
    sample(ind,:)=[];
    ind = ismember(resample.MARKER,Bcd);
    resample(ind,:)=[];
    clearvars ind Bcd sample1
%Clear STATUSCD==3 OR AGENTCD==80. This removes any samples retroactively if they were previously sampled and harvested sometime after first record keeping exercise. Switched from salvcd as this indicates ability to be salvaged, not actual salvage.
    ind= sample.DECAYCD==0
    sample1=ind(:).*sample.MARKER;
    Bcd = sample1(sample1~=0);
    ind = ismember(sample.MARKER,Bcd);
    sample(ind,:)=[];
    ind = ismember(resample.MARKER,Bcd);
    resample(ind,:)=[];
    clearvars ind Bcd sample1
%Make Selections based on the length of sample required and distance in decimal degrees from the defined origin. This section can be run repeatedley to give different sample sizes.
    for n=3:8
        sampleSEL=sample;
        %Create Subsample Sets Serially for 300-800 sample trees
            i=n*100;
            ind=ismember(sampleSEL.DISTA,maxk(sampleSEL.DISTA,length(sampleSEL.DISTA)-(i+length(resample.DISTA))));
            sampleSEL(ind,:)=[];
            resampleSEL=sampleSEL;
            ind=sampleSEL.DISTA==0;
            sampleSEL(ind,:)=[];
            ind=~sampleSEL.DISTA==0;
            resampleSEL(ind,:)=[];
            ind=ismember(resampleSEL.MARKER2,sampleSEL.MARKER1) | ismember(resampleSEL.MARKER3,sampleSEL.MARKER1);
            resample1=resampleSEL(ind,:);
            sampleSEL=[sampleSEL; resample1];
            writetable(sampleSEL,sprintf('samplejoin%g.csv',i),'WriteRowNames',true);
            clearvars i resample1 ind resampleSEL
    end


writetable(sample,'samplejoin.csv','WriteRowNames',true);
