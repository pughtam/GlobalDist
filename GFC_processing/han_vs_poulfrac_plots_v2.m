%Make maps of tau from hansen and young forest fractions from Poulter, including uncertainties.
%
%Also output the young forest fractions to a *.mat file for use by other scripts.
%
%Dependencies:
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using XXXX)
% - *.mat file from hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
%
%T. Pugh
%02.08.18

file_in='/data/Poulter_forest_age/GFAD_V1-1/GFAD_V1-1.nc';
file_in_min='/data/Poulter_forest_age/GFAD_V1-1/GFAD_V1-1_lowerbound.nc';
file_in_max='/data/Poulter_forest_age/GFAD_V1-1/GFAD_V1-1_upperbound.nc';

file_han_tau='/data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat';
%file_han_tau='/data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_canarea_v4_outarrays.mat';

file_fmask='/data/Hansen_forest_change/hansen_forested_frac_1deg_thres50.nc4';

makeplots=false; %Make plots?
writemat=true; %Write the mat file?

%----
%Read in forest age
%Units are fraction of the grid-cell occupied by that PFT and age class
fage=ncread(file_in,'age');
fage_min=ncread(file_in_min,'age');
fage_max=ncread(file_in_max,'age');
fclass=ncread(file_in,'Class');
fclass_min=ncread(file_in_min,'Class');
fclass_max=ncread(file_in_max,'Class');
flon=ncread(file_in,'lon');
flat=ncread(file_in,'lat');
fadmin=ncread(file_in,'adminunit');

ngrid=length(find(sum(sum(fage,4),3)>0));

fage(fage==0)=NaN;
fage(fage==-9999)=NaN;
fage_min(fage_min==0)=NaN;
fage_min(fage_min==-9999)=NaN;
fage_max(fage_max==0)=NaN;
fage_max(fage_max==-9999)=NaN;
fadmin(fadmin==0)=NaN;
fadmin(fadmin==-9999)=NaN;

%Sum over all PFTs in file
fage=squeeze(nansum(fage,3));
fage_min=squeeze(nansum(fage_min,3));
fage_max=squeeze(nansum(fage_max,3));

%Calculate the total forest fraction
fage_totfrac=squeeze(nansum(fage,3));
fage_totfrac(fage_totfrac==0)=NaN;
fage_min_totfrac=squeeze(nansum(fage_min,3));
fage_min_totfrac(fage_min_totfrac==0)=NaN;
fage_max_totfrac=squeeze(nansum(fage_max,3));
fage_max_totfrac(fage_max_totfrac==0)=NaN;

%Aggregate to 1 x 1 degree and rearrange dimensions
fage_sum_1deg=NaN(180,360,max(fclass));
fage_min_sum_1deg=NaN(180,360,max(fclass_min));
fage_max_sum_1deg=NaN(180,360,max(fclass_max));
fage_totfrac_1deg=NaN(180,360);
fage_min_totfrac_1deg=NaN(180,360);
fage_max_totfrac_1deg=NaN(180,360);
fadmin_1deg=NaN(180,360);
for xx=1:360
    for yy=1:180
        ind_x=(xx*2)-1;
        ind_y=(yy*2)-1;
        for nn=1:max(fclass)
            temp=fage(ind_x:ind_x+1,ind_y:ind_y+1,nn);
            fage_sum_1deg(yy,xx,nn)=nanmean(temp(:));
            clear temp
        end
        for nn=1:max(fclass_min)
            temp=fage_min(ind_x:ind_x+1,ind_y:ind_y+1,nn);
            fage_min_sum_1deg(yy,xx,nn)=nanmean(temp(:));
            clear temp
        end
        for nn=1:max(fclass_max)
            temp=fage_max(ind_x:ind_x+1,ind_y:ind_y+1,nn);
            fage_max_sum_1deg(yy,xx,nn)=nanmean(temp(:));
            clear temp
        end
        temp2=fage_totfrac(ind_x:ind_x+1,ind_y:ind_y+1);
        fage_totfrac_1deg(yy,xx)=nanmean(temp2(:));
        clear temp2
        temp2=fage_min_totfrac(ind_x:ind_x+1,ind_y:ind_y+1);
        fage_min_totfrac_1deg(yy,xx)=nanmean(temp2(:));
        clear temp2
        temp2=fage_max_totfrac(ind_x:ind_x+1,ind_y:ind_y+1);
        fage_max_totfrac_1deg(yy,xx)=nanmean(temp2(:));
        clear temp2
        temp2=fadmin(ind_x:ind_x+1,ind_y:ind_y+1);
        fadmin_1deg(yy,xx)=mode(temp2(:));
        clear temp2
        clear ind_x ind_y
    end
    clear yy
