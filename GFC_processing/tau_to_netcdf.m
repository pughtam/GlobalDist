%Write the values of Disturbance rotation period (observation-based) to netcdf files for archiving.
%
%Dependencies: write_netcdf_tau.m
%
%T. Pugh
%26.04.19

%Load the relevant Hansen tau data from a mat file calculated with
%hansen_disturb_int_calc_1deg_lu_v4_lossyear.m

%First the forest-area based data
load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_uppercd tau_d_1deg_lucorr_mask totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh_forarea=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh_forarea=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh_forarea=tau_d_1deg_lucorr_upper_maskhigh';
tau_d_1deg_maskhigh_forarea=tau_d_1deg_maskhigh';
clear tau_d_1deg_lucorr_maskhigh tau_d_1deg_lucorr_lower_maskhigh tau_d_1deg_lucorr_upper_maskhigh tau_d_1deg_maskhigh

%Then the canopy-area based data
load /data/Disturbance/input_processing/hansen_new_processing/hansen_disturb_int_calc_1deg_lu_canarea_v4_outarrays.mat
clear tau_d_1deg_lucorr_maskhigh_fill tau_d_1deg_lucorr_lower_maskhigh_fill tau_d_1deg_lucorr_upper_maskhigh_fill...
tau_d_1deg_mask tau_d_1deg_lower_mask tau_d_1deg_upper_mask tau_d_1deg_lucorr_lower_mask tau_d_1deg_lucorr_upper_mask tau_d_1deg_maskhigh...
tau_d_1deg_lower_maskhigh tau_d_1deg_upper_maskhigh esa_forloss_1deg...
esa_forloss_area_lower_1deg esa_forloss_area_upper_1deg totloss_1deg_thres50 totloss_1deg_thres50_lower totloss_1deg_thres50_upper totlosscan_1deg_thres50...
totlosscan_1deg_thres50_lower totlosscan_1deg_thres50_uppercd tau_d_1deg_lucorr_mask totlosscan_1deg_thres50_upper
tau_d_1deg_lucorr_maskhigh_canarea=tau_d_1deg_lucorr_maskhigh';
tau_d_1deg_lucorr_lower_maskhigh_canarea=tau_d_1deg_lucorr_lower_maskhigh';
tau_d_1deg_lucorr_upper_maskhigh_canarea=tau_d_1deg_lucorr_upper_maskhigh';
clear tau_d_1deg_lucorr_maskhigh tau_d_1deg_lucorr_lower_maskhigh tau_d_1deg_lucorr_upper_maskhigh

%Write out to netcdfs

output_dir='/home/adf/pughtam/data/Disturbance/netcdf_conversion_scripts/';

%Tau_O
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='standard';
method='forest-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This forest-area based definition is that standard one used in the accompanying paper';
data=tau_d_1deg_lucorr_maskhigh_forarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O 2.5th percentile
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='2p5percconf';
method='forest-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This forest-area based definition is that standard one used in the accompanying paper';
data=tau_d_1deg_lucorr_lower_maskhigh_forarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O 97.5th percentile
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='97p5percconf';
method='forest-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This forest-area based definition is that standard one used in the accompanying paper';
data=tau_d_1deg_lucorr_upper_maskhigh_forarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O not LU corrected
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='standard';
method='forest-area';
correction='noLUcorrection';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, year variable assignment in this file is nominal';
note2='Original data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='This file is without a land-use change correction. Use not recommended except to see the influence of the correction.';
note4='';
data=tau_d_1deg_maskhigh_forarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O canopy area
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='standard';
method='canopy-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This canopy-area based definition is an alternative approach to the forest-area definition which is the standard in the accompanying paper';
data=tau_d_1deg_lucorr_maskhigh_canarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O canopy area 2.5th percentile
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='2p5percconf';
method='canopy-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This canopy-area based definition is an alternative approach to the forest-area definition which is the standard in the accompanying paper';
data=tau_d_1deg_lucorr_lower_maskhigh_canarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)

%Tau_O canopy area 97.5th percentile
variable='tauO';
variable_longname='Disturbance rotation period (observation-based)';
units='years';
realisation='97p5percconf';
method='canopy-area';
correction='LUcorrected';
year=2014;
note1='This dataset is based on Global Forest Change data v1.2 covering 2001-2014, and ESA CCI landcover v2.0.7, year variable assignment in this file is nominal';
note2='Original GFC data at https://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.2.html';
note3='Original ESA data at http://maps.elie.ucl.ac.be/CCI/viewer';
note4='This canopy-area based definition is an alternative approach to the forest-area definition which is the standard in the accompanying paper';
data=tau_d_1deg_lucorr_upper_maskhigh_canarea;

write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)
