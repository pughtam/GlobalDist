%Plot results from a series of single-site LPJ-GUESS simulations with
%disturbance rotation period varying from 10 to 1000 in steps of 10.
%
%T. Pugh
%12.09.17

basefol='/media/pughtam/rds-2017-pughtam-01/Disturbance/conceptual_dist_sims/v2/';
nyear=115; %Number of simulated years

%---
dist=10:10:1000;
ndist=length(dist);

veg=NaN(ndist,nyear);
npp=NaN(ndist,nyear);
for dd=1:ndist
    fol=['site2_dist',mat2str(dist(dd)),'/'];
    file1=[basefol,fol,'cpool.out'];
    cpool_in=dlmread(file1,'',1,0);
    veg(dd,:)=cpool_in(:,4);
    file2=[basefol,fol,'cflux.out'];
    cflux_in=dlmread(file2,'',1,0);
    npp(dd,:)=cflux_in(:,4);
end
clear dd file1 file2 fol cpool_in cflux_in

veg_1986_2015=mean(veg(:,86:115),2);
npp_1986_2015=mean(npp(:,86:115),2);

figure
hold on
p1=plot(dist,veg_1986_2015,'.');
hasbehavior(p1,'legend',false)
p2=plot(fit(dist',veg_1986_2015,'exp2'),dist,veg_1986_2015,'-');
xlabel('\tau (years)')
ylabel('Biomass (kg C m^{-2})')

legend('3.75E, 47.25N','23.75E, 0.25N','15.75E, 60.25N')