%Make plots of the C pool sizes for a specific time period for one simulation. Calculations only include
%NATURAL areas as defined by Hansen et al. (2013). All gridcells with closed canopy forest are used in
%calculations (although maps are restricted to gridcells with 25% forest cover based on Hansen).
%
%Regions are defined by ESA landcovers.
%
%Dependencies:
% - dist_loss_maps_esa_func.m
%
%T. Pugh
%03.08.18

datafol='/Users/pughtam/Documents/GAP_work/Disturbance/netcdfs_for_deposition/';
addpath('/data/ESA_landcover')

base_file_stub='_LPJ-GUESS_standard_dist2litter_1x_p100.nc';
base_file_stub_min='_LPJ-GUESS_2p5percconf_dist2litter_1x_p10.nc';
base_file_stub_max='_LPJ-GUESS_97p5percconf_dist2litter_1x_p10.nc';

thres25=false; %Whether or not to apply the 25% forest cover threshold per gridcell (note implicit 5% threshold is included in the model gridlist for the simulations)

%---
%Read the data

fprintf('Hansen\n')
[mdistc_tot_TrBE_h,mdistc_tot_TrBD_h,mdistc_tot_TeBE_h,mdistc_tot_TeBD_h,mdistc_tot_BNE_h,mdistc_tot_BNS_h,mdistc_tot_MX_h,mdistc_tot_h,...
    mmortc_tot_TrBE_h,mmortc_tot_TrBD_h,mmortc_tot_TeBE_h,mmortc_tot_TeBD_h,mmortc_tot_BNE_h,mmortc_tot_BNS_h,mmortc_tot_MX_h,mmortc_tot_h,...
    mtotc_tot_TrBE_h,mtotc_tot_TrBD_h,mtotc_tot_TeBE_h,mtotc_tot_TeBD_h,mtotc_tot_BNE_h,mtotc_tot_BNS_h,mtotc_tot_MX_h,mtotc_tot_h,...
    mdistc_h,mmortc_h,mtotc_h]=dist_loss_maps_esa_func_v3(datafol,['TdistC',base_file_stub],['TmortC',base_file_stub],...
        ['TleafC',base_file_stub],['TrootC',base_file_stub],['TreproC',base_file_stub],['fpc_tree',base_file_stub],['fpc_grass',base_file_stub],thres25);
fprintf('Hansen lower\n')
[mdistc_tot_TrBE_hmin,mdistc_tot_TrBD_hmin,mdistc_tot_TeBE_hmin,mdistc_tot_TeBD_hmin,mdistc_tot_BNE_hmin,mdistc_tot_BNS_hmin,mdistc_tot_MX_hmin,mdistc_tot_hmin,...
    mmortc_tot_TrBE_hmin,mmortc_tot_TrBD_hmin,mmortc_tot_TeBE_hmin,mmortc_tot_TeBD_hmin,mmortc_tot_BNE_hmin,mmortc_tot_BNS_hmin,mmortc_tot_MX_hmin,mmortc_tot_hmin,...
    mtotc_tot_TrBE_hmin,mtotc_tot_TrBD_hmin,mtotc_tot_TeBE_hmin,mtotc_tot_TeBD_hmin,mtotc_tot_BNE_hmin,mtotc_tot_BNS_hmin,mtotc_tot_MX_hmin,mtotc_tot_hmin,...
    mdistc_hmin,mmortc_hmin,mtotc_hmin]=dist_loss_maps_esa_func_v3(datafol,['TdistC',base_file_stub_min],['TmortC',base_file_stub_min],...
        ['TleafC',base_file_stub_min],['TrootC',base_file_stub_min],['TreproC',base_file_stub_min],['fpc_tree',base_file_stub_min],['fpc_grass',base_file_stub_min],thres25);
