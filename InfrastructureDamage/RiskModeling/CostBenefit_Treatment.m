load('FALL_RESULT.mat')
load('HEIGHT_SENSITIVITY_RESULT.mat')
%Eliminate Unnecessary Values
clearvars -except SZ_DMG SZ_DMGD SZ_DMGP C_DMG C_DMGD C_DMGP MAP_DMG MAP_DMGD MAP_DMGP Cu_DMG Cu_DMGD Cu_DMGP MAP_SUM MAP_SUMD MAP_SUMP EGicV X_ST_cumul ASHicV
%Define Bounds to Evaluate
    %Fixed Cost of Mitigation per meter.
        MITT=200000/1609.34;
    %Mitigation Cost electric grid(m) times the cost per meter
        MITT_EG=EGicV(:,:).*MITT;
        dis=0.03;
        MITT_EGY=zeros(40,length(ASHicV));
        for t=1:40
            MITT_EGY(t,:)=MITT_EG(:,:)./((1+dis)^t);
        end
    %Trimming Effectiveness 0-100% by increments of 10% This is about how much of the lower cost bound is implemented
        COSTS = zeros(1,length(ASHicV),4);
        COST_SAVING = zeros(40,length(ASHicV),11);
        CB = zeros(40,length(ASHicV),11);
        for i=1:4
            COSTS(1,:,i) =  sum(MAP_DMG(:,:,i));
        end
        for i=0:1:10
            COST_SAVING(:,:,i+1)=((1-(i/10)).*MAP_DMG(:,:,3)+(i/10).*MAP_DMG(:,:,4))-((1-(i/10)).*MAP_DMG(:,:,1)+(i/10).*MAP_DMG(:,:,2));
            %Difference between Unmitgated term (left of subtraction) and mitigated (right of subtraction)
            %Stores results for 0% to 100% of costs from thinning versus line repair
            CB(:,:,i+1) = MITT_EGY(:,:)-COST_SAVING(:,:,i+1);
        end
%High and Costs for all four treatments
    H_M=max(COSTS(1,:,1));
    L_M=max(COSTS(1,:,2));
    H_ST=max(COSTS(1,:,3));
    L_ST=max(COSTS(1,:,4));
%Average Cost per meter of EG
    EG_M = COSTS(1,:,1)./EGicV(:,:);
    EG_M = mean(EG_M(~isnan(EG_M)));
    EU_M = COSTS(1,:,2)./EGicV(:,:);
    EU_M = mean(EU_M(~isnan(EU_M)));
    EG_ST = COSTS(1,:,3)./EGicV(:,:);
    EG_ST = mean(EG_ST(~isnan(EG_ST)));
    EU_ST = COSTS(1,:,4)./EGicV(:,:);
    EU_ST = mean(EU_ST(~isnan(EU_ST)));
%Correlation Between Cost and The Two Input Variables on end cost
    %Mitigated
        scatter((EGicV(1,:).*sum(X_ST_cumul(:,:))), COSTS(:,:,1),'o')
        hold on
        EGBAM=fitlm((EGicV(1,:).*sum(X_ST_cumul(:,:))),COSTS(:,:,1));
        plot(EGBAM)
        xlabel('Product of Electric Grid and Basal Area');
        ylabel('Dollar Cost');
        title('Relationship between Total Cost and Input Product')
        % Get handle to current axes.
        ax = gca
            ax.Color = 'k';
            ax.YColor = 'r';
            ax.XAxis.FontSize = 12;
            ax.YAxis.FontSize = 12;
            ax.FontWeight = 'bold';
        hold off;
        savefig('EG_BA_PRODUCT_M.fig')
        print('-f1','-dpng','EG_BA_PRODUCT_M')
    %Unmitigated
        clf
        scatter((EGicV(1,:).*sum(X_ST_cumul(:,:))), COSTS(:,:,3),'o')
        hold on
        EGBAU=fitlm((EGicV(1,:).*sum(X_ST_cumul(:,:))),COSTS(:,:,3));
        plot(EGBAU)
        xlabel('Product of Electric Grid and Basal Area');
        ylabel('Dollar Cost');
        title('Relationship between Total Cost and Input Product')
        % Get handle to current axes.
        ax = gca
            ax.Color = 'k';
            ax.YColor = 'r';
            ax.XAxis.FontSize = 12;
            ax.YAxis.FontSize = 12;
            ax.FontWeight = 'bold';
        hold off;
        savefig('EG_BA_PRODUCT_UN.fig')
        print('-f1','-dpng','EG_BA_PRODUCT_UN')
%
%Scatter of cumulative X_ST_cumul and cumulative Costs to identify which has a stronger trend in cost
modelfun=@(B,x) B(1).*log(x) + B(2);
X=sample.DIA;
Y=sample.HT;
[newcoeffs1,R1,J1,CovB1,MSE1,ErrorModelInfo1]=nlinfit(X,Y,modelfun,beta0);
mdsm=fitlm(X1,Y1);
new_y1=modelfun(newcoeffs1, X);


ST_C=fitlm(X1,Y1);
EG_C=fitlm(X1,Y1);
scatter(sum(X_ST_cumul(:,:)), sum(COST_SAVING(:,:,1)),'+')
scatter(EGicV(:,:), sum(COST_SAVING(:,:,1)),'o')


savefig('ST_Influence.fig')
print('-bestfit','-f1','-dpdf','ST_Influence')
savefig('EG_Influence.fig')
print('-bestfit','-f2','-dpdf','EG_Influence')
%Scatter of
finalmat='COST_BENEFIT.mat';
save(finalmat)
