airfoil_x = linspace(0,1, 100)';

A = airfoilgen2(5);

rng shuffle

rand1 = randn*0.05

rng shuffle 
rand2 = randn*0.05

A_rg = rand1 + A;
A_tg = rand2 + A;

A_r = [0.946776425729390;0.937577379842215;0.905771242835556;0.906639572507863;0.879025211021414;0.806042069052262;0.926450429196527;0.951120398860078;0.904047711272502;0.892499362263742;0.979528684143455;0.885255912960129];

A_t = [0.892840040308495;0.889052060526512;0.837339886401382;0.939972778264467;1.05440437707574;1.17449794454700;1.00197371341935;0.978851636758389;0.950229678036517;0.930316378533599;0.827745777490256;1.07899874722962];

[Yu, Yl] = D_airfoil2(A(1:end/2), A(end/2+1:end), airfoil_x);

[Yu_r, Yl_r] = D_airfoil2(A_rg(1:end/2), A_rg(end/2+1:end), airfoil_x);
[Yu_t, Yl_t] = D_airfoil2(A_tg(1:end/2), A_tg(end/2+1:end), airfoil_x);

figure
    title('Root airfoil')
    hold on
    plot(Yu(:,1),Yu(:,2),'b');
    plot(Yl(:,1),Yl(:,2),'b');
    
    plot(Yu_r(:,1),Yu_r(:,2),'r');
    plot(Yl_r(:,1),Yl_r(:,2),'r');
    axis([0,1,-0.25,0.25])
    
figure
    title('Tip airfoil')
    hold on
    plot(Yu(:,1),Yu(:,2),'b');
    plot(Yl(:,1),Yl(:,2),'b');
    
    plot(Yu_t(:,1),Yu_t(:,2),'r');
    plot(Yl_t(:,1),Yl_t(:,2),'r');
    axis([0,1,-0.25,0.25])