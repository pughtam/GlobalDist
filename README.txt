Scripts associated with Pugh et al., Dominant role of disturbance in global forest biomass turnover and carbon sinks
 

Calculate disturbance return periods and make Fig. 1, Suppl. Fig. 5.
-	hansen_disturb_int_calc_1deg_lu_v4_lossyear.m
-	BOXPLOT SCRIPT
WHERE ARE SUPPL. FIGS. 4 AND 7 MADE? NEED TO ADD TO THIS FILE?

Calculate the conversions from forest to non-forest land-use using ESA CCI Landcover
-	ESA_forest_loss_process.m

Aggregate raw ESA CCI landcover data into 1-degree forest type arrays
-	esa_hires_region_mask_1deg.m
-	esa_forest_9regions_new_1deg_func.m

Calculate forest area fractional cover (50% closed-canopy forest)
-	???

Helper functions
-	lpj_to_grid_func_centre.m
-	distforfrachan.m


Scripts associated with individual figures

Fig. 2
-	dist_loss_maps_esa_all_v3.m
-	dist_loss_maps_esa_func_v3.m
-	obs_distflux_turnfluxfrac_v4.m (observation-based cross-check)

Fig. 3a
-	conceptual_dist_sims_v2.m

Fig. 3b, Suppl. Fig. 12
-	dist_vul_sim_v3.m

Fig. 3c
-	tau_threshold_dist_map_v2

Fig. 3d,e, Suppl. Figs. 8, 9
-	cpool_esa_line_recovsplit_v5.m
-	cpool_esa_func_recovsplit_v5.m

Suppl. Fig. 1
-	han_vs_poulfrac_plots_v2.m

Suppl. Fig. 2.
-	???

Suppl. Fig. 3
-	???

Suppl. Fig. 4
-	??? (hansen_disturb_int_calc_1deg_lu_v4_lossyear.m ???)

Suppl. Fig. 6
-	han_tau_lossyear_check_v2.m

Suppl. Fig. 10
-	esa_regions_map_v2.m

Suppl. Fig. 11
-	???

Other checks
-	han_tau_uncer_bootstrap_sample_fig.m

