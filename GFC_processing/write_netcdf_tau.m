function write_netcdf_tau(data,variable,realisation,method,correction,year,units,variable_longname,output_dir,note1,note2,note3,note4)
%Write out to netcdf file. This function to be called from tau_to_netcdfs.m
%
%T. Pugh
%26.04.19

fprintf('Creating output file\n')

minlat=-89.5;
maxlat=89.5;
minlon=-179.5;
maxlon=179.5;
gridspace=1.0;

latgrid=minlat:gridspace:maxlat;
longrid=minlon:gridspace:maxlon;
nlat=length(latgrid);
nlon=length(longrid);

fname=[variable,'_',realisation,'_',method,'_',correction,'.nc'];
outfile=[output_dir,'/',fname];
    
nccreate(outfile,'latitude','Dimensions',{'latitude',nlat})
ncwrite(outfile,'latitude',latgrid)
ncwriteatt(outfile,'latitude','units','degrees_north');
nccreate(outfile,'longitude','Dimensions',{'longitude',nlon})
ncwrite(outfile,'longitude',longrid)
ncwriteatt(outfile,'longitude','units','degrees_east');
nccreate(outfile,'time','Dimensions',{'time',Inf})
ncwrite(outfile,'time',year)
ncwriteatt(outfile,'time','units','years');
    
nccreate(outfile,variable,'Dimensions',{'longitude','latitude','time'},'DeflateLevel',9)

ncwrite(outfile,variable,data')
ncwriteatt(outfile,variable,'longname',variable_longname)
ncwriteatt(outfile,variable,'units',units)
    
ncwriteatt(outfile,'/','Realisation',realisation);
ncwriteatt(outfile,'/','Method',method);
ncwriteatt(outfile,'/','Correction',correction);
ncwriteatt(outfile,'/','Note1',note1);
ncwriteatt(outfile,'/','Note2',note2);
ncwriteatt(outfile,'/','Note3',note3);
ncwriteatt(outfile,'/','Note4',note4);
ncwriteatt(outfile,'/','Reference','This data is described in: Pugh, T.A.M., Arneth, A., Kautz, M., Poulter, B., Smith, B., Important role of forest disturbances for global biomass turnover and carbon sinks. Nature Geoscience, 2019.');
ncwriteatt(outfile,'/','Institution','University of Birmingham, UK');
ncwriteatt(outfile,'/','Contact','Thomas Pugh, t.a.m.pugh@bham.ac.uk');
ncwriteatt(outfile,'/','Version',['Version 1: ',date]);
