%Script to compare a disturbance rotation period calculated for biotic
%outbreaks (USA only) with the general one calculated from Hansen et al.
%(2013).
%
%Biotic disturbance data is from USDA Forest Service. 
%Insect and disease survey data base. (2017). 
%Available at: http://foresthealth.fs.usda.gov. (Accessed: 23rd March 2017)
%File headers: POINT_X, POINT_Y, BDMort_frac
%
%Dependencies:
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
%
%T. Pugh
%03.08.18

%---
%Dataset for US forests

data_in=dlmread('/data/Disturbance/input_processing/Biotic_dist/BD_annual_mort_fraction_mean_1997_2015.txt','',1,0);
lon=data_in(:,1);
lat=data_in(:,2);
bdist=data_in(:,3);

lons=-179.75:0.5:179.75;
lats=-89.75:0.5:89.75;

bdistg=NaN(360,720);
for xx=1:720
    for yy=1:360
        aa=find(lon==lons(xx) & lat==lats(yy));
        if ~isempty(aa)
            bdistg(yy,xx)=bdist(aa);
        end
    end
end
bdistg(bdistg==0)=NaN;

%Aggregate to 1 deg
bdistg_1deg=NaN(180,360);
for xx=1:360
    for yy=1:180
        ind_x=(xx*2)-1;
        ind_y=(yy*2)-1;
        temp2=bdistg(ind_y:ind_y+1,ind_x:ind_x+1);
        bdistg_1deg(yy,xx)=nanmean(temp2(:));
        clear temp2
        clear ind_x ind_y
    end
    clear yy
end
clear xx

corrfac=0.1; %Deflation factor for mortality (Kautz et al., 2018, Glob. Chang. Biol.)

bdistgc_1deg=bdistg_1deg*corrfac;

tau_b=1./(bdistgc_1deg/19);

fmask=ncread('/data/Hansen_forest_change/hansen_forested_frac_1deg_thres50.nc4','forested_50_percent')';
%Find gridcells with forest cover >25%
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;

tau_b_maskhigh=tau_b.*fmask_thres;

figure
p1=pcolor(-179.5:1:179.5,-89.5:1:89.5,log10(tau_b_maskhigh));
set(p1,'linestyle','none')
colorbar
caxis([1 3])
load coast
longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
patch(longn,latn,ones(length(longn),1));
set(gca,'YLim',[25 70],'XLim',[-180 -50])
c1=colorbar;
set(c1,'Ticks',log10([10 30 100 300 1000]))
set(c1,'TickLabels',10.^get(c1,'Ticks'))