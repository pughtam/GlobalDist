%Script to make line plots of how vegetation and soil C change with disturbance rotation period,
%including shading to take account of uncertainty from disturbance type.
%
%Dependencies:
% - values from dist_vul_sim_v2.m (entered below)
% - cpool_esa_func_recovsplit_v5.m
%
%T. Pugh
%12.09.18

calcmean=true; %Calculate mean instead of total per biome

addpath('/data/ESA_landcover')

%Values for tau threshold calculated by biome using dist_vul_sim_v2.m
%For OTr and Other, adopt the range across the biomes from the global fit as the
%uncertainty
tau_thres_90=[594 523 444 289 426 417 323 406 444];
tau_thres_80=[289 218 206 125 96 203 178 187 206];

%---
%Simulations with disturbed material going to litter
base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_25x/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_0_25x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_0_25x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_0_25x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_0_25x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_0_25x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_0_25x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_0_25x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_0_25x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_0_25x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_0_25x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_0_25x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_0_25x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_5x/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_0_5x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_0_5x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_0_5x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_0_5x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_0_5x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_0_5x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_0_5x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_0_5x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_0_5x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_0_5x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_0_5x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_0_5x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_1x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_1x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_1x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_1x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_1x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_1x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_1x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_1x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_1x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_1x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_1x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_1x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_2x/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_2x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_2x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_2x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_2x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_2x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_2x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_2x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_2x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_2x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_2x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_2x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_2x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_4x/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_4x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_4x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_4x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_4x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_4x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_4x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_4x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_4x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_4x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_4x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_4x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_4x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

clear vegc_tot_reg_dlow vegc_tot_dlow soilc_tot_reg_dlow soilc_tot_dlow ...
    vegc_tot_reg_dmid vegc_tot_dmid soilc_tot_reg_dmid soilc_tot_dmid ...
    vegc_tot_reg_dhigh vegc_tot_dhigh soilc_tot_reg_dhigh soilc_tot_dhigh ...
    vegc_tot_reg_std_dlow vegc_tot_std_dlow soilc_tot_reg_std_dlow soilc_tot_std_dlow ...
    vegc_tot_reg_std_dmid vegc_tot_std_dmid soilc_tot_reg_std_dmid soilc_tot_std_dmid ...
    vegc_tot_reg_std_dhigh vegc_tot_std_dhigh soilc_tot_reg_std_dhigh soilc_tot_std_dhigh ...
    vegc soilc N_reg_dlow_sum N_reg_dmid_sum N_reg_dhigh_sum

%Simulations with disturbed material burnt
base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_25x_fire/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_fire_0_25x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_fire_0_25x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_fire_0_25x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_fire_0_25x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_fire_0_25x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_fire_0_25x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_fire_0_25x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_fire_0_25x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_fire_0_25x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_fire_0_25x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_fire_0_25x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_fire_0_25x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_5x_fire/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_fire_0_5x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_fire_0_5x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_fire_0_5x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_fire_0_5x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_fire_0_5x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_fire_0_5x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_fire_0_5x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_fire_0_5x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_fire_0_5x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_fire_0_5x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_fire_0_5x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_fire_0_5x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_fire/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_fire_1x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_fire_1x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_fire_1x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_fire_1x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_fire_1x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_fire_1x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_fire_1x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_fire_1x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_fire_1x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_fire_1x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_fire_1x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_fire_1x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_2x_fire/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_fire_2x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_fire_2x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_fire_2x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_fire_2x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_fire_2x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_fire_2x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_fire_2x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_fire_2x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_fire_2x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_fire_2x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_fire_2x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_fire_2x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_4x_fire/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_fire_4x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_fire_4x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_fire_4x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_fire_4x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_fire_4x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_fire_4x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_fire_4x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_fire_4x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_fire_4x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_fire_4x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_fire_4x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_fire_4x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

clear vegc_tot_reg_dlow vegc_tot_dlow soilc_tot_reg_dlow soilc_tot_dlow ...
    vegc_tot_reg_dmid vegc_tot_dmid soilc_tot_reg_dmid soilc_tot_dmid ...
    vegc_tot_reg_dhigh vegc_tot_dhigh soilc_tot_reg_dhigh soilc_tot_dhigh ...
    vegc_tot_reg_std_dlow vegc_tot_std_dlow soilc_tot_reg_std_dlow soilc_tot_std_dlow ...
    vegc_tot_reg_std_dmid vegc_tot_std_dmid soilc_tot_reg_std_dmid soilc_tot_std_dmid ...
    vegc_tot_reg_std_dhigh vegc_tot_std_dhigh soilc_tot_reg_std_dhigh soilc_tot_std_dhigh ...
    vegc soilc N_reg_dlow_sum N_reg_dmid_sum N_reg_dhigh_sum

