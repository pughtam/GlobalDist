%Script to estimate the bias in the calculation of tau due to classification errors in the satellite products.
%
%Dependencies:
% - ecozone_fao.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
%
%T. Pugh
%08.02.19

datafol='/Users/pughtam/Documents/GAP_work/Disturbance/netcdfs_for_deposition/';
intdatafol='/Users/pughtam/Documents/GAP_work/Disturbance/intermediate_processing/';

include_AL_bias=true; %Include bias in forest loss?
include_AF_bias=false; %Include bias in forest area?
include_AC_bias=false; %Include bias in forest loss due to land-use change?

%---
%Load in the loss and area arrays
load([intdatafol,'/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat'])
AL=totloss_1deg_thres50'; %Area of forest loss (m2)
AC=esa_forloss_1deg'; %Area of forest loss due to land-use change (m2)
%load /home/adf/pughtam/data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_totfarea_1deg_thres50.mat
fmask=ncread([datafol,'/forestmask/hansen_forested_frac_1deg.nc4'],'forested_50_percent')';
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;
fmask=double(fmask)./100;
garea=global_grid_area_1deg();
AF=fmask.*garea; %Area of closed-canopy forest (m2)

%---
if include_AL_bias
    %Set the classification error distribution in AL according to the climate domain
    %Climate domains from FAO (www.fao.org/geonetwork/srv/en/main.home and coverted into a 1 degree raster using ecozone_fao.m
    load([intdatafol,'/ecozones_1deg.mat'])
    
    %Bias in forest loss based on Table S5 of Hansen et al. (2013)
    %bias_AL_rel = (AL_prod / AL_ref) ? 1, where AL_prod is the total loss fraction in the forest loss product and AL_ref the total loss fraction in the reference data.
    bias_AL_rel=zeros(size(ecozones));
    for ii=1:360
        for jj=1:180
            if ecozones(jj,ii)==2 %Boreal
                bias_AL_rel(jj,ii)=6.49;
            elseif ecozones(jj,ii)==3 %Temperate
                bias_AL_rel(jj,ii)=6.48;
            elseif ecozones(jj,ii)==4 %Sub-tropical
                bias_AL_rel(jj,ii)=0;
            elseif ecozones(jj,ii)==5 %Tropical
                bias_AL_rel(jj,ii)=-4.44;
            end
        end
    end
    
    bias_AL_rel=(bias_AL_rel/100);
    
    %Absolute bias
    bias_AL=AL.*bias_AL_rel;
else
    bias_AL=zeros(size(AF));
end

%---
%Bias in forest area based on Pengra et al. (2015) Remote Sensing of Environment 165, 234-248, on advice from Peter Potapov.
if include_AF_bias
    bias_AF_rel=9.54;
    bias_AF_rel=(bias_AF_rel/100);
    %Absolute bias
    bias_AF=AF.*bias_AF_rel;
else
    bias_AF=zeros(size(AF));
end

%---
%Bias in forest conversion based on Table 3-6 of ESA. Land Cover CCI Product User Guide Version 2.0. (2017).
%No information available on forest to non-forest conversion accuracy. Therefore assume that classification 
%accuracy of forest and non-forest land is not correlated with locations that undergo this transition.
%Classification accuracy of forest and non-forest land was calculated by summing correct and incorrect 
%classifications across the categories defined as forest for the purposes of this study (50, 60, 70, 80, 
%90, 100, 160, 170) and those defined as non-forest land-uses (10, 20, 30,
%110, 130, 190).
if include_AC_bias
    bias_AC_for_rel=13.77;
    bias_AC_nonfor_rel=-7.54;
    bias_AC_rel=bias_AC_for_rel+bias_AC_nonfor_rel;
    bias_AC_rel=(bias_AC_rel/100);
    %Absolute bias
    bias_AC=AC*bias_AC_rel;
else
    bias_AC=zeros(size(AC));
end

%---
%Calculate overall tau_O without considering bias
AL_corr=AL-AC;
AL_corr(AL_corr<0)=0;
tau=AF./(AL_corr/14);
tau(tau>1000)=1000;
tau(fmask_thres~=1)=NaN;

%Calculate overall tau_O considering bias
AL_corr_bias=(AL+bias_AL)-(AC+bias_AC);
AL_corr_bias(AL_corr_bias<0)=0;
tau_bias=(AF+bias_AF)./(AL_corr_bias/14);
tau_bias(tau_bias>1000)=1000;
tau_bias(fmask_thres~=1)=NaN;

%---
%Make a map
tau_frac=(tau-tau_bias)./tau; %Fractional change in tau

figure
colormap(redblue)
p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,tau_frac);
set(p1,'linestyle','none')
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[-60 80])
c1=colorbar;
caxis([-0.3 0.3])
set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')

%---
%Make means across temperate/boreal and tropical regions
tau_frac_tempbor=tau_frac(114:180,:);
nanmean(tau_frac_tempbor(:))

tau_frac_trop=tau_frac(67:113,:);
nanmean(tau_frac_trop(:))