fprintf('Hansen upper\n')
[mdistc_tot_TrBE_hmax,mdistc_tot_TrBD_hmax,mdistc_tot_TeBE_hmax,mdistc_tot_TeBD_hmax,mdistc_tot_BNE_hmax,mdistc_tot_BNS_hmax,mdistc_tot_MX_hmax,mdistc_tot_hmax,...
    mmortc_tot_TrBE_hmax,mmortc_tot_TrBD_hmax,mmortc_tot_TeBE_hmax,mmortc_tot_TeBD_hmax,mmortc_tot_BNE_hmax,mmortc_tot_BNS_hmax,mmortc_tot_MX_hmax,mmortc_tot_hmax,...
    mtotc_tot_TrBE_hmax,mtotc_tot_TrBD_hmax,mtotc_tot_TeBE_hmax,mtotc_tot_TeBD_hmax,mtotc_tot_BNE_hmax,mtotc_tot_BNS_hmax,mtotc_tot_MX_hmax,mtotc_tot_hmax,...
    mdistc_hmax,mmortc_hmax,mtotc_hmax]=dist_loss_maps_esa_func_v3(datafol,['TdistC',base_file_stub_max],['TmortC',base_file_stub_max],...
        ['TleafC',base_file_stub_max],['TrootC',base_file_stub_max],['TreproC',base_file_stub_max],['fpc_tree',base_file_stub_max],['fpc_grass',base_file_stub_max],thres25);

%---
%Fraction of total mortality as disturbance
dist_mort_frac=[mmortc_tot_TrBE_h*100,mdistc_tot_TrBD_h/mmortc_tot_TrBD_h*100,mdistc_tot_TeBE_h/mmortc_tot_TeBE_h*100,...
    mdistc_tot_TeBD_h/mmortc_tot_TeBD_h*100,mdistc_tot_BNE_h/mmortc_tot_BNE_h*100,mdistc_tot_BNS_h/mmortc_tot_BNS_h*100,...
    mdistc_tot_MX_h/mmortc_tot_MX_h*100,mdistc_tot_h/mmortc_tot_h*100];
dist_mort_frac_hmin=[mdistc_tot_TrBE_hmin/mmortc_tot_TrBE_hmin*100,mdistc_tot_TrBD_hmin/mmortc_tot_TrBD_hmin*100,mdistc_tot_TeBE_hmin/mmortc_tot_TeBE_hmin*100,...
    mdistc_tot_TeBD_hmin/mmortc_tot_TeBD_hmin*100,mdistc_tot_BNE_hmin/mmortc_tot_BNE_hmin*100,mdistc_tot_BNS_hmin/mmortc_tot_BNS_hmin*100,...
    mdistc_tot_MX_hmin/mmortc_tot_MX_hmin*100,mdistc_tot_hmin/mmortc_tot_hmin*100];
dist_mort_frac_hmax=[mdistc_tot_TrBE_hmax/mmortc_tot_TrBE_hmax*100,mdistc_tot_TrBD_hmax/mmortc_tot_TrBD_hmax*100,mdistc_tot_TeBE_hmax/mmortc_tot_TeBE_hmax*100,...
    mdistc_tot_TeBD_hmax/mmortc_tot_TeBD_hmax*100,mdistc_tot_BNE_hmax/mmortc_tot_BNE_hmax*100,mdistc_tot_BNS_hmax/mmortc_tot_BNS_hmax*100,...
    mdistc_tot_MX_hmax/mmortc_tot_MX_hmax*100,mdistc_tot_hmax/mmortc_tot_hmax*100];

dist_mort_frac_absmin=min(cat(1,dist_mort_frac,dist_mort_frac_hmin,dist_mort_frac_hmax),[],1); %Because model feedbacks mean that extremes of tau do not necessarily translate to extremes of these variables
dist_mort_frac_absmax=max(cat(1,dist_mort_frac,dist_mort_frac_hmin,dist_mort_frac_hmax),[],1);

%Fraction of total turnover as mortality
dist_morttot_frac=[mmortc_tot_TrBE_h/mtotc_tot_TrBE_h*100,mmortc_tot_TrBD_h/mtotc_tot_TrBD_h*100,mmortc_tot_TeBE_h/mtotc_tot_TeBE_h*100,...
    mmortc_tot_TeBD_h/mtotc_tot_TeBD_h*100,mmortc_tot_BNE_h/mtotc_tot_BNE_h*100,mmortc_tot_BNS_h/mtotc_tot_BNS_h*100,...
    mmortc_tot_MX_h/mtotc_tot_MX_h*100,mmortc_tot_h/mtotc_tot_h*100];
