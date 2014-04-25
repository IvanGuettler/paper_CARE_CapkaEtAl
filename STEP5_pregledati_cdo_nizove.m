close all; clear all; clc

%(1) ucitati DHMZ podatke 1961-2012
load('SezoneObo.mat');
    obor_mm=ulazSvi(:,2:end,:);
    obor_ss=SezoneSvi(:,1:5,:);
load('SezoneTemp.mat');
    temp_mm=ulazSvi(:,2:end,:);
    temp_ss=SezoneSvi(:,1:5,:);
     
%---------------> uskladiti T2m i R
postajaX=[13 14 15 2 1 3 4];
%---------------> boje sezona i godine
TYPE_SS={'g','r','k','b','m-o'};
%---------------> postaje od modela
gradImeRCM={'Pazin','Abrami','Porec','Celega','Metkovic','Ploce','Opuzen'};
%---------------> oznake za modele
MODType1={'b-s','b-o','b-x'};
MODType2={'r-s','r-o','r-x'};


%(2) crtam izvorne podatke MM
%-----------------------------------> temperatura
figure(1); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    subplot(3,3,postaja)
        temp_mm_row(:,postaja)=reshape(temp_mm(:,:,postaja)',52*12,1);
        plot(squeeze(temp_mm_row(:,postaja))); hold on
        plot([1 1 NaN 360 360],[-5 30 NaN -5 30],'r','Linewidth',3)
            xlim([1 52*12]); ylim([-5 30]); xlabel('time (month)'); ylabel('T2m (degC)');
            title(gradIme(postaja))
end
%-----------------------------------> oborina
figure(2); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    subplot(3,3,postaja)
        obor_mm_row(:,postaja)=reshape(obor_mm(:,:,postajaX(postaja))',52*12,1);
        plot(squeeze(obor_mm_row(:,postaja))); hold on
        plot([1 1 NaN 360 360],[0 500 NaN 0 500],'r','Linewidth',3)
            xlim([1 52*12]); ylim([0 500]); xlabel('time (month)'); ylabel('R (mm)');
            title(gradIme(postaja))
end

%(3) crtam izvorne podatke SS i YM
%-----------------------------------> temperatura
figure(3); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for seas=1:5
    subplot(3,3,postaja)
        temp_ss_row(:,seas,postaja)=temp_ss(:,seas,postaja);
        plot([1961:1:2012],temp_ss_row(:,seas,postaja),TYPE_SS{seas}); hold on
            xlim([1961 2012]); ylim([-5 30]); xlabel('time (year)'); ylabel('T2m (degC)');
            title(gradIme(postaja))
            if (postaja==1&seas==5); legend('MAM','JJA','SON','DJF','Year','Location','northwest'); end
    end
        plot([1 1 NaN 30 30],[-5 30 NaN -5 30],'r','Linewidth',3)
end
%-----------------------------------> oborina
figure(4); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for seas=1:5
    subplot(3,3,postaja)
        obor_ss_row(:,seas,postaja)=obor_ss(:,seas,postajaX(postaja));
        plot([1961:1:2012],obor_ss_row(:,seas,postaja),TYPE_SS{seas}); hold on
            xlim([1961 2012]); ylim([0 2000]); xlabel('time (year)'); ylabel('R (mm)');
            title(gradIme(postaja))
            if (postaja==4&seas==5); legend('MAM','JJA','SON','DJF','Year','Location','northwest'); end
    end
        plot([1 1 NaN 30 30],[-5 30 NaN -5 30],'r','Linewidth',3)
end


%%
% (3) Ucitati podatke RCM: CC WaterS

%               ___________ mean monthly T2m, monthly precipitation sum
%              |  _________ Aladin, RegCM, Promes
%              | |  _______ HIST rgrid, FUT rgrid, HIST bias corr, FUT bias corr
%              | | |  _____ Postaj: Pazin, Abrami, Porec, Celega, Metković, Ploče, Opuzen 
%              | | | |  ___ broj vremenski koraka
%              | | | | | 
%              v v v v v
RCM_HST_mm=nan(2,3,4,7, 600);
RCM_FUT_mm=nan(2,3,4,7,1200); N=[1200 1200 600];
VARtxt2={'tas_mon','rr_mon'}; VARtxt={'tas','pr'};
TYPtxt={'HIST_rgrid','FUT_rgrid','HIST_BiasCorr','FUT_BiasCorr'};

for VAR=[1:2]
    for MOD=[1:3];
        for TYPE=[1:4];
            for STAT=[1:7];
                FILENAME=['../MOD',num2str(MOD),'_',TYPtxt{TYPE},'_',VARtxt{VAR},'_STAT',num2str(STAT),'.nc'];
                 if (TYPE==1); RCM_HST_mm(VAR,MOD,TYPE,STAT,1:600)   =ncread(FILENAME,VARtxt2{VAR}); end
                 if (TYPE==2); RCM_FUT_mm(VAR,MOD,TYPE,STAT,1:N(MOD))=ncread(FILENAME,VARtxt2{VAR}); end
                 if (TYPE==3); RCM_HST_mm(VAR,MOD,TYPE,STAT,1:600)   =ncread(FILENAME,VARtxt2{VAR}); end
                 if (TYPE==4); RCM_FUT_mm(VAR,MOD,TYPE,STAT,1:N(MOD))=ncread(FILENAME,VARtxt2{VAR}); end
            end
        end
    end
end
%%
% ----> plot RCM T2m monthly means: HIST
figure(5); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for MOD=1:3
    subplot(3,3,postaja)
          plot(squeeze(RCM_HST_mm(1,MOD,1,postaja,:)),MODType1{MOD}); hold on
          plot(squeeze(RCM_HST_mm(1,MOD,3,postaja,:)),MODType2{MOD}); hold on
          xlabel('time (month)'); ylabel('T2m (degC)');
          title(gradImeRCM{postaja})
    end
end
hold off
% ----> plot RCM T2m monthly means: FUT
figure(6); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for MOD=1:3
    subplot(3,3,postaja)
          plot(squeeze(RCM_FUT_mm(1,MOD,2,postaja,:)),MODType1{MOD}); hold on
          plot(squeeze(RCM_FUT_mm(1,MOD,4,postaja,:)),MODType2{MOD}); hold on
          xlabel('time (month)'); ylabel('T2m (degC)');
          title(gradImeRCM{postaja})
    end
end
hold off
%%
% ----> plot RCM R monthly sum: HIST
figure(7); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for MOD=1:3
    subplot(3,3,postaja)
          plot(squeeze(RCM_HST_mm(2,MOD,1,postaja,:)),MODType1{MOD}); hold on
          plot(squeeze(RCM_HST_mm(2,MOD,3,postaja,:)),MODType2{MOD}); hold on
          xlabel('time (month)'); ylabel('R (mm)');
          title(gradImeRCM{postaja})
    end
end
hold off
% ----> plot RCM R monthly sum: FUT
figure(8); set(gcf,'Position',[190 61 1212 737])
for postaja=1:7;
    for MOD=1:3
    subplot(3,3,postaja)
          plot(squeeze(RCM_FUT_mm(2,MOD,2,postaja,:)),MODType1{MOD}); hold on
          plot(squeeze(RCM_FUT_mm(2,MOD,4,postaja,:)),MODType2{MOD}); hold on
          xlabel('time (month)'); ylabel('R (mm)');
          title(gradImeRCM{postaja})
    end
end
hold off