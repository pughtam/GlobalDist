function [maskarea,fmask]=distforfrachan(file_in_tree,file_in_grass)
%Function to calculate a mask for forested area based on FPC in a LPJ-GUESS
%simulation and a minimum coverage of 25% forest cover based on Hansen et al. (2013) (with 50%
%canopy coverage in 1km gridcell being the basis for assessing forest coverage).
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
%
%T. Pugh
%07.04.17

datafol='/Users/pughtam/Documents/GAP_work/Disturbance/netcdfs_for_deposition/';

%Reference simulation
fpc_tree=ncread(file_in_tree,'fpc_tree');
fpc_grass=ncread(file_in_grass,'fpc_grass');
fpc_tot=fpc_tree+fpc_grass;

over1=find(fpc_tot>1);
fpc_tree(over1)=fpc_tree(over1)./fpc_tot(over1);
clear fpc_tot fpc_grass over1

%--------------------------------------------------------------------------
%Work out fraction of currently forested area that will be affected based
%on Hansen et al. (2013) forest cover data

fmask=ncread([datafol,'/forestmask/hansen_forested_frac_05.nc4'],'forested_50_percent')';

%Find gridcells with forest cover >25%
fmask_thres=NaN(size(fmask));
fmask_thres(fmask>25)=1;

%Find gridcells with LPJG forest cover over 25%
fpc_tree_thres=ones(size(fpc_tree));
fpc_tree_thres(fpc_tree<0.25)=NaN;
fpc_tree_thres=fpc_tree_thres';

maskarea=fpc_tree_thres.*fmask_thres;
