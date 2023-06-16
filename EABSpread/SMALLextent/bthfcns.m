%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create Composit
%%%%bothfcns = @(udot,t) [@(u,t)Larval_Algebra(t, u, Dirchilet,proceed, NM,D); @(udot,t)RDeq_Larval_Al_lib(t, u, Dirchilet,proceed, NM,D)];



function udot = Larval_Algebra(t, u, Dirchilet,proceed, NM,D) %This function Algebraically updates u every timestep to change EABL Algebraically.
%takes initial condition u is a vector composite of both EAB and ASH
%Set parameters
N=NM(1);
M=NM(2);
%growthEAB
Gbar=12/4;%0.0751;  %used to be G
%overcrowdingEAB
Cbar=1228507.21;%289060.52;%0.000001497794673608411; %This function Algebraically updates u every timestep. Used to make the compposite function fed into ODE45

EABL=u(1:end*1/12);
EABL=EABL(:);
PRE=EABL(:);
EABA=u(end*1/12+1:end*2/12);
EABA=EABA(:);
ASH=u(end*2/12+1:end*3/12);
ASH=ASH(:);
ST=u(end*3/12+1:end*4/12);
ST=ST(:);
FT=u(end*4/12+1:end*5/12);
FT=FT(:);
CO=u(end*5/12+1:end*6/12);
CO=CO(:);
FC=u(end*6/12+1:end*7/12);
FC=FC(:);
ASHicV=u(end*7/12+1:end*8/12);
ASHicV=ASHicV(:);
RISKicV=u(end*8/12+1:end*9/12);
RISKicV=RISKicV(:);
R=u(end*9/12+1:end*10/12);
R=R(:);
Poa=u(end*10/12+1:end*11/12);
Poa=Poa(:);
Pmp=u(end*11/12+1:end*12/12);
Pmp=Pmp(:);


EABL1=u(1:end*1/12);
EABL1=EABL1(:);
EABA1=u(end*1/12+1:end*2/12);
EABA1=EABA1(:);
ASH1=u(end*2/12+1:end*3/12);
ASH1=ASH1(:);
ST1=u(end*3/12+1:end*4/12);
ST1=ST1(:);
FT1=u(end*4/12+1:end*5/12);
FT1=FT1(:);
CO1=u(end*5/12+1:end*6/12);
CO1=CO1(:);
FC1=u(end*6/12+1:end*7/12);
FC1=FC1(:);
ASHicV1=u(end*7/12+1:end*8/12);
ASHicV1=ASHicV1(:);
RISKicV1=u(end*8/12+1:end*9/12);
RISKicV1=RISKicV1(:);
R1=u(end*9/12+1:end*10/12);
R1=R1(:);
Poa1=u(end*10/12+1:end*11/12);
Poa1=Poa1(:);
Pmp1=u(end*11/12+1:end*12/12);
Pmp1=Pmp1(:);



EABL=EABL(:)+min(Gbar*EABA(:).*(1-Poa(:)),(Cbar*ASH(:)-PRE(:)));

EABL(Dirchilet)=0;
EABA(Dirchilet)=0;
ASH(Dirchilet)=0;
ST(Dirchilet)=0;
FT(Dirchilet)=0;
CO(Dirchilet)=0;
FC(Dirchilet)=0;
ASHicV(Dirchilet)=0;
RISKicV(Dirchilet)=0;
R(Dirchilet)=0;
Poa(Dirchilet)=0;
Pmp(Dirchilet)=0;

%%%%%growth of ASH annual term. Multipled by 1 over 12 to correct.
%%%%%Swaps depending on local ash quantity compared to initial
Ghat=zeros(M*N,1);%=0.00483;
for i=proceed
	if ASH(i)/ASHicV(i)<0.1/FC(i)
		Ghat(i)=0.0346;%from same paper for younger trees
	else
		Ghat(i)=0.00483;
	end
end
%%%%%
%overcrowdingASH
Chat=0.0001403; %used to be Ca
%lossASH remove multiple of 0.25 from runeq.m and replace with 1/12 in both sets if consumption is
%allowed in off season.
C=0.0000002724;
%Timber Fall rate of Fraxinus Americana.  Proprtion per Month. Perry 2018
FALL=0.00296452855;%0.0029453;
%Standing Decay. Oberle 2018 From average decay constant.
RD=0.000837177359;%0.0008372;
%Fallen Decay. Oberle 2018
RF=0.009756926;%0.0098498;
%parameters : spacing between spatial locations and the diffussion coefficient.
hs=100;