dist_morttot_frac_hmin=[mmortc_tot_TrBE_hmin/mtotc_tot_TrBE_hmin*100,mmortc_tot_TrBD_hmin/mtotc_tot_TrBD_hmin*100,mmortc_tot_TeBE_hmin/mtotc_tot_TeBE_hmin*100,...
    mmortc_tot_TeBD_hmin/mtotc_tot_TeBD_hmin*100,mmortc_tot_BNE_hmin/mtotc_tot_BNE_hmin*100,mmortc_tot_BNS_hmin/mtotc_tot_BNS_hmin*100,...
    mmortc_tot_MX_hmin/mtotc_tot_MX_hmin*100,mmortc_tot_hmin/mtotc_tot_hmin*100];
dist_morttot_frac_hmax=[mmortc_tot_TrBE_hmax/mtotc_tot_TrBE_hmax*100,mmortc_tot_TrBD_hmax/mtotc_tot_TrBD_hmax*100,mmortc_tot_TeBE_hmax/mtotc_tot_TeBE_hmax*100,...
    mmortc_tot_TeBD_hmax/mtotc_tot_TeBD_hmax*100,mmortc_tot_BNE_hmax/mtotc_tot_BNE_hmax*100,mmortc_tot_BNS_hmax/mtotc_tot_BNS_hmax*100,...
    mmortc_tot_MX_hmax/mtotc_tot_MX_hmax*100,mmortc_tot_hmax/mtotc_tot_hmax*100];

dist_morttot_frac_absmin=min(cat(1,dist_morttot_frac,dist_morttot_frac_hmin,dist_morttot_frac_hmax),[],1);
dist_morttot_frac_absmax=max(cat(1,dist_morttot_frac,dist_morttot_frac_hmin,dist_morttot_frac_hmax),[],1);

%Fraction of total turnover as disturbance
dist_tot_frac=[mdistc_tot_TrBE_h/mtotc_tot_TrBE_h*100,mdistc_tot_TrBD_h/mtotc_tot_TrBD_h*100,mdistc_tot_TeBE_h/mtotc_tot_TeBE_h*100,...
    mdistc_tot_TeBD_h/mtotc_tot_TeBD_h*100,mdistc_tot_BNE_h/mtotc_tot_BNE_h*100,mdistc_tot_BNS_h/mtotc_tot_BNS_h*100,...
    mdistc_tot_MX_h/mtotc_tot_MX_h*100,mdistc_tot_h/mtotc_tot_h*100];
dist_tot_frac_hmin=[mdistc_tot_TrBE_hmin/mtotc_tot_TrBE_hmin*100,mdistc_tot_TrBD_hmin/mtotc_tot_TrBD_hmin*100,mdistc_tot_TeBE_hmin/mtotc_tot_TeBE_hmin*100,...
    mdistc_tot_TeBD_hmin/mtotc_tot_TeBD_hmin*100,mdistc_tot_BNE_hmin/mtotc_tot_BNE_hmin*100,mdistc_tot_BNS_hmin/mtotc_tot_BNS_hmin*100,...
    mdistc_tot_MX_hmin/mtotc_tot_MX_hmin*100,mdistc_tot_hmin/mtotc_tot_hmin*100];
dist_tot_frac_hmax=[mdistc_tot_TrBE_hmax/mtotc_tot_TrBE_hmax*100,mdistc_tot_TrBD_hmax/mtotc_tot_TrBD_hmax*100,mdistc_tot_TeBE_hmax/mtotc_tot_TeBE_hmax*100,...
    mdistc_tot_TeBD_hmax/mtotc_tot_TeBD_hmax*100,mdistc_tot_BNE_hmax/mtotc_tot_BNE_hmax*100,mdistc_tot_BNS_hmax/mtotc_tot_BNS_hmax*100,...
    mdistc_tot_MX_hmax/mtotc_tot_MX_hmax*100,mdistc_tot_hmax/mtotc_tot_hmax*100];

dist_tot_frac_absmin=min(cat(1,dist_tot_frac,dist_tot_frac_hmin,dist_tot_frac_hmax),[],1);
dist_tot_frac_absmax=max(cat(1,dist_tot_frac,dist_tot_frac_hmin,dist_tot_frac_hmax),[],1);

