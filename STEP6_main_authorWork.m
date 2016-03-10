close all; clear all; clc

%Note: povezi ispravno tocke i mjerenja; povezi ispravno redoslijed modela
%Note: set to zero if pr after adjustment less than 0

TYPEtxt      ={'rgrid', 'BiasCorr'};
TYPEtxt2_corr={'RCM', 'RCMcorr','RCMcorr adj'};

%--------------------------------------------------------------------------
%Veza DHMZ mjerenja <-> tocke modela
%--------------------------------------------------------------------------
%T2m
OBStoRCM1=[5 6 7 4 1 2 3];
%R
OBStoRCM2=[1 3 4 2 13 14 15];

%--------------------------------------------------------------------------
%Redoslijed stanica iz RCM-a
%--------------------------------------------------------------------------
        %LON[1]=13.9453;   LAT[1]=45.2408; # Pazin
        %LON[2]=13.9300;   LAT[2]=45.4308; # Abrami
        %LON[3]=13.6036;   LAT[3]=45.2203; # Porec
        %LON[4]=13.5833;   LAT[4]=45.3333; # Novigrad Celega
        %LON[5]=17.6431;   LAT[5]=43.0464; # Metkovic
        %LON[6]=17.4428;   LAT[6]=43.0475; # Ploce
        %LON[7]=17.5586;   LAT[7]=43.0175; # Opuzen
StationTXT={'Pazin','Abrami','Porec','Celega','Metkovic','Ploce','Opuzen'};

%--------------------------------------------------------------------------
%Pomocna tablica CEDO
%--------------------------------------------------------------------------
%               ____________ tip: RCMcorr, RCMcorr_adj
%              |  __________ izvori: 3 RCM, EOBS, DHMZ
%              | |  ________ varijable: tas, pr
%              | | |  ______ periodi: 1951-2000, 1961-2000
%              | | | |  ____ stanice: 1 do 7
%              | | | | |  __ mjera: mean, std
%              | | | | | |
%              V V V V V V
TABLA_CEDO=nan(2,5,2,2,7,2);

B=0;
for STAT=[1 7];
for TYPE=[  2]; 
    disp(num2str(STAT))
    B=B+1;
       
% % % %-------------------------------------------------------------------
% % %        % ---> citam T2m
% % % %-------------------------------------------------------------------
% % %        STAT_read=STAT; if (STAT==3); STAT_read=4; end %modifikacija Porec > Celega za EOBS i RCMS
% % %        
% % %        %RCM od 1951 do 2000
% % %        for MOD=[1:3]; 
% % %             AC_P0_tas_RCM_mom(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_tas_STAT',num2str(STAT_read),'_P0_YMmean.nc']         ,'tas_mon');
% % %             AC_P0_tas_RCM_std(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_tas_STAT',num2str(STAT_read),'_P0_YMstd.nc']          ,'tas_mon');
% % %             TS_HIST_tas_RCM_YMmean(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_tas_STAT',num2str(STAT_read),'_HIST_YEARmean.nc'],'tas_mon');
% % %        end %od MOD
% % %        for MOD=[1:3]; %FUT
% % %             AC_P1_tas_RCM_mom(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_tas_STAT',num2str(STAT_read),'_P1_YMmean.nc'],'tas_mon');
% % %             temp=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_tas_STAT',num2str(STAT_read),'_FUT_YEARmean.nc']                 ,'tas_mon');
% % %             TS_FUT_tas_RCM_YMmean(:,MOD)=temp(1:50);
% % %        end %od MOD
% % %        
% % %        %EOBS od 1951 do 2009
% % %             AC_P0_tas_EOBS_mom(1:12)=ncread(['./files_STAT_derived/EOBS_HIST_tas_STAT',num2str(STAT_read),'_P0_YMmean.nc'],'tg_mon');
% % %             AC_P0_tas_EOBS_std(1:12)=ncread(['./files_STAT_derived/EOBS_HIST_tas_STAT',num2str(STAT_read),'_P0_YMstd.nc'],'tg_mon');
% % %             TS_HIST_tas_EOBS_YMmean(1:59)=ncread(['./files_STAT_derived/EOBS_HIST_tas_STAT',num2str(STAT_read),'_HIST_YEARMean.nc'],'tg_mon');
% % %             
% % %        %DHMZ od 1961 do 2012
% % %        load('./from_DHMZ_KC/SezoneTemp.mat');
% % %        temp=ulazSvi(:,2:13,OBStoRCM1(STAT));
% % %             AC_P0_tas_DHMZ_mom=nanmean(temp(1:30,:));
% % %             AC_P0_tas_DHMZ_std= nanstd(temp(1:30,:),1);
% % %             TS_HIST_tas_DHMZ_YMmean=[NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN SezoneSvi(:,5,OBStoRCM1(STAT))'];
% % %            
% % % %-------------------------------------------------------------------
% % %        % ---> citam R
% % % %-------------------------------------------------------------------
% % %        %RCM od 1951 do 2000
% % %        for MOD=[1:3]; 
% % %             AC_P0_pr_RCM_mom(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_pr_STAT',num2str(STAT_read),'_P0_YMmean.nc']         ,'rr_mon');
% % %             AC_P0_pr_RCM_std(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_pr_STAT',num2str(STAT_read),'_P0_YMstd.nc']          ,'rr_mon');
% % %             TS_HIST_pr_RCM_YMmean(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_pr_STAT',num2str(STAT_read),'_HIST_YEARmean.nc'],'rr_mon');
% % %        end %od MOD
% % %        for MOD=[1:3]; %FUT
% % %             AC_P1_pr_RCM_mom(:,MOD)=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_pr_STAT',num2str(STAT_read),'_P1_YMmean.nc'],'rr_mon');
% % %             temp=ncread(['./files_STAT_derived/MOD',num2str(MOD),'_',TYPEtxt{TYPE},'_pr_STAT',num2str(STAT_read),'_FUT_YEARmean.nc'],'rr_mon');
% % %             TS_FUT_pr_RCM_YMmean(:,MOD)=temp(1:50);
% % %        end %od MOD
% % %        
% % %        %EOBS od 1951 do 2009
% % %             AC_P0_pr_EOBS_mom(1:12)=ncread(['./files_STAT_derived/EOBS_HIST_pr_STAT',num2str(STAT_read),'_P0_YMmean.nc']         ,'rr_mon');
% % %             AC_P0_pr_EOBS_std(1:12)=ncread(['./files_STAT_derived/EOBS_HIST_pr_STAT',num2str(STAT_read),'_P0_YMstd.nc']          ,'rr_mon');
% % %             TS_HIST_pr_EOBS_YMmean(1:59)=ncread(['./files_STAT_derived/EOBS_HIST_pr_STAT',num2str(STAT_read),'_HIST_YEARMean.nc'],'rr_mon');
% % %             
% % %        %DHMZ od 1961 do 2012
% % %        load('./from_DHMZ_KC/SezoneObo.mat');
% % %        temp=ulazSvi(:,2:13,OBStoRCM2(STAT));
% % %             AC_P0_pr_DHMZ_mom=nanmean(temp(1:30,:));
% % %             AC_P0_pr_DHMZ_std=nanstd(temp(1:30,:),1);    
% % %             TS_HIST_pr_DHMZ_YMmean=[NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN SezoneSvi(:,5,OBStoRCM2(STAT))'];
% % %               
% % % %------------------------------------------------------------------------
% % %      % Citam nizove bez CDO postproc      
% % % %------------------------------------------------------------------------
% % %      if (TYPE==2);
% % %        for MOD=[1:3]
% % %            fifa=['./files_STAT/MOD',num2str(MOD),'_HIST_BiasCorr_tas_STAT',num2str(STAT_read),'.nc']; MM{:,MOD,1,1}=ncread(fifa,'tas_mon');
% % %            fifa=['./files_STAT/MOD',num2str(MOD),'_HIST_BiasCorr_pr_STAT',num2str(STAT_read),'.nc'];  MM{:,MOD,1,2}=ncread(fifa,'rr_mon');
% % %            fifa=['./files_STAT/MOD',num2str(MOD),'_FUT_BiasCorr_tas_STAT',num2str(STAT_read),'.nc'];  temp=ncread(fifa,'tas_mon'); MM{:,MOD,2,1}=temp(1:600);
% % %            fifa=['./files_STAT/MOD',num2str(MOD),'_FUT_BiasCorr_pr_STAT',num2str(STAT_read),'.nc'];   temp=ncread(fifa,'rr_mon');  MM{:,MOD,2,2}=temp(1:600);
% % %        end
% % %      end
% % % %------------------------------------------------------------------------
% % %      % Spremamo u mat datoteke       
% % % %------------------------------------------------------------------------
% % %        if (STAT==1); if (TYPE==1) save stat1_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==1); if (TYPE==2) save stat1_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==2); if (TYPE==1) save stat2_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==2); if (TYPE==2) save stat2_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==3); if (TYPE==1) save stat3_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==3); if (TYPE==2) save stat3_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==4); if (TYPE==1) save stat4_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==4); if (TYPE==2) save stat4_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==5); if (TYPE==1) save stat5_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==5); if (TYPE==2) save stat5_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==6); if (TYPE==1) save stat6_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==6); if (TYPE==2) save stat6_type2.mat AC_* TS_* MM ; end; end
% % %        if (STAT==7); if (TYPE==1) save stat7_type1.mat AC_* TS_*    ; end; end
% % %        if (STAT==7); if (TYPE==2) save stat7_type2.mat AC_* TS_* MM ; end; end
       
