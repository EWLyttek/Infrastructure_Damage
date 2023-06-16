load('FALL_RESULT.mat')
load('RES_COMP.mat')
%Saves Total Compressed Results for testing when first psss doesnt work
%Define Probabilty That each DBH is in range of Electric Lines
    UPG = 200000/1609.34;%This is a per meter cost for reconstruction. 200000 per mile. 1609.34 meters per mile
    HT_EG = 35*0.3048;%Meter Height of Powerlines
    HT_EGUP = 60*0.3048;%Meter Height of Powerlines after upgrade
    DISTD = zeros(1,length(DBH));
    DIST_UPD = zeros(1,length(DBH));
    DISTP = zeros(1,length(DBH));
    DIST_UPP = zeros(1,length(DBH));
    %Solve for the b side of the triangle
    for i = 1:length(DBH)
        if (HT(i,1)-HT(i,2))*0.3048>HT_EG
            DISTD(i) = abs(sqrt((((HT(i,1)-HT(i,2))*0.3048)^2)-(HT_EG^2)));
        else
            DISTD(i) = 0;
        end
    end
    for i = 1:length(DBH)
        if (HT(i,1)-HT(i,2))*0.3048>HT_EGUP
            DIST_UPD(i) = abs(sqrt((((HT(i,1)-HT(i,2))*0.3048)^2)-(HT_EGUP^2)));
        else
            DIST_UPD(i) = 0;
        end
    end
    for i = 1:length(DBH)
        if (HT(i,1)+HT(i,2))*0.3048>HT_EG
            DISTP(i) = abs(sqrt((((HT(i,1)+HT(i,2))*0.3048)^2)-(HT_EG^2)));
        else
            DISTP(i) = 0;
        end
    end
    for i = 1:length(DBH)
        if (HT(i,1)+HT(i,2))*0.3048>HT_EGUP
            DIST_UPP(i) = abs(sqrt((((HT(i,1)+HT(i,2))*0.3048)^2)-(HT_EGUP^2)));
        else
            DIST_UPP(i) = 0;
        end
    end
%Apply Raw costs per unit Tree per Year Assuming 50 Percent Probabilty. Tree Dies, All Cost
%Reduce Costs with discounting (Simple 3% for now)
    dis=0.03;
    MIT = 2000*0.5;
    FLL = 7574*0.5;
    RES_DMGD=cell(length(DBH)*2,1);
    RES_DMGUPD=cell(length(DBH)*2,1);
    for j=1:length(DBH)
        RAWDMG = RES_COMP{j};%Number of Dead Fraxinus in Size class j
        MITDMG = RAWDMG.*MIT;%Times the mitigation cost
        MITDMG = MITDMG.*((EGicV.*DISTD(j))./10000);
        MITDMGUP = MITDMG.*((EGicV.*DIST_UPD(j))./10000);
        FLLDMG = RAWDMG.*FLL;%Times the Damage Cost
        FLLDMG = FLLDMG.*((EGicV.*DISTD(j))./10000);
        FLLDMGUP = FLLDMG.*((EGicV.*DIST_UPD(j))./10000);
        for t=1:40
            FLLDMG(t,:)=FLLDMG(t,:)./((1+dis)^t);
            FLLDMGUP(t,:)=FLLDMGUP(t,:)./((1+dis)^t);
            MITDMG(t,:)=MITDMG(t,:)./((1+dis)^t);
            MITDMGUP(t,:)=MITDMGUP(t,:)./((1+dis)^t);
        end
        RES_DMGD{j} = MITDMG;
        RES_DMGD{j+length(DBH)} = FLLDMG;
        RES_DMGUPD{j} = MITDMGUP;
        RES_DMGUPD{j+length(DBH)} = FLLDMGUP;
        clear MITDMG FLLDMG MITDMGUP FLLDMGUP RAWDMG
    end
%Apply Raw costs per unit Tree per Year Assuming 50 Percent Probabilty. Tree Dies, All Cost
%Reduce Costs with discounting (Simple 3% for now)
    RES_DMGP=cell(length(DBH)*2,1);
    RES_DMGUPP=cell(length(DBH)*2,1);
    for j=1:length(DBH)
        RAWDMG = RES_COMP{j};%Number of Dead Fraxinus in Size class j
        MITDMG = RAWDMG.*MIT;%Times the mitigation cost
        MITDMG = MITDMG.*((EGicV.*DISTP(j))./10000);
        MITDMGUP = MITDMG.*((EGicV.*DIST_UPP(j))./10000);
        FLLDMG = RAWDMG.*FLL;%Times the Damage Cost
        FLLDMG = FLLDMG.*((EGicV.*DISTP(j))./10000);
        FLLDMGUP = FLLDMG.*((EGicV.*DIST_UPP(j))./10000);
        for t=1:40
            FLLDMG(t,:)=FLLDMG(t,:)./((1+dis)^t);
            FLLDMGUP(t,:)=FLLDMGUP(t,:)./((1+dis)^t);
            MITDMG(t,:)=MITDMG(t,:)./((1+dis)^t);
            MITDMGUP(t,:)=MITDMGUP(t,:)./((1+dis)^t);
        end
        RES_DMGP{j} = MITDMG;
        RES_DMGP{j+length(DBH)} = FLLDMG;
        RES_DMGUPP{j} = MITDMGUP;
        RES_DMGUPP{j+length(DBH)} = FLLDMGUP;
        clear MITDMG FLLDMG MITDMGUP FLLDMGUP RAWDMG
    end