dist_flux=[mdistc_tot_TrBE_h,mdistc_tot_TrBD_h,mdistc_tot_TeBE_h,mdistc_tot_TeBD_h,mdistc_tot_BNE_h,mdistc_tot_BNS_h,mdistc_tot_MX_h,mdistc_tot_h];
dist_flux_hmin=[mdistc_tot_TrBE_hmin,mdistc_tot_TrBD_hmin,mdistc_tot_TeBE_hmin,mdistc_tot_TeBD_hmin,mdistc_tot_BNE_hmin,mdistc_tot_BNS_hmin,mdistc_tot_MX_hmin,mdistc_tot_hmin];
dist_flux_hmax=[mdistc_tot_TrBE_hmax,mdistc_tot_TrBD_hmax,mdistc_tot_TeBE_hmax,mdistc_tot_TeBD_hmax,mdistc_tot_BNE_hmax,mdistc_tot_BNS_hmax,mdistc_tot_MX_hmax,mdistc_tot_hmax];

dist_flux_absmin=min(cat(1,dist_flux,dist_flux_hmin,dist_flux_hmax),[],1);
dist_flux_absmax=max(cat(1,dist_flux,dist_flux_hmin,dist_flux_hmax),[],1);

%---
%Make plots

%Make stacked bar plot
figure
subplot(2,1,1)
hold on
b1=bar(1:8,[dist_tot_frac;dist_morttot_frac-dist_tot_frac]','stacked'); %Hansen
set(b1(1),'BarWidth',0.4)
ylabel('% of C turnover')
set(gca,'XTickLabel','','XLim',[0.5 8.5])

dist_tot_frac_errorlow=dist_tot_frac-dist_tot_frac_absmin;
dist_tot_frac_errorhigh=dist_tot_frac_absmax-dist_tot_frac;
e1a=errorbar(1:8,dist_tot_frac,dist_tot_frac_errorlow,dist_tot_frac_errorhigh);
set(e1a,'linestyle','none','color','k')

dist_morttot_frac_errorlow=dist_morttot_frac-dist_morttot_frac_absmin;
dist_morttot_frac_errorhigh=dist_morttot_frac_absmax-dist_morttot_frac;
e1b=errorbar(1:8,dist_morttot_frac,dist_morttot_frac_errorlow,dist_morttot_frac_errorhigh);
set(e1b,'linestyle','none','color','k')

subplot(2,1,2)
hold on
b2=bar(1:8,dist_flux','stacked');
set(b2(1),'BarWidth',0.4)
ylabel('Pg C a^{-1}')
set(gca,'XTick',1:8)
set(gca,'XTickLabel',{'TrBE','TrBD','TeBE','TeBD','NE','ND','MX','All'},'XLim',[0.5 8.5])

dist_flux_errorlow=dist_flux-dist_flux_hmin;
dist_flux_errorhigh=dist_flux_hmax-dist_flux;
e2=errorbar(1:8,dist_flux',dist_flux_errorlow',dist_flux_errorhigh');
set(e2,'linestyle','none','color','k')

%Make maps

minlat=-90.0;
maxlat=89;
minlon=-180.0;
maxlon=179;
gridsize=1;
lonc=minlon:gridsize:maxlon;
latc=minlat:gridsize:maxlat;

figure
p1=pcolor(lonc,latc,mdistc_h);
set(p1,'linestyle','none');
colorbar
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
title('Biomass turnover flux from disturbance')

figure
p1=pcolor(lonc,latc,mmortc_h);
set(p1,'linestyle','none');
colorbar
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
title('Biomass turnover flux from all mortality')

figure
p1=pcolor(lonc,latc,mtotc_h);
set(p1,'linestyle','none');
colorbar
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
title('Biomass total turnover flux')

figure
p1=pcolor(lonc,latc,(mdistc_h./mmortc_h)*100);
set(p1,'linestyle','none');
colorbar
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
title('Fraction of mortality turnover due to disturbance')
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

figure
p1=pcolor(lonc,latc,mdistc_h./mtotc_h);
set(p1,'linestyle','none');
colorbar
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80]);
title('Fraction of total turnover due to disturbance')