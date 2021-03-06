close all; clear all; clc

%Note: povezi ispravno tocke i mjerenja; povezi ispravno redoslijed modela
%Note: set to zero if pr after adjustment less than 0

%2016-02-29 ranksum > u_test
%2016-02-29 kstest2 > kolmogorov_smirnov_test_2
%2016-02-29 xlswrite commented. Check latter how to do this

pkg load statistics

TYPEtxt={'rgrid', 'BiasCorr'};
TYPEtxt2_corr={'RCM', 'RCMcorr','RCMcorr_adj'};
XRAZ=0.075;
XA=0.1;
FUTA=14;  %<-- do proofs         2017-10-27
FUTA=11;   %<-- za vrijeme proofs 2017-10-27

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
	%LON[7]=17.5586;   LAT[7]=43.0175; # Opuzen
	StationTXT={'Pazin','Abrami','Porec','Celega','Metkovic','Ploce','Opuzen'};

B=0;
for STAT=[7]; 
	for TYPE=[2]; 
		disp(num2str(STAT))
		B=B+1;
%------------------------------------------------------------------------
     % Citamo iz mat datoteka       
%------------------------------------------------------------------------
disp('Citam...')
        if (STAT==7); if (TYPE==1) 
        load stat7_type1.mat AC_* TS_*    
        end; end
        if (STAT==7); if (TYPE==2) 
        load stat7_type2.mat AC_* TS_* MM 
        end; end    
              
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
	if (TYPE==2);
    AC_t2m_P0_vs_P1_sig=nan(12,3);
    AC_pr_P0_vs_P1_sig=nan(12,3);
        for MOD=[1:3]
            for MON=[1:12]
                a=squeeze(MM{:,MOD,1,1});
                b=squeeze(MM{:,MOD,2,1});
                [P,H]=u_test(a(10*12+MON:12:40*12),b(20*12+MON:12:50*12));  if (P<0.05); AC_t2m_P0_vs_P1_sig(MON,MOD)=1; end
                a=squeeze(MM{:,MOD,1,2});
                b=squeeze(MM{:,MOD,2,2});
                [P,H]=u_test(a(10*12+MON:12:40*12),b(20*12+MON:12:50*12));  if (P<0.05);  AC_pr_P0_vs_P1_sig(MON,MOD)=1; end               
            end
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
	if (TYPE==2);
        for MOD=[1:3]
            for MON=[1:12]
                a=squeeze(MM{:,MOD,1,1});
                b=AC_P0_tas_DHMZ_ts(:,MON); b_leng(MON,1)=sum(isfinite(b));
                [P,H]=u_test(a(10*12+MON:12:40*12),b);  if (P<0.05); AC_t2m_DHMZ_vs_RCM_sig(MON,MOD)=1; end
                a=squeeze(MM{:,MOD,1,2});
                b=AC_P0_pr_DHMZ_ts(:,MON);  b_leng(MON,2)=sum(isfinite(b));
                [P,H]=u_test(a(10*12+MON:12:40*12),b);  if (P<0.05);  AC_pr_DHMZ_vs_RCM_sig(MON,MOD)=1; end               
            end
        end
	end
%%            
%-------------------------------------------------------------------     
       % ---> crtam T2m RCMcorr
