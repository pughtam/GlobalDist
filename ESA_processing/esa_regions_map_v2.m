%Make a map showing the locations of the forest regions used.
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using XXXX)
% - esa_forest_9regions_new_1deg_func.m
%
%T. Pugh
%14.12.17

fmask=ncread('/media/pughtam/rds-2017-pughtam-01/Disturbance/hansen_forested_frac_1deg_thres50.nc4','forested_50_percent')';
%Find gridcells with forest cover >25%
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;

%ESA landcover
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);
regions(3)=[];

rmaskmod=rmask;
rmaskmod(rmask==1)=8;
rmaskmod(rmask==2)=7;
rmaskmod(rmask==3)=1;
rmaskmod(rmask==4)=6;
rmaskmod(rmask==5)=5;
rmaskmod(rmask==6)=4;
rmaskmod(rmask==7)=3;
rmaskmod(rmask==8)=2;
rmaskmod(rmask==9)=1;

rmaskmod=rmaskmod.*fmask_thres;

masklabels=fliplr(regions);

figure
p1=pcolor(-180:1:179,-90:1:89,rmaskmod);
set(p1,'linestyle','none');
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel',[-120 -60 0 60 120])
colormap(flipud(jet(9)))
caxis([1 9])
c1=colorbar;
set(c1,'Ticks',[1.4 2.3 3.2 4.1 4.9 5.8 6.7 7.6])
set(c1,'TickLabels',masklabels)
set(c1,'Limits',[1 8])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

cmap=cbrewer('qual','Accent',9);
colormap(cmap)

