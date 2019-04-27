%Calculate vulnerability of biomass in different biomes to changes in tau
%based on two LPJ-GUESS simulations.
%
%Dependencies:
% - lpj_to_grid_func_centre.m
% - distforfrachan.m
% - esa_forest_9regions_new_1deg_func.m
%
%T. Pugh
%03.08.18

datafol='/Users/pughtam/Documents/GAP_work/Disturbance/netcdfs_for_deposition/';
intdatafol='/Users/pughtam/Documents/GAP_work/Disturbance/intermediate_processing/';

cveg_1x_file='Cveg_LPJ-GUESS_standard_dist2litter_1x_p100.nc';
cveg_0_5x_file='Cveg_LPJ-GUESS_standard_dist2litter_0p5x_p100.nc';

fpc_tree_1x_file='fpc_tree_LPJ-GUESS_standard_dist2litter_1x_p100.nc';
fpc_grass_1x_file='fpc_grass_LPJ-GUESS_standard_dist2litter_1x_p100.nc';

distfile='tau_d_hansen_LUcorr_5perc_esacorr_filled.txt';

addpath('/data/ESA_landcover')

%---
minlat=-90.0;
maxlat=89.5;
minlon=-180.0;
maxlon=179.5;
gridsize=1;
lonc=minlon:gridsize:maxlon;
latc=minlat:gridsize:maxlat;

%Read biomass data
cveg_1x=ncread([datafol,'/lpjg/',cveg_1x_file],'Cveg')';
cveg_0_5x=ncread([datafol,'/lpjg/',cveg_0_5x_file],'Cveg')';

%Read disturbance data
cdist_1x=lpj_to_grid_func_centre([intdatafol,'/',distfile],1,0);

%Mask data to forested area
[maskarea]=distforfrachan([datafol,'/lpjg/',fpc_tree_1x_file],[datafol,'/lpjg/',fpc_grass_1x_file]);
cveg_1x=cveg_1x.*maskarea;
cveg_0_5x=cveg_0_5x.*maskarea;
cdist_1x=cdist_1x.*maskarea;

%Aggregate to 1 degree (to increase effective patch number and make consistent with disturbance information resolution)
cveg_1x_1deg=NaN(180,360);
cveg_0_5x_1deg=NaN(180,360);
cdist_1x_1deg=NaN(180,360);
for xx=1:360
    for yy=1:180
        ind_x=(xx*2)-1;
        ind_y=(yy*2)-1;
        
        temp_1x=cveg_1x(ind_y:ind_y+1,ind_x:ind_x+1);
        temp_0_5x=cveg_0_5x(ind_y:ind_y+1,ind_x:ind_x+1);
        tempdist_1x=cdist_1x(ind_y:ind_y+1,ind_x:ind_x+1);
        cveg_1x_1deg(yy,xx)=nanmean(temp_1x(:));
        cveg_0_5x_1deg(yy,xx)=nanmean(temp_0_5x(:));
        cdist_1x_1deg(yy,xx)=nanmean(tempdist_1x(:));
        clear temp_1x temp_0_5x
        clear ind_x ind_y
    end
    clear yy
end
clear xx

%If doubling disturbance reduces Cveg below a threshold fraction of its
%original value mark it as such

cveg_reduc_frac=cveg_0_5x_1deg./cveg_1x_1deg; %Relative

%Remove NaN values ready for scatter plots
nanvals=find(isnan(cdist_1x_1deg(:))==0 & isnan(cveg_reduc_frac(:))==0 & cdist_1x_1deg(:)>0);

xxx=cdist_1x_1deg(nanvals);
yyy=-(1-cveg_reduc_frac(nanvals))*100; %Convert to a percentage loss

%---
%Make scatter plot by biome
[rmask,regions,nregion]=esa_forest_9regions_new_1deg_func(false);
rrr=rmask(nanvals);

%---
%Version 1: Subplot for each forest type, bootstrapping for each line.
pool1=parpool(7);

nboot=1000;
x=50:1000;
nbootsamp=NaN(nregion,1);
yyy_prc2_5=NaN(nregion,length(x));
yyy_prc97_5=NaN(nregion,length(x));
yyy_best=NaN(nregion,length(x));
parfor bb=1:nregion
    if bb==3 || bb==9; continue; end
    xxx_s=xxx(rrr==bb);
    yyy_s=yyy(rrr==bb);
    nbootsamp(bb)=floor(length(xxx_s));
    ff=fit(xxx_s,yyy_s,'exp2');
    ci=coeffvalues(ff);
    coeffs=NaN(nboot,4);
    yyy_out=NaN(nboot,length(x));
    for nn=1:nboot
        booti=randi(nbootsamp(bb),nbootsamp(bb),1);
        xxx_sb=xxx_s(booti);
        yyy_sb=yyy_s(booti);
        ffs=fit(xxx_sb,yyy_sb,'exp2');
        coeffs(nn,:)=coeffvalues(ffs);
        yyy_out(nn,:)=ffs.a*exp(ffs.b*x) + ffs.c*exp(ffs.d*x);
    end
    yyy_prc2_5(bb,:)=prctile(yyy_out,2.5,1);
    yyy_prc97_5(bb,:)=prctile(yyy_out,97.5,1);
    yyy_best(bb,:)=ff.a*exp(ff.b*x) + ff.c*exp(ff.d*x);