%Sum Damage across DBH for two maps RES_DMGUP and RES_DMG for Yearly Damage maps
%Cumulative Damage under each Treatment (sum across DBH and Dimensions)
    MAP_DMGP = zeros(40,length(ASHicV),4);
    C_DMGP = zeros(40,1,4);
    for j=1:length(DBH)
        DMG_A = RES_DMGP{j};
        DMG_B = RES_DMGUPP{j};
        DMG_C = RES_DMGP{15+j};
        DMG_D = RES_DMGUPP{15+j};
        MAP_DMGP(:,:,1) = MAP_DMGP(:,:,1)+DMG_A(:,:);
        MAP_DMGP(:,:,2) = MAP_DMGP(:,:,2)+DMG_B(:,:);
        MAP_DMGP(:,:,3) = MAP_DMGP(:,:,3)+DMG_C(:,:);
        MAP_DMGP(:,:,4) = MAP_DMGP(:,:,4)+DMG_D(:,:);
        C_DMGP(:,:,1) = C_DMGP(:,:,1) + sum(DMG_A,2);
        C_DMGP(:,:,2) = C_DMGP(:,:,2) + sum(DMG_B,2);
        C_DMGP(:,:,3) = C_DMGP(:,:,3) + sum(DMG_C,2);
        C_DMGP(:,:,4) = C_DMGP(:,:,4) + sum(DMG_D,2);
        clear DMG_A DMG_B DMG_C DMG_D
    end
    MAP_SUMP = sum(MAP_DMGP);
    Cu_DMGP = cumsum(C_DMGP);
%Sum across Dimensions and years for a bar graph of size class contributions to damage
    SZ_DMGP = zeros(1, length(DBH),4);
    for j=1:length(DBH)
        DMG_A = RES_DMGP{j};
        DMG_B = RES_DMGUPP{j};
        DMG_C = RES_DMGP{15+j};
        DMG_D = RES_DMGUPP{15+j};
        DMG_A1=sum(DMG_A);
        SZ_DMGP(1,j,1)=sum(DMG_A1);
        DMG_B1=sum(DMG_B);
        SZ_DMGP(1,j,2)=sum(DMG_B1);
        DMG_C1=sum(DMG_C);
        SZ_DMGP(1,j,3)=sum(DMG_C1);
        DMG_D1=sum(DMG_D);
        SZ_DMGP(1,j,4)=sum(DMG_D1);
        clear DMG_A DMG_B DMG_A1 DMG_B1 DMG_C DMG_D DMG_C1 DMG_D1
    end
%Sum Damage across DBH for two maps RES_DMGUP and RES_DMG for Yearly Damage maps
%Cumulative Damage under each Treatment (sum across DBH and Dimensions)
    MAP_DMGD = zeros(40,length(ASHicV),4);
    C_DMGD = zeros(40,1,4);
    for j=1:length(DBH)
        DMG_A = RES_DMGD{j};
        DMG_B = RES_DMGUPD{j};
        DMG_C = RES_DMGD{15+j};
        DMG_D = RES_DMGUPD{15+j};
        MAP_DMGD(:,:,1) = MAP_DMGD(:,:,1)+DMG_A(:,:);
        MAP_DMGD(:,:,2) = MAP_DMGD(:,:,2)+DMG_B(:,:);
        MAP_DMGD(:,:,3) = MAP_DMGD(:,:,3)+DMG_C(:,:);
        MAP_DMGD(:,:,4) = MAP_DMGD(:,:,4)+DMG_D(:,:);
        C_DMGD(:,:,1) = C_DMGD(:,:,1) + sum(DMG_A,2);
        C_DMGD(:,:,2) = C_DMGD(:,:,2) + sum(DMG_B,2);
        C_DMGD(:,:,3) = C_DMGD(:,:,3) + sum(DMG_C,2);
        C_DMGD(:,:,4) = C_DMGD(:,:,4) + sum(DMG_D,2);
        clear DMG_A DMG_B DMG_C DMG_D
    end
    MAP_SUMD = sum(MAP_DMGD);
    Cu_DMGD = cumsum(C_DMGD);
%Sum across Dimensions and years for a bar graph of size class contributions to damage
    SZ_DMGD = zeros(1, length(DBH),4);
    for j=1:length(DBH)
        DMG_A = RES_DMGD{j};
        DMG_B = RES_DMGUPD{j};
        DMG_C = RES_DMGD{15+j};
        DMG_D = RES_DMGUPD{15+j};
        DMG_A1=sum(DMG_A);
        SZ_DMGD(1,j,1)=sum(DMG_A1);
        DMG_B1=sum(DMG_B);
        SZ_DMGD(1,j,2)=sum(DMG_B1);
        DMG_C1=sum(DMG_C);
        SZ_DMGD(1,j,3)=sum(DMG_C1);
        DMG_D1=sum(DMG_D);
        SZ_DMGD(1,j,4)=sum(DMG_D1);
        clear DMG_A DMG_B DMG_A1 DMG_B1 DMG_C DMG_D DMG_C1 DMG_D1
    end
clearvars -except SZ_DMGD SZ_DMGP C_DMGD C_DMGP MAP_DMGD MAP_DMGP Cu_DMGD Cu_DMGP MAP_SUMD MAP_SUMP
finalmat='HEIGHT_SENSITIVITY_RESULT.mat';
save(finalmat)
