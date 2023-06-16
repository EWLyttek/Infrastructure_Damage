%This Code Is built to estimate the yearly probability of Tree fall given results from Oberle 2018 and FIA stringByDeletingLastPathComponent
clear
clf
format long
%Make Initial Conditions. Reshape vectors to matrix ~> back to vector. Ensures consistency in length between vectors and reload model 1 results.
    load('RESULT.mat');
    IC=load('NNJX100m.ASC');
    IC=sortrows(IC,6);
    X_ST_cumulat = X_ST_cumul;
    for i = 2:21
        X_ST_cumul(i,:)=X_ST_cumulat(i,:)-X_ST_cumulat(i-1,:);
    end
%%%%For Memory remove all values except that which is completely necessary.
    clearvars -except sizex sizey X_ST_cumul Dirchilet L1 XcoordV YcoordV M N NM n BCslots_vector ASHicV nullentries IC
%IC Factors
    FCic=(reshape(IC(:,8),sizex,sizey))';%'
    sourceFC=find(FCic>101);
    FCic(sourceFC)=100;
    EGic=(reshape(IC(:,13),sizex,sizey))';%'
    %Create New Site Vectors. Change to One Loop for standardization practices
        %Now turn matrix into a long vector
        	for i = [1:N]
                for j = [1:M]
                  	FCicV((i-1)*M+j)=FCic(i,j);
                    EGicV((i-1)*M+j)=EGic(i,j);
                end
            end
        FCicV(Dirchilet)=0;%Forest Cover
        EGicV(Dirchilet)=0;%Electric Grid
        file1='BETA.csv';%Trained Beta values
        file2='TR_MATRIX.csv';%Average Transition Matrix for backtesting
        file3='SZ_CLASS.csv';
        file4='HT_CLASS.csv';
        file5='BA_HT.csv';
        file6='Z_FACTOR.csv';%Normalization factors for DBH and TPH
        opts=detectImportOptions('BETA.csv');
        BE=readtable(file1);
        opts=detectImportOptions('TR_MATRIX.csv');
        TR=readtable(file2);
        opts=detectImportOptions('SZ_CLASS.csv');
        %opts = setvartype(opts,{'x___Var1', 'x___Var2'},{'double','double'});
        SZ=readtable(file3, opts);
        opts=detectImportOptions('HT_CLASS.csv');
        %opts = setvartype(opts,{'x___Var1', 'x___Var2'},{'double','double'});
        HT=readtable(file4, opts);
        opts=detectImportOptions('BA_HT.csv');
        opts = setvartype(opts,{'x___Var1'},{'double'});
        BA_HT=readtable(file5, opts);
        opts=detectImportOptions('Z_FACTOR.csv');
        Z_F=readtable(file6);
        BE=table2array(BE);
        TR=table2array(TR);
        SZ=table2array(SZ);
        HT=table2array(HT);
        BA_HT=table2array(BA_HT);
        Z_F=table2array(Z_F);
    %This Next Part Is Absolutely Atrocious coding wise. Inputs to fuctions must be single value and I need to call multiple values from the BE table per line, so I am forced to declare all BE values as individual variables. Shame.
        BEX1=BE([2:6 17:20],2);
        BEX2=BE([7:10 17:20],2);
        BEX3=BE([11:13 17:20],2);
        BEX4=BE([14:15 17:20],2);
        BEX5=BE([16 17:20],2);
    %Trees per Hectare%This is just double the average tpha times the percent coverage.
        TPH=1400;
        FCicV=FCicV;
        TPHc=TPH.*FCicV(:);
%Create Dimensional Arrays. Ordered Intro Year (21), Size Class (14), Position (sz(ASHicV)888635), simulation years(40), Decay/Fall Classes (10)
    INS=1:21;
    DBH=2:2:30;
    clear file1 file2 file3 file4 file5 opts BE
    RES_MASTER=cell(length(DBH),1);
    for j=1:length(DBH)
        RES_MASTER{j} = zeros(40,length(ASHicV),10);
    end
