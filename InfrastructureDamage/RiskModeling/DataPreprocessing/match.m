%%%Applies an intersect function to loaded CSVs based on the first column of the files and resaves the result as a new CSV
%%%Thankfully Matlab seems to be able to check things. Could have looped this to make it pretty, but there are only five states so there''s no real need



%%%NJ
format long
opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NJ_TREE.csv');
opts = setvartype(opts,{'x___CN','PLT_CN','PREV_TRE_CN'},'int64');
A= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NJ_TREE.csv');

opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NJ_PLOT.csv');
opts = setvartype(opts,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');
B= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NJ_PLOT.csv',opts);
B.Properties.VariableNames{1} = 'PLT_CN';
V=join(A,B,'keys','PLT_CN');
V1=[V(:,1:20),V(:,22),V(:,35:38),V(:,55:56),V(:,108:109),V(:,208:228)];

%%%PA
format long
opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\PA_TREE.csv');
opts = setvartype(opts,{'x___CN','PLT_CN','PREV_TRE_CN'},'int64');
A= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\PA_TREE.csv');

opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\PA_PLOT.csv');
opts = setvartype(opts,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');
B= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\PA_PLOT.csv',opts);
B.Properties.VariableNames{1} = 'PLT_CN';
W=join(A,B,'keys','PLT_CN');
W1=[W(:,1:20),W(:,22),W(:,35:38),W(:,55:56),W(:,108:109),W(:,208:228)];

%%%NY
format long
opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NY_TREE.csv');
opts = setvartype(opts,{'x___CN','PLT_CN','PREV_TRE_CN'},'int64');
A= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NY_TREE.csv');

opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NY_PLOT.csv');
opts = setvartype(opts,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');
B= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\NY_PLOT.csv',opts);
B.Properties.VariableNames{1} = 'PLT_CN';
X=join(A,B,'keys','PLT_CN');
X1=[X(:,1:20),X(:,22),X(:,35:38),X(:,55:56),X(:,108:109),X(:,208:228)];

%%%DE
format long
opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\DE_TREE.csv');
opts = setvartype(opts,{'x___CN','PLT_CN','PREV_TRE_CN'},'int64');
A= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\DE_TREE.csv');

opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\DE_PLOT.csv');
opts = setvartype(opts,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');
B= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\DE_PLOT.csv',opts);
B.Properties.VariableNames{1} = 'PLT_CN';
Y=join(A,B,'keys','PLT_CN');
Y1=[Y(:,1:20),Y(:,22),Y(:,35:38),Y(:,55:56),Y(:,108:109),Y(:,208:228)];

%%%CT
format long
opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\CT_TREE.csv');
opts = setvartype(opts,{'x___CN','PLT_CN','PREV_TRE_CN'},'int64');
A= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\CT_TREE.csv');

opts=detectImportOptions('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\CT_PLOT.csv');
opts = setvartype(opts,{'CN','SRV_CN','CTY_CN','PREV_PLT_CN'},'int64');
B= readtable('D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\CT_PLOT.csv',opts);
B.Properties.VariableNames{1} = 'PLT_CN';
Z=join(A,B,'keys','PLT_CN');
Z1=[Z(:,1:20),Z(:,22),Z(:,35:38),Z(:,55:56),Z(:,108:109),Z(:,208:228)];

writetable(V1,'D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\joinNJ.csv','WriteRowNames',true)
writetable(W1,'D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\joinPA.csv','WriteRowNames',true)
writetable(X1,'D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\joinNY.csv','WriteRowNames',true)
writetable(Y1,'D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\joinDE.csv','WriteRowNames',true)
writetable(Z1,'D:\ArcGIS MAP EAB\EAB New Maps Folder\EAB New Maps Folder\joinCT.csv','WriteRowNames',true)
match='Match.mat';
save(match)
