function [mdistc_tot_TrBE,mdistc_tot_TrBD,mdistc_tot_TeBE,mdistc_tot_TeBD,mdistc_tot_BNE,mdistc_tot_BNS,mdistc_tot_MX,mdistc_tot,...
    mmortc_tot_TrBE,mmortc_tot_TrBD,mmortc_tot_TeBE,mmortc_tot_TeBD,mmortc_tot_BNE,mmortc_tot_BNS,mmortc_tot_MX,mmortc_tot,...
    mtotc_tot_TrBE,mtotc_tot_TrBD,mtotc_tot_TeBE,mtotc_tot_TeBD,mtotc_tot_BNE,mtotc_tot_BNS,mtotc_tot_MX,mtotc_tot,...
    mdistc_1deg,mmortc_1deg,mtotc_1deg]=dist_loss_maps_esa_func_v3(datafol,mdistcfile,omortcfile,lturncfile,rturncfile,reprocfile,fpctreefile,fpcgrassfile,thres25)
%Calculate the C flux sizes for a specific time period for one simulation. Calculations only include
%forest areas as defined by Hansen et al. (2013). Calculation are made at 1 degree resolution.
%Reproduction flux included in total C turnover.
%
%Regions are defined by ESA landcovers.
%
%Dependencies:
% - distforfrachan.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using hansen_forest_frac_calc.m)
% - esa_forest_9regions_new_1deg_func.m
% - global_grid_area_1deg.m
%
%T. Pugh
%03.08.18

mdistc=ncread([datafol,'/lpjg/',mdistcfile],'TdistC')'; %Disturbance mortality turnover
omortc=ncread([datafol,'/lpjg/',omortcfile],'TmortC')'; %Other mortality turnover
otherc=ncread([datafol,'/lpjg/',lturncfile],'TleafC')'+ncread([datafol,'/lpjg/',rturncfile],'TrootC')'+ncread([datafol,'/lpjg/',reprocfile],'TreproC')'; %Other turnover (leaf, fine root, reproduction)
mmortc=mdistc+omortc; %Total mortality turnover
mtotc=mmortc+otherc; %Total turnover
clear omortc otherc

%Exclude gridcells with less than 25% tree cover
if thres25
    [maskarea,~]=distforfrachan([datafol,'/lpjg/',fpctreefile],[datafol,'/lpjg/',fpcgrassfile]);
    mdistc=mdistc.*maskarea;
    mmortc=mmortc.*maskarea;
    mtotc=mtotc.*maskarea;
end

%Aggregate to 1 degree (to increase effective patch number and make consistent with disturbance information resolution)
mdistc_1deg=NaN(180,360);
mmortc_1deg=NaN(180,360);
mtotc_1deg=NaN(180,360);
for xx=1:360
    for yy=1:180
        ind_x=(xx*2)-1;
        ind_y=(yy*2)-1;
        temp_mdistc=mdistc(ind_y:ind_y+1,ind_x:ind_x+1);
        temp_mmortc=mmortc(ind_y:ind_y+1,ind_x:ind_x+1);
        temp_mtotc=mtotc(ind_y:ind_y+1,ind_x:ind_x+1);
        mdistc_1deg(yy,xx)=nanmean(temp_mdistc(:));
        mmortc_1deg(yy,xx)=nanmean(temp_mmortc(:));
        mtotc_1deg(yy,xx)=nanmean(temp_mtotc(:));
        clear temp_mdistc temp_mmortc temp_mtotc
        clear ind_x ind_y
    end
    clear yy
end
clear xx

%Get gridcell areas
%Calculate forest areas in each class
fmask=(ncread([datafol,'/forestmask/hansen_forested_frac_1deg_thres50.nc4'],'forested_50_percent')');
gridarea=global_grid_area_1deg();
gridarea=gridarea.*(double(fmask)/100);

%Get ESA landcovers
%Create Threshold tau maps
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);

%Calculate global and regional totals in Pg C a-1
mdistc_tot=nansum(mdistc_1deg(:).*gridarea(:))/1e12;
mmortc_tot=nansum(mmortc_1deg(:).*gridarea(:))/1e12;
mtotc_tot=nansum(mtotc_1deg(:).*gridarea(:))/1e12;

