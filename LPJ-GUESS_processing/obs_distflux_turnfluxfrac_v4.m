%Script to estimate the turnover flux due to disturbance and the fraction
%of the total turnover flux due to disturbance based on observations of
%biomass and NPP. Plot output onto bar plots from dist_loss_maps_esa_all.m
%
%Biomass data from GEOCARBON, http://lucid.wur.nl/datasets/high-carbon-ecosystems
%NPP data from MODIS, https://modis.gsfc.nasa.gov/data/dataprod/mod17.php
%
%Note that because this averages to regions, it is consistent with the
%1 degree regional calculations in dist_loss_maps_esa_all_v3.m.
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - global_grid_area_1deg.m
% - esa_forest_9regions_new_func.m
%
%T. Pugh
%03.08.18

thres25=false; %Whether or not to apply the 25% forest cover threshold per gridcell (note implicit 5% threshold is included in the model gridlist for the simulations)

usesaatchiBGBcorr=true; %Use the BGB calculation given in Saatch et al. (2011). Else use a simple ratio from IPCC

datafol='/Users/pughtam/Documents/GAP_work/Disturbance/netcdfs_for_deposition/';
intdatafol='/Users/pughtam/Documents/GAP_work/Disturbance/intermediate_processing/';
biomassdata='/Users/pughtam/data/Avitabile_AGB_Map/GEOCARBON_Global_Forest_Biomass/GEOCARBON_Global_Forest_AGB_10072015.tif';
modisfol='/Users/pughtam/data/modis_gpp/';
addpath('/Users/pughtam/data/ESA_landcover')

%---
%Get the disturbance interval data

hansen_file=[intdatafol,'/tau_d_hansen_LUcorr_5perc_esacorr_filled.txt'];
dist_han=lpj_to_grid_func_centre(hansen_file,1,0);

%---
%Set some basic constants
hectare_to_metre=100^2;
ton_to_kg=1000;
DM_to_C=0.5;
AGB_BGB_ratio=0.75; %Based on Annex 3A.1, Table 3A.1.8 in the IPCC LUCF Sector Good Practice Guidelines

%Read Vegetation C from observations
[AGB_in, Rc]=geotiffread(biomassdata);
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


%Get NPP from MODIS for 2001-2010
modis_file={'MOD17A3_Science_NPP_2001.tif','MOD17A3_Science_NPP_2002.tif','MOD17A3_Science_NPP_2003.tif',...
    'MOD17A3_Science_NPP_2004.tif','MOD17A3_Science_NPP_2005.tif','MOD17A3_Science_NPP_2006.tif','MOD17A3_Science_NPP_2007.tif',...
    'MOD17A3_Science_NPP_2008.tif','MOD17A3_Science_NPP_2009.tif','MOD17A3_Science_NPP_2010.tif'};
npp_05=NaN(360,720,length(modis_file));
for nn=1:length(modis_file)
    [npp, Rg]=geotiffread([modisfol,'/',modis_file{nn}]);
    npp=flipud(npp);
    minlatg=Rg.LatitudeLimits(1);
    maxlatg=Rg.LatitudeLimits(2);
    minlong=Rg.LongitudeLimits(1);
    maxlong=Rg.LongitudeLimits(2);
    latsg=(maxlatg-minlatg)/Rg.RasterSize(1);
    lonsg=(maxlong-minlong)/Rg.RasterSize(2);
    latg=minlatg:latsg:maxlatg;
    long=minlong:lonsg:maxlong;
    %Regrid to 0.5 degrees
    nlatcell=0.5/latsg;
    nloncell=0.5/lonsg;
    npp=single(npp)/1e4; %Unit conversion also (original units 10x g C m-2)
    npp(npp==65535)=NaN;
    for ii=1:720
        for jj=61:340 %-60 to 80 degrees
            jjc=jj-60;
            indlat_s=(jjc*nlatcell)-nlatcell+1;
            indlat_e=jjc*nlatcell;
            indlon_s=(ii*nloncell)-nloncell+1;
            indlon_e=ii*nloncell;
            temp=npp(indlat_s:indlat_e,indlon_s:indlon_e);
            npp_05(jj,ii,nn)=nanmean(temp(:));
            clear temp
        end
    end
end
clear nn
npp_mod_05=mean(npp_05,3);
clear npp_05
npp_mod_05_clean=npp_mod_05;
npp_mod_05_clean(npp_mod_05>6)=NaN;

fmask=ncread([datafol,'/forestmask/hansen_forested_frac_05.nc4'],'forested_50_percent')';
%Find gridcells with forest cover >25%
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;
fmask=double(fmask)./100;

garea=global_grid_area();

if thres25
    gridarea=garea.*fmask_thres.*fmask;
else
    gridarea=garea.*fmask;
end
clear garea

%Get ESA landcovers
[rmask,regions,nregion]=esa_forest_9regions_new_func(false);

%Estimate turnover flux due to mortality in Pg C a-1
distrate_han=1./dist_han;
distrate_han(isinf(distrate_han)==1)=NaN;

han_distturn_flux=NaN(8,1);
npp_flux=NaN(8,1);
nn=0;
for bb=1:nregion
    if bb==3 || bb==9; continue; end %Ignore OTr and Other regions
    nn=nn+1;
    han_distturn_flux(nn)=nansum((distrate_han(rmask==bb)).*cveg_05(rmask==bb).*gridarea(rmask==bb));
    npp_flux(nn)=nansum(npp_mod_05_clean(rmask==bb).*gridarea(rmask==bb));
end
clear bb nn
han_distturn_flux(8)=nansum((distrate_han(:)).*cveg_05(:).*gridarea(:));
npp_flux(8)=nansum(npp_mod_05_clean(:).*gridarea(:));

han_distturn_flux=han_distturn_flux/1e12;
npp_flux=npp_flux/1e12;

%Estimate fraction of turnover flux in %
totturnfrac_han=(han_distturn_flux./npp_flux)*100;

%---
%Add to bar plot made with dist_loss_maps_esa_all_v3.m
%(ensure that this plot is the active figure)

subplot(2,1,1)
hold on
p1=plot(1.15:8.15,totturnfrac_han,'k.');

subplot(2,1,2)
hold on
p2=plot(1.15:8.15,han_distturn_flux,'k.');