end
clear xx nn
fage_sum_1deg=flip(fage_sum_1deg,1);
fage_min_sum_1deg=flip(fage_min_sum_1deg,1);
fage_max_sum_1deg=flip(fage_max_sum_1deg,1);
fage_totfrac_1deg=flip(fage_totfrac_1deg,1);
fage_min_totfrac_1deg=flip(fage_min_totfrac_1deg,1);
fage_max_totfrac_1deg=flip(fage_max_totfrac_1deg,1);
fadmin_1deg=flip(fadmin_1deg,1);
flat=flipud(flat);

%Fractions of forest under 50 years old
fage_sum_1deg_50=nansum(fage_sum_1deg(:,:,1:5),3)./fage_totfrac_1deg;

fage_min_sum_1deg_50=nansum(fage_min_sum_1deg(:,:,1:5),3)./fage_min_totfrac_1deg;

fage_max_sum_1deg_50=nansum(fage_max_sum_1deg(:,:,1:5),3)./fage_max_totfrac_1deg;

%Apply forest masks
fmask=fliplr(ncread(file_fmask,'forested_50_percent')); %Percentage of gridcell coverage with at least 50% forest.
fmask=flipud(fmask');
forestmaskhigh=false(size(fmask));
forestmaskhigh(fmask>25)=true; %At least 25% cover of 50%-canopy-cover forest in gridcell
clear fmask

fage_sum_1deg_50_maskhigh=fage_sum_1deg_50;
fage_sum_1deg_50_maskhigh(~forestmaskhigh)=NaN;

fage_min_sum_1deg_50_maskhigh=fage_min_sum_1deg_50;
fage_min_sum_1deg_50_maskhigh(~forestmaskhigh)=NaN;

fage_max_sum_1deg_50_maskhigh=fage_max_sum_1deg_50;
fage_max_sum_1deg_50_maskhigh(~forestmaskhigh)=NaN;

%Load the relevant Hansen tau data from a mat file calculated with
%hansen_disturb_int_calc_1deg_lu_v4.m

load(file_han_tau)
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh=tau_d_1deg_lucorr_upper_maskhigh';

%Now average the taud data over admin units (except region 1, i.e. the topics)
fage_sum_1deg_50_maskhigh_admin=fage_sum_1deg_50_maskhigh;
fage_min_sum_1deg_50_maskhigh_admin=fage_min_sum_1deg_50_maskhigh;
fage_max_sum_1deg_50_maskhigh_admin=fage_max_sum_1deg_50_maskhigh;
tau_d_1deg_lucorr_maskhigh_admin=tau_d_1deg_lucorr_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_admin=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_upper_maskhigh_admin=tau_d_1deg_lucorr_upper_maskhigh;

fadmin_1deg_clean=fadmin_1deg;
fadmin_1deg_clean(fadmin_1deg==1)=NaN;

nclass=max(fadmin_1deg(:));
fage_sum_1deg_50_maskhigh_admin_byclass=NaN(nclass,1);
fage_min_sum_1deg_50_maskhigh_admin_byclass=NaN(nclass,1);
fage_max_sum_1deg_50_maskhigh_admin_byclass=NaN(nclass,1);
tau_d_1deg_lucorr_maskhigh_admin_byclass=NaN(nclass,1);
tau_d_1deg_lucorr_lower_maskhigh_admin_byclass=NaN(nclass,1);
tau_d_1deg_lucorr_upper_maskhigh_admin_byclass=NaN(nclass,1);
for nn=1:nclass
    inds=find(fadmin_1deg_clean==nn);
    
    %First the age arrays
    vals=nanmedian(fage_sum_1deg_50_maskhigh(inds));
    fage_sum_1deg_50_maskhigh_admin_byclass(nn)=vals;
    fage_sum_1deg_50_maskhigh_admin(inds)=vals;
    
    vals=nanmedian(fage_min_sum_1deg_50_maskhigh(inds));
    fage_min_sum_1deg_50_maskhigh_admin_byclass(nn)=vals;
    fage_min_sum_1deg_50_maskhigh_admin(inds)=vals;
    
    vals=nanmedian(fage_max_sum_1deg_50_maskhigh(inds));
    fage_max_sum_1deg_50_maskhigh_admin_byclass(nn)=vals;
    fage_max_sum_1deg_50_maskhigh_admin(inds)=vals;
    clear vals
    
    %Then the Hansen tau
    vals=nanmedian(tau_d_1deg_lucorr_maskhigh(inds));
    tau_d_1deg_lucorr_maskhigh_admin_byclass(nn)=vals;
    tau_d_1deg_lucorr_maskhigh_admin(inds)=vals;
    
    vals=nanmedian(tau_d_1deg_lucorr_lower_maskhigh(inds));
    tau_d_1deg_lucorr_lower_maskhigh_admin_byclass(nn)=vals;
    tau_d_1deg_lucorr_lower_maskhigh_admin(inds)=vals;
    
    vals=nanmedian(tau_d_1deg_lucorr_upper_maskhigh(inds));
    tau_d_1deg_lucorr_upper_maskhigh_admin_byclass(nn)=vals;
    tau_d_1deg_lucorr_upper_maskhigh_admin(inds)=vals;
    
    clear inds vals
end
clear nn

fage_sum_1deg_50_maskhigh_admin(~forestmaskhigh)=NaN;
fage_min_sum_1deg_50_maskhigh_admin(~forestmaskhigh)=NaN;
fage_max_sum_1deg_50_maskhigh_admin(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_maskhigh_admin(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_lower_maskhigh_admin(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_upper_maskhigh_admin(~forestmaskhigh)=NaN;

if writemat
    save -v7.3 poulfrac.mat fage_sum_1deg_50_maskhigh_admin tau_d_1deg_lucorr_maskhigh fage_min_sum_1deg_50_maskhigh_admin...
        fage_min_sum_1deg_100_maskhigh_admin fage_max_sum_1deg_50_maskhigh_admin fage_max_sum_1deg_100_maskhigh_admin...
        fage_sum_1deg_50_maskhigh tau_d_1deg_lucorr_maskhigh fage_min_sum_1deg_50_maskhigh fage_min_sum_1deg_100_maskhigh...
        fage_max_sum_1deg_50_maskhigh fage_max_sum_1deg_100_maskhigh
end

%----
%Make plots

if makeplots
   
    figure
    s1=subplot(3,2,1);
    p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_lower_maskhigh_admin));
    set(p1,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([1 3])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t1=text(-170,-50,'a','Fontweight','bold');
    
    s2=subplot(3,2,2);
    p2=pcolor(-180.0:1:179.0,-90.0:1:89.0,fage_min_sum_1deg_50_maskhigh_admin);
    set(p2,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([0 1])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t2=text(-170,-50,'b','Fontweight','bold');
    
    s3=subplot(3,2,3);
    p3=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh_admin));
    set(p3,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([1 3])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t3=text(-170,-50,'c','Fontweight','bold');
    
    s4=subplot(3,2,4);
    p4=pcolor(-180.0:1:179.0,-90.0:1:89.0,fage_sum_1deg_50_maskhigh_admin);
    set(p4,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([0 1])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t4=text(-170,-50,'d','Fontweight','bold');
    
    s5=subplot(3,2,5);
    p5=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_upper_maskhigh_admin));
    set(p5,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([1 3])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t5=text(-170,-50,'e','Fontweight','bold');
    c5=colorbar;
    set(c5,'Ticks',log10([10 30 100 300 1000]))
    set(c5,'TickLabels',10.^get(c5,'Ticks'))  
    set(c5,'Location','southoutside')
    
    s6=subplot(3,2,6);
    p6=pcolor(-180.0:1:179.0,-90.0:1:89.0,fage_max_sum_1deg_50_maskhigh_admin);
    set(p6,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    caxis([0 1])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    t6=text(-170,-50,'f','Fontweight','bold');
    c6=colorbar;
    set(c6,'Location','southoutside')
    
    set(s1,'Position',[0.04 0.7 0.45 0.28])
    set(s2,'Position',[0.51 0.7 0.45 0.28])
    set(s3,'Position',[0.04 0.4 0.45 0.28])
    set(s4,'Position',[0.51 0.4 0.45 0.28])
    set(s5,'Position',[0.04 0.1 0.45 0.28])
    set(s6,'Position',[0.51 0.1 0.45 0.28])
end