%Simulations with disturbed material harvested
base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_25x_harv/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_harv_0_25x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_harv_0_25x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_harv_0_25x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_harv_0_25x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_harv_0_25x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_harv_0_25x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_harv_0_25x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_harv_0_25x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_harv_0_25x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_harv_0_25x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_harv_0_25x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_harv_0_25x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_0_5x_harv/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_harv_0_5x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_harv_0_5x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_harv_0_5x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_harv_0_5x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_harv_0_5x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_harv_0_5x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_harv_0_5x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_harv_0_5x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_harv_0_5x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_harv_0_5x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_harv_0_5x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_harv_0_5x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_harv/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_harv_1x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_harv_1x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_harv_1x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_harv_1x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_harv_1x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_harv_1x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_harv_1x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_harv_1x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_harv_1x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_harv_1x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_harv_1x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_harv_1x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_2x_harv/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_harv_2x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_harv_2x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_harv_2x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_harv_2x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_harv_2x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_harv_2x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_harv_2x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_harv_2x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_harv_2x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_harv_2x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_harv_2x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_harv_2x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

base_folder_name='/media/pughtam/rds-2017-pughtam-treemort/hansen_esaLUcorr_p10_4x_harv/postproc';
[vegc_tot_reg_dlow,vegc_tot_dlow,soilc_tot_reg_dlow,soilc_tot_dlow,...
    vegc_tot_reg_dmid,vegc_tot_dmid,soilc_tot_reg_dmid,soilc_tot_dmid,...
    vegc_tot_reg_dhigh,vegc_tot_dhigh,soilc_tot_reg_dhigh,soilc_tot_dhigh,...
    vegc_tot_reg_std_dlow,vegc_tot_std_dlow,soilc_tot_reg_std_dlow,soilc_tot_std_dlow,...
    vegc_tot_reg_std_dmid,vegc_tot_std_dmid,soilc_tot_reg_std_dmid,soilc_tot_std_dmid,...
    vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh,...
    vegc,soilc,N_reg_dlow_sum,N_reg_dmid_sum,N_reg_dhigh_sum]=cpool_esa_func_recovsplit_v5(base_folder_name,tau_thres_90,tau_thres_80,calcmean);
vegc_tot_harv_4x_dlow=cat(1,vegc_tot_reg_dlow,vegc_tot_dlow);
vegc_tot_harv_4x_dmid=cat(1,vegc_tot_reg_dmid,vegc_tot_dmid);
vegc_tot_harv_4x_dhigh=cat(1,vegc_tot_reg_dhigh,vegc_tot_dhigh);
soilc_tot_harv_4x_dlow=cat(1,soilc_tot_reg_dlow,soilc_tot_dlow);
soilc_tot_harv_4x_dmid=cat(1,soilc_tot_reg_dmid,soilc_tot_dmid);
soilc_tot_harv_4x_dhigh=cat(1,soilc_tot_reg_dhigh,soilc_tot_dhigh);

vegc_tot_harv_4x_std_dlow=cat(1,vegc_tot_reg_std_dlow,vegc_tot_std_dlow);
vegc_tot_harv_4x_std_dmid=cat(1,vegc_tot_reg_std_dmid,vegc_tot_std_dmid);
vegc_tot_harv_4x_std_dhigh=cat(1,vegc_tot_reg_std_dhigh,vegc_tot_std_dhigh);
soilc_tot_harv_4x_std_dlow=cat(1,soilc_tot_reg_std_dlow,soilc_tot_std_dlow);
soilc_tot_harv_4x_std_dmid=cat(1,soilc_tot_reg_std_dmid,soilc_tot_std_dmid);
soilc_tot_harv_4x_std_dhigh=cat(1,soilc_tot_reg_std_dhigh,soilc_tot_std_dhigh);

