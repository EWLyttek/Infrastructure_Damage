%%%%%%%Run upon loading RESULT.mat files to create the appropriate figures. CUrrently Creates a Yearly map and a line graph for each major population.
%%%%%%%Additional: Track fallen and decaying timbers, Track the distribution of parasitism rates.

clf
clf


load('RESULT.mat')
X_eab_cumulat=EABAicV;
for i=2:21
eval(sprintf('X=X_eab_A_cumul(%g,:);',i))
X_eab_cumulat=[X_eab_cumulat;X];
end

X_ash_cumulat=ASHicV;
for i=2:21
eval(sprintf('X=X_ash_cumul(%g,:);',i))
X_ash_cumulat=[X_ash_cumulat;X];
end

X_eab_sum=sum(X_eab_cumulat,2);
X_ash_sum=sum(X_ash_cumulat,2);

length=1:21;
yyaxis left
plot(length,X_eab_sum,'LineWidth', 3);
ylabel('EAB','FontSize',30);
hold on
yyaxis right
plot(length,X_ash_sum,'--','LineWidth', 3);
xlabel('Time (Years)','FontSize',30);
ylabel('Ash Basal Area','FontSize',30);
axis([1 21 0 inf])
savefig('Ash_EAB_Line.fig')
print('-bestfit','-f1','-dpdf','EAB_AshLine')

clf
clf

%make colormap map
		map=zeros(100,3);
		map(1,3)=1;
		map(:,2)=linspace(1,.2);
		map(:,1)=linspace(0,.1);

		%colormap(map)

		hotM=hot;
        hotM(1,:)=0;
        hotM(1,3)=1;

X_eab=EABAicV(1,:);
					X_eab_map=transpose(reshape(X_eab,M,N));
					X_eab_map2=X_eab_map;
					figure(2)
					imagesc(X_eab_map2);

X_ash=ASHicV(1,:);
					X_eab_map=transpose(reshape(X_ash,M,N));
					X_eab_map2=X_eab_map;
					figure(5)
					imagesc(X_eab_map2);

X_FC=FCicV(1,:);
					X_eab_map=transpose(reshape(X_FC,M,N));
					X_eab_map2=X_eab_map;
					figure(6)
					imagesc(X_eab_map2);
figure(3)
imagesc(Xcoord);

figure(4)
imagesc(Ycoord);




  X_eab=X_eab_cumulat(1,:);
        X_eab(nullentries)=-1000;
        X_eab_map=transpose(reshape(X_eab,M,N));
        X_eab_map2=X_eab_map;
        figure(2)
				subplot(4,2,1)
        ax1=subplot(4,2,1);
				pos = get(gca, 'Position');
				pos(1) = 0.1;
				pos(2) = 0.709;
				pos(3) = 0.25;
				pos(4) = 0.25;
				set(gca, 'Position', pos)
        imagesc(X_eab_map2);
        colormap(ax1,hotM)
        %colorbar
        caxis([-1000 60000])
				pbaspect([1 1 1])
        xlabel('X (22.5km)');
        ylabel('Y (25km)');
        title('1a-EAB')

  X_eab=X_eab_cumulat(2,:);
        X_eab(nullentries)=-1000;
        X_eab_map=transpose(reshape(X_eab,M,N));
        X_eab_map2=X_eab_map;
        subplot(4,2,3)
        ax2=subplot(4,2,3);
				pos = get(gca, 'Position');
				pos(1) = 0.1;
				pos(2) = 0.2;
				pos(3) = 0.25;
				pos(4) = 0.25;
				set(gca, 'Position', pos)
        imagesc(X_eab_map2);
        colormap(ax2,hotM)
        %colorbar
        caxis([-1000 60000])
        %colormap(hotM)
				pbaspect([1 1 1])
        xlabel('X (22.5km)');
        ylabel('Y (25km)');
        title('1b-EAB')

X_ash=X_ash_cumulat(1,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
	subplot(4,2,2)
  ax3=subplot(4,2,2);
	pos = get(gca, 'Position');
	pos(1) = 0.45;
	pos(2) = 0.709;
	pos(3) = 0.25;
	pos(4) = 0.25;
	set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(2,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')


savefig('Year1_2.fig')
print('-bestfit','-f2','-dpdf','FigureEABSPREAD_Year1_2')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(3,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(4,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(3,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(4,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years3_4.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year3_4')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(5,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(6,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(5,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(6,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years5_6.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year5_6')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(7,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(8,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(7,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(8,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years7_8.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year7_8')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(9,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(10,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(9,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(10,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years9_10.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year9_10')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(11,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(12,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(11,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(12,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years11_12.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year11_12')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(13,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(14,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(13,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(14,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years13-14.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year13_14')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(15,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(16,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(15,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(16,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years15-16.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year15_16')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(17,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(18,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(17,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(18,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years17_18.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year17_18')

clf
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_eab=X_eab_cumulat(19,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      figure(1)
      subplot(4,2,1)
      ax1=subplot(4,2,1);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.709;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax1,hotM)
      %colorbar
      caxis([-1000 60000])
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1a-EAB')

X_eab=X_eab_cumulat(20,:);
      X_eab(nullentries)=-1000;
      X_eab_map=transpose(reshape(X_eab,M,N));
      X_eab_map2=X_eab_map;
      subplot(4,2,3)
      ax2=subplot(4,2,3);
      pos = get(gca, 'Position');
      pos(1) = 0.1;
      pos(2) = 0.2;
      pos(3) = 0.25;
      pos(4) = 0.25;
      set(gca, 'Position', pos)
      imagesc(X_eab_map2);
      colormap(ax2,hotM)
      %colorbar
      caxis([-1000 60000])
      %colormap(hotM)
      pbaspect([1 1 1])
      xlabel('X (22.5km)');
      ylabel('Y (25km)');
      title('1b-EAB')

X_ash=X_ash_cumulat(19,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,2)
ax3=subplot(4,2,2);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.709;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax3,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1a-Ash')

X_ash=X_ash_cumulat(20,:);
X_ash(nullentries)=-1;
X_ash_map=transpose(reshape(X_ash,M,N));
X_ash_map2=X_ash_map;
subplot(4,2,4)
ax4=subplot(4,2,4);
pos = get(gca, 'Position');
pos(1) = 0.45;
pos(2) = 0.2;
pos(3) = 0.25;
pos(4) = 0.25;
set(gca, 'Position', pos)
imagesc(X_ash_map2);
%colorbar
caxis([-1 40])
colormap(ax4,map)
pbaspect([1 1 1])
xlabel('X (22.5km)');
ylabel('Y (25km)');
title('1b-Ash')

savefig('Years19_20.fig')
print('-bestfit','-f1','-dpdf','FigureEABSPREAD_Year19_20')