end
clear bb
delete(pool1)

figlabels={'a','b','c','d','e','f','g','h','i'};
figure
nn=0;
for bb=1:nregion
    if bb==3 || bb==9; continue; end %Skip these biomes which have few data points
    nn=nn+1;
    ss(nn)=subplot(3,3,nn);
    hold on
    p1=plot(xxx(rrr==bb),yyy(rrr==bb),'.','color',[0.6 0.6 0.6]);
    p2=plot(x,yyy_best(bb,:));
    p3=plot(x,yyy_prc2_5(bb,:));
    p4=plot(x,yyy_prc97_5(bb,:));
    set(p2,'color','k','linewidth',2);
    set(p3,'color','k','linestyle','--');
    set(p4,'color','k','linestyle','--');
    title(['(',figlabels{nn},') ',regions{bb}])
        
    set(gca,'YLim',[-50 10])
    grid on
    
    set(gca,'XTick','','XTickLabel','')
    set(gca,'YTick','','YTickLabel','')
    if nn==7 || nn==5 || nn==6
        xlabel('\tau_{O} (years)')
        set(gca,'XTick',0:200:1000,'XTickLabel',0:200:1000)
    end
    if nn==1 || nn==4 || nn==7
        ylabel('Biomass difference (%)')
        set(gca,'YTick',-50:10:10,'YTickLabel',-50:10:10)
    end
end
clear bb nn
set(ss(1),'Position',[0.1 0.7 0.25 0.25])
set(ss(2),'Position',[0.4 0.7 0.25 0.25])
set(ss(3),'Position',[0.7 0.7 0.25 0.25])
set(ss(4),'Position',[0.1 0.4 0.25 0.25])
set(ss(5),'Position',[0.4 0.4 0.25 0.25])
set(ss(6),'Position',[0.7 0.4 0.25 0.25])
set(ss(7),'Position',[0.1 0.1 0.25 0.25])
clear ss

%Find point of line intersection
x_thres90=NaN(nregion,1);
x_thres90_prc2_5=NaN(nregion,1);
x_thres90_prc97_5=NaN(nregion,1);
x_thres80=NaN(nregion,1);
x_thres80_prc2_5=NaN(nregion,1);
x_thres80_prc97_5=NaN(nregion,1);
for nn=1:nregion
    if nn==3 || nn==9; continue; end %Skip these biomes which have few data points
    %Best fit line, tau_crit,90
    yyy_reg=yyy_best(nn,:);
    yyy_reg_thres90=yyy_reg+10;
    thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
    x_thres90(nn)=x(thres90_ind);
    clear yyy_reg yyy_reg_thres90 thres90_ind
    %2.5th percentile, tau_crit,90
    yyy_reg=yyy_prc2_5(nn,:);
    yyy_reg_thres90=yyy_reg+10;
    thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
    x_thres90_prc2_5(nn)=x(thres90_ind);
    clear yyy_reg yyy_reg_thres90 thres90_ind
    %97.5th percentile, tau_crit,90
    yyy_reg=yyy_prc97_5(nn,:);
    yyy_reg_thres90=yyy_reg+10;
    thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
    x_thres90_prc97_5(nn)=x(thres90_ind);
    clear yyy_reg yyy_reg_thres90 thres90_ind
    
    %Best fit line, tau_crit,80
    yyy_reg=yyy_best(nn,:);
    yyy_reg_thres80=yyy_reg+20;
    thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
    x_thres80(nn)=x(thres80_ind);
    clear yyy_reg yyy_reg_thres80 thres80_ind
    %2.5th percentile, tau_crit,80
    yyy_reg=yyy_prc2_5(nn,:);
    yyy_reg_thres80=yyy_reg+20;
    thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
    x_thres80_prc2_5(nn)=x(thres80_ind);
    clear yyy_reg yyy_reg_thres80 thres80_ind
    %97.5th percentile, tau_crit,80
    yyy_reg=yyy_prc97_5(nn,:);
    yyy_reg_thres80=yyy_reg+20;
    thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
    x_thres80_prc97_5(nn)=x(thres80_ind);
    clear yyy_reg yyy_reg_thres80 thres80_ind
end
clear nn

