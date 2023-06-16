
clear
clf
%Make Initial Conditions. Reshape vectors to matrix ~> back to vector. Ensures consistency in length between vectors.
  	IC=load('ASCII.2009.Essex.Larval.ASC');
  %Size Vectors for the input Matrix. Only lines that need to be changed to allow runs. sizex is columns and size y is rows.
    sizex=253;
    sizey=223;
  	EABAic=(reshape(IC(:,5),sizex,sizey))';%'
  %The next couple of lines set EAB sources to 5 individuals per positive spot. Remove or modify as needed.
  	sourceEAB=find(EABAic>0);
  	EABAic(sourceEAB)=5;
  %Find X, Y Coords and Vectorize for later reuse.
    Xcoord=(reshape(IC(:,1),sizex,sizey))';%'
    Ycoord=(reshape(IC(:,2),sizex,sizey))';%'
  %Reshapes the ASH vector from the GIS file into a matrix.
  %decomposed to fit formatting.
    EABLic=(reshape(IC(:,9),sizex,sizey))';%'
  	ASHic=(reshape(IC(:,7),sizex,sizey))';%'
    FCic=(reshape(IC(:,8),sizex,sizey))';%'
    RISKic=(reshape(IC(:,9),sizex,sizey))';%'
    sourceFC=find(FCic>101);
  	FCic(sourceFC)=100;



  %Now turn matrix into a long vector
  	[N, M] = size(ASHic);
  %Now turn matrix into a long vector
  	for i = [1:N]
  	    for j = [1:M]
      	    ASHicV((i-1)*M+j)=ASHic(i,j);
     	    end
     	end

  %Now turn matrix into a long vector
  	for i = [1:N]
  	    for j = [1:M]
      	    EABLicV((i-1)*M+j)=EABLic(i,j);
     	    end
     	end

  %Now turn matrix into a long vector
      for i = [1:N]
          for j = [1:M]
              EABAicV((i-1)*M+j)=EABAic(i,j);
            end
        end
  %Now turn matrix into a long vector
      	for i = [1:N]
      	    for j = [1:M]
          	    FCicV((i-1)*M+j)=FCic(i,j);
         	    end
         	end
  %Now turn matrix into a long vector
      	for i = [1:N]
           for j = [1:M]
               RISKicV((i-1)*M+j)=RISKic(i,j);
             end
        	end
%Xand Y Coords into vectors
        for i = [1:N]
            for j = [1:M]
                XcoordV((i-1)*M+j)=Xcoord(i,j);
              end
          end
        for i = [1:N]
        	   for j = [1:M]
          	    YcoordV((i-1)*M+j)=Ycoord(i,j);
           	   end
         	end
    L1=length(EABLicV);
    STicV=zeros(length(L1));
    FTicV=zeros(length(L1));
    COicV=zeros(length(L1));
  	EABLic=EABLic(:);
    EABAic=EABAic(:);
  	ASHic=ASHic(:);
    FCic=FCic(:);
    RISKic=RISKic(:);

    %%%%Risk factor Code Start%%%% Remove this section if the RISKic has justifiable values placed inside it.
    %%%%Places random Ones throughout matrix as potential start locations%%%%
      s = RandStream('mlfg6331_64');
          n = sizey*sizex; % Total length must be even to have even # of 0s and 1s.
          numberOfOnes = round(n/10);
          % Get a list of random locations, with no number repeating.
          indexA = randperm(s,n);
          % Start off with all zeros.
          RISKicV = zeros(1,n);
          % Now make them, in random locations, a 1.
          RISKicV(indexA(1:numberOfOnes)) = 1;
    %%%%TEMP Risk factor Code End%%%%

  %Set Zero Boundary Conditions
  	nullentries=find(ASHicV==-1);
  	nullentries=nullentries(:);
  	BCslots_vector=[1:M, (M+1):M:((N-1)*M+1), ((N-1)*M+1):N*M, (2*M):M:N*M];
  	BCslots_vector=BCslots_vector(:);
  	Dirchilet=[BCslots_vector;nullentries];
  	EABLicV(Dirchilet)=0;
    EABAicV(Dirchilet)=0;
  	ASHicV(Dirchilet)=0;
    FCicV(Dirchilet)=0;
    RISKicV(Dirchilet)=0;
    STicV(Dirchilet)=0;
    FTicV(Dirchilet)=0;
    COicV(Dirchilet)=0;

  %Build the actual ic that will be passed to function.
  	u=[EABLicV(:);EABAicV(:);ASHicV(:);STicV(:);FTicV(:);COicV(:);FCicV(:);ASHicV(:);RISKicV(:)];
  	tots=M*N*9;
  	if tots~=length(u)
      	u=[]
      	disp('Try again.')
    end


% Run Iterations using year number as defining factor trying not to use a for loop here, as a for loop would invalidate any parfor loops placed inside of it.
IN1=u;
years=1:21;
year=1;
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 2
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 3
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 4
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 5
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 6
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 7
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 8
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 9
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 10
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 11
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 12
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 13
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 14
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 15
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 16
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 17
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 18
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 19
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 20
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%Year 21
year=year+1
RDeq_run_Larval_Algebraic;
disp('And Another year Bites the Dust')
%End of manual calls
load('EAB_ASH_year1.mat')

for years=1:21 %Lay each X line together to form the whole run outputs
year=years;
load(sprintf('EAB_ASH_year%g.mat',year))
eval(sprintf('X_eab_L_cumul(%g,:)=IN1(1:L1);',year))
eval(sprintf('X_eab_A_cumul(%g,:)=IN1(L1+1:2*L1);',year))
eval(sprintf('X_ash_cumul(%g,:)=IN1(2*L1+1:3*L1);',year))
eval(sprintf('X_ST_cumul(%g,:)=IN1(3*L1+1:4*L1);',year))
eval(sprintf('X_FT_cumul(%g,:)=IN1(4*L1+1:5*L1);',year))
eval(sprintf('X_CO_cumul(%g,:)=IN1(5*L1+1:6*L1);',year))
end

FinalStateMat=zeros(9,L1);
FinalStateMat(1,:)=XcoordV(:);
FinalStateMat(2,:)=YcoordV(:);
FinalStateMat(3,:)=X_ash_cumul(21,:);
FinalStateMat(4,:)=X_eab_A_cumul(21,:);
FinalStateMat(5,:)=X_eab_L_cumul(21,:);
FinalStateMat(6,:)=X_ST_cumul(21,:);
FinalStateMat(7,:)=X_FT_cumul(21,:);
FinalStateMat(8,:)=X_CO_cumul(21,:);
FinalStateMat(9,:)=FCicV(:);
FinalStateMat=FinalStateMat.';%'
finalmat='RESULT.mat';
save(finalmat)
clearvars