clear vegc_tot_reg_dlow vegc_tot_dlow soilc_tot_reg_dlow soilc_tot_dlow ...
    vegc_tot_reg_dmid vegc_tot_dmid soilc_tot_reg_dmid soilc_tot_dmid ...
    vegc_tot_reg_dhigh vegc_tot_dhigh soilc_tot_reg_dhigh soilc_tot_dhigh ...
    vegc_tot_reg_std_dlow vegc_tot_std_dlow soilc_tot_reg_std_dlow soilc_tot_std_dlow ...
    vegc_tot_reg_std_dmid vegc_tot_std_dmid soilc_tot_reg_std_dmid soilc_tot_std_dmid ...
    vegc_tot_reg_std_dhigh vegc_tot_std_dhigh soilc_tot_reg_std_dhigh soilc_tot_std_dhigh ...
    vegc soilc N_reg_dlow_sum N_reg_dmid_sum N_reg_dhigh_sum

vegc_tot_dlow=cat(2,vegc_tot_0_25x_dlow,vegc_tot_0_5x_dlow,vegc_tot_1x_dlow,vegc_tot_2x_dlow,vegc_tot_4x_dlow);
vegc_tot_dmid=cat(2,vegc_tot_0_25x_dmid,vegc_tot_0_5x_dmid,vegc_tot_1x_dmid,vegc_tot_2x_dmid,vegc_tot_4x_dmid);
vegc_tot_dhigh=cat(2,vegc_tot_0_25x_dhigh,vegc_tot_0_5x_dhigh,vegc_tot_1x_dhigh,vegc_tot_2x_dhigh,vegc_tot_4x_dhigh);
soilc_tot_dlow=cat(2,soilc_tot_0_25x_dlow,soilc_tot_0_5x_dlow,soilc_tot_1x_dlow,soilc_tot_2x_dlow,soilc_tot_4x_dlow);
soilc_tot_dmid=cat(2,soilc_tot_0_25x_dmid,soilc_tot_0_5x_dmid,soilc_tot_1x_dmid,soilc_tot_2x_dmid,soilc_tot_4x_dmid);
soilc_tot_dhigh=cat(2,soilc_tot_0_25x_dhigh,soilc_tot_0_5x_dhigh,soilc_tot_1x_dhigh,soilc_tot_2x_dhigh,soilc_tot_4x_dhigh);

vegc_tot_std_dlow=cat(2,vegc_tot_0_25x_std_dlow,vegc_tot_0_5x_std_dlow,vegc_tot_1x_std_dlow,vegc_tot_2x_std_dlow,vegc_tot_4x_std_dlow);
vegc_tot_std_dmid=cat(2,vegc_tot_0_25x_std_dmid,vegc_tot_0_5x_std_dmid,vegc_tot_1x_std_dmid,vegc_tot_2x_std_dmid,vegc_tot_4x_std_dmid);
vegc_tot_std_dhigh=cat(2,vegc_tot_0_25x_std_dhigh,vegc_tot_0_5x_std_dhigh,vegc_tot_1x_std_dhigh,vegc_tot_2x_std_dhigh,vegc_tot_4x_std_dhigh);
soilc_tot_std_dlow=cat(2,soilc_tot_0_25x_std_dlow,soilc_tot_0_5x_std_dlow,soilc_tot_1x_std_dlow,soilc_tot_2x_std_dlow,soilc_tot_4x_std_dlow);
soilc_tot_std_dmid=cat(2,soilc_tot_0_25x_std_dmid,soilc_tot_0_5x_std_dmid,soilc_tot_1x_std_dmid,soilc_tot_2x_std_dmid,soilc_tot_4x_std_dmid);
soilc_tot_std_dhigh=cat(2,soilc_tot_0_25x_std_dhigh,soilc_tot_0_5x_std_dhigh,soilc_tot_1x_std_dhigh,soilc_tot_2x_std_dhigh,soilc_tot_4x_std_dhigh);