%------------------------------------------------------------------------
% Citamo iz mat datoteka       
%------------------------------------------------------------------------
disp('Citam...')
       if (STAT==1); if (TYPE==1); load stat1_type1.mat AC_* TS_*     ; end; end
       if (STAT==1); if (TYPE==2); load stat1_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==2); if (TYPE==1); load stat2_type1.mat AC_* TS_*     ; end; end
       if (STAT==2); if (TYPE==2); load stat2_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==3); if (TYPE==1); load stat3_type1.mat AC_* TS_*     ; end; end
       if (STAT==3); if (TYPE==2); load stat3_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==4); if (TYPE==1); load stat4_type1.mat AC_* TS_*     ; end; end
       if (STAT==4); if (TYPE==2); load stat4_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==5); if (TYPE==1); load stat5_type1.mat AC_* TS_*     ; end; end
       if (STAT==5); if (TYPE==2); load stat5_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==6); if (TYPE==1); load stat6_type1.mat AC_* TS_*     ; end; end
       if (STAT==6); if (TYPE==2); load stat6_type2.mat AC_* TS_* MM  ; end; end
       if (STAT==7); if (TYPE==1); load stat7_type1.mat AC_* TS_*     ; end; end
       if (STAT==7); if (TYPE==2); load stat7_type2.mat AC_* TS_* MM  ; end; end    
              
%-------------------------------------------------------------------
       % ---> racunam ecdf od godisnjih srednjaka za 1961-1990
%-------------------------------------------------------------------
disp('Racunam...')
       ecdf_y=[1/30:1/30:1];
       %RCM
       for MOD=[1:3];
            ecdf_tas_RCM_YMmean_P0(:,MOD) =sort(TS_HIST_tas_RCM_YMmean(11:40,MOD)); 
             ecdf_pr_RCM_YMmean_P0(:,MOD) =sort(TS_HIST_pr_RCM_YMmean(11:40,MOD)); 
            ecdf_tas_RCM_YMmean_P1(:,MOD) =sort(TS_FUT_tas_RCM_YMmean(21:50,MOD)); 
             ecdf_pr_RCM_YMmean_P1(:,MOD) =sort(TS_FUT_pr_RCM_YMmean(21:50,MOD));
       end
       %EOBS
            ecdf_tas_EOBS_YMmean_P0=sort(TS_HIST_tas_EOBS_YMmean(11:40));
            ecdf_pr_EOBS_YMmean_P0 =sort(TS_HIST_pr_EOBS_YMmean(11:40)); 
       %DHMZ     
            temp=TS_HIST_tas_DHMZ_YMmean(11:40); ind=isnan(temp); temp(ind)=[];
            ecdf_tas_DHMZ_YMmean_P0=sort(temp);
            temp=TS_HIST_pr_DHMZ_YMmean(11:40); ind=isnan(temp); temp(ind)=[];
            ecdf_pr_DHMZ_YMmean_P0=sort(temp);
            NDHMZ=sum(isfinite(TS_HIST_tas_DHMZ_YMmean(11:40))); ecdf_y_DHMZ_tas=[1/NDHMZ:1/NDHMZ:1];
            NDHMZ=sum(isfinite(TS_HIST_pr_DHMZ_YMmean(11:40)));  ecdf_y_DHMZ_pr=[1/NDHMZ:1/NDHMZ:1];
            
%-------------------------------------------------------------------
% ---> racunam coefficient of variation
%-------------------------------------------------------------------
       %RCM
       for MOD=[1:3];
            AC_P0_pr_RCM_cv(:,MOD)=AC_P0_pr_RCM_std(:,MOD)./AC_P0_pr_RCM_mom(:,MOD);           
       end
       %EOBS
            AC_P0_pr_EOBS_cv=AC_P0_pr_EOBS_std./AC_P0_pr_EOBS_mom;
       %DHMZ
            AC_P0_pr_DHMZ_cv=AC_P0_pr_DHMZ_std./AC_P0_pr_DHMZ_mom;
 
%-------------------------------------------------------------------
% ---> racunam znacajnost P1 vs P0 razlika
%-------------------------------------------------------------------
    AC_t2m_P0_vs_P1_sig=nan(12,3);
    AC_pr_P0_vs_P1_sig=nan(12,3);
        for MOD=[1:3]
            for MON=[1:12]
                a=squeeze(MM{:,MOD,1,1});
                b=squeeze(MM{:,MOD,2,1});
                [P,H]=ranksum(a(10*12+MON:12:40*12),b(20*12+MON:12:50*12));  if (H==1); AC_t2m_P0_vs_P1_sig(MON,MOD)=1; end
                a=squeeze(MM{:,MOD,1,2});
                b=squeeze(MM{:,MOD,2,2});
                [P,H]=ranksum(a(10*12+MON:12:40*12),b(20*12+MON:12:50*12));  if (H==1);  AC_pr_P0_vs_P1_sig(MON,MOD)=1; end               
            end
        end
%-------------------------------------------------------------------
% ---> racunam znacajnost DHMZ vs RCM razlika u P0
%-------------------------------------------------------------------
        load('./from_DHMZ_KC/SezoneTemp.mat');
        temp=ulazSvi(:,2:13,OBStoRCM1(STAT));
        AC_P0_tas_DHMZ_ts=temp(1:30,:);
        load('./from_DHMZ_KC/SezoneObo.mat');
        temp=ulazSvi(:,2:13,OBStoRCM2(STAT));
        AC_P0_pr_DHMZ_ts=temp(1:30,:);

    AC_t2m_DHMZ_vs_RCM_sig=nan(12,3);
     AC_pr_DHMZ_vs_RCM_sig=nan(12,3);
        for MOD=[1:3]
            for MON=[1:12]
                a=squeeze(MM{:,MOD,1,1});
                b=AC_P0_tas_DHMZ_ts(:,MON); b_leng(MON,1)=sum(isfinite(b));
                [P,H]=ranksum(a(10*12+MON:12:40*12),b);  if (H==1); AC_t2m_DHMZ_vs_RCM_sig(MON,MOD)=1; end
                a=squeeze(MM{:,MOD,1,2});
                b=AC_P0_pr_DHMZ_ts(:,MON);  b_leng(MON,2)=sum(isfinite(b));
                [P,H]=ranksum(a(10*12+MON:12:40*12),b);  if (H==1);  AC_pr_DHMZ_vs_RCM_sig(MON,MOD)=1; end               
            end
        end

