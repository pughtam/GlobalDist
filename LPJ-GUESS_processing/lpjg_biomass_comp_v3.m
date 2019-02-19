%Script to compare LPJ-GUESS biomass carbon outputs against those from the GEOCARBON dataset for
%simulations with different disturbance settings.
%
%Biomass data from GEOCARBON, http://lucid.wur.nl/datasets/high-carbon-ecosystems
%
%Dependencies:
% - lpj_to_grid_func_centre.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
%
%T. Pugh
%11.02.19

lpjg_base_folder='/media/pughtam/rds-2017-pughtam-01/Disturbance/v3/100flat/postproc/';
lpjg_han_folder='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p100/postproc/';
cpool_file='cpool_2001_2014';
cveg_col=1; %Column in cpool_file that relates to CVeg
biomass_file='/data/general_data/Avitabile_AGB_Map/GEOCARBON_Global_Forest_Biomass/GEOCARBON_Global_Forest_AGB_10072015.tif';
use_fmask=false; %Mask to Hansen et al. (2013) forest cover (only for map coverage, no scaling)

usesaatchiBGBcorr=true; %Use the BGB calculation given in Saatch et al. (2011). Else use a simple ratio from IPCC

%---
%Read LPJ-GUESS data

cpool_in=lpj_to_grid_func_centre([lpjg_base_folder,cpool_file],1,0);
cveg_base_lpjg=squeeze(cpool_in(:,:,cveg_col));
cpool_in=lpj_to_grid_func_centre([lpjg_han_folder,cpool_file],1,0);
cveg_han_lpjg=squeeze(cpool_in(:,:,cveg_col));
clear cpool_in
cveg_base_lpjg(cveg_base_lpjg==0)=NaN;
cveg_han_lpjg(cveg_han_lpjg==0)=NaN;

%----
%Set some basic constants
hectare_to_metre=100^2;
ton_to_kg=1000;
DM_to_C=0.5;
AGB_BGB_ratio=0.75; %Based on Annex 3A.1, Table 3A.1.8 in the IPCC LUCF Sector Good Practice Guidelines

%Read Vegetation C from observations
[AGB_in, Rc]=geotiffread(biomass_file);
AGB_in=flipud(AGB_in);
minlatc=Rc.LatitudeLimits(1);
maxlatc=Rc.LatitudeLimits(2);
minlonc=Rc.LongitudeLimits(1);
maxlonc=Rc.LongitudeLimits(2);
latsc=(maxlatc-minlatc)/Rc.RasterSize(1);
lonsc=(maxlonc-minlonc)/Rc.RasterSize(2);
latc=minlatc:latsc:maxlatc-latsc;
lonc=minlonc:lonsc:maxlonc-lonsc;
AGB_in(AGB_in<-1e37)=NaN;
AGB_in=AGB_in*ton_to_kg/hectare_to_metre;
%Regrid to 0.5 degrees
%First trim values outside of the nearest integer degree
minlatci=ceil(minlatc);
maxlatci=floor(maxlatc);
minlonci=ceil(minlonc);
maxlonci=floor(maxlonc);
minlatind=find(abs(latc-minlatci)==min(abs(latc-minlatci)));
maxlatind=find(abs(latc-maxlatci)==min(abs(latc-maxlatci)));
minlonind=find(abs(lonc-minlonci)==min(abs(lonc-minlonci)));
maxlonind=find(abs(lonc-maxlonci)==min(abs(lonc-maxlonci)));
AGB_in2=AGB_in(minlatind:maxlatind-1,minlonind:maxlonind-1);
latct=latc(minlatind:maxlatind-1);
lonct=lonc(minlonind:maxlonind-1);

nlatcell=int32(0.5/latsc);
nloncell=int32(0.5/lonsc);
AGB_05=NaN(360,720);
for ii=1:719
    for jj=69:347
        jjc=jj-68;
        iic=ii;
        indlat_s=(jjc*nlatcell)-nlatcell+1;
        indlat_e=jjc*nlatcell;
        indlon_s=(iic*nloncell)-nloncell+1;
        indlon_e=iic*nloncell;
        temp=AGB_in2(indlat_s:indlat_e,indlon_s:indlon_e);
        AGB_05(jj,ii)=nanmean(temp(:));
        clear temp
    end