%Initialize Intro Data from X_ST_cumul across the array and Solve the Arrays dynamically. The INS loop is prime for a parfor loop. Dynamically saving the DC Files to the RES_MASTER file might not be good for it though.
    for i=1:length(INS)
        for j=1:length(DBH)
            DC=zeros(40,length(ASHicV),10);
            DC(i,:,1)=X_ST_cumul(i,:).*SZ(j,1);
            for a=1:length(ASHicV)
                    for t=1:35%Change i''s in DC to t
                    DC(t+5,a,1)=DC(t+5,a,1)+DC(t,a,1)*(1-Bzi(BEX1, 1, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5)-Bzi(BEX1, 2, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5)-Bzi(BEX1, 3, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5)-Bzi(BEX1, 4, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5)-Byi(BEX1, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5));

                        DC(t+5,a,2)=DC(t+5,a,2)+DC(t,a,2)*(1-Bzi(BEX2, 1, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4)-Bzi(BEX2, 2, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4)-Bzi(BEX2, 3, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4)-Byi(BEX2, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4)) ...
                        +(DC(t,a,1)*Bzi(BEX1, 1, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5));

                        DC(t+5,a,3)=DC(t+5,a,3)+DC(t,a,3)*(1-Bzi(BEX3, 1, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3)-Bzi(BEX3, 2, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3)-Byi(BEX3, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3)) ...
                        +(DC(t,a,1)*Bzi(BEX1, 2, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5))+(DC(t,a,2)*Bzi(BEX2, 1, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4));

                        DC(t+5,a,4)=DC(t+5,a,4)+DC(t,a,4)*(1-Bzi(BEX4, 1,(DBH(j)-Z_F(4,2))/Z_F(4,3), (TPHc(a)-Z_F(4,4))/Z_F(4,5), 2)-Byi(BEX4, (DBH(j)-Z_F(4,2))/Z_F(4,3), (TPHc(a)-Z_F(4,4))/Z_F(4,5), 2)) ...
                        +(DC(t,a,1)*Bzi(BEX1, 3, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5))+(DC(t,a,2)*Bzi(BEX2, 2, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4))+(DC(t,a,3)*Bzi(BEX3, 1, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3));

                        DC(t+5,a,5)=DC(t+5,a,5)+DC(t,a,5)*(1-Byi(BEX5, (DBH(j)-Z_F(5,2))/Z_F(5,3), (TPHc(a)-Z_F(5,4))/Z_F(5,5), 1)) ...
                        +(DC(t,a,1)*Bzi(BEX1, 4, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5))+(DC(t,a,2)*Bzi(BEX2, 3, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4))+(DC(t,a,3)*Bzi(BEX3, 2, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3))+(DC(t,a,4)*Bzi(BEX4, 1, (DBH(j)-Z_F(4,2))/Z_F(4,3), (TPHc(a)-Z_F(4,4))/Z_F(4,5), 2));

                        DC(t+5,a,6)=DC(t+5,a,6)+DC(t,a,1)*Byi(BEX1, (DBH(j)-Z_F(1,2))/Z_F(1,3), (TPHc(a)-Z_F(1,4))/Z_F(1,5), 5);
                        DC(t+5,a,7)=DC(t+5,a,7)+DC(t,a,2)*Byi(BEX2, (DBH(j)-Z_F(2,2))/Z_F(2,3), (TPHc(a)-Z_F(2,4))/Z_F(2,5), 4);
                        DC(t+5,a,8)=DC(t+5,a,8)+DC(t,a,3)*Byi(BEX3, (DBH(j)-Z_F(3,2))/Z_F(3,3), (TPHc(a)-Z_F(3,4))/Z_F(3,5), 3);
                        DC(t+5,a,9)=DC(t+5,a,9)+DC(t,a,4)*Byi(BEX4, (DBH(j)-Z_F(4,2))/Z_F(4,3), (TPHc(a)-Z_F(4,4))/Z_F(4,5), 2);
                        DC(t+5,a,10)=DC(t+5,a,10)+DC(t,a,5)*Byi(BEX5, (DBH(j)-Z_F(5,2))/Z_F(5,3), (TPHc(a)-Z_F(5,4))/Z_F(5,5), 1);
                    end
            end
            RES_MASTER{j}=RES_MASTER{j}+DC;
            clear DC
        end
    end
%Compress RES_MASTER results into Fallen trees in each location across 40 years
    RES_COMP=cell(length(DBH),1);
    for j=1:length(DBH)
        RES_COMP{j} = zeros(40,length(ASHicV),1);
    end
    for j=1:length(DBH)
        COMPDMG = RES_MASTER{j}(:, :, 6:10);
        RES_FALL = sum(COMPDMG,3);
        clear COMPDMG
        %change units from BA to # of tree incidents
        RES_FALLEN(:,:,1)=RES_FALL(:,:,1)./BA_HT(j);
        RES_COMP{j} = RES_FALLEN;
        clear RES_FALLEN RES_FALL
    end
    save('RES_COMP.mat', 'RES_COMP', '-v7.3')
%Saves Total Compressed Results for testing when first psss doesnt work
%Define Probabilty That each DBH is in range of Electric Lines
    UPG = 200000/1609.34;%This is a per meter cost for reconstruction. 200000 per mile. 1609.34 meters per mile
    HT_EG = 35*0.3048;%Meter Height of Powerlines
    HT_EGUP = 60*0.3048;%Meter Height of Powerlines after upgrade
    DIST = zeros(1,length(DBH));
    DIST_UP = zeros(1,length(DBH));
    %Solve for the b side of the triangle
    for i = 1:length(DBH)
        if HT(i,1)*0.3048>HT_EG
            DIST(i) = abs(sqrt(((HT(i,1)*0.3048)^2)-(HT_EG^2)));
        else
            DIST(i) = 0;
        end
    end
    for i = 1:length(DBH)
        if HT(i,1)*0.3048>HT_EGUP
            DIST_UP(i) = abs(sqrt(((HT(i,1)*0.3048)^2)-(HT_EGUP^2)));
        else
            DIST_UP(i) = 0;
        end
    end
