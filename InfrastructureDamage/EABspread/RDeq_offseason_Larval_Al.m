function udot = RDeq_offseason_Larval_Al(t, u, Dirchilet,proceed, NM)
%takes initial condition u is a vector composite of both EAB and ASH
N=NM(1);
M=NM(2);



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

%Set parameters


%growthASH
Ghat=zeros(M*N,1);%=0.00483;
for i=proceed
	if ASH(i)/ASHicV(i)<0.1/FC(i)
		Ghat(i)=0.0346;%0.00483;
	else
		Ghat(i)=0.00483;
	end
end
%overcrowdingASH
Chat=0.0001403; %used to be Ca
%Timber Fall rate of Fraxinus Americana.  Proprtion per Month. Perry 2018
FALL=0.00296452855;%0.0029453;
%Standing Decay. Oberle 2018 From average decay constant.
RD=0.000837177359;%0.0008372;
%Fallen Decay. Oberle 2018
RF=0.009756926;%0.0098498;

EABLdot=zeros(M*N,1);
EABAdot=zeros(M*N,1);
FCdot=zeros(M*N,1);
ASHdot=zeros(M*N,1);
ASHicVdot=zeros(M*N,1);
STdot=zeros(M*N,1);
FTdot=zeros(M*N,1);
COdot=zeros(M*N,1);
RISKicVdot=zeros(M*N,1);
Rdot=zeros(M*N,1);
Poadot=zeros(M*N,1);
Pmpdot=zeros(M*N,1);
for i=proceed
	EABLdot(i)=0;%
	EABAdot(i)=0;%  (Jennings, 2016)
	ASHdot(i)=Ghat(i)*ASH(i)-(Chat*FC(i)*(ASH(i)^2)); %Will need modifying term to make it will have to be a long vector of the same size
	STdot(i)=0;%-(FALL*ST(i))-(RD*ST(i));
	FTdot(i)=0;%(FALL*ST(i))-(RF*FT(i));
	COdot(i)=0;%2013.23890044*((RD*ST(i))+(RF*FT(i)));
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
Rdot(Dirchilet)=0;
Poadot(Dirchilet)=0;
Pmpdot(Dirchilet)=0;

udot = [EABLdot(:);EABAdot(:);ASHdot(:);STdot(:);FTdot(:);COdot(:);FCdot(:);ASHicVdot(:);RISKicVdot(:);Rdot(:);Poadot(:);Pmpdot(:)];

clearvars -except udot

end