fprintf('tau_{crit,90}\n')
fprintf('Region,Best, 97.5th, 2.5th\n')
for nn=1:nregion
    fprintf('%s %d %d %d\n',regions{nn},x_thres90(nn),x_thres90_prc97_5(nn),x_thres90_prc2_5(nn))
end

fprintf('tau_{crit,80}\n')
fprintf('Region,Best, 97.5th, 2.5th\n')
for nn=1:nregion
    fprintf('%s %d %d %d\n',regions{nn},x_thres80(nn),x_thres80_prc97_5(nn),x_thres80_prc2_5(nn))
end

%---
%Version 2: All forest types on one plot, bootstrapping only for overall line
nboot=1000;
nbootsamp=length(xxx);
x=50:1000;

figure
hold on
plot(xxx,yyy,'.','color',[0.6 0.6 0.6])
for bb=1:nregion
    if bb==3 || bb==9; continue; end %Skip these biomes which have few data points
    ff=fit(xxx(rrr==bb),yyy(rrr==bb),'exp2');
    p1=plot(ff,xxx(rrr==bb),yyy(rrr==bb));
    set(p1(1),'XData',[],'YData',[])
    set(p1(2),'color',[0.2 0.5 1],'linewidth',2);
    hasbehavior(p1(1),'legend',false)
    if bb>1
        hasbehavior(p1(2),'legend',false)
    end
end
clear bb
ff=fit(xxx,yyy,'exp2');
yyy_best=ff.a*exp(ff.b*x) + ff.c*exp(ff.d*x);
p1=plot(ff,xxx,yyy);
coeffs=NaN(nboot,4);
yyy_out=NaN(nboot,length(x));
for nn=1:nboot
    booti=randi(nbootsamp,nbootsamp,1);
    xxx_b=xxx(booti);
    yyy_b=yyy(booti);
    ffs=fit(xxx_b,yyy_b,'exp2');
    coeffs(nn,:)=coeffvalues(ffs);
    yyy_out(nn,:)=ffs.a*exp(ffs.b*x) + ffs.c*exp(ffs.d*x);
end
clear nn
yyy_prc2_5=prctile(yyy_out,2.5,1);
yyy_prc97_5=prctile(yyy_out,97.5,1);

p3=plot(x,yyy_prc2_5);
p4=plot(x,yyy_prc97_5);

set(p1(1),'XData',[],'YData',[])
hasbehavior(p1(1),'legend',false)
set(p1(2),'color','k','linewidth',4);
set(p3,'color','k','linestyle','--');
set(p4,'color','k','linestyle','--');
set(gca,'YLim',[-50 10])
xlabel('\tau_{O} (years)')
ylabel('Biomass difference (%)')
legend off
grid on
legend('Indiv. grid cell','Forest type fit','Global fit')

%Find point of line intersection
%Best fit line, tau_crit,90
yyy_reg_thres90=yyy_best+10;
thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
x_thres90_g=x(thres90_ind);
clear yyy_reg yyy_reg_thres90 thres90_ind
%2.5th percentile, tau_crit,90
yyy_reg_thres90=yyy_prc2_5+10;
thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
x_thres90_prc2_5_g=x(thres90_ind);
clear yyy_reg yyy_reg_thres90 thres90_ind
%97.5th percentile, tau_crit,90
yyy_reg_thres90=yyy_prc97_5+10;
thres90_ind=find(abs(yyy_reg_thres90)==min(abs(yyy_reg_thres90)));
x_thres90_prc97_5_g=x(thres90_ind);
clear yyy_reg yyy_reg_thres90 thres90_ind

%Best fit line, tau_crit,80
yyy_reg_thres80=yyy_best+20;
thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
x_thres80_g=x(thres80_ind);
clear yyy_reg yyy_reg_thres80 thres80_ind
%2.5th percentile, tau_crit,80
yyy_reg_thres80=yyy_prc2_5+20;
thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
x_thres80_prc2_5_g=x(thres80_ind);
clear yyy_reg yyy_reg_thres80 thres80_ind
%97.5th percentile, tau_crit,80
yyy_reg_thres80=yyy_prc97_5+20;
thres80_ind=find(abs(yyy_reg_thres80)==min(abs(yyy_reg_thres80)));
x_thres80_prc97_5_g=x(thres80_ind);
clear yyy_reg yyy_reg_thres80 thres80_ind

fprintf('tau_{crit,90}\n')
fprintf('Best, 97.5th, 2.5th\n')
fprintf('%d %d %d\n',x_thres90_g,x_thres90_prc97_5_g,x_thres90_prc2_5_g)

fprintf('tau_{crit,80}\n')
fprintf('Best, 97.5th, 2.5th\n')
fprintf('%d %d %d\n',x_thres80_g,x_thres80_prc97_5_g,x_thres80_prc2_5_g)
