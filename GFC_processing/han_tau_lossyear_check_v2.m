%Script to calculate the effect of different numbers of data years on the calculation of tau.
%Makes line plots of forest type-level statistics and maps.
%
%Dependencies:
% - *.mat files from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
% calculated with a range of different values for lossyear
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - esa_forest_9regions_new_1deg_func.m
%
%T. Pugh
%14.02.19

file_fmask='hansen_forested_frac_1deg_thres50.nc4';

%Load in the tau data for different sets of processing years
load hansen_disturb_int_calc_1deg_lu_v4_lossyear6_outarrays.mat %2000-2006
tau_d_1deg_lucorr_maskhigh_6=tau_d_1deg_lucorr_maskhigh';
load hansen_disturb_int_calc_1deg_lu_v4_lossyear8_outarrays.mat %2000-2008
tau_d_1deg_lucorr_maskhigh_8=tau_d_1deg_lucorr_maskhigh';
load hansen_disturb_int_calc_1deg_lu_v4_lossyear10_outarrays.mat %2000-2010
tau_d_1deg_lucorr_maskhigh_10=tau_d_1deg_lucorr_maskhigh';
load hansen_disturb_int_calc_1deg_lu_v4_lossyear12_outarrays.mat %2000-2012
tau_d_1deg_lucorr_maskhigh_12=tau_d_1deg_lucorr_maskhigh';
load hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat %2000-2014
tau_d_1deg_lucorr_maskhigh_14=tau_d_1deg_lucorr_maskhigh';
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper tau_d_1deg_lucorr_mask tau_d_1deg_lucorr_maskhigh...
tau_d_1deg_lucorr_lower_maskhigh tau_d_1deg_lucorr_upper_maskhigh

tau_d_1deg_lucorr_maskhigh_comb=cat(3,tau_d_1deg_lucorr_maskhigh_6,tau_d_1deg_lucorr_maskhigh_8,tau_d_1deg_lucorr_maskhigh_10,...
    tau_d_1deg_lucorr_maskhigh_12,tau_d_1deg_lucorr_maskhigh_14);
tau_d_1deg_lucorr_maskhigh_comb(isnan(tau_d_1deg_lucorr_maskhigh_comb))=0;

lossyears=[6,8,10,12,14];
nlossyears=length(lossyears);

dims=size(tau_d_1deg_lucorr_maskhigh_comb);
if nlossyears~=dims(3)
    error('lossyears array does not match numer of input files')
end
clear dims


%---
%Read in the ESA forest type data and make averages by forest type for each time period

%Get ESA landcovers
addpath('/data/ESA_landcover')
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);

%Get forest area in m2
fmask=fliplr(ncread(file_fmask,'forested_50_percent')); %Percentage of gridcell coverage with at least 50% forest.
fmask=flipud(fmask');
forestmaskhigh=false(size(fmask));
forestmaskhigh(fmask>25)=true; %At least 25% cover of 50%-canopy-cover forest in gridcell

tau_d_1deg_lucorr_maskhigh_comb(tau_d_1deg_lucorr_maskhigh_comb==0)=NaN;

tau_regionmean=NaN(nlossyears,nregion);
tau_regionstd=NaN(nlossyears,nregion);
tau_regionmedian=NaN(nlossyears,nregion);
farea_regionsum=NaN(nlossyears,nregion);
for ll=1:nlossyears
    for nn=1:nregion
        temp=tau_d_1deg_lucorr_maskhigh_comb(:,:,ll);
        tau_regionmean(ll,nn)=nanmean(temp(rmask==nn));
        tau_regionstd(ll,nn)=nanstd(temp(rmask==nn));
        tau_regionmedian(ll,nn)=nanmedian(temp(rmask==nn));
    end
end
clear ll nn

ncells_region=NaN(nregion,1);
for nn=1:nregion
    temp=forestmaskhigh(rmask==nn);
    ncells_region(nn)=length(temp(:));
end

%---
%Make figures per forest type
figlabels={'a','b','c','d','e','f','g','h','i'};

figure
ss=0;
for nn=1:nregion
    if nn==3 || nn==9
        %Don't plot the "other" forest categories due to their low area
        continue
    end
    ss=ss+1;
    s(ss)=subplot(3,3,ss);
    hold on
    %Mean value
    p1=plot(lossyears,tau_regionmean(:,nn),'k','linewidth',2);
    %95 confidence intervals
    p2=plot(lossyears,tau_regionmean(:,nn)-tau_regionstd(:,nn),'k--');
    p3=plot(lossyears,tau_regionmean(:,nn)+tau_regionstd(:,nn),'k--');
    %Median value
    p4=plot(lossyears,tau_regionmedian(:,nn),'m','linewidth',2);
    
    t1=title(['n=',mat2str(ncells_region(nn))]);
    set(t1,'fontweight','normal','fontsize',10)
    t2=text(11.5,1100,['(',figlabels{ss},') ',regions{nn}]);
    set(t2,'fontweight','bold')
    set(gca,'YLim',[0 1200])
    set(gca,'XLim',[5 15])
    set(gca,'XTick','','XTickLabel','')
    set(gca,'YTick','','YTickLabel','')
    if ss==7 || ss==5 || ss==6
        xlabel('Number of data years')
        set(gca,'XTick',6:2:114,'XTickLabel',6:2:14)
    end
    if ss==1 || ss==4 || ss==7
        ylabel('Mean \tau_O (y)')
        set(gca,'YTick',0:200:1200,'YTickLabel',0:200:1200)
    end
end
legend([p1,p2,p4],'Mean','Mean +- \sigma','Median')
clear ll nn ss p1 p2 p3 p4 t1 t2

set(s(1),'Position',[0.1 0.7 0.25 0.25])
set(s(2),'Position',[0.4 0.7 0.25 0.25])
set(s(3),'Position',[0.7 0.7 0.25 0.25])
set(s(4),'Position',[0.1 0.4 0.25 0.25])
set(s(5),'Position',[0.4 0.4 0.25 0.25])
set(s(6),'Position',[0.7 0.4 0.25 0.25])
set(s(7),'Position',[0.1 0.1 0.25 0.25])

%---
%Plot maps
figure
subplot(3,2,1)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_6));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

subplot(3,2,2)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_8));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

subplot(3,2,3)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_10));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

subplot(3,2,4)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_12));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

subplot(3,2,5)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_14));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')