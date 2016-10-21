function [dekLin,dekSen,pravac,linPrav, pValue,taubSig]=TrendRez(ulaz,dekada)

%Funkcija racuna trendove (linearni i Sen-ov) po dekadi i znacajnost
% priprema pravce za crtanje

% pravac: pravac sa Senovim nagibom
% linPrav: pravac linearna regresija
% dekLin: trend izrazen po dekadi LINEARNI
% dekSen: trend izrazen po dekadi SEN-ov
% pValue: znacajnost = 1 u matrici taubSig


nGod =length(ulaz);

    switch dekada
    case 1
        dek=10;
    case 0
        dek=1;
    end
% ulazNan=ulaz;
% ulazNan(isnan(ulazNan))=[];
 % za Linearan trend
 x=(1:length(ulaz))';

zpFid = fopen('Ftaub_poruke.txt','w');
   
        datain=zeros(length(ulaz),2);
         
         datain(:,1)=(1:nGod)';
         datain(:,2)=ulaz;     
              
         [taub tau h sig Z S sigma sen ]... 
               = ktaub1(datain, 0.05,0,zpFid) ;%n senplot CIlower  CIupper D Dall C3
           
          taubSig=h;
          SenSlope=sen;
          dekSen=SenSlope*dek;
          pValue=sig; 
 
% Crta se cijeli niz (i nedostajuce godine)
% datain1(:,1)=(1:nGod)';datain1(:,2)=ulaz;
pravac = datain(:,2)-(SenSlope*(datain(:,1)-datain(1,1)));
pravac(1) = nanmedian(pravac);
pravac = pravac(1) + SenSlope * (datain(:,1) - datain(1,1)); 
 
  % Linearni trend, procjena + za crtanje
  no = ~isnan(ulaz);
  trend_god= polyfit(x(no),ulaz(no),1);
 
 % trend izrazen samo po dekadi
  dekLin=trend_god(1,1)*dek;
             
  linPrav = polyval(trend_god,x);
  
  
  fclose(zpFid)
  
  
  
  