w=0;%Generalizable Mortality Rates
W=0;%Generalizable Mortality Rates

%Ash Stress Diffusion coefficient
As=ones(M*N,1);
Asf=zeros(M*N,1);
for i=proceed
	Asf(i)=(ASHicV(i)/FC(i))-ASH(i);
	if isnan(Asf(i))
		Asf(i)=0;
	end
	if Asf(i)<0.0016
		As(i)=1;
	elseif Asf(i)<=0.33
		As(i)=18.270401948842874543239951278928*Asf(i)+0.9707673568818516;
	else
		As(i)=7;
	end
end
As(Dirchilet)=1;
%Ash Abundance Coefficient
ASHb=zeros(M*N,1);

for i=proceed
ASHb(i)=10.0909-(0.263964*ASH(i));%(0.263964*ASH(i));
end

ASHb(Dirchilet)=0;

Ad=ones(M*N,1);
for i=proceed
Ad(i)=ASHb(i)/As(i);%1/As(i);%
end
Ad(Dirchilet)=1;


EABLdot=zeros(M*N,1);
EABAdot=zeros(M*N,1);
ASHdot=zeros(M*N,1);
STdot=zeros(M*N,1);
FTdot=zeros(M*N,1);
COdot=zeros(M*N,1);
RISKicVdot=zeros(M*N,1);
Rdot=zeros(M*N,1);
for i=proceed
	%proceed=proceed
	EABLdot(i)=w*EABL(i)-(EABL(i)*(Pmp(i)));
	%EABAdot(i)=D*(EABA(i+1)+EABA(i-1)-2*EABA(i))/hs^2+D*(EABA(i+M)+EABA(i-M)-2*EABA(i))/hs^2-W*EABA(i);
	EABAdot(i)=D*(Ad(i+1)*EABA(i+1)+Ad(i-1)*EABA(i-1)-2*Ad(i)*EABA(i))/hs^2+D*(Ad(i+M)*EABA(i+M)+Ad(i-M)*EABA(i-M)-2*Ad(i)*EABA(i))/hs^2-W*EABA(i)+(RISKicV(i)*R(i));%%+(RISKicV(i)*R(i));

	ASHdot(i)=Ghat(i)*ASH(i)-(Chat*FC(i)*(ASH(i)^2))-(C*EABL(i)*ASH(i));
	STdot(i)=-(FALL*ST(i))-(RD*ST(i));
	FTdot(i)=(FALL*ST(i))-(RF*FT(i));
	COdot(i)=2013.23890044*((RD*ST(i))+(RF*FT(i)));%This number is derived from the average carbon content of ash trees in NJ (12inch dbh class)
	FCdot(i)=0;
	ASHicVdot(i)=0;
	RISKicVdot(i)=0;
	Rdot(i)=0;
	Poadot(i)=0;
	Pmpdot(i)=0;
end


EABLdot(Dirchilet)=0;
EABAdot(Dirchilet)=0;
ASHdot(Dirchilet)=0;
STdot(Dirchilet)=0;
FTdot(Dirchilet)=0;
COdot(Dirchilet)=0;
FCdot(Dirchilet)=0;
ASHicVdot(Dirchilet)=0;
RISKicVdot(Dirchilet)=0;
R(Dirchilet)=0;
Poadot(Dirchilet)=0;
Pmpdot(Dirchilet)=0;

udot = [(EABL(:)+EABLdot(:)-EABL1(:));(EABA(:)+EABAdot(:)-EABA1(:));(ASH(:)+ASHdot(:)-ASH1(:));(ST(:)+STdot(:)-ST1(:));(FT(:)+FTdot(:)-FT1(:));(CO(:)+COdot(:)-CO1(:));(FC(:)+FCdot(:)-FC1(:));(ASHicV(:)+ASHicVdot(:)-ASHicV1(:));(RISKicV(:)+RISKicVdot(:)-RISKicV1(:));(R(:)+Rdot(:)-R1(:));(Poa(:)+Poadot(:)-Poa1(:));(Pmp(:)+Pmpdot(:)-Pmp1(:))];

clearvars -except udot %EABL1 EABA1 ASH1 FC1 ASHicV1 RISKicV1 R1 Poa1 Pmp1 As Asf

end