%-------------------------------------------------------------------     
disp('Crtam...')
       h=figure(B);
		subplot(4,3,1);
                plot([1:12],AC_P0_tas_RCM_mom(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_mom(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_mom(:,3),'m'); hold on
                plot([1:12],AC_P0_tas_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_mom,'r','Linewidth',2); hold on
                    xlim([1  12])
                    ylabel('mean t (deg C)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA);
                %    ttt=text(-0.1,1.15,'a','units','normalized'); set(ttt,'Fontsize',FUTA);
               
		subplot(4,3,2) 
                plot([1:12],AC_P0_tas_RCM_std(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_std(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_std(:,3),'m'); hold on
                plot([1:12],AC_P0_tas_EOBS_std,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_std,'r','Linewidth',2); hold on
                    xlim([1  12])
                    ylabel('std t (deg C)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA)
                %   ttt=text(-0.1,1.15,'b','units','normalized'); set(ttt,'Fontsize',FUTA);

            	subplot(4,3,[7 8 9])
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,2),'b'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,1),'k'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean(:,3),'m'); hold on
                plot([1:50],TS_HIST_tas_EOBS_YMmean(1:50),'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_DHMZ_YMmean(1:50),'r','Linewidth',2); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylim([13  18])        
                    ylabel('mean t (deg C)','Fontsize',FUTA); xlabel('time (year)','Fontsize',FUTA)
                %    ttt=text(-0.05,1.15,'g','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
                subplot(4,3,3)
                stairs(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_y,'b'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_y,'k'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_y,'m'); hold on
                stairs(ecdf_tas_EOBS_YMmean_P0,ecdf_y,'g','Linewidth',2); hold on
                stairs(ecdf_tas_DHMZ_YMmean_P0,ecdf_y_DHMZ_tas,'r','Linewidth',2); hold on
                    xlim([13  18])                       
                    ylim([0    1])
                    xlabel('mean annual t (deg C)','Fontsize',FUTA); ylabel('CDF','Fontsize',FUTA);  set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                %   ttt=text(-0.1,1.15,'c','units','normalized'); set(ttt,'Fontsize',FUTA);
            
%-------------------------------------------------------------------             
 % ---> crtam R RCMcorr
%-------------------------------------------------------------------
                subplot(4,3,4)
                plot([1:12],AC_P0_pr_RCM_mom(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_mom(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_mom(:,3),'m'); hold on
                plot([1:12],AC_P0_pr_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_mom,'r','Linewidth',2); hold on
                    xlim([1  12])
                    ylabel('mean P (mm)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA);
                %    ttt=text(-0.1,1.15,'d','units','normalized'); set(ttt,'Fontsize',FUTA);

                subplot(4,3,5);
                plot([1:12],AC_P0_pr_RCM_cv(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_cv(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_cv(:,3),'m'); hold on
                plot([1:12],AC_P0_pr_EOBS_cv,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_cv,'r','Linewidth',2); hold on
                    ylabel('coeff. var. P','Fontsize',FUTA)
                    xlabel('time (month)','Fontsize',FUTA); xlim([1 12])                    
                %    ttt=text(-0.1,1.15,'e','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
                subplot(4,3,[10 11 12]);    % *12 jer godisnji srednjak pretvaram u godisnju sumu                    
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,2)*12,'b'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,1)*12,'k'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean(:,3)*12,'m'); hold on
                plot([1:50],TS_HIST_pr_EOBS_YMmean(1:50)*12,'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_pr_DHMZ_YMmean(1:50),'r','Linewidth',2); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylim([0 2000])    
                    ylabel('P amount (mm)','Fontsize',FUTA); xlabel('time (year)','Fontsize',FUTA)
               %     ttt=text(-0.05,1.15,'h','units','normalized','Fontsize',FUTA);
                    lll=legend('RegCM3','Aladin','Promes','EOBS','Local OBS'); set(lll,'FontSize',FUTA-5,'Position',[0.15 0.25 0.19 0.07]); %<-- proofs FUTA-4 > FUTA-5
                    
                subplot(4,3,6);  % *12 jer godisnji srednjak pretvaram u godisnju sumu
                stairs(ecdf_pr_RCM_YMmean_P0(:,2)*12,ecdf_y,'b'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0(:,1)*12,ecdf_y,'k'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0(:,3)*12,ecdf_y,'m'); hold on
                stairs(ecdf_pr_EOBS_YMmean_P0*12,ecdf_y,'g','Linewidth',2); hold on
                stairs(ecdf_pr_DHMZ_YMmean_P0,ecdf_y_DHMZ_pr,'r','Linewidth',2); hold on
                    xlim([0 2000])                     
                    ylim([0  1]) 
                    xlabel('annual P amount (mm)','Fontsize',FUTA); ylabel('CDF','Fontsize',FUTA); set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                %    ttt=text(-0.1,1.15,'f','units','normalized'); set(ttt,'Fontsize',FUTA);

                   filenamePNG=[StationTXT{STAT},'_',TYPEtxt2_corr{TYPE},'.png'];
                   filenameEPS=[StationTXT{STAT},'_',TYPEtxt2_corr{TYPE},'.eps'];
                   print(h,filenamePNG,'-dpng','-S750,700');
                   print(h,filenameEPS,'-depsc');
%%             
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------Racun delta korekcija
%--------------------------------------------------------------------------
disp('Racunam korekcije...')
	    xxx=[1:12];
            if (TYPE==2)
                for MOD=[1:3]
                    corr_t2m(:,MOD)=AC_P0_tas_RCM_mom(:,MOD)-AC_P0_tas_DHMZ_mom';               
                      corr_R(:,MOD)=AC_P0_pr_RCM_mom(:,MOD) -AC_P0_pr_DHMZ_mom';
                      divc_R(:,MOD)=AC_P0_pr_RCM_mom(:,MOD)./AC_P0_pr_DHMZ_mom';
                end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------Crtanje delta i divc korekcija             
%--------------------------------------------------------------------------
               B2=B+100;
               h=figure(B2); 
                    plot_mn(1,3,1)
                        plot([1:12],corr_t2m(:,2),'b','Linewidth',1.5); hold on; temp2=corr_t2m(:,2);
                        plot([1:12],corr_t2m(:,1),'k','Linewidth',1.5); hold on; temp1=corr_t2m(:,1);
                        plot([1:12],corr_t2m(:,3),'m','Linewidth',1.5); hold on; temp3=corr_t2m(:,3);
          ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
          ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
          ind=isfinite(AC_t2m_DHMZ_vs_RCM_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on                        
                            xlim([1 12]); %ylim([-2.2 2.2]);
                            xlabel('time (month)','fontsize',FUTA); yh=ylabel('adj. for t (deg C)','fontsize',FUTA); set(yh, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
                            title([StationTXT{STAT},'; RCMcorr-DHMZ'] ,'Fontsize',FUTA);
                            %ttt=text(0,1.025,'a','units','normalized'); set(ttt,'fontsize',FUTA);
                            grid on
                            set(gca,'Fontsize',FUTA)                    
                            
                     plot_mn(1,3,2)
                        plot([1:12],corr_R(:,2),'b','Linewidth',1.5); hold on; temp2=corr_R(:,2);
                        plot([1:12],corr_R(:,1),'k','Linewidth',1.5); hold on; temp1=corr_R(:,1);
                        plot([1:12],corr_R(:,3),'m','Linewidth',1.5); hold on; temp3=corr_R(:,3);
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on

                            xlim([1 12]); %ylim([-85 85]);
                            title([StationTXT{STAT},'; RCMcorr-DHMZ'],'Fontsize',FUTA)
                            xlabel('time (month)','fontsize',12); yh=ylabel('adj. for P (mm)','fontsize',FUTA); set(yh, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
                            %ttt=text(0,1.025,'b','units','normalized'); set(ttt,'fontsize',FUTA);        
                            legend('RegCM','Aladin','Promes','location','southwest')
                            grid on
                            set(gca,'Fontsize',FUTA)

                     plot_mn(1,3,3)
                        plot([1:12],1./divc_R(:,2),'b','Linewidth',1.5); hold on; temp2=corr_R(:,2);
                        plot([1:12],1./divc_R(:,1),'k','Linewidth',1.5); hold on; temp1=corr_R(:,1);
                        plot([1:12],1./divc_R(:,3),'m','Linewidth',1.5); hold on; temp3=corr_R(:,3);
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
          ind=isfinite(AC_pr_DHMZ_vs_RCM_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on

                            xlim([1 12]); ylim([1 3]);
                            title([StationTXT{STAT},'; DHMZ/RCMcorr'],'Fontsize',FUTA)
                            xlabel('time (month)','fontsize',12); yh=ylabel('adj. for P (mm)','fontsize',FUTA); set(yh, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
                            %ttt=text(0,1.025,'c','units','normalized'); set(ttt,'fontsize',FUTA);        
                            grid on
                            set(gca,'Fontsize',FUTA)
                            
                    filenamePNG=[StationTXT{STAT},'_adjustment.png'];
                    filenameEPS=[StationTXT{STAT},'_adjustment.eps'];
                    print(h,filenamePNG,'-dpng','-S1200,600');
                    print(h,filenameEPS,'-depsc');
%%                 
%--------------------------------------------------------------------------Primjena delta i divc korekcija i prateci racun
                for MOD=[1:3]
                    
temp=squeeze(cell2mat(MM(:,MOD,1,1))); temp=reshape(temp,12,50); temp=temp'; temp=temp -repmat(corr_t2m(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,1,1)=reshape(temp',12*50,1); clear temp
temp=squeeze(cell2mat(MM(:,MOD,1,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp -repmat(  corr_R(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,1,2)=reshape(temp',12*50,1); clear temp   
temp=squeeze(cell2mat(MM(:,MOD,1,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp./repmat(  divc_R(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,1,3)=reshape(temp',12*50,1); clear temp   
temp=squeeze(cell2mat(MM(:,MOD,2,1))); temp=reshape(temp,12,50); temp=temp'; temp=temp -repmat(corr_t2m(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,2,1)=reshape(temp',12*50,1); clear temp
temp=squeeze(cell2mat(MM(:,MOD,2,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp -repmat(  corr_R(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,2,2)=reshape(temp',12*50,1); clear temp   
temp=squeeze(cell2mat(MM(:,MOD,2,2))); temp=reshape(temp,12,50); temp=temp'; temp=temp./repmat(  divc_R(:,MOD)',50,1); RCMcorr_adj_corr(:,MOD,2,3)=reshape(temp',12*50,1); clear temp   

temp=reshape(squeeze(RCMcorr_adj_corr(10*12+1:40*12,MOD,1,1)),12,30); AC_P0_tas_RCM_mom_adj_corr(:,MOD) =nanmean(temp');  AC_P0_tas_RCM_std_adj_corr(:,MOD)=std(temp',1);  clear temp
temp=reshape(squeeze(RCMcorr_adj_corr(10*12+1:40*12,MOD,1,2)),12,30); AC_P0_pr_RCM_mom_adj_corr1(:,MOD) =nanmean(temp');  AC_P0_pr_RCM_std_adj_corr1(:,MOD)=std(temp',1);  clear temp
temp=reshape(squeeze(RCMcorr_adj_corr(10*12+1:40*12,MOD,1,3)),12,30); AC_P0_pr_RCM_mom_adj_corr2(:,MOD) =nanmean(temp');  AC_P0_pr_RCM_std_adj_corr2(:,MOD)=std(temp',1);  clear temp
                                                                       AC_P0_pr_RCM_cv_adj_corr1(:,MOD) =AC_P0_pr_RCM_std_adj_corr1(:,MOD)./AC_P0_pr_RCM_mom_adj_corr1(:,MOD);
                                                                       AC_P0_pr_RCM_cv_adj_corr2(:,MOD) =AC_P0_pr_RCM_std_adj_corr2(:,MOD)./AC_P0_pr_RCM_mom_adj_corr2(:,MOD);

temp=reshape(squeeze(RCMcorr_adj_corr(20*12+1:50*12,MOD,2,2)),12,30); AC_P1_pr_RCM_mom_adj_corr1(:,MOD) =nanmean(temp'); clear temp
temp=reshape(squeeze(RCMcorr_adj_corr(20*12+1:50*12,MOD,2,3)),12,30); AC_P1_pr_RCM_mom_adj_corr2(:,MOD) =nanmean(temp'); clear temp
                   
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,1,1)),12,50);  TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD)=nanmean(temp);   clear temp                        
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,1,2)),12,50);  TS_HIST_pr_RCM_YMmean_adj_corr1(:,MOD)=nanmean(temp);   clear temp                            
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,1,3)),12,50);  TS_HIST_pr_RCM_YMmean_adj_corr2(:,MOD)=nanmean(temp);   clear temp                            
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,2,1)),12,50);  TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD) =nanmean(temp);   clear temp                        
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,2,2)),12,50);  TS_FUT_pr_RCM_YMmean_adj_corr1(:,MOD) =nanmean(temp);   clear temp  
temp=reshape(squeeze(RCMcorr_adj_corr(:,MOD,2,3)),12,50);  TS_FUT_pr_RCM_YMmean_adj_corr2(:,MOD) =nanmean(temp);   clear temp  
                   
                   ecdf_tas_RCM_YMmean_P0_adj_corr(:,MOD) =sort(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD)); 
                   ecdf_pr_RCM_YMmean_P0_adj_corr1(:,MOD) =sort(TS_HIST_pr_RCM_YMmean_adj_corr1(11:40,MOD)); 
                   ecdf_pr_RCM_YMmean_P0_adj_corr2(:,MOD) =sort(TS_HIST_pr_RCM_YMmean_adj_corr2(11:40,MOD)); 
                   
                 end %MOD  
                 

%-------------------------------------------------------------------     
%-------------------------------------------------------------------     
% ---> crtam T2m adj_corr
%-------------------------------------------------------------------     
%-------------------------------------------------------------------     
       B3=B+200;
       ht=figure(B3); 
            subplot(4,3,1)
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_mom_adj_corr(:,3),'m'); hold on
                plot([1:12],AC_P0_tas_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_mom,'r','Linewidth',2); hold on
                    xlim([1  12])
                    ylabel('mean t (deg C)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA)
                    %ttt=text(-0.1,1.15,'a','units','normalized'); set(ttt,'Fontsize',FUTA)
                
            subplot(4,3,2)
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,2),'b'); hold on
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,1),'k'); hold on
                plot([1:12],AC_P0_tas_RCM_std_adj_corr(:,3),'m'); hold on
                plot([1:12],AC_P0_tas_EOBS_std,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_tas_DHMZ_std,'r','Linewidth',2); hold on
                    xlim([1  12])
                    ylabel('std t (deg C)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA)
                    %ttt=text(-0.1,1.15,'b','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
            subplot(4,3,[7 8 9])                    
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,2),'b'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,1),'k'); hold on
                plot([1:50],TS_HIST_tas_RCM_YMmean_adj_corr(:,3),'m'); hold on
                plot([1:50],TS_HIST_tas_EOBS_YMmean(1:50),'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_tas_DHMZ_YMmean(1:50),'r','Linewidth',2); hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylim([13  18])    
                    ylabel('mean t (deg C)','Fontsize',FUTA); xlabel('time (year)','Fontsize',FUTA)
                    %ttt=text(-0.05,1.15,'g','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
            subplot(4,3,3)                    
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,2),ecdf_y,'b'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,1),ecdf_y,'k'); hold on
                stairs(ecdf_tas_RCM_YMmean_P0_adj_corr(:,3),ecdf_y,'m'); hold on
                stairs(ecdf_tas_EOBS_YMmean_P0,ecdf_y,'g','Linewidth',2); hold on
                stairs(ecdf_tas_DHMZ_YMmean_P0,ecdf_y_DHMZ_tas,'r','Linewidth',2); hold on
                    xlim([13  18])                       
                    ylim([0   1])
                    xlabel('mean annual t (deg C)','Fontsize',FUTA); ylabel('CDF','Fontsize',FUTA);  set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    %ttt=text(-0.1,1.15,'c','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
%-------------------------------------------------------------------             
       % ---> crtam R RCMcorr adj
%-------------------------------------------------------------------
            subplot(4,3,4);
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr1(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr1(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr1(:,3),'m'); hold on
                plot([1:12],AC_P0_pr_EOBS_mom,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_mom,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr2(:,2),'b--'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr2(:,1),'k--'); hold on
                plot([1:12],AC_P0_pr_RCM_mom_adj_corr2(:,3),'m--'); hold on
                    xlim([1   12])
                    ylabel('mean P (mm)','Fontsize',FUTA); xlabel('time (month)','Fontsize',FUTA)
                    %ttt=text(-0.1,1.15,'d','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
            subplot(4,3,5);
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr1(:,2),'b'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr1(:,1),'k'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr1(:,3),'m'); hold on
                plot([1:12],AC_P0_pr_EOBS_cv,'g','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_DHMZ_cv,'r','Linewidth',2); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr2(:,2),'b--'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr2(:,1),'k--'); hold on
                plot([1:12],AC_P0_pr_RCM_cv_adj_corr2(:,3),'m--'); hold on
                    ylabel('coeff. var. P','Fontsize',FUTA)
                    xlabel('time (month)','Fontsize',FUTA); xlim([1 12])                    
                    %ttt=text(-0.1,1.15,'e','units','normalized'); set(ttt,'Fontsize',FUTA)
                    
            subplot(4,3,[10 11 12]);  % *12 jer godisnji srednjak pretvaram u godisnju sumu                    
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr1(:,2)*12,'b'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr1(:,1)*12,'k'); hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr1(:,3)*12,'m'); hold on
                plot([1:50],TS_HIST_pr_EOBS_YMmean(1:50)*12,'g','Linewidth',2); hold on
                plot([1:50],TS_HIST_pr_DHMZ_YMmean(1:50),'r','Linewidth',2);    hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr2(:,2)*12,'b--');     hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr2(:,1)*12,'k--');     hold on
                plot([1:50],TS_HIST_pr_RCM_YMmean_adj_corr2(:,3)*12,'m--');     hold on
                    xlim([1  50]); set(gca,'xtick',[1 11 21 31 41 50],'xticklabel',{'1951', '1961', '1971', '1981', '1991', '2000'});
                    ylim([0 2000])    
                    ylabel('P amount (mm)','Fontsize',FUTA); xlabel('time (year)','Fontsize',FUTA)
                    %ttt=text(-0.05,1.15,'h','units','normalized'); set(ttt,'Fontsize',FUTA);
                    lll=legend('RegCM3','Aladin','Promes','EOBS','Local OBS'); set(lll,'FontSize',FUTA-5,'Position',[0.15 0.25 0.19 0.07]);

            subplot(4,3,6) % *12 jer godisnji srednjak pretvaram u godisnju sumu          
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr1(:,2)*12,ecdf_y,'b'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr1(:,1)*12,ecdf_y,'k'); hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr1(:,3)*12,ecdf_y,'m'); hold on
                stairs(ecdf_pr_EOBS_YMmean_P0*12,ecdf_y,'g','Linewidth',2); hold on
                stairs(ecdf_pr_DHMZ_YMmean_P0,ecdf_y_DHMZ_pr,'r','Linewidth',2); hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr2(:,2)*12,ecdf_y,'b--');    hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr2(:,1)*12,ecdf_y,'k--');    hold on
                stairs(ecdf_pr_RCM_YMmean_P0_adj_corr2(:,3)*12,ecdf_y,'m--');    hold on
                    xlim([0 2000])                     
                    ylim([0  1]) 
                    xlabel('annual P amount (mm)','Fontsize',FUTA); ylabel('CDF','Fontsize',FUTA); set(gca,'ytick',[0:0.2:1],'yticklabel',num2str([0:0.2:1]'));
                    %ttt=text(-0.1,1.15,'f','units','normalized'); set(ttt,'Fontsize',FUTA);
                    
                    filenamePNG=[StationTXT{STAT},'_',TYPEtxt2_corr{3},'.png'];
                    filenameEPS=[StationTXT{STAT},'_',TYPEtxt2_corr{3},'.eps'];
                    print(ht,filenamePNG,'-dpng','-S750,700');
                    print(ht,filenameEPS,'-depsc');
		    
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%%   
disp('Crtam P1 vs P0...')
            %-------------------------------------------------------------- %Crtanje P1 vs P0: RCM corr
           
            B4=B+400;
            ht=figure(B4); 
                subplot(2,2,1)
                              plot(xxx,AC_P1_tas_RCM_mom(:,2)-AC_P0_tas_RCM_mom(:,2),'b','Linewidth',1.5); hold on; temp2=AC_P1_tas_RCM_mom(:,2)-AC_P0_tas_RCM_mom(:,2);
                              plot(xxx,AC_P1_tas_RCM_mom(:,1)-AC_P0_tas_RCM_mom(:,1),'k','Linewidth',1.5); hold on; temp1=AC_P1_tas_RCM_mom(:,1)-AC_P0_tas_RCM_mom(:,1);
                              plot(xxx,AC_P1_tas_RCM_mom(:,3)-AC_P0_tas_RCM_mom(:,3),'m','Linewidth',1.5); hold on; temp3=AC_P1_tas_RCM_mom(:,3)-AC_P0_tas_RCM_mom(:,3);
                              ind=isfinite(AC_t2m_P0_vs_P1_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                              ind=isfinite(AC_t2m_P0_vs_P1_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                              ind=isfinite(AC_t2m_P0_vs_P1_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on
	                        xlim([1 12])
        	                ylim([0 4])
                	        xlabel('time (month)','Fontsize',FUTA)
                        	ylabel(' \Delta t (deg C)','Fontsize',FUTA)
	                        if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{2}],'Fontsize',FUTA); end
        	                grid on
                	        %ttt=text(-0.1,1.1,'a','units','normalized'); set(ttt,'Fontsize',FUTA)
                subplot(2,2,2)
                              plot(xxx,(AC_P1_pr_RCM_mom(:,2)-AC_P0_pr_RCM_mom(:,2))./AC_P0_pr_RCM_mom(:,2)*100,'b','Linewidth',1.5); hold on; temp2=(AC_P1_pr_RCM_mom(:,2)-AC_P0_pr_RCM_mom(:,2))./AC_P0_pr_RCM_mom(:,2)*100;
                              plot(xxx,(AC_P1_pr_RCM_mom(:,1)-AC_P0_pr_RCM_mom(:,1))./AC_P0_pr_RCM_mom(:,1)*100,'k','Linewidth',1.5); hold on; temp1=(AC_P1_pr_RCM_mom(:,1)-AC_P0_pr_RCM_mom(:,1))./AC_P0_pr_RCM_mom(:,1)*100;
                              plot(xxx,(AC_P1_pr_RCM_mom(:,3)-AC_P0_pr_RCM_mom(:,3))./AC_P0_pr_RCM_mom(:,3)*100,'m','Linewidth',1.5); hold on; temp3=(AC_P1_pr_RCM_mom(:,3)-AC_P0_pr_RCM_mom(:,3))./AC_P0_pr_RCM_mom(:,3)*100;  
                              plot(xxx,(AC_P1_pr_RCM_mom_adj_corr2(:,2)-AC_P0_pr_RCM_mom_adj_corr2(:,2))./AC_P0_pr_RCM_mom_adj_corr2(:,2)*100,'b--','Linewidth',1); hold on; 
                              plot(xxx,(AC_P1_pr_RCM_mom_adj_corr2(:,1)-AC_P0_pr_RCM_mom_adj_corr2(:,1))./AC_P0_pr_RCM_mom_adj_corr2(:,1)*100,'k--','Linewidth',1); hold on; 
                              plot(xxx,(AC_P1_pr_RCM_mom_adj_corr2(:,3)-AC_P0_pr_RCM_mom_adj_corr2(:,3))./AC_P0_pr_RCM_mom_adj_corr2(:,3)*100,'m--','Linewidth',1); hold on;                                      ind=isfinite(AC_pr_P0_vs_P1_sig(:,2)); plot(xxx(ind),temp2(ind),'o b','MarkerFaceColor','b'); hold on
                              ind=isfinite(AC_pr_P0_vs_P1_sig(:,1)); plot(xxx(ind),temp1(ind),'o k','MarkerFaceColor','k'); hold on
                              ind=isfinite(AC_pr_P0_vs_P1_sig(:,3)); plot(xxx(ind),temp3(ind),'o m','MarkerFaceColor','m'); hold on
		                xlim([1 12])
                		ylim([-70 70])
	                        xlabel('time (month)','Fontsize',FUTA)
        	                ylabel(' \Delta P (%)','Fontsize',FUTA)
                	        if (TYPE==2); title([StationTXT{STAT},' ',TYPEtxt2_corr{2}],'Fontsize',12); end
                        	grid on
	                        %ttt=text(-0.1,1.1,'b','units','normalized'); set(ttt,'Fontsize',FUTA)
        	                legend('P1-P0 RegCM3','P1-P0 Aladin','P1-P0 Promes','location','northwest')
                subplot(2,2,3)        
	                    stairs(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_y,'b'); hold on
        	            stairs(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_y,'k'); hold on
                	    stairs(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_y,'m'); hold on
	                    stairs(ecdf_tas_RCM_YMmean_P1(:,2),ecdf_y,'b','Linewidth',1.5); hold on
        	            stairs(ecdf_tas_RCM_YMmean_P1(:,1),ecdf_y,'k','Linewidth',1.5); hold on
                	    stairs(ecdf_tas_RCM_YMmean_P1(:,3),ecdf_y,'m','Linewidth',1.5); hold on                    
	                        ylim([0   1])
        	                xlabel('mean annual t (deg C)','Fontsize',FUTA)
                	        ylabel('CDF','Fontsize',FUTA)
                        	%ttt=text(-0.1,1.1,'c','units','normalized'); set(ttt,'Fontsize',FUTA)
                    		[testKS(2),NNN,MMM]=kolmogorov_smirnov_test_2(ecdf_tas_RCM_YMmean_P0(:,2),ecdf_tas_RCM_YMmean_P1(:,2));
		                [testKS(1),NNN,MMM]=kolmogorov_smirnov_test_2(ecdf_tas_RCM_YMmean_P0(:,1),ecdf_tas_RCM_YMmean_P1(:,1));
                	        [testKS(3),NNN,MMM]=kolmogorov_smirnov_test_2(ecdf_tas_RCM_YMmean_P0(:,3),ecdf_tas_RCM_YMmean_P1(:,3));
	             plot(13,0.5,'b o'); hold on; if (testKS(2)<0.05); plot(13,0.5,'b o','MarkerFaceColor','b'); hold on; end
        	     plot(13,0.6,'k o'); hold on; if (testKS(1)<0.05); plot(13,0.6,'k o','MarkerFaceColor','k'); hold on; end
	             plot(13,0.7,'m o'); hold on; if (testKS(3)<0.05); plot(13,0.7,'m o','MarkerFaceColor','m'); hold on; end
                subplot(2,2,4)
                	    stairs(ecdf_pr_RCM_YMmean_P0(:,2)*12,ecdf_y,'b'); hold on
        	            stairs(ecdf_pr_RCM_YMmean_P0(:,1)*12,ecdf_y,'k'); hold on
	                    stairs(ecdf_pr_RCM_YMmean_P0(:,3)*12,ecdf_y,'m'); hold on
        	            stairs(ecdf_pr_RCM_YMmean_P1(:,2)*12,ecdf_y,'b','Linewidth',1.5); hold on
                	    stairs(ecdf_pr_RCM_YMmean_P1(:,1)*12,ecdf_y,'k','Linewidth',1.5); hold on
	                    stairs(ecdf_pr_RCM_YMmean_P1(:,3)*12,ecdf_y,'m','Linewidth',1.5); hold on
        	                ylim([0  1])        
                	        xlabel('annual P amount (mm)','Fontsize',FUTA)   
	                        ylabel('CDF','Fontsize',FUTA)
        	                %ttt=text(-0.1,1.1,'d','units','normalized'); set(ttt,'Fontsize',FUTA)
                		[testKS(2), NNN, MMM]=kolmogorov_smirnov_test_2(ecdf_pr_RCM_YMmean_P0(:,2),ecdf_pr_RCM_YMmean_P1(:,2));
	                        [testKS(1), NNN, MMM]=kolmogorov_smirnov_test_2(ecdf_pr_RCM_YMmean_P0(:,1),ecdf_pr_RCM_YMmean_P1(:,1));
            		        [testKS(3), NNN, MMM]=kolmogorov_smirnov_test_2(ecdf_pr_RCM_YMmean_P0(:,3),ecdf_pr_RCM_YMmean_P1(:,3));
			           plot(600,0.5,'b o'); hold on; if (testKS(2)<0.05); plot(600,0.5,'b o','MarkerFaceColor','b'); hold on; end
			           plot(600,0.6,'k o'); hold on; if (testKS(1)<0.05); plot(600,0.6,'k o','MarkerFaceColor','k'); hold on; end
			           plot(600,0.7,'m o'); hold on; if (testKS(3)<0.05); plot(600,0.7,'m o','MarkerFaceColor','m'); hold on; end
			           lll=legend('P0 RegCM3','P0 Aladin','P0 Promes','P1 RegCM3','P1 Aladin','P1 Promes','location','southeast'); set(lll,'Fontsize',FUTA-5);
                        
                    filenamePNG=[StationTXT{STAT},'_P1_vs_P0_RCMcorr.png'];
                    filenameEPS=[StationTXT{STAT},'_P1_vs_P0_RCMcorr.eps'];
                    print(ht,filenamePNG,'-dpng','-S600,500');
                    print(ht,filenameEPS,'-depsc');

	end %od if (type==2)
	quit
%--------------------------------------------------------------
%--------------------------------------------------------------
%%   
disp('Crtam vremenske nizove RCMcorr...')
            %--------------------------------------------------------------
            % Crtanje vremenskih nizova T2m 
            %--------------------------------------------------------------
           
            B5=B+500; 
            panel=0; 
            ModelTXT{2}='RegCM3; trend='; 
            ModelTXT{1}='Aladin; trend='; 
            ModelTXT{3}='Promes; trend='; 
            Color{2}='b'; Color{1}='k'; Color{3}='m'; 
            Letter{2}='a'; Letter{1}='b'; Letter{3}='c';
            ht=figure(B5);     
            for MOD=[2 1 3]
            panel=panel+1;
            plot_mn(3,1,panel)
    tempT=[TS_HIST_tas_RCM_YMmean(:,MOD); TS_FUT_tas_RCM_YMmean(:,MOD)]; 
     P=polyfit([1:100]',tempT,1);    if (STAT~=5); [ H,p_value ] = MannKendall( tempT,0.05 ); end
    P2=polyfit([11:65]',tempT(11:65),1);    if (STAT~=5); [ H2,p_value2 ] = MannKendall( tempT(11:65),0.05 ); end
    P0_mean=mean(TS_HIST_tas_RCM_YMmean(11:40,MOD)); P0_std=std(TS_HIST_tas_RCM_YMmean(11:40,MOD),1);
    P1_mean=mean( TS_FUT_tas_RCM_YMmean(21:50,MOD)); P1_std=std( TS_FUT_tas_RCM_YMmean(21:50,MOD),1);
    plot([1:100],P(1)*[1:100]+P(2),Color{MOD}); hold on
    plot([11:65],P2(1)*[11:65]+P2(2),'g','Linewidth',2); hold on
    plot([1:100],[TS_HIST_tas_RCM_YMmean(:,MOD); TS_FUT_tas_RCM_YMmean(:,MOD)],Color{MOD},'Linewidth',1.5);
	    xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
	    text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',FUTA)
%   sadrzaj=[num2str(round(P0_mean*10)/10),'\pm',num2str(round(P0_std*10)/10),'deg C']; text(11,10.5,sadrzaj)
%   sadrzaj=[num2str(round(P1_mean*10)/10),'\pm',num2str(round(P1_std*10)/10),'deg C']; text(71,10.5,sadrzaj)
	   grid on; set(gca,'XGrid','on')
	   ylabel('t (deg C)','Fontsize',FUTA); ylim([10 19]); 
	   set(gca,'Fontsize',FUTA)
	SIG{1}='[nonsig.]'; SIG{2}='[sig.]';
	text1=[ModelTXT{MOD},num2str(round( P(1)*10*100)/100),' deg C/10yr ',SIG{ H+1}];
	text2=[ModelTXT{MOD},num2str(round(P2(1)*10*100)/100),' deg C/10yr ',SIG{H2+1}];
    legend(text1,text2,'location','northwest');
    if (panel==1); title([StationTXT{STAT},'; ',TYPEtxt2_corr{TYPE}],'Fontsize',FUTA); end
    if (panel==3); xlabel(' time (year)','Fontsize',FUTA); end    
    	    end; %od MOD
                        
                    filenameJPG=[StationTXT{STAT},'_',TYPEtxt2_corr{TYPE},'_T2m_TS.png'];
                    print(ht,filenameJPG,'-dpng','-S1000,750');    

            %--------------------------------------------------------------
            % Crtanje vremenskih nizova PR
            %--------------------------------------------------------------
           
            B6=B+600; 
	    panel=0;
            ht=figure(B6);    
            for MOD=[2 1 3]
            panel=panel+1;
                plot_mn(3,1,panel)
tempT=[TS_HIST_pr_RCM_YMmean(:,MOD); TS_FUT_pr_RCM_YMmean(:,MOD)]*12; 
P2=polyfit([11:65]',tempT(11:65),1);    if (STAT~=5); [ H2,p_value2 ] = MannKendall( tempT(11:65),0.05 ); end
P=polyfit([1:100]',tempT,1);      [ H,p_value ] = MannKendall( tempT,0.05 );
P0_mean=mean(TS_HIST_pr_RCM_YMmean(11:40,MOD)*12); P0_std=std(TS_HIST_pr_RCM_YMmean(11:40,MOD)*12,1);
P1_mean=mean( TS_FUT_pr_RCM_YMmean(21:50,MOD)*12); P1_std=std( TS_FUT_pr_RCM_YMmean(21:50,MOD)*12,1);
plot([1:100],P(1)*[1:100]+P(2),Color{MOD}); hold on
plot([11:65],P2(1)*[11:65]+P2(2),'g','Linewidth',2); hold on
plot([1:100],[TS_HIST_pr_RCM_YMmean(:,MOD); TS_FUT_pr_RCM_YMmean(:,MOD)]*12,Color{MOD},'Linewidth',1.5);
xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',FUTA)
%sadrzaj=[num2str(round(P0_mean)),'\pm',num2str(round(P0_std)),' mm']; text(11,400,sadrzaj)
%sadrzaj=[num2str(round(P1_mean)),'\pm',num2str(round(P1_std)),' mm']; text(71,400,sadrzaj)
             grid on; set(gca,'XGrid','on')
             ylabel('P (mm)','Fontsize',FUTA); ylim([300 1500]); 
             set(gca,'Fontsize',FUTA)
	SIG{1}='[nonsig.]'; SIG{2}='[sig.]';
	text1=[ModelTXT{MOD},num2str(round( P(1)*10*100)/100),' mm/10yr ',SIG{ H+1}];
	text2=[ModelTXT{MOD},num2str(round(P2(1)*10*100)/100),' mm/10yr ',SIG{H2+1}];
    legend(text1,text2,'location','northwest');
    if (panel==1); title([StationTXT{STAT},'; ',TYPEtxt2_corr{TYPE}],'Fontsize',FUTA); end
    if (panel==3); xlabel(' time (year)','Fontsize',FUTA); end    
            end %od MOD
                    

		    filenamePNG=[StationTXT{STAT},'_',TYPEtxt2_corr{TYPE},'_pr_TS.png'];
                    print(ht,filenamePNG,'-dpng','-S1000,750'); 

%--------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------
%%               
	if (TYPE==2)
disp('Crtam vremenske nizove RCMcorr_adj...')
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            % Crtanje vremenskih nizova T2m 
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
           
            B5=B+700; 
            panel=0; 
            ht=figure(B5);     
            for MOD=[2 1 3]
            panel=panel+1;
            plot_mn(3,1,panel)
plot([1:100],[TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD); TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD)],Color{MOD},'Linewidth',1.5); 
tempT=[TS_HIST_tas_RCM_YMmean_adj_corr(:,MOD); TS_FUT_tas_RCM_YMmean_adj_corr(:,MOD)]; P=polyfit([1:100]',tempT,1); if (STAT~=5);  [ H,p_value ] = MannKendall( tempT,0.05 ); end
P0_mean=mean(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD)); P0_std=std(TS_HIST_tas_RCM_YMmean_adj_corr(11:40,MOD),1);
P1_mean=mean( TS_FUT_tas_RCM_YMmean_adj_corr(21:50,MOD)); P1_std=std( TS_FUT_tas_RCM_YMmean_adj_corr(21:50,MOD),1);
xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
sadrzaj=[num2str(round(P0_mean*10)/10),'\pm',num2str(round(P0_std*10)/10),'deg C']; text(11,10.5,sadrzaj)
sadrzaj=[num2str(round(P1_mean*10)/10),'\pm',num2str(round(P1_std*10)/10),'deg C']; text(71,10.5,sadrzaj)
grid on; set(gca,'XGrid','on')
ylabel('t (deg C)','Fontsize',12); ylim([10 19])
set(gca,'Fontsize',12)
if (H==1); legend([ModelTXT{MOD},num2str(round(P(1)*10*100)/100),' deg C/10yr [sig.]'],'location','northwest')   ; end
if (H==0); legend([ModelTXT{MOD},num2str(round(P(1)*10*100)/100),' deg C/10yr [nonsig.]'],'location','northwest'); end
if (panel==1); title([StationTXT{STAT},'; RCMcorr adj'],'Fontsize',12); end
if (panel==3); xlabel(' time (year)','Fontsize',12); end    
            end %od MOD
                        
                    filenamePNG=[StationTXT{STAT},'_RCMcorr_adj_T2m_TS.png'];
                    print(ht,filenamePNG,'-dpng','-S1000,750'); 
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            % Crtanje vremenskih nizova PR
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
           
            B6=B+800; 
            panel=0; 
            ht=figure(B6);     
            for MOD=[2 1 3]
            panel=panel+1;
            plot_mn(3,1,panel);
plot([1:100],[TS_HIST_pr_RCM_YMmean_adj_corr1(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr1(:,MOD)]*12,Color{MOD},'Linewidth',1.5); hold on 
plot([1:100],[TS_HIST_pr_RCM_YMmean_adj_corr2(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr2(:,MOD)]*12,Color{MOD},'Linewidth',2.5); 
       tempT1=[TS_HIST_pr_RCM_YMmean_adj_corr1(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr1(:,MOD)]*12; 
       tempT2=[TS_HIST_pr_RCM_YMmean_adj_corr2(:,MOD); TS_FUT_pr_RCM_YMmean_adj_corr2(:,MOD)]*12; 
       P1=polyfit([1:100]',tempT1,1);  [ H1,p_value1 ] = MannKendall( tempT1,0.05 ); 
       P2=polyfit([1:100]',tempT2,1);  [ H2,p_value2 ] = MannKendall( tempT2,0.05 ); 
P0_mean1=mean(TS_HIST_pr_RCM_YMmean_adj_corr1(11:40,MOD)*12); P0_std1=std(TS_HIST_pr_RCM_YMmean_adj_corr1(11:40,MOD)*12,1);
P0_mean2=mean(TS_HIST_pr_RCM_YMmean_adj_corr2(11:40,MOD)*12); P0_std2=std(TS_HIST_pr_RCM_YMmean_adj_corr2(11:40,MOD)*12,1);
P1_mean1=mean( TS_FUT_pr_RCM_YMmean_adj_corr1(21:50,MOD)*12); P1_std1=std( TS_FUT_pr_RCM_YMmean_adj_corr1(21:50,MOD)*12,1);
P1_mean2=mean( TS_FUT_pr_RCM_YMmean_adj_corr2(21:50,MOD)*12); P1_std2=std( TS_FUT_pr_RCM_YMmean_adj_corr2(21:50,MOD)*12,1);
xlim([0 100]); set(gca,'xtick',[0:10:100],'xticklabel',num2str([1950:10:2050]'));
text(-0.05,1.1,Letter{MOD},'units','normalized','Fontsize',12)
sadrzaj=[num2str(round(P0_mean1)),'\pm',num2str(round(P0_std1)),' mm']; text(11,600,sadrzaj)
sadrzaj=[num2str(round(P1_mean1)),'\pm',num2str(round(P1_std1)),' mm']; text(71,600,sadrzaj)
sadrzaj=[num2str(round(P0_mean2)),'\pm',num2str(round(P0_std2)),' mm']; text(11,700,sadrzaj)
sadrzaj=[num2str(round(P1_mean2)),'\pm',num2str(round(P1_std2)),' mm']; text(71,700,sadrzaj)
grid on; set(gca,'XGrid','on')
ylabel('P (mm)','Fontsize',12); ylim([300 3000])
set(gca,'Fontsize',12)
if ((H1==1)&(H2==1)); 
	legend([ModelTXT{MOD},num2str(round(P1(1)*10*10)/10),' mm/10yr [sig.]'],[ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr [sig.]'],'location','northwest'); 
end
if ((H1==1)&(H2==0)); 
	legend([ModelTXT{MOD},num2str(round(P1(1)*10*10)/10),' mm/10yr [sig.]'],[ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr [nonsig.]'],'location','northwest'); 
end
if ((H1==0)&(H2==1)); 
	legend([ModelTXT{MOD},num2str(round(P1(1)*10*10)/10),' mm/10yr [nonsig.]'],[ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr [sig.]'],'location','northwest'); 
end
if ((H1==0)&(H2==0)); 
	legend([ModelTXT{MOD},num2str(round(P1(1)*10*10)/10),' mm/10yr [nonsig.]'],[ModelTXT{MOD},num2str(round(P2(1)*10*10)/10),' mm/10yr [nonsig.]'],'location','northwest'); 
end

if (panel==1); title([StationTXT{STAT},'; RCMcorr adj'],'Fontsize',12); end    
if (panel==3); xlabel(' time (year)','Fontsize',12); end    
            end %od MOD              
                       
            filenamePNG=[StationTXT{STAT},'_RCMcorr_adj_pr_TS.png'];
            print(ht,filenamePNG,'-dpng','-S1000,750');
%----------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------
            end % if TYPE 2

%% ------------------------------------------------------------------------ write to Excel
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
                end %year
                for MOD=1:3
                    matrica(  1:600 ,MOD+2) =squeeze(MM{:,MOD,1,1});
                    matrica(601:1200,MOD+2) =squeeze(MM{:,MOD,2,1});       matrica_YM(:,MOD+1) =mean(reshape(matrica(:,MOD+2),12,100));
                    matrica(  1:600 ,MOD+5) =squeeze(MM{:,MOD,1,2});
                    matrica(601:1200,MOD+5) =squeeze(MM{:,MOD,2,2});       matrica_YM(:,MOD+4) =sum(reshape(matrica(:,MOD+5), 12,100));
                    matrica(  1:600 ,MOD+8) =RCMcorr_adj_corr(:,MOD,1,1);
                    matrica(601:1200,MOD+8) =RCMcorr_adj_corr(:,MOD,2,1);  matrica_YM(:,MOD+7) =mean(reshape(matrica(:,MOD+8),12,100));
                    matrica(  1:600 ,MOD+11)=RCMcorr_adj_corr(:,MOD,1,2);
                    matrica(601:1200,MOD+11)=RCMcorr_adj_corr(:,MOD,2,2);  matrica_YM(:,MOD+10)=sum(reshape(matrica(:,MOD+11),12,100));
         		    matrica(  1:600 ,MOD+14)=RCMcorr_adj_corr(:,MOD,1,3);
	                    matrica(601:1200,MOD+14)=RCMcorr_adj_corr(:,MOD,2,3);  matrica_YM(:,MOD+13)=sum(reshape(matrica(:,MOD+14),12,100));
                    for SEAS=1:4
                        %     DEC 1960             JAN 2051 FEB 2051
                        temp=[NaN; matrica(:,MOD+2);  NaN; NaN]; temp=mean(reshape(temp,3,401)); %mean T2m RCMcorr
                        matrica_SM(:,MOD+1,1)=temp(2:4:end); %MAM
                        matrica_SM(:,MOD+1,2)=temp(3:4:end); %JJA
                        matrica_SM(:,MOD+1,3)=temp(4:4:end); %SON
                        matrica_SM(:,MOD+1,4)=temp(5:4:end); %DJF
                        
                        temp=[NaN; matrica(:,MOD+5);  NaN; NaN]; temp=sum(reshape(temp,3,401)); %sum pr RCMcorr
                        matrica_SM(:,MOD+4,1)=temp(2:4:end); %MAM
                        matrica_SM(:,MOD+4,2)=temp(3:4:end); %JJA
                        matrica_SM(:,MOD+4,3)=temp(4:4:end); %SON
                        matrica_SM(:,MOD+4,4)=temp(5:4:end); %DJF
                        
                        temp=[NaN; matrica(:,MOD+8);  NaN; NaN]; temp=mean(reshape(temp,3,401)); %mean T2m RCMcorr_adj
                        matrica_SM(:,MOD+7,1)=temp(2:4:end); %MAM
                        matrica_SM(:,MOD+7,2)=temp(3:4:end); %JJA
                        matrica_SM(:,MOD+7,3)=temp(4:4:end); %SON
                        matrica_SM(:,MOD+7,4)=temp(5:4:end); %DJF
                        
                        temp=[NaN; matrica(:,MOD+11); NaN; NaN]; temp=sum(reshape(temp,3,401)); %sum pr RCMcorr_adj v1
                        matrica_SM(:,MOD+10,1)=temp(2:4:end); %MAM
                        matrica_SM(:,MOD+10,2)=temp(3:4:end); %JJA
                        matrica_SM(:,MOD+10,3)=temp(4:4:end); %SON
                        matrica_SM(:,MOD+10,4)=temp(5:4:end); %DJF
                        temp=[NaN; matrica(:,MOD+14); NaN; NaN]; temp=sum(reshape(temp,3,401)); %sum pr RCMcorr_adj v2
                        matrica_SM(:,MOD+13,1)=temp(2:4:end); %MAM
                        matrica_SM(:,MOD+13,2)=temp(3:4:end); %JJA
                        matrica_SM(:,MOD+13,3)=temp(4:4:end); %SON
                        matrica_SM(:,MOD+13,4)=temp(5:4:end); %DJF
                    end %SEAS
                end %MOD

%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
%------------------ Plot CDF and TS
%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
SEAStxt{1}='MAM';
SEAStxt{2}='JJA';
SEAStxt{3}='SON';
SEAStxt{4}='DJF';
		ht=figure(1000);
			for SEAS=[1:4];
				plot_mn(3,2,SEAS);
plot(matrica_SM(:,1,SEAS),matrica_SM(:,2+1,SEAS),Color{2},'Linewidth',1); hold on
plot(matrica_SM(:,1,SEAS),matrica_SM(:,1+1,SEAS),Color{1},'Linewidth',1); hold on
plot(matrica_SM(:,1,SEAS),matrica_SM(:,3+1,SEAS),Color{3},'Linewidth',1); hold on
plot(matrica_SM(:,1,SEAS),matrica_SM(:,2+7,SEAS),Color{2},'Linewidth',2); hold on
plot(matrica_SM(:,1,SEAS),matrica_SM(:,1+7,SEAS),Color{1},'Linewidth',2); hold on
plot(matrica_SM(:,1,SEAS),matrica_SM(:,3+7,SEAS),Color{3},'Linewidth',2); hold on
					ylim([0 30])
					xlim([1951 2050])
					title(['mean T2m (deg C) ', SEAStxt{SEAS}])
%i					`f (SEAS==1); legend('RegCM RCMcorr','Aladin RCMcorr','Promes RCMcorr','RegCM RCMcorr adj','Aladin RCMcorr adj','Promes RCMcorr adj','location','northeast'); end
			end
				plot_mn(3,2,5);
plot(matrica_YM(:,1),matrica_YM(:,2+1),Color{2},'Linewidth',1); hold on
plot(matrica_YM(:,1),matrica_YM(:,1+1),Color{1},'Linewidth',1); hold on
plot(matrica_YM(:,1),matrica_YM(:,3+1),Color{3},'Linewidth',1); hold on
plot(matrica_YM(:,1),matrica_YM(:,2+7),Color{2},'Linewidth',2); hold on
plot(matrica_YM(:,1),matrica_YM(:,1+7),Color{1},'Linewidth',2); hold on
plot(matrica_YM(:,1),matrica_YM(:,3+7),Color{3},'Linewidth',2); hold on
					ylim([0 30])
					xlim([1951 2050])
					title(['mean T2m (deg C) Year'])

            		filenamePNG=[StationTXT{STAT},'_T2m_SEAS_timeseries.png'];
		        print(ht,filenamePNG,'-dpng','-S1600,800');

		ht=figure(3000);
			for SEAS=[1:4];
				plot_mn(3,2,SEAS);
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,2+4,SEAS),Color{2},'Linewidth',1); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,1+4,SEAS),Color{1},'Linewidth',1); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,3+4,SEAS),Color{3},'Linewidth',1); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,2+10,SEAS),Color{2},'Linewidth',2); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,1+10,SEAS),Color{1},'Linewidth',2); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,3+10,SEAS),Color{3},'Linewidth',2); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,2+13,SEAS),Color{2},'Linewidth',3); hold on 
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,1+13,SEAS),Color{1},'Linewidth',3); hold on
	plot(matrica_SM(:,1,SEAS),matrica_SM(:,3+13,SEAS),Color{3},'Linewidth',3); hold on
							ylim([0 1000])
							xlim([1951 2050])
							title(['sum pr (mm) ',SEAStxt{SEAS}])
%					if (SEAS==1); legend('RegCM RCMcorr','Aladin RCMcorr','Promes RCMcorr','RegCM RCMcorr adj1','Aladin RCMcorr adj1','Promes RCMcorr adj1','RegCM RCMcorr adj2','Aladin RCMcorr adj2','Promes RCMcorr adj2','location','northeast'); end
			end
				plot_mn(3,2,5);
	plot(matrica_YM(:,1),matrica_YM(:,2+4),Color{2},'Linewidth',1); hold on
	plot(matrica_YM(:,1),matrica_YM(:,1+4),Color{1},'Linewidth',1); hold on
	plot(matrica_YM(:,1),matrica_YM(:,3+4),Color{3},'Linewidth',1); hold on
	plot(matrica_YM(:,1),matrica_YM(:,2+10),Color{2},'Linewidth',2); hold on
	plot(matrica_YM(:,1),matrica_YM(:,1+10),Color{1},'Linewidth',2); hold on
	plot(matrica_YM(:,1),matrica_YM(:,3+10),Color{3},'Linewidth',2); hold on
	plot(matrica_YM(:,1),matrica_YM(:,2+13),Color{2},'Linewidth',3); hold on
	plot(matrica_YM(:,1),matrica_YM(:,1+13),Color{1},'Linewidth',3); hold on
	plot(matrica_YM(:,1),matrica_YM(:,3+13),Color{3},'Linewidth',3); hold on
							ylim([0 2000])
							xlim([1951 2050])
							title(['sum pr (mm) year'])

            		filenamePNG=[StationTXT{STAT},'_pr_SEAS_timeseries.png'];
		        print(ht,filenamePNG,'-dpng','-S1600,800');

%---Tablica jos jedna
%manje razlike u odnosu na izvjesce za DRINKADRIA je vezano za std(0) vs std(1).
st1= 1; st2=11;
en1=50; en2=40;
	MMMM=nan(5,4);
	MMMM(1:3,1:4)=[mean(TS_HIST_tas_RCM_YMmean(st1:en1,[2 1 3]))'    ...        
                       mean(TS_HIST_tas_RCM_YMmean(st2:en2,[2 1 3]))'    ...        
                       mean(TS_HIST_pr_RCM_YMmean(st1:en1,[2 1 3])*12)'  ...        
                       mean(TS_HIST_pr_RCM_YMmean(st2:en2,[2 1 3])*12)'];            
	MMMM(  4,1:4)=[mean(TS_HIST_tas_DHMZ_YMmean(st1:en1))    ...         
                       nanmean(TS_HIST_tas_DHMZ_YMmean(st2:en2))    ...         
                       mean(TS_HIST_pr_DHMZ_YMmean(st1:en1))     ...
                       nanmean(TS_HIST_pr_DHMZ_YMmean(st2:en2))];      
	MMMM(  5,1:4)=[mean(TS_HIST_tas_EOBS_YMmean(st1:en1))    ...         
                       mean(TS_HIST_tas_EOBS_YMmean(st2:en2))    ...         
                       mean(TS_HIST_pr_EOBS_YMmean(st1:en1))*12  ...
                       mean(TS_HIST_pr_EOBS_YMmean(st2:en2))*12];      
	SSSS=nan(5,4);
	SSSS(1:3,1:4)=[std(TS_HIST_tas_RCM_YMmean(st1:en1,[2 1 3]))'    ...        
                       std(TS_HIST_tas_RCM_YMmean(st2:en2,[2 1 3]))'    ...        
                       std(TS_HIST_pr_RCM_YMmean(st1:en1,[2 1 3])*12)'  ...        
                       std(TS_HIST_pr_RCM_YMmean(st2:en2,[2 1 3])*12)'];            
	SSSS(  4,1:4)=[std(TS_HIST_tas_DHMZ_YMmean(st1:en1))    ...         
                       nanstd(TS_HIST_tas_DHMZ_YMmean(st2:en2))    ...         
                       std(TS_HIST_pr_DHMZ_YMmean(st1:en1))     ...
                       nanstd(TS_HIST_pr_DHMZ_YMmean(st2:en2))];      
	SSSS(  5,1:4)=[std(TS_HIST_tas_EOBS_YMmean(st1:en1))    ...         
                       std(TS_HIST_tas_EOBS_YMmean(st2:en2))    ...         
                       std(TS_HIST_pr_EOBS_YMmean(st1:en1))*12  ...
                       std(TS_HIST_pr_EOBS_YMmean(st2:en2))*12];      



%--------------------------------------------------------------------------                    
   end %od TYPE rgrid, BiasCorr, BiasCorr_adj oliti RCM, RCMcorr, RCMcorr_adj
end    %STAT
end