%%            
%-------------------------------------------------------------------     
% ---> crtam T2m RCMcorr
%-------------------------------------------------------------------
disp('Crtam...')
       figure(B); set(gcf,'Position',[314 33 560 795],'PaperPositionMode','auto','visible','on')
            subplot(4,2,1)
                plot([1:12],AC_P0_tas_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_mom,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_RCM_mom(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_mom(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_mom(:,3),'m'); hold on
                    xlim([1  12])
                    if (STAT==1); ylim([0 25]); end
                    if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{TYPE}]); end
                    ylabel('mean t (deg C)'); xlabel('time (month)')
                    ttt=text(-0.1,1.15,'a)','units','normalized'); 
                
            subplot(4,2,3)
                plot([1:12],AC_P0_tas_EOBS_std,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_std,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_RCM_std(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_std(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_std(:,3),'m'); hold on
                    xlim([1  12])
                    ylabel('std t (deg C)'); xlabel('time (month)')
                    ttt=text(-0.1,1.15,'c)','units','normalized');

            subplot(4,2,5)       
                plot([1:50],TS_HIST_tas_EOBS_YMmean(1:50),'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_DHMZ_YMmean(1:50),'r','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,2),'b'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,1),'k'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,3),'m'); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylabel('mean t (deg C)'); xlabel('time (year)')
                    ttt=text(-0.1,1.15,'e)','units','normalized');
                    %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,1))/(12*30)*100*10)/10),'%'];
                    %%%text(0.05,0.9,udio,'units','normalized')
                    %---------------------------------------------> Tabla Cedo
                        TABLA_CEDO(1,1,1,1,STAT,1)=mean(TS_HIST_tas_RCM_YMmean( 1:50,2)); TABLA_CEDO(1,1,1,1,STAT,2)=std(TS_HIST_tas_RCM_YMmean( 1:50,2),1);
                        TABLA_CEDO(1,1,1,2,STAT,1)=mean(TS_HIST_tas_RCM_YMmean(10:50,2)); TABLA_CEDO(1,1,1,2,STAT,2)=std(TS_HIST_tas_RCM_YMmean(11:50,2),1);
                        TABLA_CEDO(1,2,1,1,STAT,1)=mean(TS_HIST_tas_RCM_YMmean( 1:50,1)); TABLA_CEDO(1,2,1,1,STAT,2)=std(TS_HIST_tas_RCM_YMmean( 1:50,1),1);
                        TABLA_CEDO(1,2,1,2,STAT,1)=mean(TS_HIST_tas_RCM_YMmean(10:50,1)); TABLA_CEDO(1,2,1,2,STAT,2)=std(TS_HIST_tas_RCM_YMmean(11:50,1),1);
                        TABLA_CEDO(1,3,1,1,STAT,1)=mean(TS_HIST_tas_RCM_YMmean( 1:50,3)); TABLA_CEDO(1,3,1,1,STAT,2)=std(TS_HIST_tas_RCM_YMmean( 1:50,3),1);
                        TABLA_CEDO(1,3,1,2,STAT,1)=mean(TS_HIST_tas_RCM_YMmean(10:50,3)); TABLA_CEDO(1,3,1,2,STAT,2)=std(TS_HIST_tas_RCM_YMmean(11:50,3),1);
                        TABLA_CEDO(1,4,1,1,STAT,1)=mean(TS_HIST_tas_DHMZ_YMmean( 1:50));  TABLA_CEDO(1,4,1,1,STAT,2)=std(TS_HIST_tas_DHMZ_YMmean( 1:50),1);
                        TABLA_CEDO(1,4,1,2,STAT,1)=nanmean(TS_HIST_tas_DHMZ_YMmean(10:50));  TABLA_CEDO(1,4,1,2,STAT,2)=nanstd(TS_HIST_tas_DHMZ_YMmean(11:50),1);
                        TABLA_CEDO(1,5,1,1,STAT,1)=mean(TS_HIST_tas_EOBS_YMmean( 1:50));  TABLA_CEDO(1,5,1,1,STAT,2)=std(TS_HIST_tas_EOBS_YMmean( 1:50),1);
                        TABLA_CEDO(1,5,1,2,STAT,1)=mean(TS_HIST_tas_EOBS_YMmean(10:50));  TABLA_CEDO(1,5,1,2,STAT,2)=std(TS_HIST_tas_EOBS_YMmean(11:50),1);
                        
                        
                        
                        
            subplot(4,2,7)   
                stairs(ecdf_tas_EOBS_YMmean_P0,ecdf_y         ,'g','Linewidth',2); hold on
                stairs(ecdf_tas_DHMZ_YMmean_P0,ecdf_y_DHMZ_tas,'r','Linewidth',2); hold on            
                stairs(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_y,'b'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_y,'k'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_y,'m'); hold on
                    ylim([0   1])
                    xlabel('mean annual t (deg C)'); ylabel('CDF');  set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    ttt=text(-0.1,1.15,'g)','units','normalized');
            
%-------------------------------------------------------------------             
% ---> crtam R RCMcorr
%-------------------------------------------------------------------
            subplot(4,2,2)
                plot([1:12],AC_P0_pr_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_mom,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_RCM_mom(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_mom(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_mom(:,3),'m'); hold on
                    xlim([1  12])
                    ylabel('mean P (mm)'); xlabel('time (month)')
                    if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{TYPE}]); end
                    lll=legend('EOBS','Local OBS','RegCM3','Aladin','Promes','location','northwest'); set(lll,'FontSize',6,'Orientation','horizontal','Position',[0.147 0.9639 0.7583 0.02264]);
                    ttt=text(-0.1,1.15,'b)','units','normalized');

            subplot(4,2,4)
                plot([1:12],AC_P0_pr_EOBS_cv,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_cv,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_RCM_cv(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_cv(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_cv(:,3),'m'); hold on
                    ylabel('coeff. var. P')
                    xlabel('time (month)'); xlim([1 12])                    
                    ttt=text(-0.1,1.15,'d)','units','normalized');                  
                  
            subplot(4,2,6)                                                 % *12 jer godisnji srednjak pretvaram u godisnju sumu    
                plot([1:50],TS_HIST_pr_EOBS_YMmean(1:50)*12,'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_pr_DHMZ_YMmean(1:50),   'r','Linewidth',2); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,2)*12,'b'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,1)*12,'k'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,3)*12,'m'); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylabel('P amount (mm)'); xlabel('time (year)')
                    ttt=text(-0.1,1.15,'f)','units','normalized');
                    %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,2))/(12*30)*100*10)/10),'%'];
                    %%%text(0.05,0.9,udio,'units','normalized')
                    %---------------------------------------------> Tabla Cedo
                        TABLA_CEDO(1,1,2,1,STAT,1)=mean(TS_HIST_pr_RCM_YMmean( 1:50,2)*12); TABLA_CEDO(1,1,2,1,STAT,2)=std(TS_HIST_pr_RCM_YMmean( 1:50,2)*12,1);
                        TABLA_CEDO(1,1,2,2,STAT,1)=mean(TS_HIST_pr_RCM_YMmean(10:50,2)*12); TABLA_CEDO(1,1,2,2,STAT,2)=std(TS_HIST_pr_RCM_YMmean(11:50,2)*12,1);
                        TABLA_CEDO(1,2,2,1,STAT,1)=mean(TS_HIST_pr_RCM_YMmean( 1:50,1)*12); TABLA_CEDO(1,2,2,1,STAT,2)=std(TS_HIST_pr_RCM_YMmean( 1:50,1)*12,1);
                        TABLA_CEDO(1,2,2,2,STAT,1)=mean(TS_HIST_pr_RCM_YMmean(10:50,1)*12); TABLA_CEDO(1,2,2,2,STAT,2)=std(TS_HIST_pr_RCM_YMmean(11:50,1)*12,1);
                        TABLA_CEDO(1,3,2,1,STAT,1)=mean(TS_HIST_pr_RCM_YMmean( 1:50,3)*12); TABLA_CEDO(1,3,2,1,STAT,2)=std(TS_HIST_pr_RCM_YMmean( 1:50,3)*12,1);
                        TABLA_CEDO(1,3,2,2,STAT,1)=mean(TS_HIST_pr_RCM_YMmean(10:50,3)*12); TABLA_CEDO(1,3,2,2,STAT,2)=std(TS_HIST_pr_RCM_YMmean(11:50,3)*12,1);
                        TABLA_CEDO(1,4,2,1,STAT,1)=mean(TS_HIST_pr_DHMZ_YMmean( 1:50));     TABLA_CEDO(1,4,2,1,STAT,2)=std(TS_HIST_pr_DHMZ_YMmean( 1:50),1);
                        TABLA_CEDO(1,4,2,2,STAT,1)=nanmean(TS_HIST_pr_DHMZ_YMmean(10:50));  TABLA_CEDO(1,4,2,2,STAT,2)=nanstd(TS_HIST_pr_DHMZ_YMmean(11:50),1);
                        TABLA_CEDO(1,5,2,1,STAT,1)=mean(TS_HIST_pr_EOBS_YMmean( 1:50)*12);  TABLA_CEDO(1,5,2,1,STAT,2)=std(TS_HIST_pr_EOBS_YMmean( 1:50)*12,1);
                        TABLA_CEDO(1,5,2,2,STAT,1)=mean(TS_HIST_pr_EOBS_YMmean(10:50)*12);  TABLA_CEDO(1,5,2,2,STAT,2)=std(TS_HIST_pr_EOBS_YMmean(11:50)*12,1);                    
                    
                    
            subplot(4,2,8)                                                 % *12 jer godisnji srednjak pretvaram u godisnju sumu          
                stairs(ecdf_pr_EOBS_YMmean_P0*12,ecdf_y,     'g','Linewidth',2); hold on
                stairs(ecdf_pr_DHMZ_YMmean_P0,ecdf_y_DHMZ_pr,'r','Linewidth',2); hold on 
                stairs(ecdf_pr_RCM_YMmean_P0(:,2)*12,ecdf_y,'b'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0(:,1)*12,ecdf_y,'k'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0(:,3)*12,ecdf_y,'m'); hold on                
                    ylim([0  1]) 
                    xlabel('annual P amount (mm)'); ylabel('CDF'); set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    ttt=text(-0.1,1.15,'h)','units','normalized');                 
                    filenameEPS=[StationTXT{STAT},'_',TYPEtxt2_corr{TYPE},'.eps'];
                    print(gcf,filenameEPS,'-depsc');
                    
%%
xxx=[1:12];
%--------------------------------------------------------------------------
% Racun delta korekcija
%--------------------------------------------------------------------------
disp('Racunam korekcije...')
            if (TYPE==2)
                for MOD=[1:3]
                    corr_t2m(:,MOD)=AC_P0_tas_RCM_mom(:,MOD)-AC_P0_tas_DHMZ_mom';               
                      corr_R(:,MOD)=AC_P0_pr_RCM_mom(:,MOD) -AC_P0_pr_DHMZ_mom';
                end
