%Script to read in the forest loss data from Hansen et al. (2013, Science)
%https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html
%and calculate the disturbance rotation period for each 10 deg x 10 deg section of the globe.
%
%Note that these disturbance rates are corrected for land-use change using
%landcover data from from ESA CCI Landcover v2.0.7
%http://maps.elie.ucl.ac.be/CCI/viewer/
%
%Uncertainties are calculated based on bootstrap resampling.
%
%Dependencies:
% - *.mat file for land-use change from ESA_forest_loss_process.m
% - hansen_forested_frac_1deg_thres50.nc4 (calculated using XXXX)
%
%T. Pugh
%29.01.19

readdata=false; %Read raw Hansen et al. data (very slow) or read from preprocessed *.mat file (processed using this script)

inputdir='/data/Hansen_forest_change/';

usecanarea=false; %Make calculations relative to canopy area instead of 0.01 degree forest cover area

limityearrange=true; %Limit the number of loss years considered (from 2000) to maxyear. Set to false to calculate over the whole 14 year period.
maxyear=6;

makeplots=false; %Make plots

writeoutput=false; %Write text file output for LPJ-GUESS input
file_out='tau_d_hansen_LUcorr_5perc_esacorr_filled.txt';
file_lower_out='tau_d_hansen_LUcorr_5perc_lower_esacorr_filled.txt';
file_upper_out='tau_d_hansen_LUcorr_5perc_upper_esacorr_filled.txt';

%---
%Define some constants
rad_earth=6.371e6; %m2
circ_earth=2*pi*rad_earth;

