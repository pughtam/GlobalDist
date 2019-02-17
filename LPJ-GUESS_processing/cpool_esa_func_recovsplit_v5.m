function [vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean)
%Calculate the C pool sizes for a specific time period for one simulation. Calculations only include
%forest areas as defined by Hansen et al. (2013). 
%
%Split calculations depending on whether or not the basic disturbance rate 
%for a gridcell exceeds a particular number of years.
%
%Regions are defined by ESA landcovers.
%
%Dependencies:
% - distforfrachan.m
% - lpj_to_grid_func_centre.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using XXXX)
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
% - global_grid_area_1deg.m
%
%T. Pugh
%12.09.17

cpoolfile=[base_folder_name,'/cpool_2001_2014'];
fpcfile=[base_folder_name,'/fpc_2001_2014'];

minlat=-89.5;
maxlat=89.5;
minlon=-179.5;
maxlon=179.5;
gridsize=1;
lonc=minlon:gridsize:maxlon;
latc=minlat:gridsize:maxlat;
[lons,lats]=meshgrid(lonc,latc);

%----
%Business section

cpool_in=squeeze(lpj_to_grid_func_centre(cpoolfile,1,0));
vegc=cpool_in(:,:,1);
soilc=sum(cpool_in(:,:,2:3),3);
clear cpoolfile cflux_in

%Exclude gridcells with less than 25% tree cover
[maskarea]=distforfrachan(fpcfile);
vegc=vegc.*maskarea;
soilc=soilc.*maskarea;

%Aggregate to 1 degree
vegc_1deg=NaN(180,360);
soilc_1deg=NaN(180,360);
for xx=1:360
    for yy=1:180
        ind_x=(xx*2)-1;
        ind_y=(yy*2)-1;
        temp_vegc=vegc(ind_y:ind_y+1,ind_x:ind_x+1);
        temp_soilc=soilc(ind_y:ind_y+1,ind_x:ind_x+1);
        vegc_1deg(yy,xx)=nanmean(temp_vegc(:));
        soilc_1deg(yy,xx)=nanmean(temp_soilc(:));
        clear temp_vegc temp_soilc
        clear ind_x ind_y
    end
    clear yy
end
clear xx

