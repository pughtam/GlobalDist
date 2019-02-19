%Make a map that identified areas with disturbance rotation period below a defined threshold (tau_crit)
%and calculate the associated area fractions.
%
%Links with dist_vul_sum_v3.m
%
%Dependencies:
% - esa_forest_9regions_new_1deg_func.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - global_grid_area_1deg.m
%
%T. Pugh
%03.08.18

conflevel_tau=2; %Which percentile to use for the tau, 1=2.5th, 2=50th, 3=97.5th
conflevel_line=2; %Which percentile to use for the line fitting, 1=2.5th, 2=50th, 3=97.5th
makeplot=false;

%Values for tau threshold calculated by biome using dist_vul_sim_v3.m
%For OTr and Other, adopt the range across the biomes from the global fit as the
%uncertainty
tau_thres_90=[594 523 444 289 426 417 323 406 444];
tau_thres_90_min=[560 461 429 266 398 396 309 388 429];
tau_thres_90_max=[554 445 457 261 393 394 311 382 457];

tau_thres_80=[289 218 206 125 96 203 178 187 206];
tau_thres_80_min=[278 171 201 114 50 195 171 175 201];
tau_thres_80_max=[303 252 211 138 130 213 184 196 211]; 

%---
%Create Threshold tau maps

%Get ESA regions
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);

%Associate thresholds with biomes in a map
tau_thres_90_map=NaN(size(rmask));
tau_thres_90_min_map=NaN(size(rmask));
tau_thres_90_max_map=NaN(size(rmask));
tau_thres_80_map=NaN(size(rmask));
tau_thres_80_min_map=NaN(size(rmask));
tau_thres_80_max_map=NaN(size(rmask));
for nn=1:nregion
    tau_thres_90_map(rmask==nn)=tau_thres_90(nn);
    tau_thres_90_min_map(rmask==nn)=tau_thres_90_min(nn);
    tau_thres_90_max_map(rmask==nn)=tau_thres_90_max(nn);
    tau_thres_80_map(rmask==nn)=tau_thres_80(nn);
    tau_thres_80_min_map(rmask==nn)=tau_thres_80_min(nn);
    tau_thres_80_max_map(rmask==nn)=tau_thres_80_max(nn);
end
clear nn

%---
%Compare tau_crit against observed tau

%Load the relevant Hansen tau data from a mat file calculated with hansen_disturb_int_calc_1deg_lu_v4_lossyear.m

load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
%load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_canarea_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh=tau_d_1deg_lucorr_upper_maskhigh';


%Choose variables to plot

if conflevel_tau==1
    dist_han_1deg=tau_d_1deg_lucorr_lower_maskhigh;
elseif conflevel_tau==2
    dist_han_1deg=tau_d_1deg_lucorr_maskhigh;
elseif conflevel_tau==3
    dist_han_1deg=tau_d_1deg_lucorr_upper_maskhigh;
else
    error('conflevel_tau not set to one of 1, 2 or 3')
end

if conflevel_line==1
    tau_thres_90_sel=tau_thres_90_min_map;
    tau_thres_80_sel=tau_thres_80_min_map;
elseif conflevel_line==2
    tau_thres_90_sel=tau_thres_90_map;
    tau_thres_80_sel=tau_thres_80_map;
elseif conflevel_line==3
    tau_thres_90_sel=tau_thres_90_max_map;
    tau_thres_80_sel=tau_thres_80_max_map;
else
    error('conflevel_line not set to one of 1, 2 or 3')
end

%Assign grid cells to different sensitivity classes
han_dist_thres=NaN(size(dist_han_1deg));
han_dist_thres(dist_han_1deg>=tau_thres_90_sel)=3;
han_dist_thres(dist_han_1deg<tau_thres_90_sel)=2;
han_dist_thres(dist_han_1deg<tau_thres_80_sel)=1;

%Make plot
if makeplot
    minlat=-90.0;
    maxlat=89.0;
    minlon=-180.0;
    maxlon=179.0;
    gridsize=1;
    lonc=minlon:gridsize:maxlon;
    latc=minlat:gridsize:maxlat;
    
    figure
    p1=pcolor(lonc,latc,han_dist_thres);
    set(p1,'linestyle','none');
    cmap2=[0.9290 0.6940 0.1250;
        0.5961 0.3059 0.6392;
        0.3020 0.6863 0.2902];
    colormap(cmap2)
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80]);
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-30 0 30 60],'YTickLabel','')
    c1=colorbar;
    set(c1,'Ticks',[1.3 2 2.65],'TickLabels',{'\tau_{O}<\tau_{crit,80}','\tau_{O}<\tau_{crit,90}','\tau_{O}\geq\tau_{crit,90}'})
end

%Calculate forest areas in each class
fmask=(ncread('/data/Hansen_forest_change/hansen_forested_frac_1deg_thres50.nc4','forested_50_percent')');
fmask=double(fmask)./100;
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>0.25)=1;

garea=global_grid_area_1deg();

farea=garea.*fmask.*fmask_thres;
farea_sum=nansum(farea(:))/1e6; %in km2

han_dist_lt_20_recov_farea=farea;
han_dist_lt_20_recov_farea(han_dist_thres~=1)=NaN;
han_dist_lt_20_recov_farea_sum=nansum(han_dist_lt_20_recov_farea(:))/1e6; %in km2
han_dist_lt_10_recov_farea=farea;
han_dist_lt_10_recov_farea(han_dist_thres~=2)=NaN;
han_dist_lt_10_recov_farea_sum=nansum(han_dist_lt_10_recov_farea(:))/1e6; %in km2
han_dist_gt_recov_farea=farea;
han_dist_gt_recov_farea(han_dist_thres~=3)=NaN;
han_dist_gt_recov_farea_sum=nansum(han_dist_gt_recov_farea(:))/1e6; %in km2

frac_10=(han_dist_lt_10_recov_farea_sum+han_dist_lt_20_recov_farea_sum)/(han_dist_gt_recov_farea_sum+han_dist_lt_10_recov_farea_sum+han_dist_lt_20_recov_farea_sum);
frac_20=han_dist_lt_20_recov_farea_sum/(han_dist_gt_recov_farea_sum+han_dist_lt_10_recov_farea_sum+han_dist_lt_20_recov_farea_sum);
fprintf('frac_10, frac_20\n')
fprintf('%f %f\n',frac_10,frac_20)

