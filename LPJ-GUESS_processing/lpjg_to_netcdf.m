%Write netcdf files for all uptake data underlying manuscript figures for data deposition.
%The basis is tslice files from LPJ-GUESS which give means over the years 2001-2014.
%
%Dependencies: write_netcdf_lpjg.m
%
%T. Pugh
%26.04.19

addpath('/data/Disturbance/netcdf_conversion_scripts')

input_dir='/media/pughtam/rds-2017-pughtam-treemort/';
output_dir='/home/adf/pughtam/data/Disturbance/netcdfs_for_deposition/lpjg/';

sims={'hansen_esaLUcorr_p100','hansen_esaLUcorr_p100_0_5x','100flat',...
    'hansen_esaLUcorr_p10','hansen_esaLUcorr_lower_p10','hansen_esaLUcorr_upper_p10',...
    'hansen_esaLUcorr_p10_0_25x','hansen_esaLUcorr_p10_0_5x','hansen_esaLUcorr_p10_2x','hansen_esaLUcorr_p10_4x',...
    'hansen_esaLUcorr_p10_0_25x_fire','hansen_esaLUcorr_p10_0_5x_fire','hansen_esaLUcorr_p10_fire','hansen_esaLUcorr_p10_2x_fire','hansen_esaLUcorr_p10_4x_fire',...
    'hansen_esaLUcorr_p10_0_25x_harv','hansen_esaLUcorr_p10_0_5x_harv','hansen_esaLUcorr_p10_harv','hansen_esaLUcorr_p10_2x_harv','hansen_esaLUcorr_p10_4x_harv'};
dmult={'1x','0p5x','1x',...
    '1x','1x','1x',...
    '0p25x','0p5x','2x','4x',...
    '0p25x','0p5x','1x','2x','4x',...
    '0p25x','0p5x','1x','2x','4x'};
dtype={'dist2litter','dist2litter','default',...
    'dist2litter','dist2litter','dist2litter'...
    'dist2litter','dist2litter','dist2litter','dist2litter',...
    'fire','fire','fire','fire','fire',...
    'harv','harv','harv','harv','harv'};
dreal={'standard','standard','100yplusfire',...
    'standard','2p5percconf','97p5percconf',...
    'standard','standard','standard','standard',...
    'standard','standard','standard','standard','standard',...
    'standard','standard','standard','standard','standard'};
dpatch=[100,100,100,...
    10,10,10,...
    10,10,10,10,...
    10,10,10,10,10,...
    10,10,10,10,10];
nsims=length(sims);

if (length(dmult)~=nsims || length(dtype)~=nsims || length(dreal)~=nsims)
    error('Arrays describing simulations are not consistent in length')
end

%First write files for the simulations with age forcing for the full period
for ss=1:nsims
    
    currdir=[input_dir,'/',sims{ss},'/postproc/'];
    
    cd(currdir)
    
    %Get cpool data
    cpool=squeeze(lpj_to_grid_func_centre('cpool_2001_2014',1,0));
    cveg=cpool(:,:,1);
    csoil=cpool(:,:,3);
    clitter=cpool(:,:,2);
    clear cpool
    
    %Get cflux data
    cflux=squeeze(lpj_to_grid_func_centre('cflux_2001_2014',1,0));
    dmortc=cflux(:,:,14); %Disturbance mortality turnover
    omortc=nansum(cflux(:,:,6:13),3); %Other mortality turnover
    lmortc=cflux(:,:,16); %Leaf turnover
    rmortc=cflux(:,:,15); %Root turnover
    reproc=cflux(:,:,2); %Reproduction turnover
    clear cflux
    
    %Get FPC data
    fpc=squeeze(lpj_to_grid_func_centre('fpc_2001_2014',1,0));
    fpc_tree=nansum(fpc(:,:,1:10),3);
    fpc_tot=fpc(:,:,13);
    fpc_grass=fpc_tot-fpc_tree;
    clear fpc fpc_tot
    
    %Write each dataset to netcdf file
    
    %Cveg
    variable='Cveg';
    variable_longname='Carbon stock in live vegetation';
    units='kg C m-2';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(cveg,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Csoil
    variable='Csoil';
    variable_longname='Carbon stock in soil';
    units='kg C m-2';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(csoil,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Clitter
    variable='Clitter';
    variable_longname='Carbon stock in litter';
    units='kg C m-2';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(clitter,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Carbon turnover due to disturbance mortality
    variable='TdistC';
    variable_longname='Carbon turnover due to disturbance mortality';
    units='kg C m-2 yr-1';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(dmortc,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Carbon turnover due to non-disturbance mortality
    variable='TmortC';
    variable_longname='Carbon turnover due to non-disturbance mortality';
    units='kg C m-2 yr-1';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(omortc,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Carbon turnover due to leaf phenology
    variable='TleafC';
    variable_longname='Carbon turnover due to leaf phenology';
    units='kg C m-2 yr-1';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(lmortc,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Carbon turnover due to root phenology
    variable='TrootC';
    variable_longname='Carbon turnover due to root phenology';
    units='kg C m-2 yr-1';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(rmortc,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Carbon turnover due to reproduction
    variable='TreproC';
    variable_longname='Carbon turnover due to reproduction';
    units='kg C m-2 yr-1';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(reproc,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Sum of fractional projective cover of tree PFTs
    variable='fpc_tree';
    variable_longname='Sum of fractional projective cover of tree PFTs';
    units='Fraction of ground area';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(fpc_tree,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
    %Sum of fractional projective cover of grass PFTs
    variable='fpc_grass';
    variable_longname='Sum of fractional projective cover of grass PFTs';
    units='Fraction of ground area';
    disttype=dtype{ss};
    distmulti=dmult{ss};
    realisation=dreal{ss};
    npatch=dpatch(ss);
    modname='LPJ-GUESS';
    year=2014;
    note1='This data is the mean over the period 2001-2014, the year variable in this file is nominal';
    
    write_netcdf_lpjg(fpc_grass,variable,modname,disttype,distmulti,realisation,npatch,year,...
        units,variable_longname,output_dir,note1);
    
end
clear ss