vegc_tot_fire_dlow=cat(2,vegc_tot_fire_0_25x_dlow,vegc_tot_fire_0_5x_dlow,vegc_tot_fire_1x_dlow,vegc_tot_fire_2x_dlow,vegc_tot_fire_4x_dlow);
vegc_tot_fire_dmid=cat(2,vegc_tot_fire_0_25x_dmid,vegc_tot_fire_0_5x_dmid,vegc_tot_fire_1x_dmid,vegc_tot_fire_2x_dmid,vegc_tot_fire_4x_dmid);
vegc_tot_fire_dhigh=cat(2,vegc_tot_fire_0_25x_dhigh,vegc_tot_fire_0_5x_dhigh,vegc_tot_fire_1x_dhigh,vegc_tot_fire_2x_dhigh,vegc_tot_fire_4x_dhigh);
soilc_tot_fire_dlow=cat(2,soilc_tot_fire_0_25x_dlow,soilc_tot_fire_0_5x_dlow,soilc_tot_fire_1x_dlow,soilc_tot_fire_2x_dlow,soilc_tot_fire_4x_dlow);
soilc_tot_fire_dmid=cat(2,soilc_tot_fire_0_25x_dmid,soilc_tot_fire_0_5x_dmid,soilc_tot_fire_1x_dmid,soilc_tot_fire_2x_dmid,soilc_tot_fire_4x_dmid);
soilc_tot_fire_dhigh=cat(2,soilc_tot_fire_0_25x_dhigh,soilc_tot_fire_0_5x_dhigh,soilc_tot_fire_1x_dhigh,soilc_tot_fire_2x_dhigh,soilc_tot_fire_4x_dhigh);

vegc_tot_fire_std_dlow=cat(2,vegc_tot_fire_0_25x_std_dlow,vegc_tot_fire_0_5x_std_dlow,vegc_tot_fire_1x_std_dlow,vegc_tot_fire_2x_std_dlow,vegc_tot_fire_4x_std_dlow);
vegc_tot_fire_std_dmid=cat(2,vegc_tot_fire_0_25x_std_dmid,vegc_tot_fire_0_5x_std_dmid,vegc_tot_fire_1x_std_dmid,vegc_tot_fire_2x_std_dmid,vegc_tot_fire_4x_std_dmid);
vegc_tot_fire_std_dhigh=cat(2,vegc_tot_fire_0_25x_std_dhigh,vegc_tot_fire_0_5x_std_dhigh,vegc_tot_fire_1x_std_dhigh,vegc_tot_fire_2x_std_dhigh,vegc_tot_fire_4x_std_dhigh);
soilc_tot_fire_std_dlow=cat(2,soilc_tot_fire_0_25x_std_dlow,soilc_tot_fire_0_5x_std_dlow,soilc_tot_fire_1x_std_dlow,soilc_tot_fire_2x_std_dlow,soilc_tot_fire_4x_std_dlow);
soilc_tot_fire_std_dmid=cat(2,soilc_tot_fire_0_25x_std_dmid,soilc_tot_fire_0_5x_std_dmid,soilc_tot_fire_1x_std_dmid,soilc_tot_fire_2x_std_dmid,soilc_tot_fire_4x_std_dmid);
soilc_tot_fire_std_dhigh=cat(2,soilc_tot_fire_0_25x_std_dhigh,soilc_tot_fire_0_5x_std_dhigh,soilc_tot_fire_1x_std_dhigh,soilc_tot_fire_2x_std_dhigh,soilc_tot_fire_4x_std_dhigh);

vegc_tot_harv_dlow=cat(2,vegc_tot_harv_0_25x_dlow,vegc_tot_harv_0_5x_dlow,vegc_tot_harv_1x_dlow,vegc_tot_harv_2x_dlow,vegc_tot_harv_4x_dlow);
vegc_tot_harv_dmid=cat(2,vegc_tot_harv_0_25x_dmid,vegc_tot_harv_0_5x_dmid,vegc_tot_harv_1x_dmid,vegc_tot_harv_2x_dmid,vegc_tot_harv_4x_dmid);
vegc_tot_harv_dhigh=cat(2,vegc_tot_harv_0_25x_dhigh,vegc_tot_harv_0_5x_dhigh,vegc_tot_harv_1x_dhigh,vegc_tot_harv_2x_dhigh,vegc_tot_harv_4x_dhigh);
soilc_tot_harv_dlow=cat(2,soilc_tot_harv_0_25x_dlow,soilc_tot_harv_0_5x_dlow,soilc_tot_harv_1x_dlow,soilc_tot_harv_2x_dlow,soilc_tot_harv_4x_dlow);
soilc_tot_harv_dmid=cat(2,soilc_tot_harv_0_25x_dmid,soilc_tot_harv_0_5x_dmid,soilc_tot_harv_1x_dmid,soilc_tot_harv_2x_dmid,soilc_tot_harv_4x_dmid);
soilc_tot_harv_dhigh=cat(2,soilc_tot_harv_0_25x_dhigh,soilc_tot_harv_0_5x_dhigh,soilc_tot_harv_1x_dhigh,soilc_tot_harv_2x_dhigh,soilc_tot_harv_4x_dhigh);

