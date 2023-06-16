%  %Runs ode45 on a coupled reaction diffusion equation meant to model
%  %the spread of emerald ash borer.
%  %Needs function files as seen in the ode45 statements. Runs for number of year
%  %indicated below. Split into 4 months of diffusion and 8 months of stagnation.

% Solver options
  options = odeset('RelTol',1e-6,'AbsTol',1e-6);
  proceed=[1:N*M];
  proceed(BCslots_vector)=[];
  NM=[N M];
  %spatial width of the cells
  hs=100;
  hp=10;
  L1=length(EABLicV);
  prev_NOY=year-1;


  seed=100*rand(1);
  s = RandStream('mlfg6331_64','Seed',seed);
  %New vectors
    %Parasitoid Vectors
    Poa=(0.62-0.12).*rand(s,1,N*M)+0.12;%Poa=(0.155-0.03).*rand(s,1,N*M)+0.03;
    Pmp=(0.83268-0.02027).*rand(s,1,N*M)+0.02027;
    Pps=1-(0.02.*randn(s,1,N*M)+0.32);
      %Delayed Introduction
        if year<1
        Poa=zeros(1,N*M);
        Pmp=zeros(1,N*M);
        Pps=ones(1,N*M);
      else
        Poa=Poa(:);
        Pmp=Pmp(:);
        Pps=Pps;
      end
  %Parasitoid End
  %%%Risk Point Selection Start%%%
     R=rand(s,1,n)<.0027;%Rate of incidence for local incidence of new EAB satellites
  %%%Risk Point Selection End%%%
  u=[IN1(:);R(:);Poa(:);Pmp(:)];
  tots=M*N*12;
    if tots~=length(u)
      u=[]
      disp('Try again.')
    end
clear R
IN1=u;
D_vector=1:81;
YearlyPoa.(sprintf('Y%d', year))=Poa(:);
YearlyPmp.(sprintf('Y%d', year))=Pmp(:);
YearlyPps.(sprintf('Y%d', year))=Pps(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.*(1-Pps(:))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Begin Running Solver. Only portion where a parrallel solver makes some sense.

  tic

  parfor Du=1:numel(D_vector) %Make main for loop for all values Du,opts
    D=pi*((Du-0.5)*10/4).^2;
    %The initial run, first from 0-4 months, then from 4-12 months
      [T1a X1a] = ode45(@bthfcns, [0:0.1:4], IN1, options, Dirchilet, proceed, NM,D);
      [T1b X1b] = ode45(@RDeq_offseason_Larval_Al, [4:0.1:12], X1a(end,:), options, Dirchilet, proceed, NM);
    %Run Finished with one diffusion value Conduct Modifications on output for packing
      PROP=(((.2708/7.3198)*exp(-.037*(((Du-0.5)*10)-hp/2))+(.2708/7.3198)*exp(-.037*(((Du-0.5)*10)+hp/2)))*hp/2)/1.011260648225738;
      %Packing
        X1b(end,1:L1)=X1b(end,1:L1).*Pps(1,1:L1);
        rfields{Du} = [zeros(1,L1),X1b(end,1:L1)*PROP,X1b(end,2*L1+1:3*L1)*PROP,X1b(end,3*L1+1:4*L1)*PROP,X1b(end,4*L1+1:5*L1)*PROP,X1b(end,5*L1+1:6*L1)*PROP,X1b(end,6*L1+1:7*L1)*PROP,X1b(end,7*L1+1:8*L1)*PROP,X1b(end,8*L1+1:9*L1)*PROP];
        mfields{Du} = [PROP*X1a(end,1:L1),PROP*X1a(end,L1+1:2*L1),PROP*X1a(end,2*L1+1:3*L1),PROP*X1a(end,3*L1+1:4*L1),PROP*X1a(end,4*L1+1:5*L1),PROP*X1a(end,5*L1+1:6*L1)];
      %Clear Variables To be Repeated in next loop
        disp('And another Du down...')
         X1b = [];
         X1a = [];
         T1b = [];
         T1a = [];
         D   = [];
  end

  et = toc
  for Du=1:81 %Make for loop ordered packager for all values Du
    YearlyDataBase.(sprintf('EN%d', Du))=rfields{Du};
    MidSeasonDB.(sprintf('EN%d', Du))=mfields{Du};
  end
  clear('X','T','X1b','X1a','T1a','T1b')

%package IN1Du files into new IN1
  IN1=zeros(1,9*n);
  for Du=1:81
    Dx=sprintf('EN%g',Du);
    IN1=IN1+YearlyDataBase.(Dx);
    IN1(6*L1+1:7*L1)=FCicV(1:end);
    IN1(7*L1+1:8*L1)=ASHicV(1:end);
    IN1(8*L1+1:9*L1)=RISKicV(1:end);
  end

  clear YearlyDataBase MidSeasonDB

    Year=sprintf('EAB_ASH_year%g.mat',year)
    save(Year)
  %End Code
    disp('Done with a year')
