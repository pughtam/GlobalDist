function [maskarea,fmask]=distforfrachan(file_in)
%Function to calculate a mask for forested area based on FPC in a LPJ-GUESS
%simulation and a minimum coverage of 25% forest cover based on Hansen et al. (2013) (with 50%
%canopy coverage in 1km gridcell being the basis for assessing forest coverage).
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using XXXX)
%
%T. Pugh
%07.04.17

%Reference simulation
fpc_in=dlmread(file_in,'',1,0);
fpc_tree=sum(fpc_in(:,3:12),2);
fpc_tot=fpc_in(:,15);
lon_c=fpc_in(:,1);
lat_c=fpc_in(:,2);
over1=find(fpc_tot>1);
fpc_tree(over1)=fpc_tree(over1)./fpc_tot(over1);
clear file_in over1
ngrid=length(lon_c);

%--------------------------------------------------------------------------
%Work out fraction of currently forested area that will be affected based
%on Hansen et al. (2013) forest cover data

fmask=ncread('/media/pughtam/rds-2017-pughtam-01/Disturbance/hansen_forested_frac_05.nc4','forested_50_percent')';

%Find gridcells with forest cover >25%
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;

%Find gridcells with LPJG forest cover over 25%
minlat=-89.75;
maxlat=89.75;
minlon=-179.75;
maxlon=179.75;
gridsize=0.5;
lon_map=minlon:gridsize:maxlon;
lat_map=minlat:gridsize:maxlat;
map_fpc_tree=zeros(length(lat_map),length(lon_map));
for i=1:ngrid
    x=find(lon_map==lon_c(i));
    y=find(lat_map==lat_c(i));
    map_fpc_tree(y,x)=fpc_tree(i);
    clear x y
end
clear i

map_fpc_tree_thres=ones(size(map_fpc_tree));
map_fpc_tree_thres(map_fpc_tree<0.25)=NaN;

maskarea=map_fpc_tree_thres.*fmask_thres;