vegc_tot_harv_std_dlow=cat(2,vegc_tot_harv_0_25x_std_dlow,vegc_tot_harv_0_5x_std_dlow,vegc_tot_harv_1x_std_dlow,vegc_tot_harv_2x_std_dlow,vegc_tot_harv_4x_std_dlow);
vegc_tot_harv_std_dmid=cat(2,vegc_tot_harv_0_25x_std_dmid,vegc_tot_harv_0_5x_std_dmid,vegc_tot_harv_1x_std_dmid,vegc_tot_harv_2x_std_dmid,vegc_tot_harv_4x_std_dmid);
vegc_tot_harv_std_dhigh=cat(2,vegc_tot_harv_0_25x_std_dhigh,vegc_tot_harv_0_5x_std_dhigh,vegc_tot_harv_1x_std_dhigh,vegc_tot_harv_2x_std_dhigh,vegc_tot_harv_4x_std_dhigh);
soilc_tot_harv_std_dlow=cat(2,soilc_tot_harv_0_25x_std_dlow,soilc_tot_harv_0_5x_std_dlow,soilc_tot_harv_1x_std_dlow,soilc_tot_harv_2x_std_dlow,soilc_tot_harv_4x_std_dlow);
soilc_tot_harv_std_dmid=cat(2,soilc_tot_harv_0_25x_std_dmid,soilc_tot_harv_0_5x_std_dmid,soilc_tot_harv_1x_std_dmid,soilc_tot_harv_2x_std_dmid,soilc_tot_harv_4x_std_dmid);
soilc_tot_harv_std_dhigh=cat(2,soilc_tot_harv_0_25x_std_dhigh,soilc_tot_harv_0_5x_std_dhigh,soilc_tot_harv_1x_std_dhigh,soilc_tot_harv_2x_std_dhigh,soilc_tot_harv_4x_std_dhigh);

vegc_tot_all_dlow=cat(3,vegc_tot_dlow,vegc_tot_fire_dlow,vegc_tot_harv_dlow);
vegc_tot_all_dmid=cat(3,vegc_tot_dmid,vegc_tot_fire_dmid,vegc_tot_harv_dmid);
vegc_tot_all_dhigh=cat(3,vegc_tot_dhigh,vegc_tot_fire_dhigh,vegc_tot_harv_dhigh);
soilc_tot_all_dlow=cat(3,soilc_tot_dlow,soilc_tot_fire_dlow,soilc_tot_harv_dlow);
soilc_tot_all_dmid=cat(3,soilc_tot_dmid,soilc_tot_fire_dmid,soilc_tot_harv_dmid);
soilc_tot_all_dhigh=cat(3,soilc_tot_dhigh,soilc_tot_fire_dhigh,soilc_tot_harv_dhigh);

vegc_tot_all_std_dlow=cat(3,vegc_tot_std_dlow,vegc_tot_fire_std_dlow,vegc_tot_harv_std_dlow);
vegc_tot_all_std_dmid=cat(3,vegc_tot_std_dmid,vegc_tot_fire_std_dmid,vegc_tot_harv_std_dmid);
vegc_tot_all_std_dhigh=cat(3,vegc_tot_std_dhigh,vegc_tot_fire_std_dhigh,vegc_tot_harv_std_dhigh);
soilc_tot_all_std_dlow=cat(3,soilc_tot_std_dlow,soilc_tot_fire_std_dlow,soilc_tot_harv_std_dlow);
soilc_tot_all_std_dmid=cat(3,soilc_tot_std_dmid,soilc_tot_fire_std_dmid,soilc_tot_harv_std_dmid);
soilc_tot_all_std_dhigh=cat(3,soilc_tot_std_dhigh,soilc_tot_fire_std_dhigh,soilc_tot_harv_std_dhigh);

tau=[0.25 0.5 1 2 4];

esatypes={'TrBE','TrBD','TeBE','TeBD','NE','ND','MX'};

%---
%Shaded plot for global delta

