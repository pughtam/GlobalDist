%Make a figure with maps for disturbance rotation period, and then a
%joint boxplot, split up by ESA CCI Landcover region.
%
%Dependencies:
%- esa_forest_9regions_new_1deg_func.m
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
%
%T. Pugh
%02.08.18

%Load the relevant Hansen tau data from a mat file calculated with
%hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh=tau_d_1deg_lucorr_upper_maskhigh';

%---
plotarray_hansen=tau_d_1deg_lucorr_maskhigh;
plotarray_hansen_uncer=(tau_d_1deg_lucorr_upper_maskhigh-tau_d_1deg_lucorr_lower_maskhigh)./tau_d_1deg_lucorr_maskhigh;

blankarray=NaN(size(plotarray_hansen));

%ESA landmasks
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);

rmask_sel=rmask;
rmask_sel(rmask==3 | rmask==9)=NaN;

masklabels=regions(1:8);
masklabels(3)=[];

%Create figure
figure
subplot(3,1,1)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(plotarray_hansen));
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
set(c1,'Ticks',log10([10 30 100 300 1000]))
set(c1,'TickLabels',10.^get(c1,'Ticks'))
caxis([1 3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
t1=text(-170,-50,'a \tau_{O} (years)','Fontweight','bold');

subplot(3,1,2)
p2=pcolor(-180.0:1:179.0,-90.0:1:89.0,plotarray_hansen_uncer);
set(p2,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c2=colorbar;
caxis([0 1])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
t2=text(-170,-50,'b Uncertainty','Fontweight','bold');

subplot(3,1,3)
boxplot(plotarray_hansen(:),rmask_sel(:),'notch','on','plotstyle','compact')
ylabel('\tau (years)')
set(gca,'XTick',1:7,'XTickLabel',masklabels)
set(gca,'YScale','log')
set(gca,'YLim',[20 1300])
set(gca,'YTickLabel',{'100','1000'})
t4=text(0.7,27,'c','Fontweight','bold');
grid on

%Add text with the number of grid cells per forest type to the boxplot
nsamp=NaN(1,8);
for nn=1:8
    temp=plotarray_hansen(rmask_sel==nn);
    temp(isnan(temp))=[];
    nsamp(nn)=length(temp);
    clear temp
end
clear nn
nsamp(3)=[];

hold on
for nn=1:7
    text(nn-0.2,25,num2str(nsamp(nn)))
end
clear nsamp