%---
%Now read in the Hansen et al. data and process
if readdata
    
    yyind=['80S';'70S';'60S';'50S';'40S';'30S';'20S';'10S';'00N';'10N';'20N';'30N';'40N';'50N';'60N';'70N';'80N'];
    xxind=['180W';'170W';'160W';'150W';'140W';'130W';'120W';'110W';'100W';'090W';'080W';'070W';'060W';'050W';'040W';'030W';'020W';'010W';'000E';...
        '010E';'020E';'030E';'040E';'050E';'060E';'070E';'080E';'090E';'100E';'110E';'120E';'130E';'140E';'150E';'160E';'170E'];
    
    totloss_001deg=NaN(36000,18000);
    totlosscan_001deg=NaN(36000,18000);
    totfarea_001deg=NaN(36000,18000);
    cc=0;
    for yy=5:17 %Data starts from 50S (i.e. 50S - 60S)
        for xx=1:36
            cc=cc+1; %Counter for diagnostic output
            filename_loss=[inputdir,'/Hansen_GFC2014_loss_',yyind(yy,:),'_',xxind(xx,:),'.tif'];
            filename_farea=[inputdir,'/Hansen_GFC2014_treecover2000_',yyind(yy,:),'_',xxind(xx,:),'.tif'];
            if limityearrange
                filename_lossyear=[inputdir,'/Hansen_GFC2014_lossyear_',yyind(yy,:),'_',xxind(xx,:),'.tif'];
            end
            [tempfarea, Rfarea]=geotiffread(filename_farea);
            if max(tempfarea(:))==0
                %No forested area, do not process this 10 x 10 degree section any further
                clear tempfarea Rfarea
                continue
            end
            [temploss, Rloss]=geotiffread(filename_loss);
            if limityearrange
                [templossyear, Rlossyear]=geotiffread(filename_lossyear);
            end
            
            dims_loss=size(temploss);
            dims_farea=size(tempfarea);
            if limityearrange
                dims_lossyear=size(templossyear);
                if (dims_loss(1)~=dims_farea(1)) || (dims_loss(2)~=dims_farea(2) || dims_lossyear(1)~=dims_farea(1)) || (dims_lossyear(2)~=dims_farea(2))
                    error('ERROR: Dimensions of the input datasets are not consistent')
                end
            else
                if (dims_loss(1)~=dims_farea(1)) || (dims_loss(2)~=dims_farea(2))
                    error('ERROR: Dimensions of the input datasets are not consistent')
                end
            end
            
            %Make calculations at 0.01 deg resolution (consistent with definition for forest cover used)
            fprintf('Calculated ')
            inc_ii=dims_loss(1)/1000;
            inc_jj=dims_loss(2)/1000;
            for ii=1:1000
                for jj=1:1000
                    %Calculate indices for section of array to process
                    ii_s=(ii*inc_ii)-inc_ii+1;
                    ii_e=(ii*inc_ii);
                    jj_s=(jj*inc_jj)-inc_jj+1;
                    jj_e=(jj*inc_jj);
                    %Calculate indices for output array
                    ind_xx=(xx*1000)-1000+ii;
                    ind_yy=(yy*1000)-jj;
                    
                    temploss_001deg=temploss(jj_s:jj_e,ii_s:ii_e);
                    tempfarea_001deg=tempfarea(jj_s:jj_e,ii_s:ii_e);
                    if limityearrange
                        %Ignore all loss data beyond a given number of loss years
                        templossyear_001deg=templossyear(jj_s:jj_e,ii_s:ii_e);
                        temploss_001deg(templossyear_001deg>maxyear)=0;
                    end
                    
                    totloss_001deg(ind_xx,ind_yy)=double(sum(temploss_001deg(:)))/(inc_ii*inc_jj); %.*mean(areag(jj_s:jj_e)); %Total loss calculated based on 0.0001 degree pixel area
                    totlosscan_001deg(ind_xx,ind_yy)=sum(double(temploss_001deg(:)).*(double(tempfarea_001deg(:))/100))/(inc_ii*inc_jj); %Total loss based on fraction of 0.0001 degree pixel area cover by tree canopy
                    totfarea_001deg(ind_xx,ind_yy)=double(sum(tempfarea_001deg(:))/100)/(inc_ii*inc_jj); %.*mean(areag(jj_s:jj_e)); %Total fraction covered by trees
                    
                end
                clear jj
                if mod(ii,100)==0
                    fprintf('%d ',ii*1000)
                end
            end
            clear ii
            fprintf('\n')
                    
            clear temploss tempfarea Rloss Rfarea dims_loss dims_farea
            
            fprintf('Processed %s %s. Total units is %d\n',yyind(yy,:),xxind(xx,:),cc)
        end
        clear xx
    end
    clear yy cc
    
    save -v7.3 hansen_disturb_int_calc_1deg_lu_v4.mat
else
    %Directly load preprocessed data
    if maxyear==14 && limityearrange==false
        load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_030718.mat
    elseif maxyear==12
        load /data/Disturbance/input_processing/hansen_new_processing/lossyear/hansen_disturb_int_calc_1deg_lu_v4_lossyear12.mat
    elseif maxyear==10
        load /data/Disturbance/input_processing/hansen_new_processing/lossyear/hansen_disturb_int_calc_1deg_lu_v4_lossyear10.mat
    elseif maxyear==8
        load /data/Disturbance/input_processing/hansen_new_processing/lossyear/hansen_disturb_int_calc_1deg_lu_v4_lossyear8.mat
    elseif maxyear==6
        load /data/Disturbance/input_processing/hansen_new_processing/lossyear/hansen_disturb_int_calc_1deg_lu_v4_lossyear6.mat
    else
        error('maxyear is not one of 14, 12, 10, 8 or 6, or maxyear==14 and limityearrange==true')
    end
end

%---
%Now make disturbance rotation period calculations at the 1x1 degree level

%First calculate areas of 0.01 degree gridcells consistent with above
grid=0.01;
offset=grid/2;
lat_map=-89.995:grid:89.995;
basedist=circ_earth/(360/grid);
areag_001deg=NaN(length(lat_map),1);
for y=1:length(lat_map)
    areag_001deg(y)=basedist*basedist*cosd(lat_map(y)+offset); %m2
end
clear y basedist

%Calculate total forest area and loss area at 1 deg resolution, including
%estimation of uncertainties.