diff_veg_all_dlow=((vegc_tot_all_dlow(8,:,:)./repmat(vegc_tot_all_dlow(8,3,:),1,5,1))*100)-100;
diff_veg_all_dmid=((vegc_tot_all_dmid(8,:,:)./repmat(vegc_tot_all_dmid(8,3,:),1,5,1))*100)-100;
diff_veg_all_dhigh=((vegc_tot_all_dhigh(8,:,:)./repmat(vegc_tot_all_dhigh(8,3,:),1,5,1))*100)-100;
diff_soil_all_dlow=((soilc_tot_all_dlow(8,:,:)./repmat(soilc_tot_all_dlow(8,3,:),1,5,1))*100)-100;
diff_soil_all_dmid=((soilc_tot_all_dmid(8,:,:)./repmat(soilc_tot_all_dmid(8,3,:),1,5,1))*100)-100;
diff_soil_all_dhigh=((soilc_tot_all_dhigh(8,:,:)./repmat(soilc_tot_all_dhigh(8,3,:),1,5,1))*100)-100;

diff_veg_all=cat(1,diff_veg_all_dlow,diff_veg_all_dmid,diff_veg_all_dhigh);
diff_soil_all=cat(1,diff_soil_all_dlow,diff_soil_all_dmid,diff_soil_all_dhigh);

diff_veg_all_max=nanmax(diff_veg_all,[],3);
diff_veg_all_min=nanmin(diff_veg_all,[],3);
diff_soil_all_max=nanmax(diff_soil_all,[],3);
diff_soil_all_min=nanmin(diff_soil_all,[],3);

X=[log10(tau');flipud(log10(tau'))]; %create polygon

cmap=[0.9290 0.6940 0.1250;
    0.5961 0.3059 0.6392;
    0.3020 0.6863 0.2902];

figure
subplot(1,2,1)
hold on
for nn=1:3
    Y=[diff_veg_all_max(nn,:),fliplr(diff_veg_all_min(nn,:))]; %create polygon
    bgcol=[0.5 0.5 1]; %Colour for shaded polygon (r,g,b)
    f1=fill(X,Y,cmap(nn,:));
    set(f1,'LineStyle','none');
    set(f1,'FaceAlpha',0.55) %Allow transparency (does not work with log axis)
    hasbehavior(f1,'legend',false); %Do not include shaded area in legend
end
for nn=1:3
    plot(log10(tau),diff_veg_all(nn,:,1),'color',cmap(nn,:),'linewidth',2,'markersize',10,'marker','.')
end
clear nn
set(gca,'XTick',log10(tau),'XTickLabel',tau)
set(gca,'XLim',log10([0.25 4]))
set(gca,'YLim',[-65 65])
ylabel('Biomass density difference (%)')
xlabel('\tau_{O} multiplier')
l1=line(log10([1 1]),[-65 65],'Linestyle',':','color','k');
l2=line(log10([0.25 4]),[0 0 ],'Linestyle',':','color','k');
hasbehavior(l1,'legend',false)
hasbehavior(l2,'legend',false)

subplot(1,2,2)
hold on
for nn=1:3
    Y=[diff_soil_all_max(nn,:),fliplr(diff_soil_all_min(nn,:))]; %create polygon
    bgcol=[0.5 0.5 1]; %Colour for shaded polygon (r,g,b)
    f1=fill(X,Y,cmap(nn,:));
    set(f1,'LineStyle','none');
    set(f1,'FaceAlpha',0.55) %Allow transparency (does not work with log axis)
    hasbehavior(f1,'legend',false); %Do not include shaded area in legend
end
for nn=1:3
    p1=plot(log10(tau),diff_soil_all_max(nn,:),'color',cmap(nn,:),'linewidth',1,'linestyle','--');
    hasbehavior(p1,'legend',false)
end
for nn=1:3
    p1=plot(log10(tau),diff_soil_all_min(nn,:),'color',cmap(nn,:),'linewidth',1,'linestyle','--');
    hasbehavior(p1,'legend',false)
end
for nn=1:3
    plot(log10(tau),diff_soil_all(nn,:,1),'color',cmap(nn,:),'linewidth',2,'markersize',10,'marker','.')
end
clear nn
set(gca,'XTick',log10(tau),'XTickLabel',tau)
set(gca,'XLim',log10([0.25 4]))
ylabel('Soil C density difference (%)')
xlabel('\tau_{O} multiplier')
l1=line(log10([1 1]),[-35 35],'Linestyle',':','color','k');
l2=line(log10([0.25 4]),[0 0 ],'Linestyle',':','color','k');
hasbehavior(l1,'legend',false)
hasbehavior(l2,'legend',false)
set(gca,'YLim',[-35 35])
legend('\tau_{O}<\tau_{crit,80}','\tau_{O}<\tau_{crit,90}','\tau_{O}\geq\tau_{crit,90}')

