close all; clear all; clc

 elea=ncread('./elev_0.25deg_reg_v3.0.nc','elevation'); ind=find(elea==-9999); elea(ind)=NaN;
 lati=ncread('./elev_0.25deg_reg_v3.0.nc','latitude' );
longi=ncread('./elev_0.25deg_reg_v3.0.nc','longitude');

    granica=load('./3269.dat');
      obala=load('./2876.dat');

postaje(1,:)=[13+56/60+43/3600, 45+14/60+27/3600]; texT{1}='Pazin';
postaje(2,:)=[13+55/60+48/3600, 45+25/60+51/3600]; texT{2}='Abrami';
postaje(3,:)=[13+36/60+13/3600, 45+13/60+13/3600]; texT{3}='Porec';
postaje(4,:)=[13+35/60+0/3600,  45+20/60+0/3600];  texT{4}='Celega';
postaje(5,:)=[17+38/60+35/3600, 43+2/60+47/3600];  texT{5}='Metkovic';
postaje(6,:)=[17+26/60+34/3600, 43+2/60+51/3600];  texT{6}='Ploce';
postaje(7,:)=[17+33/60+31/3600, 43+1/60+ 3/3600];  texT{7}='Opuzen';

[X,Y]=meshgrid(longi,lati);
%%
figure(1); set(gcf,'Position',[251 6 939 781])
subplot(2,2,1)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
    
subplot(2,2,2)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
            plot(postaje(:,1),postaje(:,2),'x g')
    xlim([10 20])
    ylim([42 48])
    for STAT=[1:7]; 
       ttt=text(postaje(STAT,1)-0.05,postaje(STAT,2)-0.025,texT{STAT}); set(ttt,'Color','green');
    end   
    caxis([0 2500])
 subplot(2,2,3)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
            plot(postaje(:,1),postaje(:,2),'x g')
    xlim([13.4 14.4])
    ylim([44.9 45.6])
    for STAT=[1:7]; 
       ttt=text(postaje(STAT,1)-0.05,postaje(STAT,2)-0.025,texT{STAT}); set(ttt,'Color','green');
    end   
    caxis([0 2500])   
 subplot(2,2,4)
    pcolorjw(X,Y,double(elea')); hold on
            plot(granica(:,1),granica(:,2),'r');                         hold on
            plot(obala(:,1),obala(:,2),'r');                             hold on
            plot(postaje(:,1),postaje(:,2),'x g')
    xlim([17.13 17.9])
    ylim([42.8  43.2])
    for STAT=[1:7]; 
       ttt=text(postaje(STAT,1)-0.05,postaje(STAT,2)-0.025,texT{STAT}); set(ttt,'Color','green');
    end   
    caxis([0 2500])   