%Get gridcell areas
%Calculate forest areas in each class
fmask=(ncread('/data/Hansen_forest_change/hansen_forested_frac_1deg_thres50.nc4','forested_50_percent')');
gridarea=global_grid_area_1deg();
gridarea=gridarea.*(double(fmask)/100);

%ESA landcover
[rmask,~,nregion]=esa_forest_9regions_new_1deg_func(false);

%Associate thresholds with biomes in a map
tau_thres_90_map=NaN(size(rmask));
tau_thres_80_map=NaN(size(rmask));
for nn=1:nregion
    tau_thres_90_map(rmask==nn)=tau_thres_90(nn);
    tau_thres_80_map(rmask==nn)=tau_thres_80(nn);
end
clear nn

%Compare threshold tau against tau from Hansen

%Load the relevant Hansen tau data from a mat file calculated with
%hansen_disturb_int_calc_1deg_lu_v4.m

load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
%load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_canarea_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
distint=tau_d_1deg_lucorr_maskhigh';

distintlow=zeros(size(distint));
distintlow(distint<tau_thres_80_map)=1;
distintmid=zeros(size(distint));
distintmid(distint<tau_thres_90_map)=1;
distinthigh=zeros(size(distint));
distinthigh(distint>=(tau_thres_90_map))=1;

%Calculate global and regional totals in Pg C a-1
if calcmean
    area_low=gridarea(:).*distintlow(:); area_low(isnan(area_low)==1)=0;
    area_mid=gridarea(:).*distintmid(:); area_mid(isnan(area_mid)==1)=0;
    area_high=gridarea(:).*distinthigh(:); area_high(isnan(area_high)==1)=0;
    vegc_low=vegc_1deg(:).*distintlow(:); vegc_low(isnan(vegc_low)==1)=0;
    vegc_mid=vegc_1deg(:).*distintmid(:); vegc_mid(isnan(vegc_mid)==1)=0;
    vegc_high=vegc_1deg(:).*distinthigh(:); vegc_high(isnan(vegc_high)==1)=0;
    soilc_low=soilc_1deg(:).*distintlow(:); soilc_low(isnan(soilc_low)==1)=0;
    soilc_mid=soilc_1deg(:).*distintmid(:); soilc_mid(isnan(soilc_mid)==1)=0;
    soilc_high=soilc_1deg(:).*distinthigh(:); soilc_high(isnan(soilc_high)==1)=0;
    
    vegc_tot_dlow=wmean(vegc_low,area_low);
    vegc_tot_dmid=wmean(vegc_mid,area_mid);
    vegc_tot_dhigh=wmean(vegc_high,area_high);
    soilc_tot_dlow=wmean(soilc_low,area_low);
    soilc_tot_dmid=wmean(soilc_mid,area_mid);
    soilc_tot_dhigh=wmean(soilc_high,area_high);
    
    vegc_tot_std_dlow=sqrt(var(vegc_low,area_low));
    vegc_tot_std_dmid=sqrt(var(vegc_mid,area_mid));
    vegc_tot_std_dhigh=sqrt(var(vegc_high,area_high));
    soilc_tot_std_dlow=sqrt(var(soilc_low,area_low));
    soilc_tot_std_dmid=sqrt(var(soilc_mid,area_mid));
    soilc_tot_std_dhigh=sqrt(var(soilc_high,area_high));
else
    vegc_tot_dlow=nansum(vegc_1deg(:).*gridarea(:).*distintlow(:))/1e12;
    vegc_tot_dmid=nansum(vegc_1deg(:).*gridarea(:).*distintmid(:))/1e12;
    vegc_tot_dhigh=nansum(vegc_1deg(:).*gridarea(:).*distinthigh(:))/1e12;
    soilc_tot_dlow=nansum(soilc_1deg(:).*gridarea(:).*distintlow(:))/1e12;
    soilc_tot_dmid=nansum(soilc_1deg(:).*gridarea(:).*distintmid(:))/1e12;
    soilc_tot_dhigh=nansum(soilc_1deg(:).*gridarea(:).*distinthigh(:))/1e12;
    
    vegc_tot_std_dlow=NaN; %Dummy output arguments, as not currently required
    vegc_tot_std_dmid=NaN;
    vegc_tot_std_dhigh=NaN;
    soilc_tot_std_dlow=NaN;
    soilc_tot_std_dmid=NaN;
    soilc_tot_std_dhigh=NaN;
end

vegc_tot_reg_dlow=NaN(7,1);
vegc_tot_reg_dmid=NaN(7,1);
vegc_tot_reg_dhigh=NaN(7,1);
soilc_tot_reg_dlow=NaN(7,1);
soilc_tot_reg_dmid=NaN(7,1);
soilc_tot_reg_dhigh=NaN(7,1);
vegc_tot_reg_std_dlow=NaN(7,1);
vegc_tot_reg_std_dmid=NaN(7,1);
vegc_tot_reg_std_dhigh=NaN(7,1);
soilc_tot_reg_std_dlow=NaN(7,1);
soilc_tot_reg_std_dmid=NaN(7,1);
soilc_tot_reg_std_dhigh=NaN(7,1);
nn=0;
for bb=1:9
    if bb==3 || bb==9; continue; end %Ignore OTr and Other regions
    nn=nn+1;
    if calcmean
        area_low=gridarea(rmask==bb).*distintlow(rmask==bb); area_low(isnan(area_low)==1)=0;
        area_mid=gridarea(rmask==bb).*distintmid(rmask==bb); area_mid(isnan(area_mid)==1)=0;
        area_high=gridarea(rmask==bb).*distinthigh(rmask==bb); area_high(isnan(area_high)==1)=0;
        vegc_low=vegc(rmask==bb).*distintlow(rmask==bb); vegc_low(isnan(vegc_low)==1)=0;
        vegc_mid=vegc(rmask==bb).*distintmid(rmask==bb); vegc_mid(isnan(vegc_mid)==1)=0;
        vegc_high=vegc(rmask==bb).*distinthigh(rmask==bb); vegc_high(isnan(vegc_high)==1)=0;
        soilc_low=soilc(rmask==bb).*distintlow(rmask==bb); soilc_low(isnan(soilc_low)==1)=0;
        soilc_mid=soilc(rmask==bb).*distintmid(rmask==bb); soilc_mid(isnan(soilc_mid)==1)=0;
        soilc_high=soilc(rmask==bb).*distinthigh(rmask==bb); soilc_high(isnan(soilc_high)==1)=0;
        
        vegc_tot_reg_dlow(nn)=wmean(vegc_low,area_low);
        vegc_tot_reg_dmid(nn)=wmean(vegc_mid,area_mid);
        vegc_tot_reg_dhigh(nn)=wmean(vegc_high,area_high);
        soilc_tot_reg_dlow(nn)=wmean(soilc_low,area_low);
        soilc_tot_reg_dmid(nn)=wmean(soilc_mid,area_mid);
        soilc_tot_reg_dhigh(nn)=wmean(soilc_high,area_high);
        
        vegc_tot_reg_std_dlow(nn)=sqrt(var(vegc_low,area_low));
        vegc_tot_reg_std_dmid(nn)=sqrt(var(vegc_mid,area_mid));
        vegc_tot_reg_std_dhigh(nn)=sqrt(var(vegc_high,area_high));
        soilc_tot_reg_std_dlow(nn)=sqrt(var(soilc_low,area_low));
        soilc_tot_reg_std_dmid(nn)=sqrt(var(soilc_mid,area_mid));
        soilc_tot_reg_std_dhigh(nn)=sqrt(var(soilc_high,area_high));
    else
        vegc_tot_reg_dlow(nn)=nansum(vegc(rmask==bb).*gridarea(rmask==bb).*distintlow(rmask==bb))/1e12;
        vegc_tot_reg_dmid(nn)=nansum(vegc(rmask==bb).*gridarea(rmask==bb).*distintmid(rmask==bb))/1e12;
        vegc_tot_reg_dhigh(nn)=nansum(vegc(rmask==bb).*gridarea(rmask==bb).*distinthigh(rmask==bb))/1e12;
        soilc_tot_reg_dlow(nn)=nansum(soilc(rmask==bb).*gridarea(rmask==bb).*distintlow(rmask==bb))/1e12;
        soilc_tot_reg_dmid(nn)=nansum(soilc(rmask==bb).*gridarea(rmask==bb).*distintmid(rmask==bb))/1e12;
        soilc_tot_reg_dhigh(nn)=nansum(soilc(rmask==bb).*gridarea(rmask==bb).*distinthigh(rmask==bb))/1e12;
        
        vegc_tot_reg_std_dlow(nn)=NaN; %Dummy output arguments, as not currently required
        vegc_tot_reg_std_dmid(nn)=NaN;
        vegc_tot_reg_std_dhigh(nn)=NaN;
        soilc_tot_reg_std_dlow(nn)=NaN;
        soilc_tot_reg_std_dmid(nn)=NaN;
        soilc_tot_reg_std_dhigh(nn)=NaN;
    end
end
clear nn bb

%Calculate n
nn=0;
for bb=1:9
    if bb==3 || bb==9; continue; end %Ignore OTr and Other regions
    nn=nn+1;
    temp1=distintlow(rmask==bb);
    N_reg_dlow_sum(nn)=length(find(temp1==true));
    temp2=distintmid(rmask==bb);
    N_reg_dmid_sum(nn)=length(find(temp2==true));
    temp3=distinthigh(rmask==bb);
    N_reg_dhigh_sum(nn)=length(find(temp3==true));
end
clear nn bb temp1 temp2 temp3