%---
%Shaded plot for global delta for standard sim only with std

vegc_tot_dlow_stdset=cat(3,vegc_tot_dlow-vegc_tot_std_dlow,vegc_tot_dlow,vegc_tot_std_dlow+vegc_tot_std_dlow);
vegc_tot_dmid_stdset=cat(3,vegc_tot_dmid-vegc_tot_std_dmid,vegc_tot_dmid,vegc_tot_std_dmid+vegc_tot_std_dmid);
vegc_tot_dhigh_stdset=cat(3,vegc_tot_dhigh-vegc_tot_std_dhigh,vegc_tot_dhigh,vegc_tot_std_dhigh+vegc_tot_std_dhigh);
soilc_tot_dlow_stdset=cat(3,soilc_tot_dlow-soilc_tot_std_dlow,soilc_tot_dlow,soilc_tot_std_dlow+soilc_tot_std_dlow);
soilc_tot_dmid_stdset=cat(3,soilc_tot_dmid-soilc_tot_std_dmid,soilc_tot_dmid,soilc_tot_std_dmid+soilc_tot_std_dmid);
soilc_tot_dhigh_stdset=cat(3,soilc_tot_dhigh-soilc_tot_std_dhigh,soilc_tot_dhigh,soilc_tot_std_dhigh+soilc_tot_std_dhigh);

diff_veg_all_dlow=((vegc_tot_dlow_stdset(8,:,:)./repmat(vegc_tot_dlow_stdset(8,3,:),1,5,1))*100)-100;
diff_veg_all_dmid=((vegc_tot_dmid_stdset(8,:,:)./repmat(vegc_tot_dmid_stdset(8,3,:),1,5,1))*100)-100;
diff_veg_all_dhigh=((vegc_tot_dhigh_stdset(8,:,:)./repmat(vegc_tot_dhigh_stdset(8,3,:),1,5,1))*100)-100;
diff_soil_all_dlow=((soilc_tot_dlow_stdset(8,:,:)./repmat(soilc_tot_dlow_stdset(8,3,:),1,5,1))*100)-100;
diff_soil_all_dmid=((soilc_tot_dmid_stdset(8,:,:)./repmat(soilc_tot_dmid_stdset(8,3,:),1,5,1))*100)-100;
diff_soil_all_dhigh=((soilc_tot_dhigh_stdset(8,:,:)./repmat(soilc_tot_dhigh_stdset(8,3,:),1,5,1))*100)-100;

diff_veg_all=cat(1,diff_veg_all_dlow,diff_veg_all_dmid,diff_veg_all_dhigh);
diff_soil_all=cat(1,diff_soil_all_dlow,diff_soil_all_dmid,diff_soil_all_dhigh);

diff_veg_all_max=diff_veg_all(:,:,3);
diff_veg_all_mean=diff_veg_all(:,:,2);
diff_veg_all_min=diff_veg_all(:,:,1);
diff_soil_all_max=diff_soil_all(:,:,3);
diff_soil_all_mean=diff_soil_all(:,:,2);
diff_soil_all_min=diff_soil_all(:,:,1);

X=[log10(tau');flipud(log10(tau'))]; %create polygon

cmap=[0.9290 0.6940 0.1250;
    0.5961 0.3059 0.6392;
    0.3020 0.6863 0.2902];

figure
subplot(1,2,1)
hold on
for nn=1:3
    Y=[diff_veg_all_max(nn,:),fliplr(diff_veg_all_min(nn,:))]; %create polygon
    bgcol=[0.5 0.5 1]; %Colour for shaded polygon (r,g,b)
    f1=fill(X,Y,cmap(nn,:));
    set(f1,'LineStyle','none');
    set(f1,'FaceAlpha',0.55) %Allow transparency (does not work with log axis)
    hasbehavior(f1,'legend',false); %Do not include shaded area in legend
end
for nn=1:3
    plot(log10(tau),diff_veg_all_mean(nn,:),'color',cmap(nn,:),'linewidth',2,'markersize',10,'marker','.')
