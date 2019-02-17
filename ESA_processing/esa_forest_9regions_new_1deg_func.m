function [esa_sel,regions,nregion]=esa_forest_9regions_new_1deg_func(masktofor)
%Create forest type mask based on output from esa_hires_region_mask_1deg.m
%Key addition over original array is to give split by latitudes.
%
%Dependencies:
% - *.mat files from esa_hires_region_mask_1deg.m
%
%T. Pugh
%10.11.17

load /data/ESA_landcover/esa_hires_region_mask_1deg.mat

%Split Broadleaved deciduous by tropical/temperate (23 degrees split)
[lons,lats]=meshgrid(-179.5:1:179.5,-89.5:1:89.5);
esa_sel=NaN(180,360); 
%Assign other values to 9
esa_sel(mask_broad_ever & abs(lats)<=23)=1;
esa_sel(mask_broad_dec & abs(lats)<=23)=2;
esa_sel(mask_broad_ever & abs(lats)>23)=4;
esa_sel(mask_broad_dec & abs(lats)>23)=5;
esa_sel(mask_needl_ever)=6;
esa_sel(mask_needl_dec)=7;
esa_sel(mask_tree_mixed)=8;
esa_sel(mask_tree_shrub_mosaic | mask_tree_flooded)=9;
esa_sel(esa_sel==9 & abs(lats)<=23)=3; %Assign other tropical values to 2
regions={'TrBE','TrBD','OTr','TeBE','TeBD','NE','ND','MX','Other'};

nregion=max(esa_sel(:));

if masktofor
    load /data/ESA_landcover/esa_1deg_forest.mat
    esa_sel(mask_for_1deg<0.01)=NaN;
end

%Make netcdf
% outfile='ESA_forest_9regions_v2.nc';
% nccreate(outfile,'region_mask','Dimensions',{'longitude',360,'latitude',180})
% nccreate(outfile,'latitude','Dimensions',{'latitude',180})
% nccreate(outfile,'longitude','Dimensions',{'longitude',360})
% ncwrite(outfile,'region_mask',esa_sel');
% ncwrite(outfile,'latitude',-89.5:1:89.5);
% ncwrite(outfile,'longitude',-179.5:1:179.5);
% ncwriteatt(outfile,'region_mask','Comment','1=Tropical broadleaved evergreen, 2=Tropical broadleaved deciduous, 3=Other Tropical (<23 degrees), 4=Temperate broadleaved evergreen, 5=Temperate broadleaved deciduous, 6=Needleleaved evergreen, 7=Needleleaved Deciduous, 8=Broadleaved/Needleaved mixed forest, 9=Other')
% ncwriteatt(outfile,'longitude','Units','degrees_east')
% ncwriteatt(outfile,'latitude','Units','degrees_north')
% ncwriteatt(outfile,'/','Comment','Created based on ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif using esa_forest_9regions_new_1deg_func.m')
% ncwriteatt(outfile,'/','Version','2')
% ncwriteatt(outfile,'/','Contact','T. Pugh, t.a.m.pugh@bham.ac.uk')