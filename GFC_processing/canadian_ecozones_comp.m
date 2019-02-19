%Comparison of disturbance rotation period calculated in this study with estimates
%based on forest area and total area disturbed for 12 Canadian forest ecozones presented
%in White et al. (2017) Remote Sens. Environ. 194, 303?321.
%
%Uses a shapefile of the Canadian ecozones, https://open.canada.ca/data/en/dataset/db55facf-8893-11e0-bb4b-6cf049291510
%Shapefile was first converted to a 0.1 degree raster using ArcGIS by Emma Ferranti.
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
%
%T. Pugh
%19.02.19

%Read the raster converted from the original shapefile (ecozones_cbm.shp) using ArcGIS

[ecozon,Rc]=geotiffread('Tom/half/eczn_21.tif');
ecozon=double(flipud(ecozon));

%Convert this into 1 degree
minlatc=Rc.LatitudeLimits(1);
maxlatc=Rc.LatitudeLimits(2);
minlonc=Rc.LongitudeLimits(1);
maxlonc=Rc.LongitudeLimits(2);
latsc=(maxlatc-minlatc)/Rc.RasterSize(1);
lonsc=(maxlonc-minlonc)/Rc.RasterSize(2);
latc=minlatc:latsc:maxlatc-latsc;
lonc=minlonc:lonsc:maxlonc-lonsc;
ecozon(ecozon==255)=NaN;
%Regrid to 1 degrees
%First trim values outside of the nearest integer degree
minlatci=ceil(minlatc);
maxlatci=floor(maxlatc);
minlonci=ceil(minlonc);
maxlonci=floor(maxlonc);
minlatind=find(abs(latc-minlatci)==min(abs(latc-minlatci)));
maxlatind=find(abs(latc-maxlatci)==min(abs(latc-maxlatci)));
minlonind=find(abs(lonc-minlonci)==min(abs(lonc-minlonci)));
maxlonind=find(abs(lonc-maxlonci)==min(abs(lonc-maxlonci)));
ecozon=ecozon(minlatind:maxlatind-1,minlonind:maxlonind-1);
latct=latc(minlatind:maxlatind-1);
lonct=lonc(minlonind:maxlonind-1);

all_lon=-180:1:179;
all_lat=-90:1:89;
ind_lon_s=find(all_lon==minlonci);
ind_lon_e=find(all_lon==maxlonci);
ind_lat_s=find(all_lat==minlatci);
ind_lat_e=find(all_lat==maxlatci);

nlatcell=int32(1/latsc);
nloncell=int32(1/lonsc);
ecozon_1deg=NaN(180,360);
for ii=ind_lon_s:ind_lon_e-1
    for jj=ind_lat_s:ind_lat_e-1
        jjc=jj-ind_lat_s+1;
        iic=ii-ind_lon_s+1;
        indlat_s=(jjc*nlatcell)-nlatcell+1;
        indlat_e=jjc*nlatcell;
        indlon_s=(iic*nloncell)-nloncell+1;
        indlon_e=iic*nloncell;
        temp=ecozon(indlat_s:indlat_e,indlon_s:indlon_e);
        ecozon_1deg(jj,ii)=mode(temp(:));
        clear temp
    end
end
clear ii jj jjc iic indlat_e indlat_e indlon_s indlon_e

%Delete ecozones for which a comparison is not valid due to lack of forest coverage
ecozon_1deg(ecozon_1deg==1)=NaN;
ecozon_1deg(ecozon_1deg==2)=NaN;
ecozon_1deg(ecozon_1deg==3)=NaN;
%4 = Taiga Plains
%5 = Taiga Shield West
%6 = Boreal Shield West
%7 = Atlantic Maritime
ecozon_1deg(ecozon_1deg==8)=NaN; 
%9 = Boreal plains
ecozon_1deg(ecozon_1deg==10)=NaN;
%11 = Taiga Cordillera
%12 = Boreal Cordillera
%13 = Pacific Maritime
%14 = Montane Cordillera
%15 = Hudson Plains
%16 = Taiga Shield East
%17 = Boreal Shield East
ecozon_1deg(ecozon_1deg==18)=NaN;

%Assign values for disturbance rotation periods from White et al. (2017)
%Remote Sensing of the Environment 194, 303-321.
%(Values calculated from Table 2, corrected for total forest area using Table 1)
white_tau=[NaN,NaN,NaN,134,70,87,133,NaN,151,NaN,273,268,305,221,255,226,180,NaN];
ecozon_1deg_whitetau=ecozon_1deg;
for nn=1:length(white_tau)
    aa=find(ecozon_1deg==nn);
    ecozon_1deg_whitetau(aa)=white_tau(nn);
    clear aa
end
clear nn

%Read in disturbance return periods from Hansen ESA corrected calculations

%Load the relevant Hansen tau data from a mat file calculated with
%hansen_disturb_int_calc_1deg_lu_v4_lossyear.m

load /Users/pughtam/Documents/GAP_work/Disturbance/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
%load /Users/pughtam/Documents/GAP_work/Disturbance/hansen_disturb_int_calc_1deg_lu_canarea_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh=tau_d_1deg_lucorr_upper_maskhigh';

ecozon_1deg_hantau=ecozon_1deg;
ecozon_1deg_hantau_lower=ecozon_1deg;
ecozon_1deg_hantau_upper=ecozon_1deg;
for nn=1:length(white_tau)
    aa=find(ecozon_1deg==nn);
    ecozon_1deg_hantau(aa)=nanmean(tau_d_1deg_lucorr_maskhigh(aa));
    ecozon_hantau(nn)=nanmean(tau_d_1deg_lucorr_maskhigh(aa));
    ecozon_1deg_hantau_lower(aa)=nanmean(tau_d_1deg_lucorr_lower_maskhigh(aa));
    ecozon_hantau_lower(nn)=nanmean(tau_d_1deg_lucorr_lower_maskhigh(aa));
    ecozon_1deg_hantau_upper(aa)=nanmean(tau_d_1deg_lucorr_upper_maskhigh(aa));
    ecozon_hantau_upper(nn)=nanmean(tau_d_1deg_lucorr_upper_maskhigh(aa));
    clear aa
end
clear nn

%Calculate best fit line between regions
mdli=fitlm(white_tau,ecozon_hantau,'Intercept',false);
xx=0:max(white_tau)+50;
ypred=predict(mdli,xx');

%Make scatter plot
figure
hold on
plot(white_tau,ecozon_hantau,'.','color',[0 0.2 0.8],'markersize',14)
errorbar(white_tau,ecozon_hantau,ecozon_hantau-ecozon_hantau_lower,ecozon_hantau_upper-ecozon_hantau,'linestyle','none','color',[0 0.2 0.8])
plot(xx,ypred,'-','color',[0 0.2 0.8])
xlabel('White et al. (2017), all-forest \tau (years)') 
ylabel('This study, closed-canopy forest \tau (years)')