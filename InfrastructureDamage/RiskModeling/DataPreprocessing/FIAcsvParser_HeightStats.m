%%%Matlab 2018a parser for Tree and Plot Location CSVs published and maintained by the FIA. This is a third party piece made by Erik Lyttek in 2022. Place file in local folder alongside the csvs to be checked.
%%%Loop Over State Abbreviations
x=["PA","NY","NJ","DE","CT"]
format long
%Define Center Point of data
    LAT=41.120440;
    LON=-74.711258;
opts=detectImportOptions(sprintf('%s_TREE.csv',x(1)));
opts = setvartype(opts,{'CN','PLT_CN','PREV_TRE_CN','PREVCOND','MORTYR','DECAYCD','DIA','DIAHTCD','HT','HTCD'},{'int64','int64','int64','int32','int32','int32','double','double','double','double'});

opts1=detectImportOptions(sprintf('%s_PLOT.csv',x(1)));
opts1 = setvartype(opts1,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN','ELEV','RDDISTCD'},'int64');

for i=1:numel(x);
%Load Files from local folder
    A= readtable(sprintf('%s_TREE.csv',x(i)),opts);
    B= readtable(sprintf('%s_PLOT.csv',x(i)),opts1);
%Reduce File Size
    %Select Plots by Sample Years
        B1=B.INVYR<1984;
        B(B1,:)=[];
        clearvars B1
    %Print TPHA based on TPA measurements at each plot on Graph A Acre to HA==2.47105
        A1=groupsummary(A,'PLT_CN','sum','TPA_UNADJ');
        A1.TPHA(:)=NaN;
        A1.TPHA(:)=A1.sum_TPA_UNADJ(:).*2.47105;
        A=join(A,A1,'keys','PLT_CN');
        clearvars A1
    %Select by Tree status (Live Vs. Standing Dead)
        A1=A.STANDING_DEAD_CD==1;
        A(A1,:)=[];
        clearvars A1
        A1=isnan(A.HTCD);
        A(A1,:)=[];
        clearvars A1
        A1=isnan(A.HT);
        A(A1,:)=[];
        clearvars A1
        A1=A.HT==0;
        A(A1,:)=[];
        clearvars A1
        A1=A.DIAHTCD>1;
        A(A1,:)=[];
        clearvars A1
        A1=A.DIA<1;
        A(A1,:)=[];
        clearvars A1
        A1=isnan(A.DIA);
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
    %Trim to Relevant Columns%ADJUST
        V1=[V(:,1:27),V(:,35:38),V(:,55:56),V(:,108:111),V(:,208:237)];
        clearvars V
        file=sprintf('%sjoinHT1.mat',x(i));
        save(file)
end

%load and append tables from loop
    load(sprintf('%sjoinHT1.mat',x(1)));
    sample=V1;

    for i=2:numel(x);
        load(sprintf('%sjoinHT1.mat',x(i)));
        sample=[sample; V1];
    end
    clearvars V1 V2
%Rank By absolute distance by user defined Center Point (line 6-7). Creates two Columns. One Includes distance for all records (DISTANCE), while the other only includes distance for the inital observation (DISTA)
        sz=size(sample.HTCD);
        LATdif=zeros(sz);
        LONdif=zeros(sz);
        LATdif(:)=(sample.LAT(:)-LAT).^2;
        LONdif(:)=(sample.LON(:)-LON).^2;
        sample.DISTANCE(:)=NaN;
        sample.DISTANCE(:)=sqrt(LATdif(:)+LONdif(:));
        sample.DISTA(:)=sample.DISTANCE(:);
            clearvars LATdiff LONdiff sz
        sample.RANK(:)=NaN;
        sample=sortrows(sample,'DISTA','descend');
        sample.RANK(:)=1./sample.DISTA(:);
        sample.DISTA=cast(sample.DISTA,'double');
        sample.RATIO(:)=sample.DIA(:)./sample.HT;
        sampleCUT=sample;
        CODES=[" 221Da"," 221Am", " 221Dc", " 221Ae", " 221Ba", " 221Bd"];
        CUT = contains(sample.ECOSUBCD, CODES);
        CUTX = CUT==0;
        sampleCUT(CUTX,:)=[];
%Break sample into ranges
    samplesmx=sample.DIA>5;
        samplesm=sample;
        samplesm(samplesmx,:)=[];
    samplemdx=sample.DIA<=5;
        samplemd=sample;
        samplemd(samplemdx,:)=[];
    samplemdy=samplemd.DIA>21;
        samplemd(samplemdy,:)=[];
    samplelgx=sample.DIA<=21;
        samplelg=sample;
        samplelg(samplelgx,:)=[];
    clear samplelgx samplemdx samplemdy samplesmx
%Make Selections based on the length of sample required and distance in decimal degrees from the defined origin. This section can be run repeatedley to give different sample sizes.

%writetable(sample,'samplejoinHT.csv','WriteRowNames',true);
%Multiple Linear Regression
HT=sample.HT;
RAT=sample.RATIO;
XT=[];
XT=cast(XT,'double');
XT=[sample(:,18),sample(:,40),sample(:,61),sample(:,69),sample(:,57)];
XT=table2array(XT);
XT=cast(XT,'double');
XTX=XT;
XTX=cast(XTX,'double');
XTX(:,1)=sample.DIA;
XTX(:,2)=sample.TPHA;
XTX(:,4)=sample.DISTA;
XT=XTX;
XT=[ones(length(XT),1) XT];
%No correlation(ones), No correlation(species), Highly correlated(Diameter), Correlated Negatively(TPHA), Correlated Positively(ELEV), Correlated Negatively(DISTA)
%Overall everyhting, but species, shows some correlation. To Check: [r,p] = corrcoef(XT(:,n),HT(:));
[b,bint,res,rint,stats] = regress(HT,XT);
%Linear Regression
modelfun=@(B,x) B(1).*log(x) + B(2);%9.3111 error factor with weight. 12.0296 without.
modelfunner=@(B,x) B(1,1).*log(x(:,1))+ B(1,2).*x(:,3)+ B(1,3).*x(:,4);
beta0=[0 0];
beta1=[0 0 0];
X=sample.DIA;
Y=sample.HT;
XX=sampleCUT.DIA;
YX=sampleCUT.HT;
X1=samplesm.DIA;
Y1=samplesm.HT;
X2=samplemd.DIA;
Y2=samplemd.HT;
X3=samplelg.DIA;
Y3=samplelg.HT;
[newcoeffs1,R1,J1,CovB1,MSE1,ErrorModelInfo1]=nlinfit(X,Y,modelfun,beta0);
[newcoeffs2,R2,J2,CovB2,MSE2,ErrorModelInfo2]=nlinfit(X,Y,modelfun,beta0,'Weights',sample.RANK);
[newcoeffs3,R3,J3,CovB3,MSE3,ErrorModelInfo3]=nlinfit(XTX(:,:),Y,modelfunner,beta1);
[newcoeffs4,R4,J4,CovB4,MSE4,ErrorModelInfo4]=nlinfit(XTX(:,:),Y,modelfunner,beta1,'Weights',sample.RANK);
[newcoeffs5,R5,J5,CovB5,MSE5,ErrorModelInfo5]=nlinfit(XX,YX,modelfun,beta0);
%Linear section coefficients
mdsm=fitlm(X1,Y1);
mdmd=fitlm(X2,Y2);
mdlg=fitlm(X3,Y3);
mdcut=fitlm(XX,YX);
restpha=fitlm(R1,sample.HT);
new_y1=modelfun(newcoeffs1, X);
new_y2=modelfun(newcoeffs2, X);
figure(7)
plot(mdsm)
figure(8)
plot(mdmd)
figure(9)
plot(mdlg)
scatter(X, Y,'MarkerEdgeColor','blue')
hold on
scatter(X, new_y1,'d','filled','MarkerEdgeColor','black','MarkerFaceColor','black')
scatter(X, new_y2,'+','MarkerEdgeColor','red')
ylabel('Height (ft)','FontSize',24);
xlabel('DBH (in)','FontSize',24);
legend({'Observations','Unweighted Regression','Distance Weighted Regression'},'Location','southeast','FontSize', 12)
axis([0 40 0 inf])
savefig('AshHeightRegression.fig')
print('-f1','-dpng','AshHeightRegression')
%sample equation for height%HT = 32.2612ln(DIA) - 7.3703
%Separate sample by species code (4 sets). Separate by trees per hectare (quintiles, 5 sets), same with elevation. Total 14 Separated test sets.
    SP1=sample.SPCD~=540;
    SP2=sample.SPCD~=541;
    SP3=sample.SPCD~=542;
    SP4=sample.SPCD~=543;
    SP11=sample;
    SP21=sample;
    SP31=sample;
    SP41=sample;
    SP11(SP1,:)=[];
    SP21(SP2,:)=[];
    SP31(SP3,:)=[];
    SP41(SP4,:)=[];
    %TPHA
    TPHA1 = quantile(sample.TPHA,5);
    TPHA2=sample.TPHA<=TPHA1(1);
    TPHA3=sample.TPHA>TPHA1(1) & sample.TPHA<=TPHA1(2);
    TPHA4=sample.TPHA>TPHA1(2) & sample.TPHA<=TPHA1(3);
    TPHA5=sample.TPHA>TPHA1(3) & sample.TPHA<=TPHA1(4);
    TPHA6=sample.TPHA>TPHA1(5);
    TPHAC1 = sample(TPHA2,:);
    TPHAC2 = sample(TPHA3,:);
    TPHAC3 = sample(TPHA4,:);
    TPHAC4 = sample(TPHA5,:);
    TPHAC5 = sample(TPHA6,:);
    %ELEVATION
    ELEV1 = quantile(sample.ELEV,5);
    ELEV2=sample.ELEV<=ELEV1(1);
    ELEV3=sample.ELEV>ELEV1(1) & sample.ELEV<=ELEV1(2);
    ELEV4=sample.ELEV>ELEV1(2) & sample.ELEV<=ELEV1(3);
    ELEV5=sample.ELEV>ELEV1(3) & sample.ELEV<=ELEV1(4);
    ELEV6=sample.ELEV>ELEV1(5);
    ELEVC1 = sample(ELEV2,:);
    ELEVC2 = sample(ELEV3,:);
    ELEVC3 = sample(ELEV4,:);
    ELEVC4 = sample(ELEV5,:);
    ELEVC5 = sample(ELEV6,:);
    %Distance
    DIST1 = quantile(sample.DISTA,5);
    DIST2=sample.DISTA<=DIST1(1);
    DIST3=sample.DISTA>DIST1(1) & sample.DISTA<=DIST1(2);
    DIST4=sample.DISTA>DIST1(2) & sample.DISTA<=DIST1(3);
    DIST5=sample.DISTA>DIST1(3) & sample.DISTA<=DIST1(4);
    DIST6=sample.DISTA>DIST1(5);
    DISTC1 = sample(DIST2,:);
    DISTC2 = sample(DIST3,:);
    DISTC3 = sample(DIST4,:);
    DISTC4 = sample(DIST5,:);
    DISTC5 = sample(DIST6,:);
    %RDDISTCD
    RD1=sample.RDDISTCD~=1;
    RD2=sample.RDDISTCD~=2;
    RD3=sample.RDDISTCD~=3;
    RD4=sample.RDDISTCD~=4;
    RD5=sample.RDDISTCD~=5;
    RD6=sample.RDDISTCD~=6;
    RD7=sample.RDDISTCD~=7;
    RD8=sample.RDDISTCD~=8;
    RD9=sample.RDDISTCD~=9;
    RD11=sample;
    RD21=sample;
    RD31=sample;
    RD41=sample;
    RD51=sample;
    RD61=sample;
    RD71=sample;
    RD81=sample;
    RD91=sample;
    RD11(RD1,:)=[];
    RD21(RD2,:)=[];
    RD31(RD3,:)=[];
    RD41(RD4,:)=[];
    RD51(RD5,:)=[];
    RD61(RD6,:)=[];
    RD71(RD7,:)=[];
    RD81(RD8,:)=[];
    RD91(RD9,:)=[];
%Difference between means
    %EcoRegions
    %ECO = ordinal(sample.ECOSUBCD,sample.ECOSUBCD);
    %figure(2)
    %boxplot(sample.HT,ECO)
    %Species
    SPEC = ordinal(sample.SPCD,{'Black', 'White', 'Green'},[],[540 541 543 544]);
    figure(3)
    boxplot(sample.HT,SPEC)
    %TPHA
    TRPRHA = ordinal(sample.TPHA,{'Sparse', 'Light', 'Medium', 'Heavy', 'Dense'},[],[0 TPHA1(1) TPHA1(2) TPHA1(3) TPHA1(4) TPHA1(5)]);
    figure(4)
    boxplot(sample.HT,TRPRHA)
    %ELEV
    ELEVAT = ordinal(sample.ELEV,{'Bottom', 'Low', 'Medium', 'High', 'Highest'},[],[0 ELEV1(1) ELEV1(2) ELEV1(3) ELEV1(4) ELEV1(5)]);
    figure(5)
    boxplot(sample.HT,ELEVAT)
    %DIST
    DISTAT = ordinal(sample.DISTA,{'Bottom', 'Low', 'Medium', 'High', 'Highest'},[],[0 DIST1(1) DIST1(2) DIST1(3) DIST1(4) DIST1(5)]);
    figure(6)
    boxplot(sample.HT,DISTAT)
    %RDDIST
    RDDISTAT = ordinal(sample.RDDISTCD,{'1', '2', '3', '4', '5', '6', '7', '8', '9'},[],[0 1 2 3 4 5 6 7 8 9]);
    figure(7)
    boxplot(sample.HT,RDDISTAT)