nbtstrp=1000; %Number of bootstrapped samples to take

totfareafrac_1deg_thres50=NaN(360,180);
totfarea_1deg_thres50=NaN(360,180);
totfareacan_1deg_thres50=NaN(360,180);
totloss_1deg_thres50=NaN(360,180);
totlosscan_1deg_thres50=NaN(360,180);
totloss_1deg_thres50_btstrp=NaN(360,180,nbtstrp);
totlosscan_1deg_thres50_btstrp=NaN(360,180,nbtstrp);
for ii=1:360
    for jj=1:180
        ii_s=(ii*100)-99;
        ii_e=ii*100;
        jj_s=(jj*100)-99;
        jj_e=jj*100;
        totfarea_001deg_ext=totfarea_001deg(ii_s:ii_e,jj_s:jj_e);
        totloss_001deg_ext=totloss_001deg(ii_s:ii_e,jj_s:jj_e);
        totlosscan_001deg_ext=totlosscan_001deg(ii_s:ii_e,jj_s:jj_e);
        areag_001deg_ext=repmat(areag_001deg(jj_s:jj_e)',100,1);
        
        %Identify 0.01 degree gridcells which meet our forest definition of 50%
        %canopy cover at this scale
        aa=find(totfarea_001deg_ext>=0.5);
        
        if ~isempty(aa)
            %Calculate total fraction of gridcells defined as forest at 0.01 degree (relative to 1 degree gridcell)
            totfareafrac_1deg_thres50(ii,jj)=length(aa)/(100^2);
            %Calculate total area in gridcells defined as forest at 0.01 degree
            totfarea_1deg_thres50(ii,jj)=sum(areag_001deg_ext(aa));
            %Calculate total canopy cover in gridcells defined as forest at 0.01 degree
            totfareacan_1deg_thres50(ii,jj)=sum(totfarea_001deg_ext(aa).*areag_001deg_ext(aa));
            %Calculate total area of 0.0001 degree pixels defined as experiencing stand-replacing forest loss
            %within the area defined as forest at 0.01 degree
            totloss_1deg_thres50(ii,jj)=sum(totloss_001deg_ext(aa).*areag_001deg_ext(aa));
            %Calculate total area of tree canopy lost due to stand-replacing disturbances within the area defined as forest at 0.01 degree
            totlosscan_1deg_thres50(ii,jj)=sum(totlosscan_001deg_ext(aa).*areag_001deg_ext(aa));
            
            %Now repeat all the above calculations but using bootstrapped sampling within the area defined as forest at 0.01 degree
            for bb=1:nbtstrp
                samp=datasample(aa,length(aa)); %Sample with replacement
                totloss_1deg_thres50_btstrp(ii,jj,bb)=sum(totloss_001deg_ext(samp).*areag_001deg_ext(samp));
                totlosscan_1deg_thres50_btstrp(ii,jj,bb)=sum(totlosscan_001deg_ext(samp).*areag_001deg_ext(samp));
            end
            clear bb samp
            
        end
        clear aa ii_s ii_e jj_s jj_e
    end
    if mod(ii,10)==0
        fprintf('Aggregated up to ii=%d\n',ii)
    end
end
clear ii jj
clear totfarea_001deg_ext totfarea_001deg_ext areag_001deg_ext totfarea_001deg_ext_frac

%Calculate the 95% confidence intervals on the bootstrapped results
totloss_1deg_thres50_lower=prctile(totloss_1deg_thres50_btstrp,2.5,3);
totloss_1deg_thres50_upper=prctile(totloss_1deg_thres50_btstrp,97.5,3);
totlosscan_1deg_thres50_lower=prctile(totlosscan_1deg_thres50_btstrp,2.5,3);
totlosscan_1deg_thres50_upper=prctile(totlosscan_1deg_thres50_btstrp,97.5,3);

%Now calculate the typical disturbance rotation period
if ~usecanarea
    %Defined relative to forest area at 0.01 degree resolution
    tau_d_1deg=1./((totloss_1deg_thres50./totfarea_1deg_thres50)/maxyear);
    tau_d_1deg_lower=1./((totloss_1deg_thres50_upper./totfarea_1deg_thres50)/maxyear);
    tau_d_1deg_upper=1./((totloss_1deg_thres50_lower./totfarea_1deg_thres50)/maxyear);
else
    %Defined relative to canopy area
    tau_d_1deg=1./((totlosscan_1deg_thres50./totfareacan_1deg_thres50)/maxyear);
    tau_d_1deg_lower=1./((totlosscan_1deg_thres50_upper./totfareacan_1deg_thres50)/maxyear);
    tau_d_1deg_upper=1./((totlosscan_1deg_thres50_lower./totfareacan_1deg_thres50)/maxyear);
end
tau_d_1deg(tau_d_1deg>1000)=1000; %Only interested in disturbance periods less than 1000 years. Anything longer classified as unreliable
tau_d_1deg_lower(tau_d_1deg_lower>1000)=1000;
tau_d_1deg_upper(tau_d_1deg_upper>1000)=1000;

%---
%Make a correction for land-use change based on ESA CCI landcover data

%Load the forest loss to land-use change between 2000 and 2014 as calculated with ESA_forest_loss_process.m
if maxyear==14 && limityearrange==false
    load /media/pughtam/rds-2017-pughtam-01/Disturbance/ESA_process/esa_forloss_1deg_cropgrassurb.mat
elseif maxyear==12
    load /media/pughtam/rds-2017-pughtam-01/Disturbance/ESA_process/esa_forloss_1deg_cropgrassurb_2012.mat
elseif maxyear==10
    load /media/pughtam/rds-2017-pughtam-01/Disturbance/ESA_process/esa_forloss_1deg_cropgrassurb_2010.mat
elseif maxyear==8
    load /media/pughtam/rds-2017-pughtam-01/Disturbance/ESA_process/esa_forloss_1deg_cropgrassurb_2008.mat
elseif maxyear==6
    load /media/pughtam/rds-2017-pughtam-01/Disturbance/ESA_process/esa_forloss_1deg_cropgrassurb_2006.mat
else
    error('maxyear is not one of 14, 12, 10, 8 or 6, or maxyear==14 and limityearrange==true')
end
esa_forloss_1deg=fliplr(esa_forloss_1deg');

%Central estimate
totloss_1deg_thres50_lucorr=totloss_1deg_thres50-esa_forloss_1deg;
totloss_1deg_thres50_lucorr(totloss_1deg_thres50_lucorr<0)=0;
totlosscan_1deg_thres50_lucorr=totlosscan_1deg_thres50-esa_forloss_1deg;
totlosscan_1deg_thres50_lucorr(totlosscan_1deg_thres50_lucorr<0)=0;

%Assuming uncertainty range of +/- 50%, sample between these bounds. Assume a gaussian distribution in the
%absence of further information.

esa_forloss_1deg_lower=esa_forloss_1deg*0.5;
esa_forloss_1deg_upper=esa_forloss_1deg*1.5;

nsamplu=1000;
rng(0,'twister'); %Initialise random number generator for repeatability
esa_forloss_area_lower_1deg=zeros(360,180);
esa_forloss_area_upper_1deg=zeros(360,180);
esa_forloss_area_distrib_1deg=zeros(360,180,nsamplu);
for ii=1:360
    for jj=1:180
        a=esa_forloss_1deg_lower(ii,jj);
        b=esa_forloss_1deg_upper(ii,jj);
        c=esa_forloss_1deg(ii,jj);
        r = ((b-a)/4).*randn(1000,1) + c; %Assume range encompasses 2 standard deviations
        esa_forloss_area_lower_1deg(ii,jj)=prctile(r,2.5);
        esa_forloss_area_upper_1deg(ii,jj)=prctile(r,97.5);
        esa_forloss_area_distrib_1deg(ii,jj,:)=r;
        clear a b r
    end
end
clear ii jj

%Error propagation based on brute force sampling
totloss_1deg_thres50_lucorr_crosscheck=NaN(360,180);
totloss_1deg_thres50_lower_lucorr=NaN(360,180);
totloss_1deg_thres50_upper_lucorr=NaN(360,180);
totlosscan_1deg_thres50_lucorr_crosscheck=NaN(360,180);
totlosscan_1deg_thres50_lower_lucorr=NaN(360,180);
totlosscan_1deg_thres50_upper_lucorr=NaN(360,180);
for ii=1:360
    for jj=1:180
        totfloss=squeeze(totloss_1deg_thres50_btstrp(ii,jj,:));
        totflosscan=squeeze(totlosscan_1deg_thres50_btstrp(ii,jj,:));
        lufloss=squeeze(esa_forloss_area_distrib_1deg(ii,jj,:));
        if nansum(totfloss(:))~=0 && nansum(totflosscan(:))~=0
            %Create square matix of possible outcomes based on the two samples
            err_matrix=repmat(totfloss,1,nsamplu)-repmat(lufloss',nbtstrp,1);
            err_matrix_can=repmat(totflosscan,1,nsamplu)-repmat(lufloss',nbtstrp,1);
            err_matrix(err_matrix<=0)=1; %Set to a very low value, but not zero to avoid NaNs later
            err_matrix_can(err_matrix_can<=0)=1;
            %Find the 95% confidence intervals
            totloss_1deg_thres50_lucorr_crosscheck(ii,jj)=prctile(err_matrix(:),50); %To cross-check with central estimate
            totloss_1deg_thres50_lower_lucorr(ii,jj)=prctile(err_matrix(:),2.5);
            totloss_1deg_thres50_upper_lucorr(ii,jj)=prctile(err_matrix(:),97.5);
            totlosscan_1deg_thres50_lucorr_crosscheck(ii,jj)=prctile(err_matrix_can(:),50); %To cross-check with central estimate
            totlosscan_1deg_thres50_lower_lucorr(ii,jj)=prctile(err_matrix_can(:),2.5);
            totlosscan_1deg_thres50_upper_lucorr(ii,jj)=prctile(err_matrix_can(:),97.5);
            clear R P
        end
    end
    if mod(ii,10)==0
        fprintf('Aggregated up to ii=%d\n',ii)
    end
end
clear ii jj totfloss lufloss err_matrix err_matrix_can

%Calculate the typical disturbance return period with the LU correction
if ~usecanarea
    tau_d_1deg_lucorr=1./((totloss_1deg_thres50_lucorr./totfarea_1deg_thres50)/maxyear); %Defined relative to forest area at 0.01 degree resolution
    tau_d_1deg_lucorr_lower=1./((totloss_1deg_thres50_upper_lucorr./totfarea_1deg_thres50)/maxyear);
    tau_d_1deg_lucorr_upper=1./((totloss_1deg_thres50_lower_lucorr./totfarea_1deg_thres50)/maxyear);
else
    tau_d_1deg_lucorr=1./((totlosscan_1deg_thres50_lucorr./totfareacan_1deg_thres50)/maxyear); %Defined relative to forest area at 0.01 degree resolution
    tau_d_1deg_lucorr_lower=1./((totlosscan_1deg_thres50_upper_lucorr./totfareacan_1deg_thres50)/maxyear);
    tau_d_1deg_lucorr_upper=1./((totlosscan_1deg_thres50_lower_lucorr./totfareacan_1deg_thres50)/maxyear);
end
tau_d_1deg_lucorr(tau_d_1deg_lucorr>1000)=1000; %Only interested in disturbance periods less than 1000 years. Anything longer is unreliable
tau_d_1deg_lucorr_lower(tau_d_1deg_lucorr_lower>1000)=1000;
tau_d_1deg_lucorr_upper(tau_d_1deg_lucorr_upper>1000)=1000;

%----
%Carry out forest masking
fmask_1deg=ncread('/data/Hansen_forest_change/hansen_forested_frac_1deg_thres50.nc4','forested_50_percent')';
forestmask=false(size(fmask_1deg'));
forestmask(fmask_1deg'>5)=true; %At least 5% cover of 50%-canopy-cover forest in gridcell
forestmaskhigh=false(size(fmask_1deg'));
forestmaskhigh(fmask_1deg'>25)=true; %At least 25% cover of 50%-canopy-cover forest in gridcell
clear fmask_1deg

tau_d_1deg_mask=tau_d_1deg;
tau_d_1deg_lower_mask=tau_d_1deg_lower;
tau_d_1deg_upper_mask=tau_d_1deg_upper;
tau_d_1deg_mask(~forestmask)=NaN;
tau_d_1deg_lower_mask(~forestmask)=NaN;
tau_d_1deg_upper_mask(~forestmask)=NaN;
tau_d_1deg_lucorr_mask=tau_d_1deg_lucorr;
tau_d_1deg_lucorr_lower_mask=tau_d_1deg_lucorr_lower;
tau_d_1deg_lucorr_upper_mask=tau_d_1deg_lucorr_upper;
tau_d_1deg_lucorr_mask(~forestmask)=NaN;
tau_d_1deg_lucorr_lower_mask(~forestmask)=NaN;
tau_d_1deg_lucorr_upper_mask(~forestmask)=NaN;

tau_d_1deg_maskhigh=tau_d_1deg;
tau_d_1deg_lower_maskhigh=tau_d_1deg_lower;
tau_d_1deg_upper_maskhigh=tau_d_1deg_upper;
tau_d_1deg_maskhigh(~forestmaskhigh)=NaN;
tau_d_1deg_lower_maskhigh(~forestmaskhigh)=NaN;
tau_d_1deg_upper_maskhigh(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_maskhigh=tau_d_1deg_lucorr;
tau_d_1deg_lucorr_lower_maskhigh=tau_d_1deg_lucorr_lower;
tau_d_1deg_lucorr_upper_maskhigh=tau_d_1deg_lucorr_upper;
tau_d_1deg_lucorr_maskhigh(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_lower_maskhigh(~forestmaskhigh)=NaN;
tau_d_1deg_lucorr_upper_maskhigh(~forestmaskhigh)=NaN;

%----

if makeplots
    %Basic map
    figure
    p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,log10(tau_d_1deg_lucorr_maskhigh'));
    set(p1,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    c1=colorbar;
    set(c1,'Ticks',log10([10 30 100 300 1000]))
    set(c1,'TickLabels',10.^get(c1,'Ticks'))
    caxis([1 3])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    
    %Map of relative uncertainty
    figure
    p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,((tau_d_1deg_lucorr_upper_maskhigh-tau_d_1deg_lucorr_lower_maskhigh)./tau_d_1deg_lucorr_maskhigh)');
    set(p1,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    c1=colorbar;
    caxis([0 1])
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
    
    %Check for whether ESA CCI forest conversion exceeds Landsat forest loss
    figure
    p1=pcolor(-180.0:1:179.0,-90.0:1:89.0,totloss_1deg_thres50'-esa_forloss_1deg');
    set(p1,'linestyle','none')
    load coast
    longn=[long;NaN]; latn=[lat;NaN]; %Add a NaN on the end of the arrays to avoid joining the first and last points of the coastlines
    patch(longn,latn,ones(length(longn),1));
    set(gca,'YLim',[-60 80])
    c1=colorbar;
    caxis([-1e9 1e9])
    colormap(redblue)
    set(gca,'XTick',[-120 -60 0 60 120],'XTickLabel','')
    set(gca,'YTick',[-60 -30 0 30 60],'YTickLabel','')
end

%----
%Nearest neighbour extrapolation in gridcells beyond the range of the maskhigh mask (25% closed-canopy forest cover)
%To be used for LPJ-GUESS input

tau_d_1deg_lucorr_maskhigh_fill=tau_d_1deg_lucorr_maskhigh;
tau_d_1deg_lucorr_lower_maskhigh_fill=tau_d_1deg_lucorr_lower_maskhigh;
tau_d_1deg_lucorr_upper_maskhigh_fill=tau_d_1deg_lucorr_upper_maskhigh;
nansleft=length(find(isnan(tau_d_1deg_lucorr_maskhigh_fill)==1));
while nansleft>1075 %1075 is number of cells around the edge which we don't fill
    temp=tau_d_1deg_lucorr_maskhigh_fill;
    temp_lower=tau_d_1deg_lucorr_lower_maskhigh_fill;
    temp_upper=tau_d_1deg_lucorr_upper_maskhigh_fill;
    
    for ii=2:359
        for jj=2:179
            if isnan(tau_d_1deg_lucorr_maskhigh_fill(ii,jj))==1
                temp_ext=temp(ii-1:ii+1,jj-1:jj+1);
                tau_d_1deg_lucorr_maskhigh_fill(ii,jj)=nanmean(temp_ext(:));
                temp_lower_ext=temp_lower(ii-1:ii+1,jj-1:jj+1);
                tau_d_1deg_lucorr_lower_maskhigh_fill(ii,jj)=nanmean(temp_lower_ext(:));
                temp_upper_ext=temp_upper(ii-1:ii+1,jj-1:jj+1);
                tau_d_1deg_lucorr_upper_maskhigh_fill(ii,jj)=nanmean(temp_upper_ext(:));
            end
        end
    end
    nansleft=length(find(isnan(tau_d_1deg_lucorr_maskhigh_fill)==1));
    fprintf('nansleft = %d\n',nansleft)
end
clear ii jj nansleft temp temp_lower temp_upper temp_ext temp_lower_ext temp_upper_ext

%Now mask filled cells to 5% mask
tau_d_1deg_lucorr_maskhigh_fill=tau_d_1deg_lucorr_maskhigh_fill.*forestmask;
tau_d_1deg_lucorr_lower_maskhigh_fill=tau_d_1deg_lucorr_lower_maskhigh_fill.*forestmask;
tau_d_1deg_lucorr_upper_maskhigh_fill=tau_d_1deg_lucorr_upper_maskhigh_fill.*forestmask;
tau_d_1deg_lucorr_maskhigh_fill(tau_d_1deg_lucorr_maskhigh_fill==0)=NaN;
tau_d_1deg_lucorr_lower_maskhigh_fill(tau_d_1deg_lucorr_lower_maskhigh_fill==0)=NaN;
tau_d_1deg_lucorr_upper_maskhigh_fill(tau_d_1deg_lucorr_upper_maskhigh_fill==0)=NaN;

%----
%Save key arrays to *.mat files

if ~usecanarea
    save -v7.3 hansen_disturb_int_calc_1deg_lu_v4_lossyear6_outarrays.mat tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
        tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
        tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh tau_d_1deg_lucorr_maskhigh tau_d_1deg_lucorr_lower_maskhigh tau_d_1deg_lucorr_upper_maskhigh esa_forloss_1deg...
        esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
        totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
else
    save -v7.3 hansen_disturb_int_calc_1deg_lu_canarea_v4_lossyear6_outarrays.mat tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
        tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
        tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh tau_d_1deg_lucorr_maskhigh tau_d_1deg_lucorr_lower_maskhigh tau_d_1deg_lucorr_upper_maskhigh esa_forloss_1deg...
        esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
        totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_upper
end

%----
if writeoutput
    %Output to text file for LPJ-GUESS input
    %Use 5% filled mask output to give the maximum range for the LPJ-GUESS input file (i.e. increase flexibility in
    %processing later)
    
    %Resample to 0.5 degrees
    tau_d_1deg_lucorr_mask_05=NaN(720,360);
    tau_d_1deg_lucorr_lower_mask_05=NaN(720,360);
    tau_d_1deg_lucorr_upper_mask_05=NaN(720,360);
    for xx=1:720
        for yy=1:360
            xx_c=round(xx/2);
            yy_c=round(yy/2);
            tau_d_1deg_lucorr_mask_05(xx,yy)=tau_d_1deg_lucorr_maskhigh_fill(xx_c,yy_c);
            tau_d_1deg_lucorr_lower_mask_05(xx,yy)=tau_d_1deg_lucorr_lower_maskhigh_fill(xx_c,yy_c);
            tau_d_1deg_lucorr_upper_mask_05(xx,yy)=tau_d_1deg_lucorr_upper_maskhigh_fill(xx_c,yy_c);
            clear xx_c yy_c
        end
        clear yy
    end
    clear xx
    
    tau_d_1deg_lucorr_mask_05_int=int16(tau_d_1deg_lucorr_mask_05');
    tau_d_1deg_lucorr_lower_mask_05_int=int16(tau_d_1deg_lucorr_lower_mask_05');
    tau_d_1deg_lucorr_upper_mask_05_int=int16(tau_d_1deg_lucorr_upper_mask_05');
    
    [lons,lats]=meshgrid(-179.75:0.5:179.75,-89.75:0.5:89.75);
    
    ngrid=length(tau_d_1deg_lucorr_mask_05_int(tau_d_1deg_lucorr_mask_05_int>0));
    
    %Now linearise the arrayxx
    lon_out=NaN(ngrid,1);
    lat_out=NaN(ngrid,1);
    tau_d_1deg_lucorr_mask_05_int_out=NaN(ngrid,1);
    tau_d_1deg_lucorr_lower_mask_05_int_out=NaN(ngrid,1);
    tau_d_1deg_lucorr_upper_mask_05_int_out=NaN(ngrid,1);
    nn=0;
    for xx=1:720
        for yy=1:360
            if tau_d_1deg_lucorr_mask_05_int(yy,xx)>0
                nn=nn+1;
                lon_out(nn)=lons(yy,xx);
                lat_out(nn)=lats(yy,xx);
                tau_d_1deg_lucorr_mask_05_int_out(nn)=tau_d_1deg_lucorr_mask_05_int(yy,xx);
                tau_d_1deg_lucorr_lower_mask_05_int_out(nn)=tau_d_1deg_lucorr_lower_mask_05_int(yy,xx);
                tau_d_1deg_lucorr_upper_mask_05_int_out(nn)=tau_d_1deg_lucorr_upper_mask_05_int(yy,xx);
            end
        end
        clear yy
    end
    clear xx
    
    %Write out to text files
       
    format_out='%7.2f %7.2f %5d\n';
    
    fid_out=fopen(file_out,'w');
    fprintf(fid_out,'Lon    Lat    Return\n');
    for nn=1:ngrid
        if ~isnan(tau_d_1deg_lucorr_mask_05_int_out(nn))
            fprintf(fid_out,format_out,lon_out(nn),lat_out(nn),tau_d_1deg_lucorr_mask_05_int_out(nn));
        end
    end
    clear nn
    fclose(fid_out);
    
    fid_out=fopen(file_lower_out,'w');
    fprintf(fid_out,'Lon    Lat    Return\n');
    for nn=1:ngrid
        if ~isnan(tau_d_1deg_lucorr_lower_mask_05_int_out(nn))
            fprintf(fid_out,format_out,lon_out(nn),lat_out(nn),tau_d_1deg_lucorr_lower_mask_05_int_out(nn));
        end
    end
    clear nn
    fclose(fid_out);
    
    fid_out=fopen(file_upper_out,'w');
    fprintf(fid_out,'Lon    Lat    Return\n');
    for nn=1:ngrid
        if ~isnan(tau_d_1deg_lucorr_upper_mask_05_int_out(nn))
            fprintf(fid_out,format_out,lon_out(nn),lat_out(nn),tau_d_1deg_lucorr_upper_mask_05_int_out(nn));
        end
    end
    clear nn
    fclose(fid_out);
    
end