%Apply Raw costs per unit Tree per Year Assuming 50 Percent Probabilty. Tree Dies, All Cost
%Reduce Costs with discounting (Simple 3% for now)
    dis=0.03;
    MIT = 1960*0.5;
    FLL = 7574*0.5;
    RES_DMG=cell(length(DBH)*2,1);
    RES_DMGUP=cell(length(DBH)*2,1);
    for j=1:length(DBH)
        RAWDMG = RES_COMP{j};%Number of Dead Fraxinus in Size class j
        MITDMG = RAWDMG.*MIT;%Times the mitigation cost
        MITDMG = MITDMG.*((EGicV.*DIST(j))./10000);
        MITDMGUP = MITDMG.*((EGicV.*DIST_UP(j))./10000);
        FLLDMG = RAWDMG.*FLL;%Times the Damage Cost
        FLLDMG = FLLDMG.*((EGicV.*DIST(j))./10000);
        FLLDMGUP = FLLDMG.*((EGicV.*DIST_UP(j))./10000);
        for t=1:40
            FLLDMG(t,:)=FLLDMG(t,:)./((1+dis)^t);
            FLLDMGUP(t,:)=FLLDMGUP(t,:)./((1+dis)^t);
            MITDMG(t,:)=MITDMG(t,:)./((1+dis)^t);
            MITDMGUP(t,:)=MITDMGUP(t,:)./((1+dis)^t);
        end
        RES_DMG{j} = MITDMG;
        RES_DMG{j+length(DBH)} = FLLDMG;
        RES_DMGUP{j} = MITDMGUP;
        RES_DMGUP{j+length(DBH)} = FLLDMGUP;
        clear MITDMG FLLDMG MITDMGUP FLLDMGUP RAWDMG
    end
%Sum Damage across DBH for two maps RES_DMGUP and RES_DMG for Yearly Damage maps
%Cumulative Damage under each Treatment (sum across DBH and Dimensions)
    MAP_DMG = zeros(40,length(ASHicV),4);
    C_DMG = zeros(40,1,4);
    for j=1:length(DBH)
        DMG_A = RES_DMG{j};
        DMG_B = RES_DMGUP{j};
        DMG_C = RES_DMG{15+j};
        DMG_D = RES_DMGUP{15+j};
        MAP_DMG(:,:,1) = MAP_DMG(:,:,1)+DMG_A(:,:);
        MAP_DMG(:,:,2) = MAP_DMG(:,:,2)+DMG_B(:,:);
        MAP_DMG(:,:,3) = MAP_DMG(:,:,3)+DMG_C(:,:);
        MAP_DMG(:,:,4) = MAP_DMG(:,:,4)+DMG_D(:,:);
        C_DMG(:,:,1) = C_DMG(:,:,1) + sum(DMG_A,2);
        C_DMG(:,:,2) = C_DMG(:,:,2) + sum(DMG_B,2);
        C_DMG(:,:,3) = C_DMG(:,:,3) + sum(DMG_C,2);
        C_DMG(:,:,4) = C_DMG(:,:,4) + sum(DMG_D,2);
        clear DMG_A DMG_B DMG_C DMG_D
    end
    MAP_SUM = sum(MAP_DMG);
    Cu_DMG = cumsum(C_DMG);
%Sum across Dimensions and years for a bar graph of size class contributions to damage
    SZ_DMG = zeros(1, length(DBH),4);
    for j=1:length(DBH)
        DMG_A = RES_DMG{j};
        DMG_B = RES_DMGUP{j};
        DMG_C = RES_DMG{15+j};
        DMG_D = RES_DMGUP{15+j};
        DMG_A1=sum(DMG_A);
        SZ_DMG(1,j,1)=sum(DMG_A1);
        DMG_B1=sum(DMG_B);
        SZ_DMG(1,j,2)=sum(DMG_B1);
        DMG_C1=sum(DMG_C);
        SZ_DMG(1,j,3)=sum(DMG_C1);
        DMG_D1=sum(DMG_D);
        SZ_DMG(1,j,4)=sum(DMG_D1);
        clear DMG_A DMG_B DMG_A1 DMG_B1 DMG_C DMG_D DMG_C1 DMG_D1
    end
finalmat='FALL_RESULT.mat';
save(finalmat)
%Scenarios to analyze.
    %Transitions have equal likelihood across all classes(1 for BE and 0 for Factor BE)
    %Height Sensitivity to model run
    %Beta Value Sensitivity runs


syms BEi tph dbh INIT END
%Standing
function X_BE=Bzi(BEi, INIT, dbh, tph, END)
    k=1;
    D=1;
    N=exp(BEi(INIT)+BEi(end-2)*dbh+BEi(end)*tph);
    for k=1:END
        D=D+exp(BEi(k)+BEi(end-2)*dbh+BEi(end)*tph);
    end
    X_BE=N/D;
end
%Fallen
function X_BE=Byi(BEi, dbh, tph, END)
    k=1;
    D=1;
    N=exp(BEi(end-4)+BEi(end-3)*dbh+BEi(end-1)*tph);
    for k=1:END
        D=D+exp(BEi(k)+BEi(end-3)*dbh+BEi(end-1)*tph);
    end
    X_BE=N/D;
end
