close all; clear all; clc

 elea=ncread('./elev_0.25deg_reg_v3.0.nc','elevation'); ind=find(elea==-9999); elea(ind)=NaN;
 lati=ncread('./elev_0.25deg_reg_v3.0.nc','latitude' );
longi=ncread('./elev_0.25deg_reg_v3.0.nc','longitude');

    granica=load('./3269.dat');
      obala=load('./2876.dat');

postaje(1,:)=[13+56/60+43/3600, 45+14/60+27/3600]; %> Poreč
postaje(2,:)=[13+55/60+48/3600, 45+25/60+51/3600]; %> Abrami
postaje(3,:)=[13+36/60+13/3600, 45+13/60+13/3600]; %> Pazin
postaje(4,:)=[13+35/60+0/3600,  45+20/60+0/3600];  %> Novigrad Celega
postaje(5,:)=[17+38/60+35/3600, 43+2/60+47/3600];  %> Metković
postaje(6,:)=[17+26/60+34/3600, 43+2/60+51/3600];  %> Ploče
postaje(7,:)=[17+33/60+31/3600, 43+1/60+ 3/3600];  %> Opuzen


[X,Y]=meshgrid(longi,lati);

figure(1); set(gcf,'Position',[110 135 1289 548])
subplot(1,2,1)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
    
subplot(1,2,2)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
            plot(postaje(:,1),postaje(:,2),'x g')
    xlim([10 20])
    ylim([42 48])
    
    
    caxis([0 2500])
    
