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

RCM_HST_mm=nan(2,3,4,7, 600);
RCM_FUT_mm=nan(2,3,4,7,1200); N=[1200 1200 600];
VARtxt2={'tas_mon','tas_mon','pr_mon','pr_mon'}; VARtxt={'tas','tas','pr','pr'};
TYPtxt={'HIST_rgrid','FUT_rgrid','HIST_BiasCorr','FUT_BiasCorr'};

% for VAR=[1:2]
%     for MOD=[1:3];
%         for TYPE=[1:4];
%             for STAT=[1:7];
 for VAR=[1]
     for MOD=[1];
         for TYPE=[3];
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
