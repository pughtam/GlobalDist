%Make plot to demonstrate the influence of the number of bootstrap samples on the uncertainty estimates.
%
%Dependencies:
% - *.mat files from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
% calculated with a range of different values for bootstrap sampling
%
%T. Pugh
%08.02.19

load hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
tau_d_1deg_lucorr_upper_maskhigh_stan=tau_d_1deg_lucorr_upper_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_stan=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_maskhigh_stan=tau_d_1deg_lucorr_maskhigh;

load hansen_disturb_int_calc_1deg_lu_v4_outarrays_bts500_250119.mat
tau_d_1deg_lucorr_upper_maskhigh_500=tau_d_1deg_lucorr_upper_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_500=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_maskhigh_500=tau_d_1deg_lucorr_maskhigh;

load hansen_disturb_int_calc_1deg_lu_v4_outarrays_bts1500_250119.mat
tau_d_1deg_lucorr_upper_maskhigh_1500=tau_d_1deg_lucorr_upper_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_1500=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_maskhigh_1500=tau_d_1deg_lucorr_maskhigh;

load hansen_disturb_int_calc_1deg_lu_v4_outarrays_bts100_250119.mat
tau_d_1deg_lucorr_upper_maskhigh_100=tau_d_1deg_lucorr_upper_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_100=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_maskhigh_100=tau_d_1deg_lucorr_maskhigh;

figure
colormap(redblue)
subplot(3,2,1)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_lower_maskhigh_100-tau_d_1deg_lucorr_lower_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('5% confidence limit, n=100')

subplot(3,2,2)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_upper_maskhigh_100-tau_d_1deg_lucorr_upper_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('95% confidence limit, n=100')

subplot(3,2,3)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_lower_maskhigh_500-tau_d_1deg_lucorr_lower_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('5% confidence limit, n=500')

subplot(3,2,4)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_upper_maskhigh_500-tau_d_1deg_lucorr_upper_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('95% confidence limit, n=500')

subplot(3,2,5)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_lower_maskhigh_1500-tau_d_1deg_lucorr_lower_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('5% confidence limit, n=1500')

subplot(3,2,6)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,(tau_d_1deg_lucorr_upper_maskhigh_1500-tau_d_1deg_lucorr_upper_maskhigh_stan)');
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-20 20])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
title('95% confidence limit, n=1500')