mdistc_tot_TrBE=nansum(mdistc_1deg(rmask==1).*gridarea(rmask==1))/1e12;
mmortc_tot_TrBE=nansum(mmortc_1deg(rmask==1).*gridarea(rmask==1))/1e12;
mtotc_tot_TrBE=nansum(mtotc_1deg(rmask==1).*gridarea(rmask==1))/1e12;

mdistc_tot_TrBD=nansum(mdistc_1deg(rmask==2).*gridarea(rmask==2))/1e12;
mmortc_tot_TrBD=nansum(mmortc_1deg(rmask==2).*gridarea(rmask==2))/1e12;
mtotc_tot_TrBD=nansum(mtotc_1deg(rmask==2).*gridarea(rmask==2))/1e12;

mdistc_tot_TeBE=nansum(mdistc_1deg(rmask==4).*gridarea(rmask==4))/1e12;
mmortc_tot_TeBE=nansum(mmortc_1deg(rmask==4).*gridarea(rmask==4))/1e12;
mtotc_tot_TeBE=nansum(mtotc_1deg(rmask==4).*gridarea(rmask==4))/1e12;

mdistc_tot_TeBD=nansum(mdistc_1deg(rmask==5).*gridarea(rmask==5))/1e12;
mmortc_tot_TeBD=nansum(mmortc_1deg(rmask==5).*gridarea(rmask==5))/1e12;
mtotc_tot_TeBD=nansum(mtotc_1deg(rmask==5).*gridarea(rmask==5))/1e12;

mdistc_tot_BNE=nansum(mdistc_1deg(rmask==6).*gridarea(rmask==6))/1e12;
mmortc_tot_BNE=nansum(mmortc_1deg(rmask==6).*gridarea(rmask==6))/1e12;
mtotc_tot_BNE=nansum(mtotc_1deg(rmask==6).*gridarea(rmask==6))/1e12;

mdistc_tot_BNS=nansum(mdistc_1deg(rmask==7).*gridarea(rmask==7))/1e12;
mmortc_tot_BNS=nansum(mmortc_1deg(rmask==7).*gridarea(rmask==7))/1e12;
mtotc_tot_BNS=nansum(mtotc_1deg(rmask==7).*gridarea(rmask==7))/1e12;

mdistc_tot_MX=nansum(mdistc_1deg(rmask==8).*gridarea(rmask==8))/1e12;
mmortc_tot_MX=nansum(mmortc_1deg(rmask==8).*gridarea(rmask==8))/1e12;
mtotc_tot_MX=nansum(mtotc_1deg(rmask==8).*gridarea(rmask==8))/1e12;

fprintf('           TrBE    TrBD    TeBE    TeBD    BNE     BNS     MX      Global\n');
fprintf('DistC     %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f\n',mdistc_tot_TrBE,mdistc_tot_TrBD,mdistc_tot_TeBE,mdistc_tot_TeBD,mdistc_tot_BNE,mdistc_tot_BNS,mdistc_tot_MX,mdistc_tot);
fprintf('MortC     %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f\n',mmortc_tot_TrBE,mmortc_tot_TrBD,mmortc_tot_TeBE,mmortc_tot_TeBD,mmortc_tot_BNE,mmortc_tot_BNS,mmortc_tot_MX,mmortc_tot);
fprintf('TotC      %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f\n',mtotc_tot_TrBE,mtotc_tot_TrBD,mtotc_tot_TeBE,mtotc_tot_TeBD,mtotc_tot_BNE,mtotc_tot_BNS,mtotc_tot_MX,mtotc_tot);
fprintf('Mort %%    %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f  %6.3f\n',mdistc_tot_TrBE/mmortc_tot_TrBE*100,mdistc_tot_TrBD/mmortc_tot_TrBD*100,mdistc_tot_TeBE/mmortc_tot_TeBE*100,...
                                                                                mdistc_tot_TeBD/mmortc_tot_TeBD*100,mdistc_tot_BNE/mmortc_tot_BNE*100,mdistc_tot_BNS/mmortc_tot_BNS*100,...
                                                                                mdistc_tot_MX/mmortc_tot_MX*100,mdistc_tot/mmortc_tot*100);