%--------------------------------------------------------------------------Crtanje delta korekcija                           
                B2=B+100;
                figure(B2); set(gcf,'Position',[281 409 1019 389],'PaperPositionMode','auto','visible','on')
                    subplot(1,2,1)
                        plot([1:12],corr_t2m(:,2),'b','Linewidth',1.5); hold on; temp2=corr_t2m(:,2);
                        plot([1:12],corr_t2m(:,1),'k','Linewidth',1.5); hold on; temp1=corr_t2m(:,1);
                        plot([1:12],corr_t2m(:,3),'m','Linewidth',1.5); hold on; temp3=corr_t2m(:,3);
                                ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                                ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                                ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on                        
                            xlim([1 12]);
                            xlabel('time (month)','fontsize',12); ylabel('adj. for t (deg C)','fontsize',12)
                            title([StationTXT{STAT},'; RCMcorr-DHMZ'] ,'Fontsize',12);
                            ttt=text(-0.15,1,'a)','units','normalized'); set(ttt,'fontsize',14);
                            grid on
                            set(gca,'Fontsize',12)                    
                            %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,1))/(12*30)*100*10)/10),'%'];
                            %%%text(0.05,0.9,udio,'units','normalized')

                            
                     subplot(1,2,2)
                        plot([1:12],corr_R(:,2),'b','Linewidth',1.5); hold on; temp2=corr_R(:,2);
                        plot([1:12],corr_R(:,1),'k','Linewidth',1.5); hold on; temp1=corr_R(:,1);
                        plot([1:12],corr_R(:,3),'m','Linewidth',1.5); hold on; temp3=corr_R(:,3);
                                ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                                ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                                ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on
                            xlim([1 12]);
                            title([StationTXT{STAT},'; RCMcorr-DHMZ'],'Fontsize',12)
                            xlabel('time (month)','fontsize',12); ylabel('adj. for P (mm)','fontsize',12)
                            ttt=text(-0.15,1,'b)','units','normalized'); set(ttt,'fontsize',14);        
                            legend('RegCM','Aladin','Promes','location','southwest')
                            grid on
                            set(gca,'Fontsize',12)
                            %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,2))/(12*30)*100*10)/10),'%'];
                            %%%text(0.05,0.9,udio,'units','normalized')
                            
                    filenameEPS=[StationTXT{STAT},'_adjustment.eps'];
                    print(gcf,filenameEPS,'-depsc');       
%%                 
%--------------------------------------------------------------------------Primjena delta korekcija i prateci racun
                for MOD=[1:3]
                    
temp=squeeze(cell2mat(MM(:,MOD,1,1))); temp=reshape(temp,12,50); temp=temp'; temp=temp-repmat(corr_t2m(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,1,1)=reshape(temp',12*50,1); clear temp
temp=squeeze(cell2mat(MM(:,MOD,1,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp-repmat(corr_R(:,MOD)',50,1);   RCMcorr_adj_corr(:,MOD,1,2)=reshape(temp',12*50,1); clear temp   
temp=squeeze(cell2mat(MM(:,MOD,2,1))); temp=reshape(temp,12,50); temp=temp'; temp=temp-repmat(corr_t2m(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,2,1)=reshape(temp',12*50,1); clear temp
temp=squeeze(cell2mat(MM(:,MOD,2,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp-repmat(corr_R(:,MOD)',50,1);   RCMcorr_adj_corr(:,MOD,2,2)=reshape(temp',12*50,1); clear temp   

temp=reshape(squeeze(RCMcorr_adj_corr(10*12+1:40*12,MOD,1,1)),12,30); AC_P0_tas_RCM_mom_adj_corr(:,MOD)=nanmean(temp'); AC_P0_tas_RCM_std_adj_corr(:,MOD)=std(temp',1);         clear temp
temp=reshape(squeeze(RCMcorr_adj_corr(10*12+1:40*12,MOD,1,2)),12,30); AC_P0_pr_RCM_mom_adj_corr(:,MOD)=nanmean(temp');  AC_P0_pr_RCM_std_adj_corr(:,MOD)=std(temp',1);          clear temp
                                                                      AC_P0_pr_RCM_cv_adj_corr(:,MOD)=AC_P0_pr_RCM_std_adj_corr(:,MOD)./AC_P0_pr_RCM_mom_adj_corr(:,MOD);
                   
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,1,1)),12,50);  TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD)=nanmean(temp);   clear temp                        
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,1,2)),12,50);  TS_HIST_pr_RCM_YMmean_adj_corr(:,MOD)=nanmean(temp);    clear temp                            
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,2,1)),12,50);  TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD)=nanmean(temp);   clear temp                        
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,2,2)),12,50);  TS_FUT_pr_RCM_YMmean_adj_corr(:,MOD)=nanmean(temp);    clear temp  
                   
                   ecdf_tas_RCM_YMmean_P0_adj_corr(:,MOD)=sort(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD)); 
                   ecdf_pr_RCM_YMmean_P0_adj_corr(:,MOD) =sort(TS_HIST_pr_RCM_YMmean_adj_corr(11:40,MOD)); 
                   
                 end %MOD  
%%                 
%-------------------------------------------------------------------     
% ---> crtam T2m adj_corr
%-------------------------------------------------------------------
disp('Crtam adj_corr...')
       B3=B+200;
       figure(B3); set(gcf,'Position',[879 31 560 795],'PaperPositionMode','auto','visible','on')
            subplot(4,2,1)
                plot([1:12],AC_P0_tas_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_mom,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,3),'m'); hold on
                    xlim([1  12])
                    if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{3}]); end
                    ylabel('mean t (deg C)'); xlabel('time (month)')
                    ttt=text(-0.1,1.15,'a)','units','normalized'); 
                
            subplot(4,2,3)
                plot([1:12],AC_P0_tas_EOBS_std,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_std,'r','Linewidth',2); hold on            
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,3),'m'); hold on
                    xlim([1  12])
                    ylabel('std t (deg C)'); xlabel('time (month)')
                    ttt=text(-0.1,1.15,'c)','units','normalized');
                    
            subplot(4,2,5)     
                plot([1:50],TS_HIST_tas_EOBS_YMmean(1:50),'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_DHMZ_YMmean(1:50),'r','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,2),'b'); hold on       
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,1),'k'); hold on       
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,3),'m'); hold on       
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylabel('mean t (deg C)'); xlabel('time (year)')
                    ttt=text(-0.1,1.15,'e)','units','normalized');
                    if (STAT==1); ylim([ 9 14]); end
                    if (STAT==7); ylim([12 17]); end
                    %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,1))/(12*30)*100*10)/10),'%'];
                    %%%text(0.05,0.9,udio,'units','normalized')
                    
            subplot(4,2,7)                    
                stairs(ecdf_tas_EOBS_YMmean_P0,ecdf_y,         'g','Linewidth',2); hold on
                stairs(ecdf_tas_DHMZ_YMmean_P0,ecdf_y_DHMZ_tas,'r','Linewidth',2); hold on            
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,2),ecdf_y,'b'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,1),ecdf_y,'k'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,3),ecdf_y,'m'); hold on
                    ylim([0   1])
                    if (STAT==1); xlim([ 9 14]); end
                    if (STAT==7); xlim([12 17]); end
                    xlabel('mean annual t (deg C)'); ylabel('CDF');  set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    ttt=text(-0.1,1.15,'g)','units','normalized');
                    
%-------------------------------------------------------------------             
% ---> crtam R RCMcorr adj
%-------------------------------------------------------------------
            subplot(4,2,2)
                plot([1:12],AC_P0_pr_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_mom,'r','Linewidth',2); hold on            
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr(:,3),'m'); hold on
                    xlim([1   12])
                    ylabel('mean P (mm)'); xlabel('time (month)')
                    if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{3}]); end
                    lll=legend('EOBS','Local OBS','RegCM3','Aladin','Promes','location','northwest'); set(lll,'FontSize',6,'Orientation','horizontal','Position',[0.147 0.9639 0.7583 0.02264]);
                    ttt=text(-0.1,1.15,'b)','units','normalized');                  
            subplot(4,2,4)
                plot([1:12],AC_P0_pr_EOBS_cv,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_cv,'r','Linewidth',2); hold on            
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr(:,3),'m'); hold on
                    ylabel('coeff. var. P')
                    xlabel('time (month)'); xlim([1 12])                    
                    ttt=text(-0.1,1.15,'d)','units','normalized');

            subplot(4,2,6)                                                 % *12 jer godisnji srednjak pretvaram u godisnju sumu                    
                plot([1:50],TS_HIST_pr_EOBS_YMmean(1:50)*12,'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_pr_DHMZ_YMmean(1:50),   'r','Linewidth',2); hold on            
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr(:,2)*12,'b'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr(:,1)*12,'k'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr(:,3)*12,'m'); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylabel('P amount (mm)'); xlabel('time (year)')
                    ttt=text(-0.1,1.15,'f)','units','normalized');
                    %%%udio=['Local OBS in P0: ',num2str(round(sum(b_leng(:,2))/(12*30)*100*10)/10),'%'];
                    %%%text(0.05,0.9,udio,'units','normalized')

            subplot(4,2,8)                                                 % *12 jer godisnji srednjak pretvaram u godisnju sumu 
                stairs(ecdf_pr_EOBS_YMmean_P0*12,ecdf_y,     'g','Linewidth',2); hold on
                stairs(ecdf_pr_DHMZ_YMmean_P0,ecdf_y_DHMZ_pr,'r','Linewidth',2); hold on            
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr(:,2)*12,ecdf_y,'b'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr(:,1)*12,ecdf_y,'k'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr(:,3)*12,ecdf_y,'m'); hold on
                    ylim([0  1]) 
                    xlabel('annual P amount (mm)'); ylabel('CDF'); set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    ttt=text(-0.1,1.15,'h)','units','normalized');           
                    filenameEPS=[StationTXT{STAT},'_',TYPEtxt2_corr{3},'.eps'];
                    print(gcf,filenameEPS,'-depsc');
                    