end

if usesaatchiBGBcorr
    BGB_05=0.489*(AGB_05.^0.89);
    cveg_05=AGB_05+BGB_05;
    cveg_05=cveg_05*DM_to_C;
else
    cveg_05=AGB_05*DM_to_C/AGB_BGB_ratio;
end

%----
%Mask data

if use_fmask
    %Read present-day forest mask derived from Hansen et al. (2013) data
    fmask=ncread('/data/Hansen_forest_change/hansen_forested_frac_05.nc4','forested_50_percent'); %Percentage of gridcell coverage with at least 50% forest.
    fmask=(double(fmask)/100)'; %Convert to fraction
    fmask(fmask<0.25)=NaN;
    
    cveg_05(isnan(fmask)==1)=NaN;
    cveg_base_lpjg(isnan(fmask)==1)=NaN;
    cveg_han_lpjg(isnan(fmask)==1)=NaN;
end
cveg_avt_05=cveg_05;

%----
%Linearise arrays and remove NaN values

aa=find(isnan(cveg_avt_05(:))==1 | isnan(cveg_base_lpjg(:))==1 | isnan(cveg_han_lpjg(:))==1);
cveg_avt_05(aa)=[];
cveg_base_lpjg(aa)=[];
cveg_han_lpjg(aa)=[];
clear aa

cveg_avt_05=cveg_avt_05';
cveg_base_lpjg=cveg_base_lpjg';
cveg_han_lpjg=cveg_han_lpjg';

%Model for ideal fit
mdli=fitlm(cveg_avt_05,cveg_avt_05,'Intercept',false);
ypred_ideal=predict(mdli,cveg_avt_05);

%----
%Make heat maps
cmap=parula(100);
cmap(1,:)=[1 1 1];

figure
subplot(1,2,1)
hold on
[N_base,C]=hist3([cveg_avt_05,cveg_base_lpjg],[100,100]);
    p1=pcolor(C{1},C{2},N_base'); set(p1,'linestyle','none')
plot(1:50,1:50,'k')
set(gca,'XLim',[0 50],'YLim',[0 50])
mdl1=fitlm(cveg_avt_05,cveg_base_lpjg,'Intercept',true);
ypred_base=predict(mdl1,cveg_avt_05);
plot(cveg_avt_05,ypred_base,'r')
rmse_base=sqrt(mean((ypred_ideal-cveg_base_lpjg).^2));
text(1,47,'(a)')
text(1,42,['R^{2}=',mat2str(round(mdl1.Rsquared.Ordinary,3))])
text(1,37,['RMSE=',mat2str(round(rmse_base,3))])
title('Baseline LPJ-GUESS')
ylabel('Modelled biomass (kg C m^{-2})')
xlabel('Observed biomass (kg C m^{-2})')

subplot(1,2,2)
hold on
[N_han,C]=hist3([cveg_avt_05,cveg_han_lpjg],[100,100]);
    p1=pcolor(C{1},C{2},N_han'); set(p1,'linestyle','none')
plot(1:50,1:50,'k')
set(gca,'XLim',[0 50],'YLim',[0 50])
mdl2=fitlm(cveg_avt_05,cveg_han_lpjg,'Intercept',true);
ypred_han=predict(mdl2,cveg_avt_05);
plot(cveg_avt_05,ypred_han,'r')
rmse_han=sqrt(mean((ypred_ideal-cveg_han_lpjg).^2));
text(1,47,'(b)')
text(1,42,['R^{2}=',mat2str(round(mdl2.Rsquared.Ordinary,3))])
text(1,37,['RMSE=',mat2str(round(rmse_han,3))])
title('\tau-forced LPJ-GUESS')
xlabel('Observed biomass (kg C m^{-2})')

colormap(cmap)
