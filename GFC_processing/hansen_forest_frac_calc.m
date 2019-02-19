%Script to read in the forest cover from Hansen et al. (2013, 
%http://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.1.html)
%and calculate the forest cover.
%
%Part 1 reads the forest cover data and makes the calculations.
%Part 2 regrids and writes out a netcdf
%
%T. Pugh
%10.06.17

part1=false; %Run first part?
part2=true; %Run second part?

halfdegree=false; %Resolution for regridding in second part
outfile='hansen_forested_frac_1deg_thres50.nc4'; %Name of output file for second part
outvar='forested_50_percent'; %Name of output variable in file for second part
thres=50; %Percentage forest cover fraction at 0.01 x 0.01 degree to consider forest

%-----
if part1

yyind=['80S';'70S';'60S';'50S';'40S';'30S';'20S';'10S';'00N';'10N';'20N';'30N';'40N';'50N';'60N';'70N';'80N'];
xxind=['180W';'170W';'160W';'150W';'140W';'130W';'120W';'110W';'100W';'090W';'080W';'070W';'060W';'050W';'040W';'030W';'020W';'010W';'000E';...
    '010E';'020E';'030E';'040E';'050E';'060E';'070E';'080E';'090E';'100E';'110E';'120E';'130E';'140E';'150E';'160E';'170E'];

forested_thres20=zeros(36000,18000);
totfarea=NaN(36,18);
cc=0;
for yy=5:17 %Data starts from 50S (i.e. 50°S - 60°S)
    for xx=1:36
        cc=cc+1; %Counter for diagnostic output
        filename_farea=['Hansen_GFC2014_treecover2000_',yyind(yy,:),'_',xxind(xx,:),'.tif'];
        [tempfarea, Rfarea]=geotiffread(filename_farea);
        if max(tempfarea(:))==0
            %No forested area, do not process this 10° x 10° section any further
            clear tempfarea Rfarea
            continue
        end
        
        dims_farea=size(tempfarea);

        
        grid=Rfarea.DeltaLon;
        minlat=Rfarea.Latlim(1);
        maxlat=Rfarea.Latlim(2)-grid;
        lat_map=minlat:grid:maxlat;
        offset=grid/2;
        
        ny=length(lat_map);
        rad_earth=6.371e6; %m2
        circ_earth=2*pi*rad_earth;
        basedist=circ_earth/(360/grid);
        
        areag=NaN(ny,1);
        for y=1:ny
            areag(y)=basedist*basedist*cosd(lat_map(y)+offset); %m2
        end
        clear ny rad_earth circ_earth basedist

        
        %Use mean area for grid-cell for now, as it greatly reduces the computational requirements,
        %and losses of accuracy should be minimal away from the poles.
        inc_ii=dims_farea(1)/1000;
        inc_jj=dims_farea(2)/1000;
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
                
                sec_area=tempfarea(jj_s:jj_e,ii_s:ii_e);
                sec_area_mean=mean(sec_area(:));
                if ~isnan(sec_area_mean)
                    if sec_area_mean>thres
                        forested_thres(ind_xx,ind_yy)=1;
                    end
                end
            end
            clear jj
        end
        clear ii            
        
        totfarea(xx,yy)=(sum(tempfarea(:))/100)*mean(areag);
        
        clear temploss tempfarea Rloss Rfarea dims_loss dims_farea
        
        fprintf('Processed %s %s. Total units is %d\n',yyind(yy,:),xxind(xx,:),cc)
    end
    clear xx
    outtemp=['testoutthres',mat2str(yy),'.mat'];
    save(outtemp,'forested_thres','-v7.3');
end
clear yy cc

save forested_frac_0_01_degree_thres.mat -v7.3
clear all
end %if part1


%-----
if part2

load forested_frac_0_01_degree.mat

%Now reprocess to a coarser resolution, defining a grid cell as forested
%depending on whether its forested fraction is over a threshold.
if halfdegree
    %Make calculations at 0.5 degree resolution
    nlats=360;
    nlons=720;
    lons=-179.75:0.5:179.75;
    lats=-89.75:0.5:89.75;
    conv=50;
else
    %Then do it at 1 degree resolution
    nlats=180;
    nlons=360;
    lons=-179.5:1:179.5;
    lats=-89.5:1:89.5;
    conv=100;
end

forested_regrid_thres=zeros(nlats,nlons);
for ilath=1:nlats
    ilat_min=(ilath*conv)-conv+1;
    ilat_max=ilath*conv;
    for ilonh=1:nlons
        ilon_min=(ilonh*conv)-conv+1;
        ilon_max=ilonh*conv;
        %sum up the planted area across the 0.5 degree grid cell
        tsec=forested_thres(ilon_min:ilon_max,ilat_min:ilat_max);
        tsec_sum=nansum(tsec(:));
        if tsec_sum>0
            forested_regrid_thres(ilath,ilonh)=(tsec_sum/(conv^2))*100;
        end
        
    end
    fprintf('ilath is %d\n',ilath)
end
clear ilath ilonh
clear ilon_min ilon_max
clear ilat_min ilat_max


%Write output to netcdf file
ncid = netcdf.create(outfile, 'NETCDF4');

dimid_lon=netcdf.defDim(ncid,'Longitude',nlons);
dimid_lat=netcdf.defDim(ncid,'Latitude',nlats);
varid_lon=netcdf.defVar(ncid,'Longitude','double',dimid_lon);
varid_lat=netcdf.defVar(ncid,'Latitude','double',dimid_lat);
netcdf.putVar(ncid,varid_lon,lons)
netcdf.putVar(ncid,varid_lat,lats)
varid1=netcdf.defVar(ncid,outvar,'int',[dimid_lon dimid_lat]);
netcdf.defVarDeflate(ncid,varid1,true,true,9)
netcdf.putVar(ncid,varid1,forested_regrid_thres')

glo_varid=netcdf.getConstant('NC_GLOBAL');
netcdf.putAtt(ncid,glo_varid,'Note 1','Created using Hansen et al. (2013, Science) forest cover data using hansen_forest_frac_calc.m')
netcdf.putAtt(ncid,glo_varid,'Note 2',date)
netcdf.putAtt(ncid,glo_varid,'Note 3','Creator: Thomas Pugh, t.a.m.pugh@bham.ac.uk')

netcdf.close(ncid)

end %if part2