%%   
disp('Crtam P1 vs P0...')
            %-------------------------------------------------------------- %Crtanje P1 vs P0: RCM corr
           
            B4=B+400;
            figure(B4); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','visible','on');
                subplot(2,2,1)
                    plot([1:12],AC_P1_tas_RCM_mom(:,2)-AC_P0_tas_RCM_mom(:,2),'b','Linewidth',1.5); hold on; temp2=AC_P1_tas_RCM_mom(:,2)-AC_P0_tas_RCM_mom(:,2); xxx=[1:12];
                    plot([1:12],AC_P1_tas_RCM_mom(:,1)-AC_P0_tas_RCM_mom(:,1),'k','Linewidth',1.5); hold on; temp1=AC_P1_tas_RCM_mom(:,1)-AC_P0_tas_RCM_mom(:,1);
                    plot([1:12],AC_P1_tas_RCM_mom(:,3)-AC_P0_tas_RCM_mom(:,3),'m','Linewidth',1.5); hold on; temp3=AC_P1_tas_RCM_mom(:,3)-AC_P0_tas_RCM_mom(:,3);
                    ind=isfinite(AC_t2m_P0_vs_P1_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                    ind=isfinite(AC_t2m_P0_vs_P1_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                    ind=isfinite(AC_t2m_P0_vs_P1_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on
                        xlim([1 12])
                        ylim([0 4])
                        xlabel('time (month)','Fontsize',12)
                        ylabel(' \Delta t (deg C)','Fontsize',12)
                        if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{2}],'Fontsize',12); end
                        grid on
                        ttt=text(-0.1,1.1,'a)','units','normalized'); set(ttt,'Fontsize',12)
                subplot(2,2,2)
                    plot([1:12],(AC_P1_pr_RCM_mom(:,2)-AC_P0_pr_RCM_mom(:,2))./AC_P0_pr_RCM_mom(:,2)*100,'b','Linewidth',1.5); hold on; temp2=(AC_P1_pr_RCM_mom(:,2)-AC_P0_pr_RCM_mom(:,2))./AC_P0_pr_RCM_mom(:,2)*100;
                    plot([1:12],(AC_P1_pr_RCM_mom(:,1)-AC_P0_pr_RCM_mom(:,1))./AC_P0_pr_RCM_mom(:,1)*100,'k','Linewidth',1.5); hold on; temp1=(AC_P1_pr_RCM_mom(:,1)-AC_P0_pr_RCM_mom(:,1))./AC_P0_pr_RCM_mom(:,1)*100;
                    plot([1:12],(AC_P1_pr_RCM_mom(:,3)-AC_P0_pr_RCM_mom(:,3))./AC_P0_pr_RCM_mom(:,3)*100,'m','Linewidth',1.5); hold on; temp3=(AC_P1_pr_RCM_mom(:,3)-AC_P0_pr_RCM_mom(:,3))./AC_P0_pr_RCM_mom(:,3)*100;  
                    ind=isfinite(AC_pr_P0_vs_P1_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                    ind=isfinite(AC_pr_P0_vs_P1_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                    ind=isfinite(AC_pr_P0_vs_P1_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on
                        xlim([1 12])
                        ylim([-70 70])
                        xlabel('time (month)','Fontsize',12)
                        ylabel(' \Delta P (%)','Fontsize',12)
                        if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{2}],'Fontsize',12); end
                        grid on
                        ttt=text(-0.1,1.1,'b)','units','normalized'); set(ttt,'Fontsize',12)
                        legend('P1-P0 RegCM3','P1-P0 Aladin','P1-P0 Promes','location','northwest')
                subplot(2,2,3)        
                    stairs(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_y,'b'); hold on
                    stairs(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_y,'k'); hold on
                    stairs(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_y,'m'); hold on
                    stairs(ecdf_tas_RCM_YMmean_P1(:,2),ecdf_y,'b','Linewidth',1.5); hold on
                    stairs(ecdf_tas_RCM_YMmean_P1(:,1),ecdf_y,'k','Linewidth',1.5); hold on
                    stairs(ecdf_tas_RCM_YMmean_P1(:,3),ecdf_y,'m','Linewidth',1.5); hold on                    
              
                        ylim([0   1])
                        xlabel('mean annual t (deg C)','Fontsize',12)
                        ylabel('CDF','Fontsize',12)
                        ttt=text(-0.1,1.1,'c)','units','normalized'); set(ttt,'Fontsize',12)
                                testKS(2)=kstest2(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_tas_RCM_YMmean_P1(:,2));
                                testKS(1)=kstest2(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_tas_RCM_YMmean_P1(:,1));
                                testKS(3)=kstest2(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_tas_RCM_YMmean_P1(:,3));
                                    if (STAT==1); MIRKO=11; end
                                    if (STAT==7); MIRKO=13; end
                                    plot(MIRKO,0.5,'b o'); hold on; if (testKS(2)==1); plot(MIRKO,0.5,'b o','MarkerFaceColor','b'); hold on; end
                                    plot(MIRKO,0.6,'k o'); hold on; if (testKS(1)==1); plot(MIRKO,0.6,'k o','MarkerFaceColor','k'); hold on; end
                                    plot(MIRKO,0.7,'m o'); hold on; if (testKS(3)==1); plot(MIRKO,0.7,'m o','MarkerFaceColor','m'); hold on; end
                subplot(2,2,4)
                    stairs(ecdf_pr_RCM_YMmean_P0(:,2)*12,ecdf_y,'b'); hold on
                    stairs(ecdf_pr_RCM_YMmean_P0(:,1)*12,ecdf_y,'k'); hold on
                    stairs(ecdf_pr_RCM_YMmean_P0(:,3)*12,ecdf_y,'m'); hold on
                    stairs(ecdf_pr_RCM_YMmean_P1(:,2)*12,ecdf_y,'b','Linewidth',1.5); hold on
                    stairs(ecdf_pr_RCM_YMmean_P1(:,1)*12,ecdf_y,'k','Linewidth',1.5); hold on
                    stairs(ecdf_pr_RCM_YMmean_P1(:,3)*12,ecdf_y,'m','Linewidth',1.5); hold on               
                        ylim([0  1])        
                        xlabel('annual P amount (mm)','Fontsize',12)   
                        ylabel('CDF','Fontsize',12)
                        ttt=text(-0.1,1.1,'d)','units','normalized'); set(ttt,'Fontsize',12)
                                testKS(2)=kstest2(ecdf_pr_RCM_YMmean_P0(:,2),ecdf_pr_RCM_YMmean_P1(:,2));
                                testKS(1)=kstest2(ecdf_pr_RCM_YMmean_P0(:,1),ecdf_pr_RCM_YMmean_P1(:,1));
                                testKS(3)=kstest2(ecdf_pr_RCM_YMmean_P0(:,3),ecdf_pr_RCM_YMmean_P1(:,3));
                                    plot(600,0.5,'b o'); hold on; if (testKS(2)==1); plot(600,0.5,'b o','MarkerFaceColor','b'); hold on; end
                                    plot(600,0.6,'k o'); hold on; if (testKS(1)==1); plot(600,0.6,'k o','MarkerFaceColor','k'); hold on; end
                                    plot(600,0.7,'m o'); hold on; if (testKS(3)==1); plot(600,0.7,'m o','MarkerFaceColor','m'); hold on; end
                        legend('P0 RegCM3','P0 Aladin','P0 Promes','P1 RegCM3','P1 Aladin','P1 Promes','location','southeast')

                    filenameEPS=[StationTXT{STAT},'_',TYPEtxt2_corr{2},'_P1vsP0.eps'];
                    print(gcf,filenameEPS,'-depsc');           
%%   
disp('Crtam vremenske nizove RCMcorr...')
            %--------------------------------------------------------------
            % Crtanje vremenskih nizova T2m 
            %--------------------------------------------------------------
           sigTXT={'[nonsig.]','[sig.]'};
           
            B5=B+500; panel=0; ModelTXT{2}='RegCM3; trend='; ModelTXT{1}='Aladin; trend='; ModelTXT{3}='Promes; trend='; Color{2}='b'; Color{1}='k'; Color{3}='m'; Letter{2}='a)'; Letter{1}='b)'; Letter{3}='c)';
            figure(B5); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','Visible','on');    
            for MOD=[2 1 3]
            panel=panel+1;
                subplot(3,1,panel)
                    plot([1:100],[TS_HIST_tas_RCM_YMmean(:,MOD); TS_FUT_tas_RCM_YMmean(:,MOD)],Color{MOD},'Linewidth',1.5); hold on
                                    tempT=[TS_HIST_tas_RCM_YMmean(:,MOD); TS_FUT_tas_RCM_YMmean(:,MOD)]; P=polyfit([1:100]',tempT,1);             if (STAT~=5); [ H,p_value ] = MannKendall( tempT,0.05 ); end
                                   tempT2=[TS_HIST_tas_RCM_YMmean(11:50,MOD); TS_FUT_tas_RCM_YMmean(1:12,MOD)]; P2=polyfit([11:62]',tempT2,1);    if (STAT~=5); [ H2,p_value ] = MannKendall( tempT2,0.05 ); end
                                    P0_mean=mean(TS_HIST_tas_RCM_YMmean(11:40,MOD)); P0_std=std(TS_HIST_tas_RCM_YMmean(11:40,MOD),1);
                                    P1_mean=mean( TS_FUT_tas_RCM_YMmean(21:50,MOD)); P1_std=std( TS_FUT_tas_RCM_YMmean(21:50,MOD),1);
                    plot([11:62],P2(1)*[11:62]+P2(2),'g','Linewidth',2); hold on
                    plot([1:100],P(1)*[1:100]+P(2),Color{MOD}); hold on
                                    xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
                                    text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
                        if (STAT==7)
                                    sadrzaj=[num2str(round(P0_mean*10)/10),'\pm',num2str(round(P0_std*10)/10),'degC']; text(11,12.5,sadrzaj)
                                    sadrzaj=[num2str(round(P1_mean*10)/10),'\pm',num2str(round(P1_std*10)/10),'degC']; text(71,12.5,sadrzaj)
                        else
                                    sadrzaj=[num2str(round(P0_mean*10)/10),'\pm',num2str(round(P0_std*10)/10),'degC']; text(11,10.5,sadrzaj)
                                    sadrzaj=[num2str(round(P1_mean*10)/10),'\pm',num2str(round(P1_std*10)/10),'degC']; text(71,10.5,sadrzaj)
                        end
                                    grid on; set(gca,'XGrid','off')
                                    ylabel('t (deg C)','Fontsize',12); ylim([10 17]); if (STAT==7); ylim([12 18]); end
                                    set(gca,'Fontsize',12)
                    legend(['1951-2050 ', ModelTXT{MOD},num2str(round(P(1)*10*100)/100),' degC/10yr ',sigTXT{H+1}],['1961-2012 ', ModelTXT{MOD},num2str(round(P2(1)*10*100)/100),' degC/10yr ',sigTXT{H2+1}],'location','northwest');
                    if (panel==1); title([StationTXT{STAT},'; RCMcorr'],'Fontsize',12); end
                    if (panel==3); xlabel(' time (year)',               'Fontsize',12); end    
            end               
                    filenameEPS=[StationTXT{STAT},'_RCMcorr_T2m_TS.eps'];
                    print(gcf,filenameEPS,'-depsc');    
%%                    
            %--------------------------------------------------------------
            % Crtanje vremenskih nizova PR
            %--------------------------------------------------------------
           
            B6=B+600; panel=0; ModelTXT{2}='RegCM3; trend='; ModelTXT{1}='Aladin; trend='; ModelTXT{3}='Promes; trend='; Color{2}='b'; Color{1}='k'; Color{3}='m'; Letter{2}='a)'; Letter{1}='b)'; Letter{3}='c)';
            figure(B6); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','Visible','on');    
            for MOD=[2 1 3]
            panel=panel+1;
                subplot(3,1,panel)
                    plot([1:100],[TS_HIST_pr_RCM_YMmean(:,MOD); TS_FUT_pr_RCM_YMmean(:,MOD)]*12,Color{MOD},'Linewidth',1.5); hold on
                                    tempT=[TS_HIST_pr_RCM_YMmean(:,MOD); TS_FUT_pr_RCM_YMmean(:,MOD)]*12; P=polyfit([1:100]',tempT,1);               [ H,p_value ] = MannKendall( tempT, 0.05 );
                                    tempT2=[TS_HIST_pr_RCM_YMmean(11:50,MOD); TS_FUT_pr_RCM_YMmean(1:12,MOD)]*12; P2=polyfit([11:62]',tempT2,1);     [H2,p_value ] = MannKendall( tempT2,0.05 );
                                    P0_mean=mean(TS_HIST_pr_RCM_YMmean(11:40,MOD)*12); P0_std=std(TS_HIST_pr_RCM_YMmean(11:40,MOD)*12,1);
                                    P1_mean=mean( TS_FUT_pr_RCM_YMmean(21:50,MOD)*12); P1_std=std( TS_FUT_pr_RCM_YMmean(21:50,MOD)*12,1);
                    plot([11:62],P2(1)*[11:62]+P2(2),'g','Linewidth',2); hold on
                    plot([1:100],P(1)*[1:100]+P(2),Color{MOD});
                        xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
                        text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
                        if (STAT==7)
                                    sadrzaj=[num2str(round(P0_mean)),'\pm',num2str(round(P0_std)),' mm']; text(11,400,sadrzaj)
                                    sadrzaj=[num2str(round(P1_mean)),'\pm',num2str(round(P1_std)),' mm']; text(71,400,sadrzaj)
                        else
                                    sadrzaj=[num2str(round(P0_mean)),'\pm',num2str(round(P0_std)),' mm']; text(11,600,sadrzaj)
                                    sadrzaj=[num2str(round(P1_mean)),'\pm',num2str(round(P1_std)),' mm']; text(71,600,sadrzaj)
                        end
                        grid on; set(gca,'XGrid','off')
                        ylabel('P (mm)','Fontsize',12); ylim([500 2000]); if (STAT==7); ylim([300 1800]); end
                        set(gca,'Fontsize',12)
                        legend(['1951-2050 ',ModelTXT{MOD},num2str(round(P(1)*10*10)/10),' mm/10yr ',sigTXT{H+1}],['1961-2012 ',ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr ',sigTXT{H2+1}],'location','northwest');
                        
                        if (panel==1); title([StationTXT{STAT},'; RCMcorr'],'Fontsize',12); end    
                        if (panel==3); xlabel(' time (year)','Fontsize',12); end    
            end               
                    filenameEPS=[StationTXT{STAT},'_RCMcorr_pr_TS.eps'];
                    print(gcf,filenameEPS,'-depsc'); 
%%                
% % % % disp('Crtam vremenske nizove RCMcorr_adj...')
% % % %             %--------------------------------------------------------------
% % % %             % Crtanje vremenskih nizova T2m 
% % % %             %--------------------------------------------------------------
% % % %            
% % % %             B5=B+700; panel=0; ModelTXT{2}='RegCM3; trend='; ModelTXT{1}='Aladin; trend='; ModelTXT{3}='Promes; trend='; Color{2}='b'; Color{1}='k'; Color{3}='m'; Letter{2}='a)'; Letter{1}='b)'; Letter{3}='c)';
% % % %             figure(B5); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','visible','on');    
% % % %             for MOD=[2 1 3]
% % % %             panel=panel+1;
% % % %                 subplot(3,1,panel)
% % % %                     plot([1:100],[TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD); TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD)],Color{MOD},'Linewidth',1.5); 
% % % %                                     tempT=[TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD); TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD)]; P=polyfit([1:100]',tempT,1); if (STAT~=5);  [ H,p_value ] = MannKendall( tempT,0.05 ); end
% % % %                                     P0_mean=mean(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD)); P0_std=std(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD),1);
% % % %                                     P1_mean=mean( TS_FUT_tas_RCM_YMmean_adj_corr(21:50,MOD)); P1_std=std( TS_FUT_tas_RCM_YMmean_adj_corr(21:50,MOD),1);
% % % %                         xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
% % % %                         text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
% % % %                                     sadrzaj=[num2str(round(P0_mean*10)/10),'\pm',num2str(round(P0_std*10)/10),'degC']; text(11,10.5,sadrzaj)
% % % %                                     sadrzaj=[num2str(round(P1_mean*10)/10),'\pm',num2str(round(P1_std*10)/10),'degC']; text(71,10.5,sadrzaj)
% % % %                         grid on; set(gca,'XGrid','on')
% % % %                         ylabel('t (deg C)','Fontsize',12); ylim([10 17])
% % % %                             set(gca,'Fontsize',12)
% % % %                             if (H==1); legend([ModelTXT{MOD},num2str(round(P(1)*10*100)/100),' degC/10yr [sig.]'],'location','northwest')   ; end
% % % %                             if (H==0); legend([ModelTXT{MOD},num2str(round(P(1)*10*100)/100),' degC/10yr [nonsig.]'],'location','northwest'); end
% % % %                         if (panel==1); title([StationTXT{STAT},'; RCMcorr adj'],'Fontsize',12); end
% % % %                         if (panel==3); xlabel(' time (year)','Fontsize',12); end    
% % % %             end               
% % % %                         
% % % %                     filenameJPG=[StationTXT{STAT},'_RCMcorr_adj_T2m_TS.jpg'];
% % % %                     filenameEPS=[StationTXT{STAT},'_RCMcorr_adj_T2m_TS.eps'];
% % % %                     %%%print(gcf,filenameJPG,'-djpeg');
% % % %                     print(gcf,filenameEPS,'-depsc');    
% % % % %%                    
% % % %             %--------------------------------------------------------------
% % % %             % Crtanje vremenskih nizova PR
% % % %             %--------------------------------------------------------------
% % % %            
% % % %             B6=B+800; panel=0; ModelTXT{2}='RegCM3; trend='; ModelTXT{1}='Aladin; trend='; ModelTXT{3}='Promes; trend='; Color{2}='b'; Color{1}='k'; Color{3}='m'; Letter{2}='a)'; Letter{1}='b)'; Letter{3}='c)';
% % % %             figure(B6); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','visible','on');    
% % % %             for MOD=[2 1 3]
% % % %             panel=panel+1;
% % % %                 subplot(3,1,panel)
% % % %                     plot([1:100],[TS_HIST_pr_RCM_YMmean_adj_corr(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr(:,MOD)]*12,Color{MOD},'Linewidth',1.5); 
% % % %                                     tempT=[TS_HIST_pr_RCM_YMmean_adj_corr(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr(:,MOD)]*12; P=polyfit([1:100]',tempT,1);  [ H,p_value ] = MannKendall( tempT,0.05 );                                   P0_mean=mean(TS_HIST_pr_RCM_YMmean_adj_corr(11:40,MOD)*12); P0_std=std(TS_HIST_pr_RCM_YMmean_adj_corr(11:40,MOD)*12,1);
% % % %                                     P1_mean=mean( TS_FUT_pr_RCM_YMmean_adj_corr(21:50,MOD)*12); P1_std=std( TS_FUT_pr_RCM_YMmean_adj_corr(21:50,MOD)*12,1);
% % % %                         xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
% % % %                         text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
% % % %                                     sadrzaj=[num2str(round(P0_mean)),'\pm',num2str(round(P0_std)),' mm']; text(11,600,sadrzaj)
% % % %                                     sadrzaj=[num2str(round(P1_mean)),'\pm',num2str(round(P1_std)),' mm']; text(71,600,sadrzaj)
% % % %                         grid on; set(gca,'XGrid','on')
% % % %                         ylabel('P (mm)','Fontsize',12); ylim([500 2000])
% % % %                             set(gca,'Fontsize',12)
% % % %                             if (H==1); legend([ModelTXT{MOD},num2str(round(P(1)*10*10)/10),' mm/10yr [sig.]'],'location','northwest')   ; end
% % % %                             if (H==0); legend([ModelTXT{MOD},num2str(round(P(1)*10*10)/10),' mm/10yr [nonsig.]'],'location','northwest'); end
% % % %                         if (panel==1); title([StationTXT{STAT},'; RCMcorr adj'],'Fontsize',12); end    
% % % %                         if (panel==3); xlabel(' time (year)','Fontsize',12); end    
% % % %             end               
% % % %                         
% % % %                     filenameJPG=[StationTXT{STAT},'_RCMcorr_adj_pr_TS.jpg'];
% % % %                     filenameEPS=[StationTXT{STAT},'_RCMcorr_adj_pr_TS.eps'];
% % % %                     %%%print(gcf,filenameJPG,'-djpeg');
% % % %                     print(gcf,filenameEPS,'-depsc'); 
% % % %                     
            end % if TYPE 2
            
% % % %% ------------------------------------------------------------------------ write to Excel
            if (TYPE==2)
                i=0;j=0;
                for YEAR=1951:1:2050;
                    j=j+1;
                    for MON=1:12;
                        i=i+1;
                        matrica(i,1)=YEAR;
                        matrica(i,2)=MON;
                    end %mon
                        matrica_YM(j,1)=YEAR;
                        matrica_SM(j,1,1)=YEAR;
                        matrica_SM(j,1,2)=YEAR;
                        matrica_SM(j,1,3)=YEAR;
                        matrica_SM(j,1,4)=YEAR;
                end %YEAR
                for MOD=1:3
                    matrica(  1:600 ,MOD+2) =squeeze(MM{:,MOD,1,1});
                    matrica(601:1200,MOD+2) =squeeze(MM{:,MOD,2,1});       matrica_YM(:,MOD+1) =mean(reshape(matrica(:,MOD+2),12,100));
                    matrica(  1:600 ,MOD+5) =squeeze(MM{:,MOD,1,2});
                    matrica(601:1200,MOD+5) =squeeze(MM{:,MOD,2,2});       matrica_YM(:,MOD+4) =sum(reshape(matrica(:,MOD+5), 12,100));
                    matrica(  1:600 ,MOD+8) =RCMcorr_adj_corr(:,MOD,1,1);
                    matrica(601:1200,MOD+8) =RCMcorr_adj_corr(:,MOD,2,1);  matrica_YM(:,MOD+7) =mean(reshape(matrica(:,MOD+8),12,100));
                    matrica(  1:600 ,MOD+11)=RCMcorr_adj_corr(:,MOD,1,2);
                    matrica(601:1200,MOD+11)=RCMcorr_adj_corr(:,MOD,2,2);  matrica_YM(:,MOD+10)=sum(reshape(matrica(:,MOD+11),12,100));
                    for SEAS=1:4  %MAM, JJA, SON, DJF
                        %     DEC 1960             JAN 2051 FEB 2051
                        temp=[NaN; matrica(:,MOD+2);  NaN; NaN]; temp=mean(reshape(temp,3,401));
                        matrica_SM(:,MOD+1,SEAS)=temp(1+SEAS:4:end);
                        
                        temp=[NaN; matrica(:,MOD+5);  NaN; NaN]; temp=sum(reshape(temp,3,401));
                        matrica_SM(:,MOD+4,SEAS)=temp(1+SEAS:4:end);
                        
                        temp=[NaN; matrica(:,MOD+8);  NaN; NaN]; temp=mean(reshape(temp,3,401));
                        matrica_SM(:,MOD+7,SEAS)=temp(1+SEAS:4:end);
                        
                        temp=[NaN; matrica(:,MOD+11); NaN; NaN]; temp=sum(reshape(temp,3,401));
                        matrica_SM(:,MOD+10,SEAS)=temp(1+SEAS:4:end);
                    end %SEAS
                end %MOD

% % %                 xlswrite('./DHMZ_RCM_MM.xls', matrica,    StationTXT{STAT},'B2');         
% % % xlswrite('./DHMZ_RCM_MM.xls', {'YEAR';'MONTH';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'B1');
% % %                 xlswrite('./DHMZ_RCM_YM.xls', matrica_YM, StationTXT{STAT},'B2');
% % %                 
% % % xlswrite('./DHMZ_RCM_YM.xls', {'YEAR';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'B1');
% % %                 xlswrite('./DHMZ_RCM_SM.xls', matrica_SM(:,:,1), StationTXT{STAT},'B2');
% % %                 
% % % xlswrite('./DHMZ_RCM_SM.xls', {'YEAR MAM';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'B1');                
% % %                 xlswrite('./DHMZ_RCM_SM.xls', matrica_SM(:,:,2), StationTXT{STAT},'O2');
% % % xlswrite('./DHMZ_RCM_SM.xls', {'YEAR JJA';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'O1');
% % %                 xlswrite('./DHMZ_RCM_SM.xls', matrica_SM(:,:,3), StationTXT{STAT},'AB2');
% % % xlswrite('./DHMZ_RCM_SM.xls', {'YEAR SON';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'AB1');                
% % %                 xlswrite('./DHMZ_RCM_SM.xls', matrica_SM(:,:,4), StationTXT{STAT},'AO2');
% % % xlswrite('./DHMZ_RCM_SM.xls', {'YEAR DJF';'tas_corr MOD1';'tas_corr MOD2';'tas_corr MOD3';'pr_corr MOD1';'pr_corr MOD2';'pr_corr MOD3';'tas_corr_adj MOD1';'tas_corr_adj MOD2';'tas_corr_adj MOD3';'pr_corr_adj MOD1';'pr_corr_adj MOD2';'pr_corr_adj MOD3'}',    StationTXT{STAT},'AO1');
%% Crtam sezonske trendove
disp('Crtam vremenske nizove RCMcorr: sezonski srednjaci...')
%--------------------------------------------------------------
% Crtanje vremenskih nizova T2m SM
%--------------------------------------------------------------         
            B7=B+900; panel=0; 
            figure(B7); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','Visible','on');    
            for MOD=[2 1 3]
            panel=panel+1;
                subplot(3,1,panel)
                % ---> MAM
                    plot([1:100],matrica_SM(:,MOD+1,1),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+1,1);     P1=polyfit([1:100]',tempT, 1);   [H1,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+1,1); P2=polyfit([11:62]',tempT2,1);   [H2,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P1(1)*[1:100]+P1(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P2(1)*[11:62]+P2(2),'g',        'Linewidth',2);  hold on        
                % ---> JJA
                    plot([1:100],matrica_SM(:,MOD+1,2),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+1,2);     P3=polyfit([1:100]',tempT, 1);   [H3,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+1,2); P4=polyfit([11:62]',tempT2,1);   [H4,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P3(1)*[1:100]+P3(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P4(1)*[11:62]+P4(2),'g',        'Linewidth',2);  hold on      
                % ---> MAM
                    plot([1:100],matrica_SM(:,MOD+1,3),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+1,3);     P5=polyfit([1:100]',tempT, 1);   [H5,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+1,3); P6=polyfit([11:62]',tempT2,1);   [H6,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P5(1)*[1:100]+P5(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P6(1)*[11:62]+P6(2),'g',        'Linewidth',2);  hold on                          
                % ---> DJF
                    plot([1:99],matrica_SM(1:99,MOD+1,4),Color{MOD},'Linewidth',2); hold on
                          tempT=matrica_SM(1:99,MOD+1,4);   P7=polyfit([1:99]',tempT, 1);     [H7,p_value] = MannKendall( tempT, 0.05 );
                         tempT2=matrica_SM(11:62,MOD+1,4);  P8=polyfit([11:62]',tempT2,1);    [H8,p_value] = MannKendall( tempT2,0.05 );
                    plot([1:99], P7(1)*[1:99]+ P7(2) ,Color{MOD},'Linewidth',1);  hold on                    
                    plot([11:62],P8(1)*[11:62]+P8(2),'c'        ,'Linewidth',2);  hold on
                    
                                    xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
                                    text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
                                    grid on; set(gca,'XGrid','off')
                                    ylabel('t (degC)','Fontsize',12); ylim([0 30]);
                                    set(gca,'Fontsize',12)
legend('MAM time series',['1951-2050 MAM ', ModelTXT{MOD},num2str(round(P1(1)*10*100)/100),' degC/10yr ',sigTXT{H1+1}],['1961-2012 MAM ', ModelTXT{MOD},num2str(round(P2(1)*10*100)/100),' degC/10yr ',sigTXT{H2+1}], ...
       'JJA time series',['1951-2050 JJA ', ModelTXT{MOD},num2str(round(P3(1)*10*100)/100),' degC/10yr ',sigTXT{H3+1}],['1961-2012 JJA ', ModelTXT{MOD},num2str(round(P4(1)*10*100)/100),' degC/10yr ',sigTXT{H4+1}], ...
       'SON time series',['1951-2050 SON ', ModelTXT{MOD},num2str(round(P5(1)*10*100)/100),' degC/10yr ',sigTXT{H5+1}],['1961-2012 SON ', ModelTXT{MOD},num2str(round(P6(1)*10*100)/100),' degC/10yr ',sigTXT{H6+1}], ...
       'DJF time series',['1951-2050 DJF ', ModelTXT{MOD},num2str(round(P7(1)*10*100)/100),' degC/10yr ',sigTXT{H7+1}],['1961-2012 DJF ', ModelTXT{MOD},num2str(round(P8(1)*10*100)/100),' degC/10yr ',sigTXT{H8+1}], ...
       'location','northwestoutside');
                    if (panel==1); title([StationTXT{STAT},'; RCMcorr SM'],'Fontsize',12); end
                    if (panel==3); xlabel(' time (year)',                  'Fontsize',12); end    
            end                    
                        
%%                    
%--------------------------------------------------------------
% Crtanje vremenskih nizova PR SM
%--------------------------------------------------------------         
            B8=B+1000; panel=0; 
            figure(B8); set(gcf,'Position',[253 75 830 734],'PaperPositionMode','auto','Visible','on');    
            for MOD=[2 1 3]
            panel=panel+1;
                subplot(3,1,panel)
                    % ---> MAM
                    plot([1:100],matrica_SM(:,MOD+4,1),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+4,1);     P1=polyfit([1:100]',tempT, 1);   [H1,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+4,1); P2=polyfit([11:62]',tempT2,1);   [H2,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P1(1)*[1:100]+P1(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P2(1)*[11:62]+P2(2),'g',        'Linewidth',2);  hold on        
                % ---> JJA
                    plot([1:100],matrica_SM(:,MOD+4,2),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+4,2);     P3=polyfit([1:100]',tempT, 1);   [H3,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+4,2); P4=polyfit([11:62]',tempT2,1);   [H4,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P3(1)*[1:100]+P3(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P4(1)*[11:62]+P4(2),'g',        'Linewidth',2);  hold on      
                % ---> MAM
                    plot([1:100],matrica_SM(:,MOD+4,3),Color{MOD},'Linewidth',1); hold on
                           tempT=matrica_SM(:,MOD+4,3);     P5=polyfit([1:100]',tempT, 1);   [H5,p_value ] = MannKendall( tempT, 0.05 );
                          tempT2=matrica_SM(11:62,MOD+4,3); P6=polyfit([11:62]',tempT2,1);   [H6,p_value]  = MannKendall( tempT2,0.05 );
                    plot([1:100],P5(1)*[1:100]+P5(2),Color{MOD}, 'Linewidth',1);  hold on
                    plot([11:62],P6(1)*[11:62]+P6(2),'g',        'Linewidth',2);  hold on                          
                % ---> DJF
                    plot([1:99],matrica_SM(1:99,MOD+4,4),Color{MOD},'Linewidth',2); hold on
                          tempT=matrica_SM(1:99,MOD+4,4);   P7=polyfit([1:99]',tempT, 1);     [H7,p_value] = MannKendall( tempT, 0.05 );
                         tempT2=matrica_SM(11:62,MOD+4,4);  P8=polyfit([11:62]',tempT2,1);    [H8,p_value] = MannKendall( tempT2,0.05 );
                    plot([1:99], P7(1)*[1:99]+ P7(2) ,Color{MOD},'Linewidth',1);  hold on                    
                    plot([11:62],P8(1)*[11:62]+P8(2),'c'        ,'Linewidth',2);  hold on
                    
                                    xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
                                    text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
                                    grid on; set(gca,'XGrid','off')
                                    ylabel('P (mm)','Fontsize',12); ylim([0 700]);
                                    set(gca,'Fontsize',12)
legend('MAM time series',['1951-2050 MAM ', ModelTXT{MOD},num2str(round(P1(1)*10*10)/10),' mm/10yr ',sigTXT{H1+1}],['1961-2012 MAM ', ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr ',sigTXT{H2+1}], ...
       'JJA time series',['1951-2050 JJA ', ModelTXT{MOD},num2str(round(P3(1)*10*10)/10),' mm/10yr ',sigTXT{H3+1}],['1961-2012 JJA ', ModelTXT{MOD},num2str(round(P4(1)*10*10)/10),' mm/10yr ',sigTXT{H4+1}], ...
       'SON time series',['1951-2050 SON ', ModelTXT{MOD},num2str(round(P5(1)*10*10)/10),' mm/10yr ',sigTXT{H5+1}],['1961-2012 SON ', ModelTXT{MOD},num2str(round(P6(1)*10*10)/10),' mm/10yr ',sigTXT{H6+1}], ...
       'DJF time series',['1951-2050 DJF ', ModelTXT{MOD},num2str(round(P7(1)*10*10)/10),' mm/10yr ',sigTXT{H7+1}],['1961-2012 DJF ', ModelTXT{MOD},num2str(round(P8(1)*10*10)/10),' mm/10yr ',sigTXT{H8+1}], ...
       'location','northwestoutside');
                    if (panel==1); title([StationTXT{STAT},'; RCMcorr SM'],'Fontsize',12); end
                    if (panel==3); xlabel(' time (year)',                  'Fontsize',12); end    
            end      
                    

            end %TYPE
            
            
            
%--------------------------------------------------------------------------                    
   end %od TYPE rgrid, BiasCorr, BiasCorr_adj oliti RCM, RCMcorr, RCMcorr_adj
end    %STAT