end
clear nn
set(gca,'XTick',log10(tau),'XTickLabel',tau)
set(gca,'XLim',log10([0.25 4]))
set(gca,'YLim',[-65 65])
ylabel('Biomass density difference (%)')
xlabel('\tau_{O} multiplier')
l1=line(log10([1 1]),[-65 65],'Linestyle',':','color','k');
l2=line(log10([0.25 4]),[0 0 ],'Linestyle',':','color','k');
hasbehavior(l1,'legend',false)
hasbehavior(l2,'legend',false)

subplot(1,2,2)
hold on
for nn=1:3
    Y=[diff_soil_all_max(nn,:),fliplr(diff_soil_all_min(nn,:))]; %create polygon
    bgcol=[0.5 0.5 1]; %Colour for shaded polygon (r,g,b)
    f1=fill(X,Y,cmap(nn,:));
    set(f1,'LineStyle','none');
    set(f1,'FaceAlpha',0.55) %Allow transparency (does not work with log axis)
    hasbehavior(f1,'legend',false); %Do not include shaded area in legend
end
for nn=1:3
    p1=plot(log10(tau),diff_soil_all_max(nn,:),'color',cmap(nn,:),'linewidth',1,'linestyle','--');
    hasbehavior(p1,'legend',false)
end
for nn=1:3
    p1=plot(log10(tau),diff_soil_all_min(nn,:),'color',cmap(nn,:),'linewidth',1,'linestyle','--');
    hasbehavior(p1,'legend',false)
end
for nn=1:3
    plot(log10(tau),diff_soil_all_mean(nn,:),'color',cmap(nn,:),'linewidth',2,'markersize',10,'marker','.')
end
clear nn
set(gca,'XTick',log10(tau),'XTickLabel',tau)
set(gca,'XLim',log10([0.25 4]))
ylabel('Soil C density difference (%)')
xlabel('\tau_{O} multiplier')
l1=line(log10([1 1]),[-35 35],'Linestyle',':','color','k');
l2=line(log10([0.25 4]),[0 0 ],'Linestyle',':','color','k');
hasbehavior(l1,'legend',false)
hasbehavior(l2,'legend',false)
set(gca,'YLim',[-35 35])
legend('\tau_{O}<\tau_{crit,80}','\tau_{O}<\tau_{crit,90}','\tau_{O}\geq\tau_{crit,90}')

%---
%Shaded plot for total C density

veg_all_dmid=vegc_tot_all_dmid(8,:,:);
veg_all_dhigh=vegc_tot_all_dhigh(8,:,:);
tot_all_dmid=vegc_tot_all_dmid(8,:,:)+soilc_tot_all_dmid(8,:,:);
tot_all_dhigh=vegc_tot_all_dhigh(8,:,:)+soilc_tot_all_dhigh(8,:,:);

veg_all=cat(1,veg_all_dmid,veg_all_dhigh);
tot_all=cat(1,tot_all_dmid,tot_all_dhigh);

veg_all_max=nanmax(veg_all,[],3);
veg_all_min=nanmin(veg_all,[],3);
tot_all_max=nanmax(tot_all,[],3);
tot_all_min=nanmin(tot_all,[],3);

X=[log10(tau');flipud(log10(tau'))]; %create polygon

%This cmap merged from cbrewer('qual','Set1',4) and lines(7)
cmap=[0.5961 0.3059 0.6392 ; 0.3020 0.6863 0.2902];

figure
hold on
for nn=1:2
    Y=[tot_all_max(nn,:),fliplr(tot_all_min(nn,:))]; %create polygon
    bgcol=[0.5 0.5 1]; %Colour for shaded polygon (r,g,b)
    f1=fill(X,Y,cmap(nn,:));
    set(f1,'LineStyle','none');
    set(f1,'FaceAlpha',0.55) %Allow transparency (does not work with log axis)
    hasbehavior(f1,'legend',false); %Do not include shaded area in legend
end
for nn=1:2
    plot(log10(tau),tot_all(nn,:,1),'color',cmap(nn,:),'linewidth',2,'markersize',10,'marker','.')
end
clear nn
set(gca,'XTick',log10(tau),'XTickLabel',tau)
set(gca,'XLim',log10([0.25 4]))
if calcmean
    ylabel('Total C density (kg m^{-2})')
else
    ylabel('Total ecosystem C (Pg)')
end
xlabel('\tau_{O} multiplier')
legend('\tau_{O}<\tau_{crit,90}','\tau_{O}\geq\tau_{crit,90}')