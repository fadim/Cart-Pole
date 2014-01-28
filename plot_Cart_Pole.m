function plot_Cart_Pole(x,theta)


l=2;     % Çubuk uzunluðununu çizim yaptýrýrken biraz daha büyük deðer alýyoruz.(Normal deðer 0.5)

pxg = [x+1 x-1 x-1 x+1 x+1];
pyg = [0.25 0.25 1.25 1.25 0.25];

pxp=[x x+l*sin(theta)];
pyp=[1.25 1.25+l*cos(theta)];

[pxw1,pyw1] = plotcircle(x-0.5,0.125,0,0.125);
[pxw2,pyw2] = plotcircle(x+0.5,0.125,0,0.125);

plot(pxg,pyg,'k-',pxw1,pyw1,'k',pxw2,pyw2,'k',pxp,pyp,'r')
title('Cart-Pole Balancing Problem by Reinforcement Learning')
axis([-6 6 0 6])

grid
drawnow;